/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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
#import "Isgl3dGLContext2.h"


@interface Isgl3dGLDepthRenderTexture2 () {
@private
	GLuint _frameBuffer;
	GLuint _depthRenderBuffer;
	
	GLint _oldFrameBuffer;
    GLint _oldRenderBuffer;

    Isgl3dGLDepthRenderTextureCulling _culling;
}

@end


#pragma mark -
@implementation Isgl3dGLDepthRenderTexture2

@synthesize culling = _culling;


- (id)initWithId:(unsigned int)textureId width:(unsigned int)width height:(unsigned int)height {
	
	if (self = [super initWithId:textureId width:width height:height]) {
        
        _culling = Isgl3dGLDepthRenderTextureCullingFront;
        
        _depthRenderBuffer = GL_NONE;
        _oldRenderBuffer = GL_NONE;
        
		// Create depth frame buffer
		glGenFramebuffers(1, &_frameBuffer);
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_oldFrameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);

		glBindTexture(GL_TEXTURE_2D, self.textureId);
        
        if ([Isgl3dGLContext2 openGLExtensionSupported:@"GL_OES_depth_texture"]) {
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, self.textureId, 0);
        } else {
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.textureId, 0);

            glGenRenderbuffers(1, &_depthRenderBuffer);
            glGetIntegerv(GL_RENDERBUFFER_BINDING, &_oldRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
            
            glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
        }
        
		if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
			Isgl3dClassDebugLog(Isgl3dLogLevelError, @"Failed to make complete framebuffer object for depth render texture %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
		}
		
		glBindFramebuffer(GL_FRAMEBUFFER, _oldFrameBuffer);
        if (_oldRenderBuffer != GL_NONE)
            glBindRenderbuffer(GL_RENDERBUFFER, _oldRenderBuffer);
	}
	
	return self;
}

- (void)dealloc {
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

- (void)clear {
	glViewport(0, 0, self.width, self.height);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	glEnable(GL_DEPTH_TEST);
	glClearDepthf(1.0f);

    if (self.culling != Isgl3dGLDepthRenderTextureCullingNone) {
        glEnable(GL_CULL_FACE);
        glCullFace(self.culling);
    }
}


- (void)initializeRender {
	glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    if (_depthRenderBuffer != GL_NONE)
        glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
}

- (void)finalizeRender {
	glBindFramebuffer(GL_FRAMEBUFFER, _oldFrameBuffer);
    if (_oldRenderBuffer != GL_NONE)
        glBindRenderbuffer(GL_RENDERBUFFER, _oldRenderBuffer);
}

@end
