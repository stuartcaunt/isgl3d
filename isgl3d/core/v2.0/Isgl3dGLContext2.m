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

@implementation Isgl3dGLContext2

// Create an ES 2.0 context
- (id) initWithLayer:(CAEAGLLayer *) layer {
	
	if ((self = [super init])) {

		// Create the OpenGL context using ES 2.0
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		if (!_context || ![EAGLContext setCurrentContext:_context]) {
			[self release];
			return nil;
		}


		// Create the frame buffer
		glGenFramebuffers(1, &_defaultFramebuffer);
		glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
		
		// Create the color render buffer and attach to frame buffer
		glGenRenderbuffers(1, &_colorRenderbuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
		[_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
		
		// Get the width and height
		glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
		glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);


		_depthAndStencilRenderBuffer = 0;
		_depthRenderBuffer = 0;
		_stencilRenderBuffer = 0;
		_stencilBufferAvailable = YES;

		// Try to attach packed depth and stencil buffer
		glGenRenderbuffers(1, &_depthAndStencilRenderBuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, _depthAndStencilRenderBuffer);
		glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthAndStencilRenderBuffer);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, _depthAndStencilRenderBuffer);

		// Test if it's ok
		if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {

			glDeleteRenderbuffers(1, &_depthAndStencilRenderBuffer);
			_depthAndStencilRenderBuffer = 0;

			// Create an attach a separate depth buffer
			glGenRenderbuffers(1, &_depthRenderBuffer);
			glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
			glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _backingWidth, _backingHeight);
			glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
			if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
				Isgl3dLog(Error, @"Isgl3dGLContext2 : No depth buffer available on this device: failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
				[self release];
				return nil;
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
				
			} else {
				Isgl3dLog(Info, @"Isgl3dGLContext2 : Separate stencil and depth buffers in use: all iSGL3D functionalities available.");
			}

		} else {
			Isgl3dLog(Info, @"Isgl3dGLContext2 : Packed stencil and depth buffer in use: all iSGL3D functionalities available.");
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

	// Delete frame buffer and render buffers
	if (_defaultFramebuffer) {
		glDeleteFramebuffers(1, &_defaultFramebuffer);
		_defaultFramebuffer = 0;
	}

	if (_colorRenderbuffer) {
		glDeleteRenderbuffers(1, &_colorRenderbuffer);
		_colorRenderbuffer = 0;
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

- (void) finalizeRender {
	[super finalizeRender];
	
	glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
	[_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer {
	// Allocate color buffer storage
	glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
	[_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];

	// Get current width and height
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);

	Isgl3dLog(Info, @"Isgl3dGLContext2 : Resizing OpenGL buffers to %ix%i", _backingWidth, _backingHeight);
	

	if (_depthAndStencilRenderBuffer) {
		// Allocate depth and stencil buffer storage
		glBindRenderbuffer(GL_RENDERBUFFER, _depthAndStencilRenderBuffer);
		glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8_OES, _backingWidth, _backingHeight);
	} else {
		// Allocate depth buffer storage
		glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
		glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _backingWidth, _backingHeight);
		
		if (_stencilRenderBuffer) {		
			// Allocate stencil buffer storage
			glBindRenderbuffer(GL_RENDERBUFFER, _stencilRenderBuffer);
			glRenderbufferStorage(GL_RENDERBUFFER, GL_STENCIL_INDEX8, _backingWidth, _backingHeight);
		}
	}
	
	if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
		Isgl3dLog(Error, @"Isgl3dGLContext2 : Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
		return NO;
	}
	 
	return YES;
}

- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y {
	
	uint8_t pixelData[4]; 
	glReadPixels(x, _backingHeight - y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, &pixelData);
	
	NSString * pixelString = [NSString stringWithFormat:@"0x%02X%02X%02X", pixelData[0], pixelData[1], pixelData[2]];
	
	return pixelString;
}




@end
