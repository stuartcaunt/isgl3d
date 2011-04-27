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

#import "Isgl3dGoursatSurface.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"

@implementation Isgl3dGoursatSurface

@synthesize a = _a;
@synthesize b = _b;
@synthesize c = _c;
@synthesize width = _width;
@synthesize height = _height;
@synthesize depth = _depth;
@synthesize longs = _longs;
@synthesize lats = _lats;

+ (id) meshWithGeometry:(float)a b:(float)b c:(float)c width:(float)width height:(float)height depth:(float)depth longs:(int)longs lats:(int)lats {
	return [[[self alloc] initWithGeometry:a b:b c:c width:width height:height depth:depth longs:longs lats:lats] autorelease];
}

- (id) initWithGeometry:(float)a b:(float)b c:(float)c width:(float)width height:(float)height depth:(float)depth longs:(int)longs lats:(int)lats {
	
	if ((self = [super init])) {
		_a = a;
		_b = b;
		_c = c;
		_width = width;
		_height = height;
		_depth = depth;
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
		float theta = latNumber * M_PI / _lats;
		float sTheta = sin(theta);
		float cTheta = cos(theta);

		for (int longNumber = 0; longNumber <= _longs; ++longNumber) {
			float phi = longNumber * 2 * M_PI / _longs;
			
			float sPhi = sin(phi);
			float cPhi = cos(phi);
			float c4Phi = cos(4 * phi);
			
			float f = sTheta * sTheta * sTheta * sTheta * (0.25 * (3 + c4Phi)) + (cTheta * cTheta * cTheta * cTheta) + _a;
			float m = 0.25 * (-_b + sqrt(_b * _b - 4 * f * _c)) / f;
			float l = sqrt(m);  
			
			float x = l * sTheta * cPhi * _width;
			float y = l * cTheta * _height;
			float z = l * sTheta * sPhi * _depth;
			
			float u = 1.0 - (1.0 * longNumber / _longs);
			float v = 1.0 * latNumber / _lats;
		
			[vertexData add:x];
			[vertexData add:y];
			[vertexData add:z];
			
			// Normal not correct but simple approximation.
			[vertexData add:cPhi * sTheta];
			[vertexData add:cTheta];
			[vertexData add:sPhi * sTheta];

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
	return (_lats + 1) * (_longs + 1) * 8;
}

- (unsigned int) estimatedIndicesSize {
	return _lats * _longs * 6;
}

@end
