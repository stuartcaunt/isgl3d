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

#import "Isgl3dKeyframeMesh.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dGLVBOFactory.h"
#import "Isgl3dLog.h"
#import "Isgl3dScheduler.h"

@interface Isgl3dKeyframeMesh ()
- (void) initialiseVBODataWithMesh:(Isgl3dGLMesh *)mesh;
- (Isgl3dArray *) createKeyframeMeshDataFromMesh:(Isgl3dGLMesh *)mesh;
@end

@implementation Isgl3dKeyframeMesh

@synthesize nMeshes = _nMeshes;
@synthesize nFrames = _nFrames;
@synthesize currentFrameIndex = _currentFrameIndex;
@synthesize currentFrameDuration = _currentFrameDuration;
@synthesize isAnimating = _isAnimating;

+ (id) keyframeMeshWithMesh:(Isgl3dGLMesh *)mesh {
	return [[[self alloc] initWithMesh:mesh] autorelease];
}

- (id) initWithMesh:(Isgl3dGLMesh *)mesh {
	if ((self = [super init])) {
		_meshData = [[NSMutableArray alloc] init];
		_animationData = IA_ALLOC_INIT(Isgl3dKeyframeAnimationData);

		_currentFrameIndex = 0;
		_currentFrameDuration = 0.0f;
		
		_isAnimating = NO;
		_isFirstRender = YES;
		
		[self initialiseVBODataWithMesh:mesh];
	}
	return self;
}

- (void) dealloc {
	if (_isAnimating) {
		[self stopAnimation];
	}
	
	[_meshData release];
	[_animationData release];
	

	[super dealloc];
}

- (void) initialiseVBODataWithMesh:(Isgl3dGLMesh *)mesh {
	// Initialise vertex data from mesh: 
	//   - All keyframe meshes added afterwards must have the same number of vertices
	[self setVertices:mesh.vertexData withVertexDataSize:mesh.vertexDataSize andIndices:mesh.indices withIndexDataSize:mesh.indexDataSize 
					andNumberOfElements:mesh.numberOfElements andVBOData:mesh.vboData];

	// Calculate number of vertices
	_numberOfVertices = _vertexDataSize / _vboData.stride;
	
	// Store vbo info to avoid recalculation
	_stride = _vboData.stride;
	_positionOffsetX = _vboData.positionOffset;
	_positionOffsetY = _vboData.positionOffset + sizeof(float);
	_positionOffsetZ = _vboData.positionOffset + 2 * sizeof(float);
	_normalOffsetX = _vboData.normalOffset;
	_normalOffsetY = _vboData.normalOffset + sizeof(float);
	_normalOffsetZ = _vboData.normalOffset + 2 * sizeof(float);

	// Add mesh data to keyframe meshes
	[self addKeyframeMesh:mesh];
}

- (void) addKeyframeMesh:(Isgl3dGLMesh *)mesh {
	// Create the keyframe mesh data from the original mesh data
	Isgl3dArray * meshData = [self createKeyframeMeshDataFromMesh:mesh];
	
	// Add keyframe mesh data to array
	if (meshData) {
		[_meshData addObject:meshData];
	
		// Update number of meshes	
		_nMeshes++;
	}
}

- (void) addKeyframeAnimationData:(unsigned int)meshIndex duration:(float)duration {
	// Add keyframe animation data (mesh index and duration)
	if (meshIndex < _nMeshes) {
		Isgl3dKeyframeAnimationData frame = {meshIndex, duration};
		IA_ADD(_animationData, frame);
		_nFrames++;
	
	} else {
		Isgl3dLog(Error, @"Isgl3dKeyframeMesh : animation data contains mesh index outside bounds");
	}
	
}

- (Isgl3dArray *) createKeyframeMeshDataFromMesh:(Isgl3dGLMesh *)mesh {
	// Verify that the new mesh data is coherent
	if (mesh.numberOfVertices != _numberOfVertices) {
		Isgl3dLog(Error, @"Isgl3dKeyframeMesh : cannot add mesh with %d vertices (expected %d)", mesh.numberOfVertices, _numberOfVertices);
		return nil;
	}

	// Get info of structure from vbo data
	Isgl3dGLVBOData * vboData = mesh.vboData;
	unsigned int stride = vboData.stride;
	unsigned int positionOffsetX = vboData.positionOffset;
	unsigned int positionOffsetY = vboData.positionOffset + sizeof(float);
	unsigned int positionOffsetZ = vboData.positionOffset + 2 * sizeof(float);
	unsigned int normalOffsetX = vboData.normalOffset;
	unsigned int normalOffsetY = vboData.normalOffset + sizeof(float);
	unsigned int normalOffsetZ = vboData.normalOffset + 2 * sizeof(float);
	
	// Get raw vertex data array from mesh
	unsigned char * vertexData = mesh.vertexData;

	// Create an array	of vertex data to be used for the keyframe animation
	Isgl3dArray * meshData = IA_ALLOC_INIT_WITH_CAPACITY_AR(Isgl3dKeyframeVertexData, _numberOfVertices);
	Isgl3dKeyframeVertexData keyframeVertexData;
	
	// Iterate over all the vertex data in the passed mesh and add it to the keyframe vertex data array
	for (unsigned int i = 0; i < _numberOfVertices; i++) {
		
		keyframeVertexData.vertexPosition.x = *((float*)&vertexData[stride * i + positionOffsetX]);
		keyframeVertexData.vertexPosition.y = *((float*)&vertexData[stride * i + positionOffsetY]);
		keyframeVertexData.vertexPosition.z = *((float*)&vertexData[stride * i + positionOffsetZ]);
		keyframeVertexData.vertexNormal.x   = *((float*)&vertexData[stride * i + normalOffsetX  ]);
		keyframeVertexData.vertexNormal.y   = *((float*)&vertexData[stride * i + normalOffsetY  ]);
		keyframeVertexData.vertexNormal.z   = *((float*)&vertexData[stride * i + normalOffsetZ  ]);
		
		IA_ADD(meshData, keyframeVertexData);
	}
	
	return meshData;
}

- (void) startAnimation {
	if (!_isAnimating) {
		[[Isgl3dScheduler sharedInstance] schedule:self selector:@selector(update:) isPaused:NO];
		
		_isAnimating = YES;
	}
}

- (void) stopAnimation {
	if (_isAnimating) {
		[[Isgl3dScheduler sharedInstance] unschedule:self];

		_isAnimating = NO;
	}
}


- (void) update:(float)dt {
	// Check that interpolation is needed (not if both meshes to be used are the same)
	BOOL interpolationNecessary = NO;
	
	// Update current frame duration
	_currentFrameDuration += dt;
	
	// Get current frame animation data
	Isgl3dKeyframeAnimationData * currentFrameData = IA_GET_PTR(Isgl3dKeyframeAnimationData *, _animationData, _currentFrameIndex);
	
	// Update current frame if necessary
	if (_currentFrameDuration > currentFrameData->duration) {
		_currentFrameIndex++;
		if (_currentFrameIndex >= _nFrames) {
			_currentFrameIndex = 0;
		}
		_currentFrameDuration -= currentFrameData->duration;
		currentFrameData = IA_GET_PTR(Isgl3dKeyframeAnimationData *, _animationData, _currentFrameIndex);
		interpolationNecessary = YES;
	}
	
	// Get next frame animation data
	unsigned int nextFrameIndex = _currentFrameIndex + 1;
	if (nextFrameIndex >= _nFrames) {
		nextFrameIndex = 0;
	}

	Isgl3dKeyframeAnimationData * nextFrameData = IA_GET_PTR(Isgl3dKeyframeAnimationData *, _animationData, nextFrameIndex);

	// Interpolate data if necessary	
	interpolationNecessary |= (currentFrameData->meshIndex != nextFrameData->meshIndex);
	if (interpolationNecessary || _isFirstRender) {
		
		// Interpolation factor
		float f = _currentFrameDuration / currentFrameData->duration;
		
		[self interpolateMesh1:currentFrameData->meshIndex andMesh2:nextFrameData->meshIndex withFactor:f];
		
		_isFirstRender = NO;
	}
}

- (void) interpolateMesh1:(unsigned int)mesh1Index andMesh2:(unsigned int)mesh2Index withFactor:(float)f {
	if (mesh1Index >= _nMeshes) {
		Isgl3dLog(Error, @"Isgl3dKeyframeMesh : mesh1 index (%d) exceeds limit (%d)", mesh1Index, _nMeshes - 1);
		return;
	}
	if (mesh2Index >= _nMeshes) {
		Isgl3dLog(Error, @"Isgl3dKeyframeMesh : mesh2 index (%d) exceeds limit (%d)", mesh2Index, _nMeshes - 1);
		return;
	}
	
	if (f < 0.0f || f > 1.0f) {
		Isgl3dLog(Error, @"Isgl3dKeyframeMesh : interpolation factor (%f) must be between 0 and 1", f);
		return;
	}
	
	// Calculate inverse factor
	float mf = 1.0f - f;

	// Get mesh data for current and next frames
	Isgl3dArray * meshData1 = [_meshData objectAtIndex:mesh1Index];
	Isgl3dArray * meshData2 = [_meshData objectAtIndex:mesh2Index];
	
	// Interpolate data and update vbo data
	for (unsigned int i = 0; i < _numberOfVertices; i++) {
		Isgl3dKeyframeVertexData * vertex1 = IA_GET_PTR(Isgl3dKeyframeVertexData *, meshData1, i);
		Isgl3dKeyframeVertexData * vertex2 = IA_GET_PTR(Isgl3dKeyframeVertexData *, meshData2, i);
		
		*((float*)&_vertexData[_stride * i + _positionOffsetX]) = mf * vertex1->vertexPosition.x + f * vertex2->vertexPosition.x;
		*((float*)&_vertexData[_stride * i + _positionOffsetY]) = mf * vertex1->vertexPosition.y + f * vertex2->vertexPosition.y;
		*((float*)&_vertexData[_stride * i + _positionOffsetZ]) = mf * vertex1->vertexPosition.z + f * vertex2->vertexPosition.z;
		*((float*)&_vertexData[_stride * i + _normalOffsetX  ]) = mf * vertex1->vertexNormal.x   + f * vertex2->vertexNormal.x;
		*((float*)&_vertexData[_stride * i + _normalOffsetY  ]) = mf * vertex1->vertexNormal.y   + f * vertex2->vertexNormal.y;
		*((float*)&_vertexData[_stride * i + _normalOffsetZ  ]) = mf * vertex1->vertexNormal.z   + f * vertex2->vertexNormal.z;
	}
	
	// Update vbo data in GPU
	[[Isgl3dGLVBOFactory sharedInstance] createBufferFromUnsignedCharArray:_vertexData size:_vertexDataSize atIndex:_vboData.vboIndex];
	
}

@end
