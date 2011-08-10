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

#import <Foundation/Foundation.h>

@class Isgl3dGLRenderer;
@class Isgl3dNode;

/**
 * The Isgl3dMaterial is the abstract class used for all materials in iSGL3D. It can not be rendered: an extended
 * class must be used to provide a real material for rendering.
 */
@interface Isgl3dMaterial : NSObject <NSCopying> {

@private

}

/*
 * Prepares the renderer for use with this material.
 * 
 * Note that this is intended for internal use only by iSGL3D and should never be called explicitly.
 * @param renderer The renderer
 * @param requirements The node requirements for the renderer
 * @param alpha The alpha value of the node being rendered.
 * @param node The node being rendered.
 */
- (void) prepareRenderer:(Isgl3dGLRenderer *)renderer requirements:(unsigned int)requirements alpha:(float)alpha node:(Isgl3dNode *)node;


@end
