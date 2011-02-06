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

#import "Isgl3dVector4D.h"

@implementation Isgl3dVector4D

@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;
@synthesize w = _w;



+ (Isgl3dVector4D *) vector {
	return [[[Isgl3dVector4D alloc] init:0.0f y:0.0f z:0.0f] autorelease];
}


+ (Isgl3dVector4D *) vectorWithX:(float)x y:(float)y z:(float)z {
	return [[[Isgl3dVector4D alloc] init:x y:y z:z] autorelease];
}

+ (Isgl3dVector4D *) vectorWithX:(float)x y:(float)y z:(float)z w:(float)w {
	return [[[Isgl3dVector4D alloc] init:x y:y z:z w:w] autorelease];
}

- (id) init:(float)x y:(float)y z:(float)z {
	if (self = [super init]) {
		_x = x;
		_y = y;
		_z = z;
		_w = 1.0;
	}
	return self;
}

- (id) init:(float)x y:(float)y z:(float)z w:(float)w {
	if (self = [super init]) {
		_x = x;
		_y = y;
		_z = z;
		_w = w;
	}
	return self;
}

- (Isgl3dVector4D *) clone {
	return [[[Isgl3dVector4D alloc] init:_x y:_y z:_z w:_w] autorelease];
}

- (void) copyFrom:(Isgl3dVector4D *)from {
	_x = from.x;
	_y = from.y;
	_z = from.z;
	_w = from.w;
}

- (void) reset:(float)x y:(float)y z:(float)z {
	_x = x;
	_y = y;
	_z = z;
	_w = 1.0;
}

- (void) reset:(float)x y:(float)y z:(float)z w:(float)w {
	_x = x;
	_y = y;
	_z = z;
	_w = w;
}

- (float) length {
	return sqrt(_x * _x + _y * _y + _z * _z + _w * _w);
}

- (Isgl3dVector4D *) add:(Isgl3dVector4D *)vector4D {
	Isgl3dVector4D * result = [self clone];
	
	result.x += vector4D.x;
	result.y += vector4D.y;
	result.z += vector4D.z;
	result.w += vector4D.w;
	
	return result;
}

- (Isgl3dVector4D *) sub:(Isgl3dVector4D *)vector4D {
	Isgl3dVector4D * result = [self clone];
	
	result.x -= vector4D.x;
	result.y -= vector4D.y;
	result.z -= vector4D.z;
	result.w -= vector4D.w;
	
	return result;
}

- (Isgl3dVector4D *) scale:(float)scale {
	Isgl3dVector4D * result = [self clone];
	
	result.x *= scale;
	result.y *= scale;
	result.z *= scale;
	result.w *= scale;
	
	return result;
}


- (float) dot:(Isgl3dVector4D *)vector4D {
	return _x * vector4D.x + _y * vector4D.y + _z * vector4D.z + _w * vector4D.w;
}


- (void) normalize {
	float length = sqrt(_x * _x + _y * _y + _z * _z + _w * _w);
	
	if( length != 0.0f && length != 1.0f)
	{
		length = 1.0f / length; // Save some CPU
		_x *= length;
		_y *= length;
		_z *= length;
		_w *= length;
	}
}

@end
