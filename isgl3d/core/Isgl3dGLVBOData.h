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

#define VBO_POSITION_SIZE 3
#define VBO_NORMAL_SIZE 3
#define VBO_UV_SIZE 2
#define VBO_COLOR_SIZE 4
#define VBO_SIZE_SIZE 1

/**
 * The Isgl3dGLVBOData is used to store data about the internal structure of vertex data passed to the GPU as
 * well as the identifier of the Virtual Buffer Object stored in the GPU.
 * 
 * Both Isgl3dGLMeshes and Isgl3dParticles required an Isgl3dGLVBOData object to pass and return information
 * from the GPU. Each of these have certain properties in common and others that are specific to them. 
 * 
 * If an offset for a particular element is set to -1, it is implied that this element is not contained in the data.
 * 
 * Certain elements are fixed by iSGL3D for VBO data:
 * <ul>
 * <li>Position data contain 3 values of GL_FLOATs for (px, py, pz)</li>
 * <li>Normal data contain 3 values of GL_FLOATs for (nx, ny, nz)</li>
 * <li>UV data contain 2 values of GL_FLOATs for (u, v)</li>
 * <li>Color data contain 4 values of GL_FLOATs for (r, g, b, a)</li>
 * <li>Size data contains 1 value of GL_FLOAT for (s)</li>
 * <li>Bone index data contains n values of GL_UNSIGNED_CHAR for (ib0, ib1, ..., ibn-1) where there are n bones for each vertex</li>
 * <li>Bone weight data contains n values of GL_FLOATs for (wb0, wb1, ..., wbn-1) where there are n bones for each vertex</li>
 * </ul>
 * 
 */
@interface Isgl3dGLVBOData : NSObject {

@private
	unsigned int _vboIndex;
	unsigned int _stride;	// in bytes

	int _positionOffset;	// in bytes
	int _normalOffset;		// in bytes
	int _uvOffset;			// in bytes
	int _colorOffset;		// in bytes
	int _sizeOffset;		// in bytes
	int _boneIndexOffset;	// in bytes
	int _boneWeightOffset;	// in bytes
	
	unsigned int _boneIndexSize; // in elements
	unsigned int _boneWeightSize; // in elements
}

/**
 * Initialises the Isgl3dGLVBO object. All offsets are set to -1 indicating that none are in use.
 */
- (id)init;

/**
 * Contains the index (or identifier) of the VBO as stored in the GPU. This is set automatically by the 
 * iSGL3D framework when a mesh or particle is created and should only be read if necessary.
 */
@property (nonatomic) unsigned int vboIndex;

/**
 * Contains the stride of the vertex data. The stride is the size in bytes of all data that is necessary
 * to describe a single vertex. The vertex data is interlaced - a single array is used for all values, for example
 * for basic mesh data with position, normal and uv elements we have
 * [px0, py0, pz0, nx0, ny0, nz0, u0, v0, px1, py1, pz1, nx1, ny1, nz1, u1, v1, ... ]. If all of this data is
 * reprensented by floating point values, the stride is equal to (8 * sizeof(float)), ie 3 position, 3 normal and 2 uv.
 */
@property (nonatomic) unsigned int stride;

/**
 * Contains the offset in bytes for the position data of a vertex. 
 */
@property (nonatomic) int positionOffset;

/**
 * Contains the offset in bytes for the normal data of a vertex. 
 * This is used uniquely for mesh data and not for particles.
 */
@property (nonatomic) int normalOffset;

/**
 * Contains the offset in bytes for the uv data of a vertex. 
 * This is used uniquely for mesh data and not for particles.
 */
@property (nonatomic) int uvOffset;

/**
 * Contains the offset in bytes for the color data of a vertex. 
 * This is used uniquely for particle data and not for meshse.
 */
@property (nonatomic) int colorOffset;

/**
 * Contains the offset in bytes for the size data of a vertex. 
 * This is used uniquely for particle data and not for meshse.
 */
@property (nonatomic) int sizeOffset;

/**
 * Contains the offset in bytes for the bone index data of a vertex. 
 * This is used uniquely for animated meshes with skinning.
 */
@property (nonatomic) int boneIndexOffset;

/**
 * Contains the offset in bytes for the bone weight data of a vertex. 
 * This is used uniquely for animated meshes with skinning.
 */
@property (nonatomic) int boneWeightOffset;

/**
 * Contains the number of bone indices associated with each vertex.
 * This is used uniquely for animated meshes with skinning.
 */
@property (nonatomic) unsigned int boneIndexSize;

/**
 * Contains the number of bone weights associated with each vertex.
 * This is used uniquely for animated meshes with skinning.
 */
@property (nonatomic) unsigned int boneWeightSize;

@end
