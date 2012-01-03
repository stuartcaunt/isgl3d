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

@class Isgl3dMaterial;
@class Isgl3dUVMap;
@class Isgl3dPlane;


typedef enum {
	FaceIdUnknown = -1,
	FaceIdFront,	// Z > 0.0
	FaceIdBack,		// Z < 0.0
	FaceIdRight,	// X > 0.0
	FaceIdLeft,		// X < 0.0
	FaceIdTop,		// Y > 0.0
	FaceIdBottom	// Y < 0.0
} FaceId;


/**
 * The Isgl3dMultiMaterialCube is not strictly speaking a primitive in iSGL3D, but rather a collection of 6 Isgl3dPlanes, each one
 * associated with a different Isgl3dMaterial.
 * 
 * As with the Isgl3dCube mesh, the Isgl3dMultiMaterialCube is more precisely a rectangular prism since the sides can 
 * be of different lengths. The cube is centered at the origin.
 * 
 * The Isgl3dMultiMaterialCube inherits directly from Isgl3dNode meaning that it can be directly added to the scene graph. Each face
 * of the cube is an Isgl3dMeshNode, added as a child to this node, constructed with an Isgl3dPlane mesh and an Isgl3dMaterial.
 * 
 * Each face is identified uniquely by a FaceId which can be FaceIdFront, FaceIdBack, FaceIdRight, FaceIdLeft, FaceIdTop or FaceIdBottom.
 */
@interface Isgl3dMultiMaterialCube : Isgl3dNode {

	float _width;	// Size on X-axis
	float _height;	// Size on Y-axis
	float _depth;	// Size on Z-axis
	
	// Number of face segments for each dimension 
	int _nSegmentWidth;
	int _nSegmentHeight;
	int _nSegmentDepth;
	
}


/**
 * Allocates and initialises (autorelease) geometry of the cube but does not construct any of the faces (Isgl3dMeshNodes) which are added separately with
 * the addFace method.
 * @param width The width of the cube along the x-axis.
 * @param height The height of the cube along the y-axis.
 * @param depth The depth of the cube along the z-axis.
 * @param nSegmentWidth The number of segments along the x-axis.
 * @param nSegmentHeight The number of segments along the y-axis.
 * @param nSegmentDepth The number of segments along the z-axis.
 */
+ (id) cubeWithDimensions:(float)width height:(float)height depth:(float)depth 
		 nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth;

/** 
 * Allocates and initialises (autorelease) geometry of the cube and constructs all the faces. All 6 faces must be included in the array of materials and uv maps.
 * @param materialArray NSArray of Isgl3dMaterial for each face material (array indices are referring to FaceId).
 * @param uvMapArray NSArray of Isgl3dUVMap for each face (array indices are referring to FaceId). If an uv map is nil, the standard uv map is used.
 * @param width The width of the cube along the x-axis.
 * @param height The height of the cube along the y-axis.
 * @param depth The depth of the cube along the z-axis.
 * @param nSegmentWidth The number of segments along the x-axis.
 * @param nSegmentHeight The number of segments along the y-axis.
 * @param nSegmentDepth The number of segments along the z-axis.
 */
+ (id) cubeWithDimensionsAndMaterials:(NSArray *)materialArray uvMapArray:(NSArray *)uvMapArray width:(float)width height:(float)height depth:(float)depth 
					 nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth;

/** 
 * Allocates and initialises (autorelease) geometry of the cube and constructs all the faces. The 6 faces are covered with color materials of random color.
 * @param width The width of the cube along the x-axis.
 * @param height The height of the cube along the y-axis.
 * @param depth The depth of the cube along the z-axis.
 * @param nSegmentWidth The number of segments along the x-axis.
 * @param nSegmentHeight The number of segments along the y-axis.
 * @param nSegmentDepth The number of segments along the z-axis.
 */
+ (id) cubeWithDimensionsAndRandomColors:(float)width height:(float)height depth:(float)depth 
					 nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth;

/**
 * Initialises the geometry of the cube but does not construct any of the faces (Isgl3dMeshNodes) which are added separately with
 * the addFace method.
 * @param width The width of the cube along the x-axis.
 * @param height The height of the cube along the y-axis.
 * @param depth The depth of the cube along the z-axis.
 * @param nSegmentWidth The number of segments along the x-axis.
 * @param nSegmentHeight The number of segments along the y-axis.
 * @param nSegmentDepth The number of segments along the z-axis.
 */
- (id) initWithDimensions:(float)width height:(float)height depth:(float)depth 
		 nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth;

/** 
 * Initialises the geometry of the cube and constructs all the faces. All 6 faces must be included in the array of materials and uv maps.
 * @param materialArray NSArray of Isgl3dMaterial for each face material (array indices are referring to FaceId).
 * @param uvMapArray NSArray of Isgl3dUVMap for each face (array indices are referring to FaceId). If an uv map is nil, the standard uv map is used.
 * @param width The width of the cube along the x-axis.
 * @param height The height of the cube along the y-axis.
 * @param depth The depth of the cube along the z-axis.
 * @param nSegmentWidth The number of segments along the x-axis.
 * @param nSegmentHeight The number of segments along the y-axis.
 * @param nSegmentDepth The number of segments along the z-axis.
 */
- (id) initWithDimensionsAndMaterials:(NSArray *)materialArray uvMapArray:(NSArray *)uvMapArray width:(float)width height:(float)height depth:(float)depth 
					 nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth;

/** 
 * Initialises the geometry of the cube and constructs all the faces. The 6 faces are covered with color materials of random color.
 * @param width The width of the cube along the x-axis.
 * @param height The height of the cube along the y-axis.
 * @param depth The depth of the cube along the z-axis.
 * @param nSegmentWidth The number of segments along the x-axis.
 * @param nSegmentHeight The number of segments along the y-axis.
 * @param nSegmentDepth The number of segments along the z-axis.
 */
- (id) initWithDimensionsAndRandomColors:(float)width height:(float)height depth:(float)depth 
					 nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth;

/**
 * Adds a face to the cube, corresponding to the passed FaceId.
 * @param faceId The FaceId of the face to create (can be FaceIdFront, FaceIdBack, FaceIdRight, FaceIdLeft, FaceIdTop or FaceIdBottom).
 * @param material The Isgl3dMaterial to be rendered on the face.
 * @param uvMap The Isgl3dUVMap corresponding to the face. If nil, the standard uv map is used.
 * @return The Isgl3dPlane mesh created for the face.
 */
- (Isgl3dPlane *) addFace:(FaceId)faceId material:(Isgl3dMaterial *)material uvMap:(const Isgl3dUVMap *)uvMap;

@end
