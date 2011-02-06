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

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "Isgl3dGLContext.h"

@class Isgl3dGLProgram;
@class Matrix4D;

@interface Isgl3dGLContext2 : Isgl3dGLContext {

@private
	EAGLContext * _context;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint _defaultFramebuffer;
	GLuint _colorRenderbuffer;

	GLuint _depthAndStencilRenderBuffer;
	GLuint _depthRenderBuffer;
	GLuint _stencilRenderBuffer;

}

- (id) initWithLayer:(CAEAGLLayer *) layer;

/**
 * @result (autorelease) a new GLProgram
 */
- (Isgl3dGLProgram *) createProgram;
- (void) useProgram:(Isgl3dGLProgram *)program;

@end

