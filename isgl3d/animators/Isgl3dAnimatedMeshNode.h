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

#import "Isgl3dMeshNode.h"

@class Isgl3dGLMesh;
@class Isgl3dMaterial;
@class Isgl3dBoneBatch;

/**
 * The Isgl3dAnimatedMeshNode is the main container for animating meshes and skinning bones.
 * 
 * Given a mesh (which is non-animated by default) and a material and subsequently adding a number of bone batches 
 * (a bone batch containes several bones attached to a portion of the mesh), the mesh can
 * be animated to follow the movement of the bones for a given frame number.
 */
@interface Isgl3dAnimatedMeshNode : Isgl3dMeshNode {

@private
	NSMutableArray * _boneBatches;
	
	unsigned int _numberOfBonesPerVertex;
}


/**
 * Allocates and initialises (autorelease) node with a mesh to be animated and a material.
 * @param mesh The mesh to be animated.
 * @param material The material associated with the mesh
 */
+ (id) nodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material;

/**
 * Initialises the node with a mesh to be animated and a material.
 * @param mesh The mesh to be animated.
 * @param material The material associated with the mesh
 */
- (id) initWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material;

/**
 * Adds a bone batch to the node, used to animate a section of the mesh.
 * @param boneBatch The bone batch.
 */
- (void) addBoneBatch:(Isgl3dBoneBatch *)boneBatch;

/**
 * Sets the number of bones associated with each vertex.
 * @param numberOfBonesPerVertex The number of bones per vertex.
 */
- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex;

/**
 * Sets the current frame number, used to update the animation.
 * When the frame number is modified, all associated bone batches are notified of the change and the current
 * frame number. At the following render stage, all bone transformations are recalculated accordingly. 
 * @param frameNumber The number of the frame to be shown.
 */
- (void) setFrame:(unsigned int)frameNumber;

@end
