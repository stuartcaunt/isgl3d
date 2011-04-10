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

#import "Isgl3dMatrix.h"

@class Isgl3dArray;
@class Isgl3dBoneNode;
@class Isgl3dGLRenderer;

/**
 * An Isgl3dBoneBatch is used to add bones to the vertices of a portion of a mesh.
 * 
 * Due to limitations in the GPU to the number of bones that can be associated with a full mesh (maximum of 8), the mesh is split 
 * up into different parts, each part associated with only some of the bones. These parts are then sent to the renderer separately.
 * 
 * The bone batch is therefore strongly tied to the mesh to be animated: it is initialised with the number of elements (vertices)
 * of the mesh concerned as well as the element offset (first concerned element in the full array of mesh elements).
 * 
 * Isgl3DBoneBatches are added directly to Isgl3dAnimatedMeshes to provide the animation.
 * 
 * The animation is controlled by adding transformations for all the bones for a given frame of the animation. The mesh data should 
 * already be associated with bone indices so index of the matrix in this array needs to correspond to the same one.
 * 
 */
@interface Isgl3dBoneBatch : NSObject {

@private
	NSMutableDictionary * _frameTransformations;

	Isgl3dArray * _currentFrameGlobalTransformations;
	Isgl3dArray * _currentFrameGlobalInverseTransformations;

	unsigned int _numberOfElements;
	unsigned int _elementOffset;

	unsigned int _currentFrameNumber;
	
	BOOL _transformationDirty;
	BOOL _frameChanged;
}

/**
 * Allocates and initialises (autorelease) bone batch with a portion of the mesh to be animated.
 * @param numberOfElements The number of elements (vertices) concerned with this bone batch.
 * @param elementOffset The starting offset of the original mesh for this bone batch.
 */
+ (id) boneBatchWithNumberOfElements:(unsigned int)numberOfElements andElementOffset:(unsigned int)elementOffset;

/**
 * Initialises the bone batch with a portion of the mesh to be animated.
 * @param numberOfElements The number of elements (vertices) concerned with this bone batch.
 * @param elementOffset The starting offset of the original mesh for this bone batch.
 */
- (id) initWithNumberOfElements:(unsigned int)numberOfElements andElementOffset:(unsigned int)elementOffset;

/**
 * Adds the bone transformations for a given frame number.
 * The order of the transformations in the array needs to correspond to the bone indices in the mesh data.
 * @param transformations The Isgl3dArray of transformations (Isgl3dMatrix4 structure) for each of the bones associated with the bone batch.
 * @param frame The corresponding frame number.
 */
- (void) addBoneTransformations:(Isgl3dArray *)transformations forFrame:(unsigned int)frame;

/*
 * Sets the frame number and accordingly the transformation for each bone.
 * @param frameNumber The desired frame number
 * 
 * Note that this is called internally in iSGL3D by the Isgl3dAnimatedMesh which iterates over all bone batches
 * associated with the mesh: this method should never be called explicitly. 
 */
- (void) setFrame:(unsigned int)frameNumber;

/*
 * Renders the corresponding portion of the mesh with the Isgl3DRender.
 * @param renderer The renderer.
 * 
 * Note that this is called internally in iSGL3D and should never be called explicitly.
 */
- (void) renderMesh:(Isgl3dGLRenderer *)renderer;

/*
 * Specifies that the global transformation needs to be updated.
 * @param isDirty Indicates if the transformation is dirty or not.
 * 
 * Note that this is called internally in iSGL3D and should never be called explicitly.
 */
- (void) setTransformationDirty:(BOOL)isDirty;

/*
 * Updates the global transformation of the node.
 * @param parentTransformation The global transformation of the parent node.
 * 
 * Note that this is called internally in iSGL3D and should never be called explicitly.
 */
- (void) updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation;

@end
