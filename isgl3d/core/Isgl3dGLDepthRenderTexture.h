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

#import "Isgl3dGLTexture.h"

/**
 * The Isgl3dGLDepthRenderTexture is used internally to render z-buffer depth values onto a texture (used for example with shadow mapping).
 * 
 * Note : This class is intended for internal use only.
 */
@interface Isgl3dGLDepthRenderTexture : Isgl3dGLTexture {

}

/**
 * Initialises the Isgl3dGLDepthRenderTexture with an OpenGL texture object for a given width and height.
 */
- (id)initWithId:(unsigned int)textureId width:(unsigned int)width height:(unsigned int)height;

/**
 * Clears and prepares the texture.
 */
- (void)clear;

/**
 * Initializes the texture to be rendered onto.
 */
- (void)initializeRender;

/**
 * Finalizes the texture after rendering.
 */
- (void)finalizeRender;



@end
