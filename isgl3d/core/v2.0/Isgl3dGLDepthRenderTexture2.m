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

#import "Isgl3dGLDepthRenderTexture2.h"
#import "Isgl3dLog.h"

@implementation Isgl3dGLDepthRenderTexture2


- (id)initWithId:(unsigned int)textureId width:(unsigned int)width height:(unsigned int)height {
	
	if ((self = [super initWithId:textureId width:width height:height])) {
		// Create depth frame buffer
		glGenFramebuffers(1, &_frameBuffer);
		glGenRenderbuffers(1, &_depthRenderBuffer);
		
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_oldFrameBuffer);
		glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);

		glBindTexture(GL_TEXTURE_2D, self.textureId);
		glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.textureId, 0);
	
		glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
		glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.width, self.height);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
			
		if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
			Isgl3dLog(Error, @"Failed to make complete framebuffer object for depth render texture %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
		}
		
		glBindFramebuffer(GL_FRAMEBUFFER, _oldFrameBuffer);
	}
	
	return self;
}

- (void) dealloc {
	if (_frameBuffer) {
		glDeleteFramebuffers(1, &_frameBuffer);
		_frameBuffer = 0;
	}

	if (_depthRenderBuffer) {
		glDeleteRenderbuffers(1, &_depthRenderBuffer);
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
	glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
}

- (void) finalizeRender {
	glBindFramebuffer(GL_FRAMEBUFFER, _oldFrameBuffer);
}

@end
