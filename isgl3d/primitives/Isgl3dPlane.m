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

#import "Isgl3dPlane.h"
#import "Isgl3dUVMap.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"


@interface Isgl3dPlane (PrivateMethods) 
- (void)buildPrimitiveWithUVMap:(const Isgl3dUVMap *)uvMap isFrontFace:(BOOL)isFrontFace;
@end


@implementation Isgl3dPlane


+ (id) meshWithGeometry:(float)width height:(float)height nx:(int)nx ny:(int)ny {
	return [[[self alloc] initWithGeometry:width height:height nx:nx ny:ny] autorelease];
}

+ (id) meshWithGeometryAndUVMap:(float)width height:(float)height nx:(int)nx ny:(int)ny uvMap:(const Isgl3dUVMap *)uvMap {
	return [[[self alloc] initWithGeometryAndUVMap:width height:height nx:nx ny:ny uvMap:uvMap] autorelease];
}

- (id) initWithGeometry:(float)width height:(float)height nx:(int)nx ny:(int)ny {
	
	if ((self = [self initWithGeometryAndUVMap:width height:height nx:nx ny:ny uvMap:nil])) {
		// Empty.
	}
	
	return self;
}

- (id) initWithGeometryAndUVMap:(float)width height:(float)height nx:(int)nx ny:(int)ny uvMap:(const Isgl3dUVMap *)uvMap {
	if ((self = [super init])) {
		_width = width;
		_height = height;
		_nx = nx;
		_ny = ny;
		
		if (uvMap) {
			_uvMap = [uvMap retain];
		} else {
			_uvMap = [[Isgl3dUVMap standardUVMap] retain];
		}
		
		[self constructVBOData];
	}
	
	return self;
}

- (void) dealloc {
	[_uvMap release];
	
    [super dealloc];
}

- (void) fillVertexData:(Isgl3dFloatArray *)vertexData andIndices:(Isgl3dUShortArray *)indices {

	float uABVector = _uvMap.uB - _uvMap.uA;
	float vABVector = _uvMap.vB - _uvMap.vA;
	float uACVector = _uvMap.uC - _uvMap.uA;
	float vACVector = _uvMap.vC - _uvMap.vA;
	float uX, vX, uXY, vXY, iRatio, jRatio;
	
	for (int i = 0; i <= _nx; i++) {
		float x = -(_width / 2) + i * (_width / _nx);
		iRatio = (float)i / _nx;
		uX = _uvMap.uA + iRatio * uABVector;
		vX = _uvMap.vA + iRatio * vABVector;
			 
		for (int j = 0; j <= _ny; j++) {
			float y = -(_height / 2) + j * (_height / _ny);
			jRatio = 1. - (float)j / _ny;
			uXY = uX + jRatio * uACVector;
			vXY = vX + jRatio * vACVector;
						
			[vertexData add:x];
			[vertexData add:y];
			[vertexData add:0.0];
			
			[vertexData add:0.0];
			[vertexData add:0.0];
			[vertexData add:1.0];

			[vertexData add:uXY];
			[vertexData add:vXY];
			
//			Isgl3dLog(Info, @"x = %f y = %f u = %f v = % f", x, y, uXY, vXY);
		}
	}
	
	for (int i = 0; i < _nx; i++) {
		for (int j = 0; j < _ny; j++) {
			
			int first = i * (_ny + 1) + j;			
			int second = first + (_ny + 1);
			int third = first + 1;
			int fourth = second + 1;
			
			[indices add:first];
			[indices add:second];
			[indices add:third];
				
			[indices add:third];
			[indices add:second];
			[indices add:fourth];
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
