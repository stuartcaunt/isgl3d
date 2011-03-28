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

#import "Isgl3dGLDepthRenderTexture1.h"
#import "Isgl3dLog.h"

@implementation Isgl3dGLDepthRenderTexture1


- (id)initWithId:(unsigned int)textureId width:(unsigned int)width height:(unsigned int)height {
	
	if ((self = [super initWithId:textureId width:width height:height])) {
		// Create depth frame buffer
		glGenFramebuffersOES(1, &_frameBuffer);
		glGenRenderbuffersOES(1, &_depthRenderBuffer);
		
		glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, &_oldFrameBuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _frameBuffer);

		glBindTexture(GL_TEXTURE_2D, self.textureId);
		glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, self.textureId, 0);
	
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderBuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, self.width, self.height);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderBuffer);
			
		if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
			Isgl3dLog(Error, @"Failed to make complete framebuffer object for depth render texture %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		}
		
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _oldFrameBuffer);
	}
	
	return self;
}

- (void) dealloc {
	if (_frameBuffer) {
		glDeleteFramebuffersOES(1, &_frameBuffer);
		_frameBuffer = 0;
	}

	if (_depthRenderBuffer) {
		glDeleteRenderbuffersOES(1, &_depthRenderBuffer);
		_depthRenderBuffer = 0;
	}
	
	[super dealloc];
}

- (void) clear {
	glViewport(0, 0, self.width, self.height);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glClearColor(0, 0, 0, 1);
	glEnable(GL_DEPTH_TEST);
	glClearDepthf(1.0f);
}


- (void) initializeRender {
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _frameBuffer);
}

- (void) finalizeRender {
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _oldFrameBuffer);
}

@end
