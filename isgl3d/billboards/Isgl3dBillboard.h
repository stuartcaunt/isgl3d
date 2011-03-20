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

#import "Isgl3dGLParticle.h"

/**
 * The Isgl3dBillboard is a simple wrapper class using thie Isgl3dGLParticle. Essential billboard functionality
 * is performed using OpenGL point sprites (encapsulated by the Isgl3dGLParticle). It therefore has certain limitations,
 * for example, sprites are square so rectangular billboards need to have textures that have transparent bands (and alpha
 * culling is needed to correctly render with a depth buffer).
 * 
 * Furthermore, in OpenGL, sprites are rendered face-on to the viewer and are not affected by rotational transformations. The only transformations that
 * can be performed on sprites (more specifically, the Isgl3dParticleNode) are translational ones. For this reason, even if the device
 * is in landscape mode, particles will be rendered as if it is portrait (no rotation can be performed, even along the z-axis).
 * 
 * For more information see Isgl3dParticleNode.
 * 
 */
@interface Isgl3dBillboard : Isgl3dGLParticle {
	
}

@end
