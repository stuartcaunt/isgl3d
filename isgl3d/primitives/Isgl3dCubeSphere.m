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

#import "Isgl3dCubeSphere.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"
#import "Isgl3dVector.h"

@interface Isgl3dCubeSphere (PrivateMethods)
- (Isgl3dVector3) intersectionOfVector:(Isgl3dVector3)vector withPlane:(Isgl3dVector4)plane;
@end

@implementation Isgl3dCubeSphere

@synthesize radius = _radius;
@synthesize longs = _longs;
@synthesize lats = _lats;

+ (id) meshWithGeometry:(float)radius longs:(int)longs lats:(int)lats {
	return [[[self alloc] initWithGeometry:radius longs:longs lats:lats] autorelease];
}

- (id) initWithGeometry:(float)radius longs:(int)longs lats:(int)lats {
	
	if ((self = [super init])) {
		_radius = radius;
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
	
	int lats = _lats;
	if (lats % 4 != 0) {
		lats = lats + 4 - lats % 4;
	}
	
	int longs = _longs;
	if (longs % 4 != 0) {
		longs = longs + 4 - longs % 4;
	}
	int nPerFace = longs / 4;
	float root2 = sqrt(2);
	
	Isgl3dVector4 topPlane = iv4(0, 1, 0, -1);
	Isgl3dVector4 bottomPlane = iv4(0, 1, 0, 1);
	Isgl3dVector4 sePlane = iv4(1, 0, 1, -root2);
	Isgl3dVector4 swPlane = iv4(1, 0, -1, root2);
	Isgl3dVector4 nwPlane = iv4(1, 0, 1, root2);
	Isgl3dVector4 nePlane = iv4(1, 0, -1, -root2);

	float nx = 0;
	float ny = 0;
	float nz = 0;
	
	for (int latNumber = 0; latNumber <= lats; ++latNumber) {
		float theta = latNumber * M_PI / lats;


		// Calculate projection of azimuthal points onto cube
		for (int longNumber = 0; longNumber <= longs; ++longNumber) {
			float phi = longNumber * 2 * M_PI / longs;
			
			float sinTheta = sin(theta);
			float sinPhi = sin(phi);
			float cosTheta = cos(theta);
			float cosPhi = cos(phi);

			// Find intersection of point with different planes making up sphere			
			Isgl3dVector3 ptOnSphere = iv3(cosPhi * sinTheta, cosTheta, sinPhi * sinTheta);
			Isgl3dVector3 intersection;			

			if (latNumber < lats / 4) {
				intersection = [self intersectionOfVector:ptOnSphere withPlane:topPlane];
				nx = 0;
				nz = 0;
				ny = 1;
			} else if (latNumber > 3 * lats / 4) {
				intersection = [self intersectionOfVector:ptOnSphere withPlane:bottomPlane];
				nx = 0;
				nz = 0;
				ny = -1;
			} else {
				if (longNumber < nPerFace) {
					intersection = [self intersectionOfVector:ptOnSphere withPlane:sePlane];
					nx = 1. / root2;
					nz = 1. / root2;
					ny = 0;
				} else if (longNumber >= nPerFace && longNumber < 2 * nPerFace) {
					intersection = [self intersectionOfVector:ptOnSphere withPlane:swPlane];
					nx = -1. / root2;
					nz = 1. / root2;
					ny = 0;
				} else if (longNumber >= 2 * nPerFace && longNumber < 3 * nPerFace) {
					intersection = [self intersectionOfVector:ptOnSphere withPlane:nwPlane];
					nx = -1. / root2;
					nz = -1. / root2;
					ny = 0;
				} else {
					intersection = [self intersectionOfVector:ptOnSphere withPlane:nePlane];
					nx = 1. / root2;
					nz = -1. / root2;
					ny = 0;
				}
			}			
			
			float x = intersection.x;
			float y = intersection.y;
			float z = intersection.z;
			
			// fix y
			if (y > 1) {
				y = 1;
			} else if (y < -1) {
				y = -1;
			}
			
			float u = 1.0 - (1.0 * longNumber / longs);
			float v = 1.0 * latNumber / lats;
		
			[vertexData add:_radius * x];
			[vertexData add:_radius * y];
			[vertexData add:_radius * z];
			
			[vertexData add:nx];
			[vertexData add:ny];
			[vertexData add:nz];

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

- (Isgl3dVector3) intersectionOfVector:(Isgl3dVector3)vector withPlane:(Isgl3dVector4)plane {
	float x = vector.x;
	float y = vector.y;
	float z = vector.z;
	
	float a = plane.x;
	float b = plane.y;
	float c = plane.z;
	float d = plane.w;
	
	float l = -d / (a*x + b*y + c*z);
	
	return iv3(l*x, l*y, l*z);
}


- (unsigned int) estimatedVertexSize {
	int lats = _lats;
	if (lats % 4 != 0) {
		lats = lats + 4 - lats % 4;
	}
	
	int longs = _longs;
	if (longs % 4 != 0) {
		longs = longs + 4 - longs % 4;
	}
	return (lats + 1) * (longs + 1) * 8;
}

- (unsigned int) estimatedIndicesSize {
	int lats = _lats;
	if (lats % 4 != 0) {
		lats = lats + 4 - lats % 4;
	}
	
	int longs = _longs;
	if (longs % 4 != 0) {
		longs = longs + 4 - longs % 4;
	}
	return lats * longs * 8;
}

@end
