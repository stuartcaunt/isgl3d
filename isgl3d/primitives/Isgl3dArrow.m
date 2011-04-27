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

#import "Isgl3dArrow.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"

@implementation Isgl3dArrow

@synthesize radius = _radius;
@synthesize height = _height;
@synthesize headRadius = _headRadius;
@synthesize headHeight = _headHeight;

+ (id) meshWithGeometry:(float)height radius:(float)radius headHeight:(float)headHeight headRadius:(float)headRadius ns:(int)ns nt:(int)nt {
	return [[[self alloc] initWithGeometry:height radius:radius headHeight:headHeight headRadius:headRadius ns:ns nt:nt] autorelease];
}

- (id) initWithGeometry:(float)height radius:(float)radius headHeight:(float)headHeight headRadius:(float)headRadius ns:(int)ns nt:(int)nt {
	
	if ((self = [super init])) {
		_height = height;
		_radius = radius;
		_headHeight = headHeight;
		_headRadius = headRadius;
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
	
	float totalHeight = _radius + _height + (_headRadius - _radius);
	
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
	
	float vOffset = _radius;
	
	float headStart = _height - _headHeight;
	
	// Create middle
	for (int t = 0; t <= _nt; t++) {
		for (int s = 0; s <= _ns; s++) {
			float theta = s * 2 * M_PI / _ns;

			[vertexData add:_radius * sin(theta)];
			[vertexData add:-(_height / 2) + (t * headStart / _nt)];
			[vertexData add:_radius * cos(theta)];
			
			[vertexData add:sin(theta)];
			[vertexData add:0];
			[vertexData add:cos(theta)];
	
			[vertexData add:1.0 * s / _ns];
			[vertexData add:1.0 - (vOffset + t * headStart / _nt) / totalHeight];
		}
	}

	// Create head
	for (int s = 0; s <= _ns; s++) {
		float theta = s * 2 * M_PI / _ns;
		[vertexData add:_headRadius * sin(theta)];
		[vertexData add:(_height / 2) - _headHeight];
		[vertexData add:_headRadius * cos(theta)];

		[vertexData add:sin(theta)];
		[vertexData add:0];
		[vertexData add:cos(theta)];
		

		[vertexData add:1.0 * s / _ns];
		[vertexData add:0];
	}
	
	// Create top
	for (int s = 0; s <= _ns; s++) {
		[vertexData add:0];
		[vertexData add:(_height / 2)];
		[vertexData add:0];
		
		[vertexData add:0];
		[vertexData add:1];
		[vertexData add:0];

		[vertexData add:1.0 * s / _ns];
		[vertexData add:1.0 - (headStart + _headRadius / totalHeight)];
	}
	
	int totalNT = _nt + 3;
	
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
	return (_nt + 4) * (_ns + 1) * 8;
}

- (unsigned int) estimatedIndicesSize {
	return (_nt + 3) * _ns * 6;
}

@end
