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

@implementation Isgl3dGLContext1

// Create an ES 1.1 context
- (id) initWithLayer:(CAEAGLLayer *) layer {
	
	if ((self = [super init])) {

		// Create the OpenGL context using ES 1.1
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		if (!_context || ![EAGLContext setCurrentContext:_context]) {
			[self release];
			return nil;
		}

		// Create the frame buffer
		glGenFramebuffersOES(1, &_defaultFramebuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFramebuffer);
		
		// Create the color render buffer and attach to frame buffer
		glGenRenderbuffersOES(1, &_colorRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
		[_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _colorRenderbuffer);

		// Get the width and height
		glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
		glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);


		_depthAndStencilRenderBuffer = 0;
		_depthRenderBuffer = 0;
		_stencilRenderBuffer = 0;
		_stencilBufferAvailable = YES;

		// Try to attach packed depth and stencil buffer
		glGenRenderbuffersOES(1, &_depthAndStencilRenderBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthAndStencilRenderBuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH24_STENCIL8_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthAndStencilRenderBuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_STENCIL_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthAndStencilRenderBuffer);

		// Test if it's ok
		if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {

			glDeleteRenderbuffersOES(1, &_depthAndStencilRenderBuffer);
			_depthAndStencilRenderBuffer = 0;

			// Create an attach a separate depth buffer
			glGenRenderbuffersOES(1, &_depthRenderBuffer);
			glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderBuffer);
			glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, _backingWidth, _backingHeight);
			glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderBuffer);
			if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
				Isgl3dLog(Error, @"Isgl3dGLContext1 : No depth buffer available on this device: failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
				[self release];
				return nil;
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
				
			} else {
				Isgl3dLog(Info, @"Isgl3dGLContext1 : Separate stencil and depth buffers in use: all iSGL3D functionalities available.");
			}

		} else {
			Isgl3dLog(Info, @"Isgl3dGLContext1 : Packed stencil and depth buffer in use: all iSGL3D functionalities available.");
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

	// Delete frame buffer and render buffers
	if (_defaultFramebuffer) {
		glDeleteFramebuffersOES(1, &_defaultFramebuffer);
		_defaultFramebuffer = 0;
	}

	if (_colorRenderbuffer) {
		glDeleteRenderbuffersOES(1, &_colorRenderbuffer);
		_colorRenderbuffer = 0;
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

- (void) prepare:(GLfloat *)clearColor {
	_clearColor[0] = clearColor[0];
	_clearColor[1] = clearColor[1];
	_clearColor[2] = clearColor[2];
	_clearColor[3] = clearColor[3];
	
	glViewport(0, 0, _backingWidth, _backingHeight);
	
	glClearColor(clearColor[0], clearColor[1], clearColor[2], clearColor[3]);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glEnable(GL_DEPTH_TEST);
	glClearDepthf(1.0f);
}


- (void) clearBuffer {

	glViewport(0, 0, _backingWidth, _backingHeight);
	glClearColor(_clearColor[0], _clearColor[1], _clearColor[2], _clearColor[3]);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

/*
	glEnable(GL_SCISSOR_TEST);	
	glViewport(50, 50, 220, 380);
	glScissor(50, 50, 220, 380);	
	glClearColor(_clearColor[0], _clearColor[1], _clearColor[2], _clearColor[3]);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
	glDisable(GL_SCISSOR_TEST);
*/
}

- (void) clearBufferForEventCapture {
	glClearColor(0, 0, 0, 1);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

- (void) clearDepthBuffer {
	glClear(GL_DEPTH_BUFFER_BIT);
}

- (Isgl3dGLRenderer *) createRenderer {
	_currentRenderer = [[Isgl3dGLRenderer1 alloc] init];
	_currentRenderer.stencilBufferAvailable = self.stencilBufferAvailable;
	
	return [_currentRenderer autorelease];
}

- (void) initializeRender {
//	[EAGLContext setCurrentContext:_context];
	
//	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFramebuffer);
}

- (void) finalizeRender {
	[super finalizeRender];
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
	[_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer {
	// Allocate color buffer storage
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
	[_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];

	// Get current width and height
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);

	// Allocate depth and stencil buffer storage
	if (_depthAndStencilRenderBuffer) {
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthAndStencilRenderBuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH24_STENCIL8_OES, _backingWidth, _backingHeight);
	} else {
		// Allocate depth buffer storage
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderBuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, _backingWidth, _backingHeight);

		if (_stencilRenderBuffer) {		
			// Allocate stencil buffer storage
			glBindRenderbufferOES(GL_RENDERBUFFER_OES, _stencilRenderBuffer);
			glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_STENCIL_INDEX8_OES, _backingWidth, _backingHeight);
		}
	}
	
	if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		Isgl3dLog(Error, @"Isgl3dGLContext1 : Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
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
