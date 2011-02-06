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

#import "Isgl3dNode.h"

@class Isgl3dGLRenderer;
@class Isgl3dMatrix4D;

/**
 * The Isgl3dScene3D is the root node for a scene. It is associated closely to the Isgl3dView3D: the
 * view renders a single "active" scene.
 * 
 * The scene inherits from an Isgl3dNode implying that it is contains a number of child nodes: effectively
 * the whole of the scene is built by adding nodes to the scene (or as children of child nodes).
 */
@interface Isgl3dScene3D : Isgl3dNode {

@private
	NSMutableArray * _alphaNodes;
	NSMutableArray * _sortedNodes;
}

/**
 * Initialises the Isgl3dScene3D node.
 */
- (id) init;

/*
 * Renders all transparent objects on the scene, if the z-sorting option has been chosen in the view.
 * This handles z-buffer problems that can occur when one transparent object is rendered above another:
 * if the order of rendering is not correct then an object that is behind another may not be rendered
 * correctly.
 * 
 * Using the viewers position (taken from the view matrix), all transparent objects in the scene are
 * ordered in terms of distance from the viewer and rendered from furthest to closest.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 * 
 * @param renderer The Renderer.
 * @param viewMatrix The view matrix.
 */
- (void) renderZSortedAlphaObjects:(Isgl3dGLRenderer *)renderer viewMatrix:(Isgl3dMatrix4D *)viewMatrix;

@end
