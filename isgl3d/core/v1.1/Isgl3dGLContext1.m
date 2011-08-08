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

#import "Isgl3dGLContext1.h"
#import "Isgl3dGLTextureFactory.h"
#import "Isgl3dGLTextureFactoryState1.h"
#import "Isgl3dGLVBOFactory1.h"
#import "Isgl3dGLRenderer1.h"
#import "Isgl3dLog.h"


@interface Isgl3dGLContext1 ()
- (void) checkGLExtensions;
- (BOOL) createBuffers:(CAEAGLLayer *)eaglLayer;
- (BOOL) createExtensionBuffers;
- (void) releaseBuffers;
- (void) releaseExtensionBuffers;
@end


@implementation Isgl3dGLContext1

// Create an ES 1.1 context
- (id) initWithLayer:(CAEAGLLayer *) layer {
	
	if ((self = [super init])) {

		_msaaAvailable = NO;
		_msaaEnabled = NO;
		_framebufferDiscardAvailable = NO;
		
		// Create the OpenGL context using ES 1.1
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
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
		[[Isgl3dGLTextureFactory sharedInstance] setState:[[[Isgl3dGLTextureFactoryState1 alloc] init] autorelease]];
		[[Isgl3dGLVBOFactory sharedInstance] setConcreteFactory:[[[Isgl3dGLVBOFactory1 alloc] init] autorelease]];

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
	
	
	[super dealloc];
}


- (void) checkGLExtensions {
	// Check and activate additional OpenGL extensions
	//const GLubyte *str = glGetString(GL_EXTENSIONS);
	//NSString *featuresStr = [NSString stringWithCString:(const char *)str encoding:NSASCIIStringEncoding];
	
	//_msaaAvailable = ([featuresStr rangeOfString:@"GL_APPLE_framebuffer_multisample"].location != NSNotFound);
	//_framebufferDiscardAvailable = ([featuresStr rangeOfString:@"GL_EXT_discard_framebuffer"].location != NSNotFound);

#if (GL_APPLE_framebuffer_multisample==1)
	_msaaAvailable = YES;
#else
	_msaaAvailable = NO;
#endif
	
#if	(EXT_discard_framebuffer==1)
	_framebufferDiscardAvailable = YES;
#else
	_framebufferDiscardAvailable = NO;
#endif
}

- (BOOL) createBuffers:(CAEAGLLayer *)eaglLayer {
	BOOL succeeded = NO;
	
	_depthAndStencilRenderBuffer = 0;
	_depthRenderBuffer = 0;
	_stencilRenderBuffer = 0;
	_stencilBufferAvailable = YES;
		
	// Create and bind the color render buffer
	glGenRenderbuffersOES(1, &_colorRenderBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer);
	
	if(![_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:eaglLayer]) {
		glDeleteRenderbuffersOES(1, &_colorRenderBuffer);
		return succeeded;
	}
	
	// Get the width and height
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);

	// Create and bind the frame buffer, attach the color render buffer to the framebuffer
	glGenFramebuffersOES(1, &_defaultFrameBuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFrameBuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _colorRenderBuffer);

	// Try to attach packed depth and stencil buffer
	glGenRenderbuffersOES(1, &_depthAndStencilRenderBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthAndStencilRenderBuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH24_STENCIL8_OES, _backingWidth, _backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthAndStencilRenderBuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_STENCIL_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthAndStencilRenderBuffer);
	
	// Check if the creation of the packed depth and stencil buffers was successful
	// if not fallback to separate buffers
	if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		// Cleanup first
		glDeleteRenderbuffersOES(1, &_depthAndStencilRenderBuffer);
		_depthAndStencilRenderBuffer = 0;

		// Create an attach a separate depth buffer
		glGenRenderbuffersOES(1, &_depthRenderBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderBuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderBuffer);
		if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
			Isgl3dLog(Error, @"Isgl3dGLContext1 : No depth buffer available on this device: failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
			return succeeded;
		}

		// Create and attach a separate stencil buffer
		glGenRenderbuffersOES(1, &_stencilRenderBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _stencilRenderBuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_STENCIL_INDEX8_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_STENCIL_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _stencilRenderBuffer);
		if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
			Isgl3dLog(Info, @"Isgl3dGLContext1 : Depth buffer in use, no stencil buffer on this device: some iSGL3D functionalities are not available.");
			
			glDeleteRenderbuffersOES(1, &_stencilRenderBuffer);
			_stencilRenderBuffer = 0;
			_stencilBufferAvailable = NO;
			succeeded = YES;
			
		} else {
			Isgl3dLog(Info, @"Isgl3dGLContext1 : Separate stencil and depth buffers in use: all iSGL3D functionalities available.");
			succeeded = YES;
		}
	}
	else {
		Isgl3dLog(Info, @"Isgl3dGLContext1 : Packed stencil and depth buffer in use: all iSGL3D functionalities available.");
		succeeded = YES;
	}

	if (succeeded) {
		[self createExtensionBuffers];
	}
	
	return succeeded;
}

- (BOOL)createExtensionBuffers {
	BOOL succeeded = NO;

	
	// MSAA support
    if (!_msaaAvailable) {
		Isgl3dLog(Info, @"Isgl3dGLContext1 : MSAA unavailable for device.");
        return succeeded;
    }
	
	// MSAA
	if (_msaaEnabled) {
		// Get the maximum number of MSAA samples
		glGetIntegerv(GL_MAX_SAMPLES_APPLE, &_msaaSamples);
		if (_msaaSamples <= 0) {
			Isgl3dLog(Info, @"Isgl3dGLContext1 : MSAA unavailable for device.");
			return succeeded;
		} else {
			Isgl3dLog(Info, @"Isgl3dGLContext1 : MSAA available for device, using %i samples.", _msaaSamples);
		}
		
		glGenFramebuffersOES(1, &_msaaFrameBuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _msaaFrameBuffer);
		
		glGenRenderbuffersOES(1, &_msaaColorRenderBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _msaaColorRenderBuffer);
		glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES, _msaaSamples, GL_RGBA8_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _msaaColorRenderBuffer);
		
		// Try to attach packed depth and stencil buffer
		glGenRenderbuffersOES(1, &_msaaDepthAndStencilRenderBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _msaaDepthAndStencilRenderBuffer);
		
		glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES, _msaaSamples, GL_DEPTH24_STENCIL8_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _msaaDepthAndStencilRenderBuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_STENCIL_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _msaaDepthAndStencilRenderBuffer);
		
		
		// Check if the creation of the packed depth and stencil buffers was successful
		// if not fallback to separate buffers
		if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
			glDeleteRenderbuffersOES(1, &_msaaDepthAndStencilRenderBuffer);
			_msaaDepthAndStencilRenderBuffer = 0;
			
			// Create and attach a separate depth buffer
			glGenRenderbuffersOES(1, &_msaaDepthRenderBuffer);
			glBindRenderbufferOES(GL_RENDERBUFFER_OES, _msaaDepthRenderBuffer);
			glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES, _msaaSamples, GL_DEPTH_COMPONENT16_OES, _backingWidth, _backingHeight);
			glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _msaaDepthRenderBuffer);
			if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
				Isgl3dLog(Error, @"Isgl3dGLContext2 : No MSAA depth buffer available on this device: failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
				return succeeded;
			}
			
			// Create and attach a separate stencil buffer
			glGenRenderbuffersOES(1, &_msaaStencilRenderBuffer);
			glBindRenderbufferOES(GL_RENDERBUFFER_OES, _msaaStencilRenderBuffer);
			glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER_OES, _msaaSamples, GL_STENCIL_INDEX8_OES, _backingWidth, _backingHeight);
			glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_STENCIL_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _msaaStencilRenderBuffer);
			if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
				Isgl3dLog(Info, @"Isgl3dGLContext2 : MSAA Depth buffer in use, no MSAA stencil buffer on this device: some iSGL3D functionalities are not available.");
				
				glDeleteRenderbuffersOES(1, &_msaaStencilRenderBuffer);
				_msaaStencilRenderBuffer = 0;
				_stencilBufferAvailable = NO;
				
			} else {
				Isgl3dLog(Info, @"Isgl3dGLContext1 : Separate MSAA stencil and depth buffers in use: all iSGL3D functionalities available.");
				succeeded = YES;
			}
		} else {
			Isgl3dLog(Info, @"Isgl3dGLContext1 : Complete MSAA framebuffer object created: all iSGL3D functionalities available.");
			succeeded = YES;
		}
	} else {
		Isgl3dLog(Info, @"Isgl3dGLContext1 : MSAA unavailable for device.");
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
		glDeleteFramebuffersOES(1, &_defaultFrameBuffer);
		_defaultFrameBuffer = 0;
	}
	
	if (_colorRenderBuffer) {
		glDeleteRenderbuffersOES(1, &_colorRenderBuffer);
		_colorRenderBuffer = 0;
	}
	
	if (_depthAndStencilRenderBuffer) {
		glDeleteRenderbuffersOES(1, &_depthAndStencilRenderBuffer);
		_depthAndStencilRenderBuffer = 0;
	}
	
	if (_depthRenderBuffer) {
		glDeleteRenderbuffersOES(1, &_depthRenderBuffer);
		_depthRenderBuffer = 0;
	}
	if (_stencilRenderBuffer) {
		glDeleteRenderbuffersOES(1, &_stencilRenderBuffer);
		_stencilRenderBuffer = 0;
	}
	
	[self releaseExtensionBuffers];
	
	if (oldContext != _context)
		[EAGLContext setCurrentContext:oldContext];
}

- (void)releaseExtensionBuffers {
	if (_msaaFrameBuffer)
	{
		glDeleteFramebuffersOES(1, &_msaaFrameBuffer);
		_msaaFrameBuffer = 0;
	}
	if (_msaaColorRenderBuffer)
	{
		glDeleteRenderbuffersOES(1, &_msaaColorRenderBuffer);
		_msaaColorRenderBuffer = 0;
	}
	if (_msaaDepthAndStencilRenderBuffer)
	{
		glDeleteRenderbuffersOES(1, &_msaaDepthAndStencilRenderBuffer);
		_msaaDepthAndStencilRenderBuffer = 0;
	}
	if (_msaaDepthRenderBuffer)
	{
		glDeleteRenderbuffersOES(1, &_msaaDepthRenderBuffer);
		_msaaDepthRenderBuffer = 0;
	}
	if (_msaaStencilRenderBuffer)
	{
		glDeleteRenderbuffersOES(1, &_msaaStencilRenderBuffer);
		_msaaStencilRenderBuffer = 0;
	}
}


- (Isgl3dGLRenderer *) createRenderer {
	_currentRenderer = [[Isgl3dGLRenderer1 alloc] init];
	_currentRenderer.stencilBufferAvailable = self.stencilBufferAvailable;
	
	return [_currentRenderer autorelease];
}

- (void) prepareRender {
	[super prepareRender];
	
	if(_msaaAvailable && _msaaEnabled){		
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _msaaFrameBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _msaaColorRenderBuffer);
	} else {
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFrameBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer);
	}
}

- (void) finalizeRender {
	[super finalizeRender];

	if (_msaaAvailable && _msaaEnabled) {
		//glDisable(GL_SCISSOR_TEST);
		glBindFramebufferOES(GL_READ_FRAMEBUFFER_APPLE, _msaaFrameBuffer);
		glBindFramebufferOES(GL_DRAW_FRAMEBUFFER_APPLE, _defaultFrameBuffer);
		glResolveMultisampleFramebufferAPPLE();
	}
	
	if (_framebufferDiscardAvailable) {
		const GLenum discards[] = { GL_COLOR_ATTACHMENT0_OES, GL_DEPTH_ATTACHMENT_OES, GL_STENCIL_ATTACHMENT_OES };
		glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 3, discards);
	}
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer);
	[_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer {
	// Recreate all buffers
	[self releaseBuffers];
	
	if ([self createBuffers:layer] == NO) {
		return NO;
	}

	// Get current width and height
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);
	Isgl3dLog(Info, @"Isgl3dGLContext1 : Resizing OpenGL buffers to %ix%i", _backingWidth, _backingHeight);

	return YES;
}

- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y {
	
	uint8_t pixelData[4]; 
	glReadPixels(x, _backingHeight - y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, &pixelData);
	
	NSString * pixelString = [NSString stringWithFormat:@"0x%02X%02X%02X", pixelData[0], pixelData[1], pixelData[2]];
	return pixelString;
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

- (void) switchToStandardBuffers
{
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFrameBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer);
}

- (void) switchToMsaaBuffers
{
	if (_msaaAvailable && _msaaEnabled) {
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _msaaFrameBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _msaaColorRenderBuffer);
	}
}

@end
