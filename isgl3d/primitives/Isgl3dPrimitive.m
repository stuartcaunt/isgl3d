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

#import "Isgl3dPrimitive.h"
#import "Isgl3dGLMesh.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"

@interface Isgl3dPrimitive ()
- (unsigned int) estimatedVertexDataSize;
- (unsigned int) estimatedIndicesSize;
@end

@implementation Isgl3dPrimitive

- (id) init {    
    if ((self = [super init])) {

    }
	
    return self;
}

- (void) dealloc {

	[super dealloc];
}

- (void) constructMeshData {
	unsigned int vertexDataSize = [self estimatedVertexDataSize];
	unsigned int indicesSize = [self estimatedIndicesSize];
	

	Isgl3dFloatArray * vertexData;
	Isgl3dUShortArray * indices;
	
	if (vertexDataSize == 0) {
		vertexData = [[Isgl3dFloatArray alloc] init];
	} else {
		vertexData = [[Isgl3dFloatArray alloc] initWithSize:vertexDataSize];
	}
	
	if (indicesSize == 0) {
		indices = [[Isgl3dUShortArray alloc] init];
	} else {
		indices = [[Isgl3dUShortArray alloc] initWithSize:indicesSize];
	}
	
	[self fillVertexData:vertexData andIndices:indices];

	[self setVertexData:(unsigned char *)[vertexData array] withSize:[vertexData size] * sizeof(float)];
	[self setIndices:(unsigned char *)[indices array] withSize:[indices size] * sizeof(ushort) andNumberOfElements:[indices size]];

	self.vboData.stride = PRIMITIVE_VBO_STRIDE;
	self.vboData.positionOffset = PRIMITIVE_VERTEX_POS_OFFSET;
	self.vboData.normalOffset = PRIMITIVE_VERTEX_NORMAL_OFFSET;
	self.vboData.uvOffset = PRIMITIVE_VERTEX_UV_OFFSET;

	[vertexData release];
	[indices release];
}


- (void) fillVertexData:(Isgl3dFloatArray *)vertexData andIndices:(Isgl3dUShortArray *)indices {
	// overload
}

- (unsigned int) estimatedVertexDataSize {
	// overload
	return 0;
}

- (unsigned int) estimatedIndicesSize {
	// overload
	return 0;
}

@end
