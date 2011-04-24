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

#import "Isgl3dGLParticle.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dGLVBOFactory.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"

@interface Isgl3dGLParticle (PrivateMethods)
- (void) fillArrays;
@end

@implementation Isgl3dGLParticle

@synthesize dirty = _dirty;
@synthesize distanceFromPoint = _distanceFromPoint;

+ (id) particle {
	return [[[self alloc] init] autorelease];
}

- (id) init {
	
	if ((self = [super init])) {
		
		_x = 0;
		_y = 0;
		_z = 0;

		_size = 32;
		
		_vboData = [[Isgl3dGLVBOData alloc] init];

		_color[0] = 1.0;
		_color[1] = 1.0;
		_color[2] = 1.0;
		_color[3] = 1.0;
		
		_renderColor[0] = 1.0;
		_renderColor[1] = 1.0;
		_renderColor[2] = 1.0;
		_renderColor[3] = 1.0;
		
		_attenuation[0] = 1.0;
		_attenuation[1] = 0.0;
		_attenuation[2] = 0.0;
		
		_dirty = YES;
	}
	
	return self;
}

- (void) dealloc {

	// Release buffer data
	[[Isgl3dGLVBOFactory sharedInstance] deleteBuffer:_vboData.vboIndex];
	[[Isgl3dGLVBOFactory sharedInstance] deleteBuffer:_indicesBufferId];
	
	[_vboData release];
	
	if (_vertexData) {
		[_vertexData release];
	}
	if (_indices) {
		[_indices release];
	}
	
	[super dealloc];
}

- (float) size {
	return _size;
}

- (void) setSize:(float)size {
	_size = size;
	_dirty = YES;
}

- (float) x {
	return _x;
}

- (void) setX:(float)x {
	_x = x;
	_dirty = YES;
}

- (float) y {
	return _y;
}

- (void) setY:(float)y {
	_y = y;
	_dirty = YES;
}

- (float) z {
	return _z;
}

- (void) setZ:(float)z {
	_z = z;
	_dirty = YES;
}

- (float *) color {
	return _color;
}

- (void) setColor:(float)r g:(float)g b:(float)b {
	_color[0] = r;
	_color[1] = g;
	_color[2] = b;
	_renderColor[0] = r;
	_renderColor[1] = g;
	_renderColor[2] = b;
	_dirty = YES;
}

- (void) setColor:(float)r g:(float)g b:(float)b a:(float)a {
	_color[0] = r;
	_color[1] = g;
	_color[2] = b;
	_color[3] = a;
	_renderColor[0] = r;
	_renderColor[1] = g;
	_renderColor[2] = b;
	_renderColor[3] = a;
	_dirty = YES;
}

- (void) setAttenuation:(float)constant linear:(float)linear quadratic:(float)quadratic {
	_attenuation[0] = constant;
	_attenuation[1] = linear;
	_attenuation[2] = quadratic;
}

- (float *) attenuation {
	return _attenuation;
}


- (Isgl3dGLVBOData *) vboData {
	return _vboData;
}

- (unsigned int) indicesBufferId {
	return _indicesBufferId;
}

- (unsigned int) numberOfPoints {
	return 1;
}


- (void) update {
}

- (void) buildArrays {
	
	if (_vertexData) {
		[_vertexData release];
	}
	if (_indices) {
		[_indices release];
	}
	
	_vertexData = [[Isgl3dFloatArray alloc] init];
	_indices = [[Isgl3dUShortArray alloc] init];

	_vboData.stride = PARTICLE_VBO_STRIDE;
	_vboData.positionOffset = PARTICLE_VERTEX_POS_OFFSET;
	_vboData.colorOffset = PARTICLE_VERTEX_COLOR_OFFSET;
	_vboData.sizeOffset = PARTICLE_VERTEX_SIZE_OFFSET;

	[self fillArrays];

	if (_vboData.vboIndex != 0) {
		[[Isgl3dGLVBOFactory sharedInstance] createBufferFromFloatArray:_vertexData atIndex:_vboData.vboIndex];
	} else {
		_vboData.vboIndex = [[Isgl3dGLVBOFactory sharedInstance] createBufferFromFloatArray:_vertexData];
	}

	if (_indicesBufferId != 0) {
		[[Isgl3dGLVBOFactory sharedInstance] createBufferFromUShortElementArray:_indices atIndex:_indicesBufferId];
	} else {
		_indicesBufferId = [[Isgl3dGLVBOFactory sharedInstance] createBufferFromUShortElementArray:_indices];
	}
}


- (void) calculateDistanceFromX:(float)x y:(float)y z:(float)z {
	_distanceFromPoint = sqrt((x - _x) * (x - _x) + (y - _y) * (y - _y) + (z - _z) * (z - _z)); 
}

- (NSComparisonResult) compareDistances:(Isgl3dGLParticle *)particle {
	NSComparisonResult retVal = NSOrderedSame;
	if (_distanceFromPoint < particle.distanceFromPoint) {
		retVal = NSOrderedDescending;
	} else if (_distanceFromPoint > particle.distanceFromPoint) { 
		retVal = NSOrderedAscending;
	}
	return retVal;
}

- (void) fillArrays {
	[_vertexData add:_x];
	[_vertexData add:_y];
	[_vertexData add:_z];

	[_vertexData add:_color[0]];
	[_vertexData add:_color[1]];
	[_vertexData add:_color[2]];
	[_vertexData add:_color[3]];

	[_vertexData add:_size];

	[_indices add:0];
}

- (void) prepareForEventCapture:(float)r g:(float)g b:(float)b {
	_color[0] = r;
	_color[1] = g;
	_color[2] = b;
	_color[3] = 1.0f;
	[self buildArrays];
}

- (void) restoreRenderColor {
	_color[0] = _renderColor[0];
	_color[1] = _renderColor[1];
	_color[2] = _renderColor[2];
	_color[3] = _renderColor[3];
	_dirty = YES;
}


@end
