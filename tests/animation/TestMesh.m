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

#import "TestMesh.h"

@implementation TestMesh

- (id) initWithGeometry:(float)width length:(float)length height:(float)height nx:(int)nx ny:(int)ny factor:(float)factor {
	
	if ((self = [super init])) {
		_width = width;
		_length = length;
		_height = height;
		_nx = nx;
		_ny = ny;
		_factor = factor;
		
		[self constructVBOData];
		
	}
    return self;
}

- (void) dealloc {

	[super dealloc];
}

- (void) fillVertexData:(Isgl3dFloatArray *)vertexData andIndices:(Isgl3dUShortArray *)indices {

	float uXY, vXY;
	float x, y, z;
	float nx, ny, nz;
	float u, v;
	float normalLength;

	for (int i = 0; i <= _nx; i++) {
		uXY = (float)i / _nx;
 		x = -(_width / 2) + i * (_width / _nx);
			 
		for (int j = 0; j <= _ny; j++) {
			vXY = 1. - (float)j / _ny;
			z = -(_length / 2) + j * (_length / _ny);
			u = 2.0 * (2.0 * M_PI * i) / _nx;
			v = 2.0 * (2.0 * M_PI * j) / _ny;
			y = sin(u) * sin(v) * _height;
			nx = -cos(u)*sin(v) * _height;
			ny = 1.0f;
			nz = -sin(u)*cos(v) * _height;

			y = y * _factor;
			nx = nx * _factor;
			nz = nz * _factor;
			
			normalLength = sqrt(nx*nx + ny*ny + nz*nz);
			nx = nx / normalLength;
			ny = ny / normalLength;
			nz = nz / normalLength;
			
			[vertexData add:x];
			[vertexData add:y];
			[vertexData add:z];
			
			[vertexData add:nx];
			[vertexData add:ny];
			[vertexData add:nz];

			[vertexData add:uXY];
			[vertexData add:vXY];
		}
	}
	
	for (int i = 0; i < _nx; i++) {
		for (int j = 0; j < _ny; j++) {
			
			int first = i * (_ny + 1) + j;			
			int second = first + (_ny + 1);
			int third = first + 1;
			int fourth = second + 1;
			
			[indices add:first];
			[indices add:third];
			[indices add:second];
				
			[indices add:third];
			[indices add:fourth];
			[indices add:second];
		}
	}

}

- (unsigned int) estimatedVertexSize {
	return (_nx + 1) * (_ny + 1) * 8;
}

- (unsigned int) estimatedIndicesSize {
	return _nx * _ny * 6;
}

@end


