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
#import "Isgl3dGLVBOData.h"
#import "Isgl3dGLVBOFactory.h"

@implementation Isgl3dGLMesh

@synthesize vboData = _vboData;
@synthesize normalizationEnabled = _normalizationEnabled;
@synthesize vertexDataSize = _vertexDataSize;
@synthesize indexDataSize = _indexDataSize;
@synthesize numberOfElements = _numberOfElements;

+ (id) mesh {
	return [[[self alloc] init] autorelease];
}

- (id) init {    
    if ((self = [super init])) {
		
		_vertexData = 0;
		_indices = 0;
		_vboData = [[Isgl3dGLVBOData alloc] init];
    }
	
    return self;
}

- (void) dealloc {


	if (_vertexData) {
		free(_vertexData);
		_vertexData = 0;
	}
	if (_indices) {
		free(_indices);
		_indices = 0;
	}

	// Release buffer data
	[[Isgl3dGLVBOFactory sharedInstance] deleteBuffer:_indicesBufferId];
	[[Isgl3dGLVBOFactory sharedInstance] deleteBuffer:_vboData.vboIndex];
	[_vboData release];

	[super dealloc];
}

- (void) constructVBOData {
	if (_vertexData) {
		free(_vertexData);
		_vertexData = 0;
	}
	if (_indices) {
		free(_indices);
		_indices = 0;
	}

	[self constructMeshData];

	if (_vertexData) {
		_vboData.vboIndex = [[Isgl3dGLVBOFactory sharedInstance] createBufferFromUnsignedCharArray:_vertexData size:_vertexDataSize];
	}
	
	if (_indices) {
		_indicesBufferId = [[Isgl3dGLVBOFactory sharedInstance] createBufferFromUnsignedCharArray:_indices size:_indexDataSize];
	}	
}

- (void) constructMeshData {
	// Overload
}

- (unsigned int) numberOfVertices {
	return _vertexDataSize / _vboData.stride;
}

- (unsigned char *) vertexData {
	return _vertexData;
}

- (void) setVertexData:(unsigned char *)vertexData withSize:(unsigned int)vertexDataSize {
	if (_vertexData) {
		free(_vertexData);
	}
	
	_vertexData = malloc(vertexDataSize);
	memcpy(_vertexData, vertexData, vertexDataSize);
	_vertexDataSize = vertexDataSize;
}

- (unsigned char *) indices {
	return _indices;
}

- (void) setIndices:(unsigned char *)indices withSize:(unsigned int)indexDataSize andNumberOfElements:(unsigned int)numberOfElements {
	if (_indices) {
		free(_indices);
	}
	
	_indices = malloc(indexDataSize);
	memcpy(_indices, indices, indexDataSize);
	_indexDataSize = indexDataSize;
	_numberOfElements = numberOfElements;
}

- (Isgl3dGLVBOData *) vboData {
	return _vboData;
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	if (vboData != _vboData) {
		[_vboData release];
		_vboData = [vboData retain];
		
		if (_vertexData) {
			_vboData.vboIndex = [[Isgl3dGLVBOFactory sharedInstance] createBufferFromUnsignedCharArray:_vertexData size:_vertexDataSize];
		}
		
		if (_indices) {
			_indicesBufferId = [[Isgl3dGLVBOFactory sharedInstance] createBufferFromUnsignedCharArray:_indices size:_indexDataSize];
		}		
	}
}

- (unsigned int) indicesBufferId {
	return _indicesBufferId;
}


- (void) setVertices:(unsigned char *)vertexData withVertexDataSize:(unsigned int)vertexDataSize andIndices:(unsigned char *)indices 
			withIndexDataSize:(unsigned int)indexDataSize andNumberOfElements:(unsigned int)numberOfElements andVBOData:(Isgl3dGLVBOData *)vboData {

	// Vertex data
	if (_vertexData) {
		free(_vertexData);
	}
	
	_vertexData = malloc(vertexDataSize);
	memcpy(_vertexData, vertexData, vertexDataSize);
	_vertexDataSize = vertexDataSize;

	// Index data
	if (_indices) {
		free(_indices);
	}
	
	_indices = malloc(indexDataSize);
	memcpy(_indices, indices, indexDataSize);
	_indexDataSize = indexDataSize;
	_numberOfElements = numberOfElements;

	// VBO data
	[_vboData release];
	_vboData = [vboData retain];
	
	_vboData.vboIndex = [[Isgl3dGLVBOFactory sharedInstance] createBufferFromUnsignedCharArray:_vertexData size:_vertexDataSize];
	_indicesBufferId = [[Isgl3dGLVBOFactory sharedInstance] createBufferFromUnsignedCharArray:_indices size:_indexDataSize];
}


@end
