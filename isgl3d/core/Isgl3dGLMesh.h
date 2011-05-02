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

@class Isgl3dGLVBOData;

/**
 * The Isgl3dGLMesh contains all the vertex data for a 3D mesh object. The raw vertex data is passed
 * to the GPU for rendering.
 * 
 * Mesh vertex data always contains:
 * <ul>
 * <li>Position coordinates: 3 values (x, y, z) of GL_FLOATs</li>
 * <li>Normal vector: 3 values (nx, ny, nz) of GL_FLOATs</li>
 * <li>UV coordinates: 2 values (u, v) of GL_FLOATs</li>
 * </ul>
 * 
 * Animated meshes with skinning contain additional data of varying size depening on how many bones
 * are associated with a vertex:
 * <ul>
 * <li>Bone indices: n values (ib0, ib1, ..., ibn-1) of GL_UNSIGNED_BYTEs</li>
 * <li>Bone weights: n values (wb0, wb1, ..., wbn-1) of GL_FLOATs</li>
 * </ul>
 * 
 * iSGL3D passes interlaced data to the GPU meaning that all the elements of the vertex data (position, normal,
 * etc) are passed in a single array rather than each one separately.
 * 
 * As well as the vertex data, the Isgl3dGLMesh contains an array of indices to create the triangles. Three
 * indices are used to create a triangle: these indices correspond to the vertex indices allowing vertices
 * to be re-used in different triangles.
 * 
 * For information on the structure of the vertex data, an Isgl3dGLVBOData object is associated with the mesh (VBO being Virtual Buffer
 * Object). This contains information on what is contained in the vertex data, what is the stride of the data (how many bytes are used 
 * to store the data for a single vertex), the offset of the various elements, etc.
 * 
 * To construct a mesh, all the vertex and index data needs to be provided along with a valid VBO data object (to inform the GPU of how the data 
 * is constructed and to register the data with the GPU). All data are provided in the same call to ensure the correct order of actions
 * in creation of the data before registering it with the GPU.
 */
@interface Isgl3dGLMesh : NSObject {

@protected
	unsigned int _indicesBufferId;

	unsigned char * _vertexData;
	unsigned char * _indices;
	unsigned int _vertexDataSize; // size in bytes
	unsigned int _indexDataSize;  // size in bytes

	unsigned int _numberOfElements;

	Isgl3dGLVBOData * _vboData;
	
	BOOL _normalizationEnabled;
}

/**
 * Returns the Isgl3dGLVBOData containing information regarding the current VBO data of the GPU. 
 */
@property (readonly) Isgl3dGLVBOData * vboData;

/**
 * Indicates that the vertex data is not normalized and that this needs to be performed by the GPU.
 * For better performance, the data should already be normalized when creating the mesh.
 */
@property (nonatomic) BOOL normalizationEnabled;

/**
 * Returns the raw vertex data for the mesh.
 */
@property (nonatomic, readonly) unsigned char * vertexData;

/**
 * Returns the raw index data for the mesh.
 */
@property (nonatomic, readonly) unsigned char * indices;

/**
 * Returns the vertex data size in bytes.
 */
@property (nonatomic, readonly) unsigned int vertexDataSize;

/**
 * Returns the index data size in bytes.
 */
@property (nonatomic, readonly) unsigned int indexDataSize;

/**
 * Returns the number of elements (indices) used to construct the mesh.
 */
@property (nonatomic, readonly) unsigned int numberOfElements;

/**
 * Returns the number of vertices contained in the mesh data.
 */
@property (nonatomic, readonly) unsigned int numberOfVertices;

/**
 * Allocates and initialises (autorelease) Isgl3dGLMesh.
 */
+ (id) mesh;

/**
 * Initialises the Isgl3dGLMesh.
 */
- (id) init;

/**
 * Needs to be called to construct the full VBO data in the GPU.
 * Internally this calls construcMeshData to construct the mesh and create raw data for the vertices and indices.
 * This data is then passed to the GPU to create virtual buffer objects that can be accessed internally in the GPU.
 * 
 * This is typically called internally (by Isgl3dPrimitive for example) and does not have to be called if the
 * data is set explicitly.
 */
- (void) constructVBOData;

/**
 * Used to construct the raw mesh data (vertices and indices).
 * The Isgl3dGLVBOData object also needs to be updated to specify the stride and the offsets of each element of data.
 * 
 * This is typically called internally (by Isgl3dPrimitive for example) and does not have to be called if the
 * data is set explicitly.
 */
- (void) constructMeshData;

/**
 * Returns the raw, interlaced vertex data.
 * @return The raw vertex data containing position, normal, etc mapped onto an unsigned char array.
 */
- (unsigned char *) vertexData;

/**
 * Returns the raw, interlaced index data.
 * @return The raw index data containing the vertex indices grouped by three for each triangle.
 */
- (unsigned char *) indices;

/**
 * Returns the Isgl3dGLVBOData object containing information about the VBO in the GPU.
 * @return the VBO data.
 */
- (Isgl3dGLVBOData *) vboData;

/**
 * Sets the raw, interlaced vertex data in combination with the index data along with the relevant VBO data. When this is called the raw data is sent to the GPU
 * and registered.
 * @param vertexData the raw vertex data cast as an unsigned char pointer.
 * @param vertexDataSize the vertex data size in bytes.
 * @param indices the raw index data cast as an unsigned char pointer.
 * @param indexDataSize the index data size in bytes.
 * @param numberOfElements the true number of indices contained in the array (for ushort data for example, this equals indexDataSize / sizeof(ushort)).
 * @param vboData An Isgl3dGLVBOData object containing information on the structure of the raw vertex data.
 */
- (void) setVertices:(unsigned char *)vertexData withVertexDataSize:(unsigned int)vertexDataSize andIndices:(unsigned char *)indices 
             withIndexDataSize:(unsigned int)indexDataSize andNumberOfElements:(unsigned int)numberOfElements andVBOData:(Isgl3dGLVBOData *)vboData;

/**
 * Returns the buffer identifier for the index data as it is registered in the GPU.
 * The equivalent Id for the vertex data is available in the Isgl3DGLVBOData object. 
 * This is called internally by iSGL3D.
 */
- (unsigned int) indicesBufferId;

/**
 * Sets the raw, interlaced vertex data.
 * The vertex data is copied internally: the original needs to be released.
 * @param vertexData the raw vertex data cast as an unsigned char pointer.
 * @param vertexDataSize the vertex data size in bytes.
 */
- (void) setVertexData:(unsigned char *)vertexData withSize:(unsigned int)vertexDataSize;

/**
 * Sets the index data.
 * The index data is copied internally: the original needs to be released.
 * @param indices the raw index data cast as an unsigned char pointer.
 * @param indexDataSize the index data size in bytes.
 * @param numberOfElements the true number of indices contained in the array (for ushort data for example, this equals indexDataSize / sizeof(ushort)).
 */
- (void) setIndices:(unsigned char *)indices withSize:(unsigned int)indexDataSize andNumberOfElements:(unsigned int)numberOfElements;

/**
 * Explicitly sets the VBO data relevant to the raw vertex and index data. When this is called the raw data is sent to the GPU
 * and registered.
 * @param vboData An Isgl3dGLVBOData object containing information on the structure of the raw vertex data.
 */
- (void) setVBOData:(Isgl3dGLVBOData *)vboData;

@end
