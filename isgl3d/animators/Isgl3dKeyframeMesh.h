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
#import "Isgl3dGLMesh.h"
#import "Isgl3dVector.h"
#import "Isgl3dArray.h"

typedef struct {
	unsigned int meshIndex;
	unsigned int duration;
} Isgl3dKeyframeAnimationData;

typedef struct {
	Isgl3dVector3 vertexPosition;
	Isgl3dVector3 vertexNormal;
} Isgl3dKeyframeVertexData;

/**
 * The Isgl3dKeyframeMesh is used to perform keyframe vertex animation on meshes. A number of Isgl3dMeshes are passed to
 * the Isgl3dKeyframeMesh and the vertex positions and normals are interpolated between two of the meshes.
 * 
 * Animation data is provided for each key frame. This takes a mesh index and a duration of the frame. The interpolation occurs
 * between the current frame mesh and the next frame mesh with the interpolation factor dependent on the time within the 
 * frame.
 * 
 * Manualy animation can be performed either by using the "update" method and sending the delta time since the last interpolation, or
 * by specifying two different meshes and a given interpolation factor using the "interpolateMesh1:andMesh2:withFactor" method.
 * 
 * Automatic animation can be performed using the "startAnimation" and "stopAnimation" methods.
 * 
 * Note: All meshes must contain the same number of vertices. Interpolation occurs simply between vertices at the same location in
 * each mesh data array.
 */
@interface Isgl3dKeyframeMesh : Isgl3dGLMesh {

@private
	NSMutableArray * _meshData;
	Isgl3dArray * _animationData;
	
	unsigned int _numberOfVertices;
	unsigned int _stride;
	unsigned int _positionOffsetX;
	unsigned int _positionOffsetY;
	unsigned int _positionOffsetZ;
	unsigned int _normalOffsetX;
	unsigned int _normalOffsetY;
	unsigned int _normalOffsetZ;
	
	unsigned int _nMeshes;
	unsigned int _nFrames;
	unsigned int _currentFrameIndex;
	float _currentFrameDuration;
	
	BOOL _isAnimating;
	BOOL _isFirstRender;
}

/**
 * Returns the number of meshes used in the animations.
 */
@property (nonatomic, readonly) unsigned int nMeshes;

/**
 * Returns the number of frames in the animation.
 */
@property (nonatomic, readonly) unsigned int nFrames;

/**
 * Returns the current frame index.
 */
@property (nonatomic, readonly) unsigned int currentFrameIndex;

/**
 * Returns the current duration of the current frame.
 */
@property (nonatomic, readonly) float currentFrameDuration;

/**
 * Returns true if the mesh is animating automatically.
 */
@property (nonatomic, readonly) BOOL isAnimating;

/**
 * Allocates and initialises (autorelease) Isgl3dKeyframeMesh with an initial mesh.
 */
+ (id) keyframeMeshWithMesh:(Isgl3dGLMesh *)mesh;

/**
 * Initialises the Isgl3dKeyframeMesh with an initial mesh.
 */
- (id) initWithMesh:(Isgl3dGLMesh *)mesh;

/**
 * Adds new keyframe mesh data from an Isgl3dGLMesh.
 * @param mesh The mesh data to be added for a keyframe.
 */
- (void) addKeyframeMesh:(Isgl3dGLMesh *)mesh;

/**
 * Adds a new keyframe animation data.
 * @param meshIndex The mesh index for the frame (index relative to order in which meshes are added)
 * @param duration The duration of the frame. 
 */
- (void) addKeyframeAnimationData:(unsigned int)meshIndex duration:(float)duration;

/**
 * Updates the animation with a given delta time.
 * @param dt The delta time.
 */
- (void) update:(float)dt;

/**
 * Interpolates the mesh data between two meshes for a given factor between 0 and 1.
 * A factor of 0 corresponds to mesh1 being rendered, a factor of 1 corresponds to mesh2 being rendered.
 * @param mesh1Index the index of mesh1.
 * @param mesh2Index the index of mesh2.
 * @param factor the interpolation factor between 0 and 1.
 */
- (void) interpolateMesh1:(unsigned int)mesh1Index andMesh2:(unsigned int)mesh2Index withFactor:(float)factor;

/**
 * Starts automatic animation of the meshes.
 */
- (void) startAnimation;

/**
 * Stops the animation of the meshes.
 */
- (void) stopAnimation;

@end
