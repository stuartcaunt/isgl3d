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

@class Isgl3dBoneNode;

/**
 * The Isgl3DSkeletonNode provides a parent container class for both Isgl3dAnimatedMeshes and Isgl3dBoneNodes.
 * 
 * Given an Isgl3dAnimated mesh and/or Isgl3dBoneNodes, the Isgl3dSkeletonNode provides a simple interface
 * to animate the 3D object.
 * 
 * By passing an instance of an Isgl3dSkeletonNode to the Isgl3dAnimationController, the whole of the animation
 * process can be automated.
 */
@interface Isgl3dSkeletonNode : Isgl3dNode {

@private

}

/*
 * Allocates and initialises (autorelease) Isgl3dSkeletonNode.
 */
+ (id) skeletonNode;

/*
 * Initialises the Isgl3dSkeletonNode.
 */
- (id) init;

/**
 * Creates an Isgl3dBoneNode and automatically adds it as a child.
 * The Isgl3dBoneNodes added directly to the skeleton represent the <em>top level</em> bones of the skeleton:
 * the Isgl3dBoneNode can also have bones attached to it to represent a complete structure of connected bones.
 * @return Isgl3dBoneNode (autorelease) The created bone node.
 */
- (Isgl3dBoneNode *) createBoneNode;

/**
 * Sets the frame number and accordingly the transformation for the connected Isgl3dAnimatedMesh and/or
 * the Isgl3dBoneNodes.
 * @param frameNumber The desired frame number
 * Note that this is called automatically by the Isgl3dAnimationController if this is in use. 
 */
- (void) setFrame:(unsigned int)frameNumber;

@end
