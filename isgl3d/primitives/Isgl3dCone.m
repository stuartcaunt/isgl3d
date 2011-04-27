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

#import "Isgl3dCone.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"

@implementation Isgl3dCone

@synthesize topRadius = _topRadius;
@synthesize bottomRadius = _bottomRadius;
@synthesize height = _height;

+ (id) meshWithGeometry:(float)height topRadius:(float)topRadius bottomRadius:(float)bottomRadius ns:(int)ns nt:(int)nt openEnded:(BOOL)openEnded {
	return [[[self alloc] initWithGeometry:height topRadius:topRadius bottomRadius:bottomRadius ns:ns nt:nt openEnded:openEnded] autorelease];
}

- (id) initWithGeometry:(float)height topRadius:(float)topRadius bottomRadius:(float)bottomRadius ns:(int)ns nt:(int)nt openEnded:(BOOL)openEnded {
	
	if ((self = [super init])) {
		_height = height;
		_topRadius = topRadius;
		_bottomRadius = bottomRadius;
		_ns = ns;
		_nt = nt;
		_openEnded = openEnded;
		
		[self constructVBOData];
	}
	
	return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void) fillVertexData:(Isgl3dFloatArray *)vertexData andIndices:(Isgl3dUShortArray *)indices {
	
	float totalHeight;
	if (_openEnded) {
		totalHeight = _height;
	} else {
		totalHeight = _bottomRadius + _height + _topRadius;
	}
	
	float dR = _bottomRadius - _topRadius;
	float length = sqrt(_height * _height + dR * dR);

	if (!_openEnded) {
		// Create bottom
		for (int s = 0; s <= _ns; s++) {
			[vertexData add:0];
			[vertexData add:-(_height / 2)];
			[vertexData add:0];
			
			[vertexData add:0];
			[vertexData add:-1];
			[vertexData add:0];
	
			[vertexData add:1.0 * s / _ns];
			[vertexData add:1];
		}
	}
	
	float vOffset;
	if (_openEnded) {
		vOffset = 0;
	} else {
		vOffset = _bottomRadius;
	}
	
	
	// Create middle
	for (int t = 0; t <= _nt; t++) {
		float radius = _bottomRadius - (_bottomRadius - _topRadius) * t / _nt;
		for (int s = 0; s <= _ns; s++) {
			float theta = s * 2 * M_PI / _ns;

			[vertexData add:radius * sin(theta)];
			[vertexData add:-(_height / 2) + (t * _height / _nt)];
			[vertexData add:radius * cos(theta)];
			
			[vertexData add:sin(theta) * _height / length];
			[vertexData add:dR / length];
			[vertexData add:cos(theta) * _height / length];
	
			[vertexData add:1.0 * s / _ns];
			[vertexData add:1.0 - (vOffset + t * _height / _nt) / totalHeight];
		}
	}

	if (!_openEnded) {
		// Create top
		for (int s = 0; s <= _ns; s++) {
			[vertexData add:0];
			[vertexData add:(_height / 2)];
			[vertexData add:0];
			
			[vertexData add:0];
			[vertexData add:1];
			[vertexData add:0];
	
			[vertexData add:1.0 * s / _ns];
			[vertexData add:0];
		}
	}
	
	int totalNT;
	if (_openEnded) {
		totalNT = _nt;
	} else {
		totalNT = _nt + 2;
	}
	
	for (int t = 0; t < totalNT; t++) {
		for (int s = 0; s < _ns; s++) {
			
			int first = (t * (_ns + 1)) + s;
			int second = first + (_ns + 1);
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
	if (_openEnded) {
		return (_nt + 1) * (_ns + 1) * 8;
	} else {
		return (_nt + 3) * (_ns + 1) * 8;
	}
}

- (unsigned int) estimatedIndicesSize {
	if (_openEnded) {
		return _nt * _ns * 8;
	} else {
		return (_nt + 2) * _ns * 6;
	}
}


@end
