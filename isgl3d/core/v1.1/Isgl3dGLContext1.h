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

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Isgl3dGLContext.h"


/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dGLContext1 : Isgl3dGLContext {

@private
	EAGLContext * _context;

	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint _defaultFrameBuffer;
	GLuint _colorRenderBuffer;

	GLuint _depthAndStencilRenderBuffer;
	GLuint _depthRenderBuffer;
	GLuint _stencilRenderBuffer;
	
	// OpenGL MSAA buffers
	GLuint _msaaFrameBuffer;
	GLuint _msaaColorRenderBuffer;
	
	GLuint _msaaDepthAndStencilRenderBuffer;
	GLuint _msaaDepthRenderBuffer;
	GLuint _msaaStencilRenderBuffer;
}

- (id) initWithLayer:(CAEAGLLayer *) layer;

@end

