/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2011 Stuart Caunt
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "Isgl3dGLContext2.h"
#import "Isgl3dGLProgram.h"
#import "Isgl3dGLTextureFactory.h"
#import "Isgl3dGLTextureFactoryState2.h"
#import "Isgl3dGLVBOFactory2.h"
#import "Isgl3dGLRenderer2.h"
#import "Isgl3dLog.h"


@interface Isgl3dGLContext2 ()
@property (nonatomic) GLuint activeFrameBuffer;
@property (nonatomic) GLuint activeRenderBuffer;

- (void) checkGLExtensions;
- (BOOL) createBuffers:(CAEAGLLayer *)eaglLayer;
- (BOOL) createExtensionBuffers;
- (void) releaseBuffers;
- (void) releaseExtensionBuffers;

- (void)freeCurrentRenderImageData;
@end


@implementation Isgl3dGLContext2

@synthesize activeFrameBuffer=_activeFrameBuffer;
@synthesize activeRenderBuffer=_activeRenderBuffer;

static NSArray *_glExtensionsNames = nil;

BOOL CheckForGLExtension(NSString *searchName) {
    if (_glExtensionsNames == nil) {
        const char *extensionsCStr = (const char *)glGetString(GL_EXTENSIONS);
        NSString *extensionsString = [NSString stringWithCString:extensionsCStr encoding: NSASCIIStringEncoding];
        _glExtensionsNames = [[extensionsString componentsSeparatedByString:@" "] retain];
    }
    return [_glExtensionsNames containsObject:searchName];
}


// Create an ES 2.0 context
- (id) initWithLayer:(CAEAGLLayer *) layer {
	
	if ((self = [super init])) {
		
		_msaaAvailable = NO;
		_msaaEnabled = NO;
		_framebufferDiscardAvailable = NO;
		
		_currentRenderImage = NULL;
		_currentRenderImageData = NULL;
		_currentRenderImageDataRef = NULL;

        _activeFrameBuffer = 0;
        _activeRenderBuffer = 0;
        
		// Create the OpenGL context using ES 2.0
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		if (!_context || ![EAGLContext setCurrentContext:_context]) {
			[self release];
			return nil;
		}

		// Check and activate additional OpenGL extensions
		[self checkGLExtensions];
		
		// Create and bind all necessary buffers
		if ([self createBuffers:layer] == NO) {
			[self release];
			return nil;
		}

		// Initialise texture factory and vbo factory
		[[Isgl3dGLTextureFactory sharedInstance] setState:[[[Isgl3dGLTextureFactoryState2 alloc] init] autorelease]];
		[[Isgl3dGLVBOFactory sharedInstance] setConcreteFactory:[[[Isgl3dGLVBOFactory2 alloc] init] autorelease]];

		// Enable depth testing
		glEnable(GL_DEPTH_TEST);
		glClearDepthf(1.0f);
	}
	
	return self;
}

- (void) dealloc {

	// Release all buffers
	[self releaseBuffers];
	
	// Tear down context
	if ([EAGLContext currentContext] == _context) {
		[EAGLContext setCurrentContext:nil];
	}
	
	[_context release];
	_context = nil;

	[Isgl3dGLTextureFactory resetInstance];
	[Isgl3dGLVBOFactory resetInstance];
	
	[self freeCurrentRenderImageData];
	
	[super dealloc];
}

- (void) checkGLExtensions {
	// Check and activate additional OpenGL extensions
    _msaaAvailable = CheckForGLExtension(@"GL_APPLE_framebuffer_multisample");
    _framebufferDiscardAvailable = CheckForGLExtension(@"GL_EXT_discard_framebuffer");
}

- (BOOL) createBuffers:(CAEAGLLayer *)eaglLayer {
	BOOL succeeded = NO;
	
	_depthAndStencilRenderBuffer = 0;
	_depthRenderBuffer = 0;
	_stencilRenderBuffer = 0;
	_stencilBufferAvailable = YES;
	
	// Create and bind the color render buffer
	glGenRenderbuffers(1, &_colorRenderBuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
	
	if(![_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer]) {
		glDeleteRenderbuffers(1, &_colorRenderBuffer);
		return succeeded;
	}
	
	// Get the width and height
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
	
	// Create and bind the frame buffer, attach the color render buffer to the framebuffer
	glGenFramebuffers(1, &_defaultFrameBuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, _defaultFrameBuffer);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
	
	// Try to attach packed depth and stencil buffer
	glGenRenderbuffers(1, &_depthAndStencilRenderBuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _depthAndStencilRenderBuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8_OES, _backingWidth, _backingHeight);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthAndStencilRenderBuffer);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, _depthAndStencilRenderBuffer);
	
	// Check if the creation of the packed depth and stencil buffers was successful
	// if not fallback to separate buffers
	if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
		// Cleanup first
		glDeleteRenderbuffers(1, &_depthAndStencilRenderBuffer);
		_depthAndStencilRenderBuffer = 0;
		
		// Create and attach a separate depth buffer
		glGenRenderbuffers(1, &_depthRenderBuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
		glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _backingWidth, _backingHeight);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
		if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
			Isgl3dLog(Error, @"Isgl3dGLContext2 : No depth buffer available on this device: failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
			return succeeded;
		}
		
		// Create and attach a separate stencil buffer
		glGenRenderbuffers(1, &_stencilRenderBuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, _stencilRenderBuffer);
		glRenderbufferStorage(GL_RENDERBUFFER, GL_STENCIL_INDEX8, _backingWidth, _backingHeight);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, _stencilRenderBuffer);
		if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
			Isgl3dLog(Info, @"Isgl3dGLContext2 : Depth buffer in use, no stencil buffer on this device: some iSGL3D functionalities are not available.");
			
			glDeleteRenderbuffers(1, &_stencilRenderBuffer);
			_stencilRenderBuffer = 0;
			_stencilBufferAvailable = NO;
			succeeded = YES;
			
		} else {
			Isgl3dLog(Info, @"Isgl3dGLContext2 : Separate stencil and depth buffers in use: all iSGL3D functionalities available.");
			succeeded = YES;
		}
	}
	else {
		Isgl3dLog(Info, @"Isgl3dGLContext2 : Packed stencil and depth buffer in use: all iSGL3D functionalities available.");
		succeeded = YES;
	}
	
	if (succeeded) {
		succeeded = [self createExtensionBuffers];
	}
	
	return succeeded;
}

- (BOOL)createExtensionBuffers {
	BOOL succeeded = NO;
	
	// MSAA support
    if (!_msaaAvailable) {
		Isgl3dLog(Info, @"Isgl3dGLContext2 : MSAA unavailable for device.");
        return YES;
    }
    
	if (_msaaEnabled) {
		// Get the maximum number of MSAA samples
		glGetIntegerv(GL_MAX_SAMPLES_APPLE, &_msaaSamples);
		if (_msaaSamples <= 0) {
			Isgl3dLog(Info, @"Isgl3dGLContext2 : MSAA unavailable for device (max samples <= 0).");
			return succeeded;
		}
		
		glGenFramebuffers(1, &_msaaFrameBuffer);
		glBindFramebuffer(GL_FRAMEBUFFER, _msaaFrameBuffer);
		
		glGenRenderbuffers(1, &_msaaColorRenderBuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, _msaaColorRenderBuffer);
		glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, _msaaSamples, GL_RGBA8_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _msaaColorRenderBuffer);
		
		// Try to attach packed depth and stencil buffer
		glGenRenderbuffers(1, &_msaaDepthAndStencilRenderBuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, _msaaDepthAndStencilRenderBuffer);
		
		glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, _msaaSamples, GL_DEPTH24_STENCIL8_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _msaaDepthAndStencilRenderBuffer);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, _msaaDepthAndStencilRenderBuffer);
		
		
		// Check if the creation of the packed depth and stencil buffers was successful
		// if not fallback to separate buffers
		if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
			glDeleteRenderbuffers(1, &_msaaDepthAndStencilRenderBuffer);
			_msaaDepthAndStencilRenderBuffer = 0;
			
			// Create and attach a separate depth buffer
			glGenRenderbuffers(1, &_msaaDepthRenderBuffer);
			glBindRenderbuffer(GL_RENDERBUFFER, _msaaDepthRenderBuffer);
			glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, _msaaSamples, GL_DEPTH_COMPONENT16, _backingWidth, _backingHeight);
			glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _msaaDepthRenderBuffer);
			if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
				Isgl3dLog(Error, @"Isgl3dGLContext2 : No MSAA depth buffer available on this device: failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
				return succeeded;
			}
			
			// Create and attach a separate stencil buffer
			glGenRenderbuffers(1, &_msaaStencilRenderBuffer);
			glBindRenderbuffer(GL_RENDERBUFFER, _msaaStencilRenderBuffer);
			glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, _msaaSamples, GL_STENCIL_INDEX8, _backingWidth, _backingHeight);
			glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, _msaaStencilRenderBuffer);
			if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
				Isgl3dLog(Info, @"Isgl3dGLContext2 : MSAA Depth buffer in use, no MSAA stencil buffer on this device: some iSGL3D functionalities are not available.");
				
				glDeleteRenderbuffers(1, &_msaaStencilRenderBuffer);
				_msaaStencilRenderBuffer = 0;
				_stencilBufferAvailable = NO;
				
			} else {
				Isgl3dLog(Info, @"Isgl3dGLContext2 : Separate MSAA stencil and depth buffers in use: all iSGL3D functionalities available.");
				succeeded = YES;
			}
		} else {
			Isgl3dLog(Info, @"Isgl3dGLContext2 : Complete MSAA framebuffer object created: all iSGL3D functionalities available.");
			succeeded = YES;
		}
	} else {
		succeeded  = YES;
	}
	
	return succeeded;
}

- (void)releaseBuffers {

	EAGLContext *oldContext = [EAGLContext currentContext];
	if (oldContext != _context)
		[EAGLContext setCurrentContext:_context];
	
	// Delete frame buffer and render buffers
	if (_defaultFrameBuffer) {
		glDeleteFramebuffers(1, &_defaultFrameBuffer);
		_defaultFrameBuffer = 0;
	}
	
	if (_colorRenderBuffer) {
		glDeleteRenderbuffers(1, &_colorRenderBuffer);
		_colorRenderBuffer = 0;
	}
	
	if (_depthAndStencilRenderBuffer) {
		glDeleteRenderbuffers(1, &_depthAndStencilRenderBuffer);
		_depthAndStencilRenderBuffer = 0;
	}
	
	if (_depthRenderBuffer) {
		glDeleteRenderbuffers(1, &_depthRenderBuffer);
		_depthRenderBuffer = 0;
	}
	if (_stencilRenderBuffer) {
		glDeleteRenderbuffers(1, &_stencilRenderBuffer);
		_stencilRenderBuffer = 0;
	}
	
	[self releaseExtensionBuffers];

    _activeFrameBuffer = 0;
    _activeRenderBuffer = 0;
    
	if (oldContext != _context)
		[EAGLContext setCurrentContext:oldContext];
}

- (void)releaseExtensionBuffers {
	if (_msaaFrameBuffer)
	{
		glDeleteFramebuffers(1, &_msaaFrameBuffer);
		_msaaFrameBuffer = 0;
	}
	if (_msaaColorRenderBuffer)
	{
		glDeleteRenderbuffers(1, &_msaaColorRenderBuffer);
		_msaaColorRenderBuffer = 0;
	}
	if (_msaaDepthAndStencilRenderBuffer)
	{
		glDeleteRenderbuffers(1, &_msaaDepthAndStencilRenderBuffer);
		_msaaDepthAndStencilRenderBuffer = 0;
	}
	if (_msaaDepthRenderBuffer)
	{
		glDeleteRenderbuffers(1, &_msaaDepthRenderBuffer);
		_msaaDepthRenderBuffer = 0;
	}
	if (_msaaStencilRenderBuffer)
	{
		glDeleteRenderbuffers(1, &_msaaStencilRenderBuffer);
		_msaaStencilRenderBuffer = 0;
	}
}

- (void)freeCurrentRenderImageData
{
	if (_currentRenderImageDataRef)
	{
		CFRelease(_currentRenderImageDataRef);
		_currentRenderImageDataRef = NULL;
	}
	
	if (_currentRenderImageData)
	{
		free(_currentRenderImageData);
		_currentRenderImageData = NULL;
	}
	
	if (_currentRenderImage)
	{
		CGImageRelease(_currentRenderImage);
		_currentRenderImage = NULL;
	}
}


- (Isgl3dGLProgram *) createProgram {
	return [[[Isgl3dGLProgram alloc] init] autorelease];
}

- (void) useProgram:(Isgl3dGLProgram *)program {
	glUseProgram([program glProgram]);
}

- (Isgl3dGLRenderer *) createRenderer {
	_currentRenderer = [[Isgl3dGLRenderer2 alloc] init];
	_currentRenderer.stencilBufferAvailable = self.stencilBufferAvailable;

	return [_currentRenderer autorelease];
}

- (void) prepareRender {
	[super prepareRender];
	
	if(_msaaAvailable && _msaaEnabled) {
        self.activeFrameBuffer = _msaaFrameBuffer;
	} else {
        self.activeFrameBuffer = _defaultFrameBuffer;
	}
    self.activeRenderBuffer = _colorRenderBuffer;
}

- (void) finalizeRender {
	[super finalizeRender];
	
	if (_msaaAvailable && _msaaEnabled) {
		//glDisable(GL_SCISSOR_TEST);
        _activeFrameBuffer = 0;
		glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, _defaultFrameBuffer);
		glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _msaaFrameBuffer);
		glResolveMultisampleFramebufferAPPLE();
        
        if (_framebufferDiscardAvailable) {
            if (_stencilBufferAvailable) {
                const GLenum discards[] = { GL_COLOR_ATTACHMENT0, GL_DEPTH_ATTACHMENT, GL_STENCIL_ATTACHMENT };
                glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 3, discards);
            } else {
                const GLenum discards[] = { GL_COLOR_ATTACHMENT0, GL_DEPTH_ATTACHMENT };
                glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 2, discards);
            }
        }
	}
    
    self.activeRenderBuffer = _colorRenderBuffer;
	[_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer {
	[self freeCurrentRenderImageData];

	// Recreate all buffers
	[self releaseBuffers];
	
	if ([self createBuffers:layer] == NO) {
		return NO;
	}

	// Get current width and height
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
	Isgl3dLog(Info, @"Isgl3dGLContext2 : Resizing OpenGL buffers to %ix%i", _backingWidth, _backingHeight);

	return YES;
}

- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y {
	
	uint8_t pixelData[4]; 
	glReadPixels(x, _backingHeight - y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, &pixelData);
	
	NSString * pixelString = [NSString stringWithFormat:@"0x%02X%02X%02X", pixelData[0], pixelData[1], pixelData[2]];
	
	return pixelString;
}

- (CGImageRef)currentRenderImage
{
	NSInteger x = 0, y = 0;
	NSInteger width = _backingWidth, height = _backingHeight;
	static NSInteger dataLength = 0;
	
	if (_currentRenderImageData == nil)
	{
		dataLength = width * height * 4;
		_currentRenderImageData = (GLubyte *)malloc(dataLength * sizeof(GLubyte));
		_currentRenderImageDataRef = CGDataProviderCreateWithData(NULL, _currentRenderImageData, dataLength, NULL);
	}
	
	// Read pixel data from the framebuffer
	glPixelStorei(GL_PACK_ALIGNMENT, 4);
	glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, _currentRenderImageData);
	
	// Create a CGImage with the pixel data
	// If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
	// otherwise, use kCGImageAlphaPremultipliedLast
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGImageRef newImage = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaNoneSkipLast,
										_currentRenderImageDataRef, NULL, true, kCGRenderingIntentDefault);
	
	NSInteger widthInPoints, heightInPoints;
	
	// OpenGL ES measures data in PIXELS
	// Create a graphics context with the target size measured in POINTS
	if (NULL != UIGraphicsBeginImageContextWithOptions)
	{
		// scale is not supported
		CGFloat scale = 1.0;
		widthInPoints = width / scale;
		heightInPoints = height / scale;
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, scale);
	}
	else
	{
		// On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
		widthInPoints = width;
		heightInPoints = height;
		UIGraphicsBeginImageContext(CGSizeMake(widthInPoints, heightInPoints));
	}
	
	CGContextRef cgcontext = UIGraphicsGetCurrentContext();
	CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
	
	// UIKit coordinate system is upside down to GL/Quartz coordinate system
	// Flip the CGImage by rendering it to the flipped bitmap context
	// The size of the destination area is measured in POINTS
	CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), newImage);
	
	_currentRenderImage = CGBitmapContextCreateImage(cgcontext);
	
	UIGraphicsEndImageContext();
	
	CGImageRelease(newImage);
	CFRelease(colorspace);
		
	return _currentRenderImage;
}

- (void) setMsaaEnabled:(BOOL)value {
    if (!_msaaAvailable)
        return;
    
    if (_msaaEnabled != value) {
        _msaaEnabled = value;
        
        if (_msaaEnabled) {
            [self createExtensionBuffers];
        } else {
            [self releaseExtensionBuffers];
        }
    }
}

- (void)switchToStandardBuffers
{
    self.activeFrameBuffer = _defaultFrameBuffer;
    self.activeRenderBuffer = _colorRenderBuffer;
}

- (void)switchToMsaaBuffers
{
	if (_msaaAvailable && _msaaEnabled) {
        self.activeFrameBuffer = _msaaFrameBuffer;
        self.activeRenderBuffer = _msaaColorRenderBuffer;
	}
}

- (void)setActiveFrameBuffer:(GLuint)buffer {
    if (_activeFrameBuffer != buffer) {
        _activeFrameBuffer = buffer;
        glBindFramebuffer(GL_FRAMEBUFFER, _activeFrameBuffer);
    }
}

- (void)setActiveRenderBuffer:(GLuint)buffer {
    if (_activeRenderBuffer != buffer) {
        _activeRenderBuffer = buffer;
        glBindRenderbuffer(GL_RENDERBUFFER, _activeRenderBuffer);
    }
}

@end
