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

#import "Isgl3dTorus.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"

@implementation Isgl3dTorus

@synthesize radius = _radius;
@synthesize tubeRadius = _tubeRadius;

+ (id) meshWithGeometry:(float)radius tubeRadius:(float)tubeRadius ns:(int)ns nt:(int)nt {
	return [[[self alloc] initWithGeometry:radius tubeRadius:tubeRadius ns:ns nt:nt] autorelease];
}

- (id) initWithGeometry:(float)radius tubeRadius:(float)tubeRadius ns:(int)ns nt:(int)nt {
	
	if ((self = [super init])) {
		_radius = radius;
		_tubeRadius = tubeRadius;
		_ns = ns;
		_nt = nt;
		
		[self constructVBOData];
	}
	
	return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void) fillVertexData:(Isgl3dFloatArray *)vertexData andIndices:(Isgl3dUShortArray *)indices {
	
	for (int s = 0; s <= _ns; s++) {
		float theta = s * 2 * M_PI / _ns;
		for (int t = 0; t <= _nt; t++) {
			float phi = t * 2 * M_PI / _nt;
			
			float sinTheta = sin(theta);
			float sinPhi = sin(phi);
			float cosTheta = cos(theta);
			float cosPhi = cos(phi);
			
			float x = sinTheta * (_radius + _tubeRadius * sinPhi);
			float y =                     - _tubeRadius * cosPhi;
			float z = cosTheta * (_radius + _tubeRadius * sinPhi);

			float nx = sinTheta * sinPhi;
			float ny = -cosPhi;
			float nz = cosTheta * sinPhi;

			float u = 1.0 * s / _ns;
			float v = 1.0 - (1.0 * t / _nt);
		
			[vertexData add:x];
			[vertexData add:y];
			[vertexData add:z];
			
			[vertexData add:nx];
			[vertexData add:ny];
			[vertexData add:nz];

			[vertexData add:u];
			[vertexData add:v];
		}
	}


	for (int s = 0; s < _ns; s++) {
		for (int t = 0; t < _nt; t++) {
			
			int first = (s * (_nt + 1)) + t;
			int second = first + (_nt + 1);
			int third = first + 1;
			int fourth = second + 1;
			
			[indices add:first];
			[indices add:second];
			[indices add:third];

			[indices add:second];
			[indices add:fourth];
			[indices add:third];
			
		}
	}
}

- (unsigned int) estimatedVertexSize {
	return (_nt + 1) * (_ns + 1) * 8;
}

- (unsigned int) estimatedIndicesSize {
	return _nt * _ns * 6;
}


@end
