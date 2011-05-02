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

#import "Isgl3dGLMesh.h"

#define PRIMITIVE_VERTEX_POS_OFFSET 0
#define PRIMITIVE_VERTEX_NORMAL_OFFSET (3 * sizeof(float))
#define PRIMITIVE_VERTEX_UV_OFFSET (6 * sizeof(float))
#define PRIMITIVE_VBO_STRIDE (8 * sizeof(float))


@class Isgl3dFloatArray;
@class Isgl3dUShortArray;

/**
 * The Isgl3dPrimitive is an abstract class, inheriting from Isgl3dGLMesh, automating the process of constructing the
 * vertex data.
 * 
 * It implements the constructMeshData of Isgl3dGLMesh and performs all the necessary actions to generate the vertex
 * data and index data to be sent to the GPU. All primitives inheriting from this class must implement the fillVertexData
 * method: all the vertex positions, normals and uv coordinates are added to the vertex data array, and the vertex indices 
 * are added to the index data array.
 */
@interface Isgl3dPrimitive : Isgl3dGLMesh {

@private
}

/**
 * Initialises the Isgl3dPrimitive.
 */
- (id) init;

/**
 * Constructs all vertex and index data to be passed to the GPU. This is unimplemented in the Isgl3dPrimitive
 * and must be implemented in all classes extending this.
 * @param vertexData An array of floating point values for the vertex data.
 * @param indices An array of unsigned short values for the index data.
 */
- (void) fillVertexData:(Isgl3dFloatArray *)vertexData andIndices:(Isgl3dUShortArray *)indices;

@end
