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

#import "Isgl3dEllipsoid.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"

@implementation Isgl3dEllipsoid

@synthesize radiusX = _radiusX;
@synthesize radiusY = _radiusY;
@synthesize radiusZ = _radiusZ;
@synthesize longs = _longs;
@synthesize lats = _lats;


+ (id) meshWithGeometry:(float)radiusX radiusY:(float)radiusY radiusZ:(float)radiusZ longs:(int)longs lats:(int)lats {
	return [[[self alloc] initWithGeometry:radiusX radiusY:radiusY radiusZ:radiusZ longs:longs lats:lats] autorelease];
}

- (id) initWithGeometry:(float)radiusX radiusY:(float)radiusY radiusZ:(float)radiusZ longs:(int)longs lats:(int)lats {
	
	if ((self = [super init])) {
		_radiusX = radiusX;
		_radiusY = radiusY;
		_radiusZ = radiusZ;
		_longs = longs;
		_lats = lats;
		
		[self constructVBOData];
	}
	
	return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void) fillVertexData:(Isgl3dFloatArray *)vertexData andIndices:(Isgl3dUShortArray *)indices {
	
	for (int latNumber = 0; latNumber <= _lats; ++latNumber) {
		for (int longNumber = 0; longNumber <= _longs; ++longNumber) {
			float theta = latNumber * M_PI / _lats;
			float phi = longNumber * 2 * M_PI / _longs;
			
			float sinTheta = sin(theta);
			float sinPhi = sin(phi);
			float cosTheta = cos(theta);
			float cosPhi = cos(phi);
			
			float x = cosPhi * sinTheta;
			float y = cosTheta;
			float z = sinPhi * sinTheta;
			float u = 1.0 - (1.0 * longNumber / _longs);
			float v = 1.0 * latNumber / _lats;
		
			[vertexData add:_radiusX * x];
			[vertexData add:_radiusY * y];
			[vertexData add:_radiusZ * z];
			
			// Normal data not correct but simple approximation
			[vertexData add:x];
			[vertexData add:y];
			[vertexData add:z];

			[vertexData add:u];
			[vertexData add:v];
		}
	}

	for (int latNumber = 0; latNumber < _lats; latNumber++) {
		for (int longNumber = 0; longNumber < _longs; longNumber++) {
			
			int first = (latNumber * (_longs + 1)) + longNumber;
			int second = first + (_longs + 1);
			int third = first + 1;
			int fourth = second + 1;
			
			[indices add:first];
			[indices add:third];
			[indices add:second];

			[indices add:second];
			[indices add:third];
			[indices add:fourth];
		}
	}

}

- (unsigned int) estimatedVertexSize {
	return (_lats + 4) * (_longs + 1) * 8;
}

- (unsigned int) estimatedIndicesSize {
	return _lats * _longs * 6;
}


@end
