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

#import "Isgl3dVector3D.h"

#define Isgl3dVector3D_precision 1.e-6

@implementation Isgl3dVector3D

@synthesize miniVec3D = _vector;

static Isgl3dVector3D * _forward = nil;
static Isgl3dVector3D * _backward = nil;
static Isgl3dVector3D * _left = nil;
static Isgl3dVector3D * _right = nil;
static Isgl3dVector3D * _up = nil;
static Isgl3dVector3D * _down = nil;

+ (void) initialize {
	_forward = [[Isgl3dVector3D vectorWithX:0 y:0 z:-1] retain];
	_backward = [[Isgl3dVector3D vectorWithX:0 y:0 z:1] retain];
	_left = [[Isgl3dVector3D vectorWithX:-1 y:0 z:0] retain];
	_right = [[Isgl3dVector3D vectorWithX:1 y:0 z:0] retain];
	_up = [[Isgl3dVector3D vectorWithX:0 y:1 z:0] retain];
	_down = [[Isgl3dVector3D vectorWithX:0 y:-1 z:0] retain];
	
}

+ (Isgl3dVector3D *) vector {
	return [[[Isgl3dVector3D alloc] init:0.0f y:0.0f z:0.0f] autorelease];
}


+ (Isgl3dVector3D *) vectorWithX:(float)x y:(float)y z:(float)z {
	return [[[Isgl3dVector3D alloc] init:x y:y z:z] autorelease];
}

+ (Isgl3dVector3D *) vectorFromVector:(Isgl3dVector3D *)vector {
	return [[[Isgl3dVector3D alloc] init:vector.x y:vector.y z:vector.z] autorelease];
}

+ (Isgl3dVector3D *) FORWARD {
	return _forward;
}

+ (Isgl3dVector3D *) BACKWARD {
	return _backward;
}

+ (Isgl3dVector3D *) LEFT {
	return _left;
}

+ (Isgl3dVector3D *) RIGHT {
	return _right;
}

+ (Isgl3dVector3D *) UP {
	return _up;
}

+ (Isgl3dVector3D *) DOWN {
	return _down;
}

- (id) init:(float)x y:(float)y z:(float)z {
	if ((self = [super init])) {
		_vector = mv3DCreate(x, y, z);
	}
	return self;
}

- (id) initWithMiniVec3D:(Isgl3dMiniVec3D)vector {
	if ((self = [super init])) {
		_vector = vector;
	}
	return self;
}


- (float) x {
	return _vector.x;
}

- (void) setX:(float)x {
	_vector.x = x;
}

- (float) y {
	return _vector.y;
}

- (void) setY:(float)y {
	_vector.y = y;
}

- (float) z {
	return _vector.z;
}

- (void) setZ:(float)z {
	_vector.z = z;
}

- (Isgl3dMiniVec3D *) miniVec3DPointer {
	return &_vector;
}

- (Isgl3dVector3D *) clone {
	return [[[Isgl3dVector3D alloc] init:_vector.x y:_vector.y z:_vector.z] autorelease];
}

- (void) copyFrom:(Isgl3dVector3D *)from {
	_vector.x = from.x;
	_vector.y = from.y;
	_vector.z = from.z;
}

- (void) reset:(float)x y:(float)y z:(float)z {
	_vector.x = x;
	_vector.y = y;
	_vector.z = z;
}

- (float) length {
	return mv3DLength(&_vector);
}

- (Isgl3dVector3D *) add:(Isgl3dVector3D *)vector3D {
	Isgl3dVector3D * result = [self clone];
	
	result.x += vector3D.x;
	result.y += vector3D.y;
	result.z += vector3D.z;
	
	return result;
}

- (Isgl3dVector3D *) sub:(Isgl3dVector3D *)vector3D {
	Isgl3dVector3D * result = [self clone];
	
	result.x -= vector3D.x;
	result.y -= vector3D.y;
	result.z -= vector3D.z;
	
	return result;
}

- (Isgl3dVector3D *) scale:(float)scale {
	Isgl3dVector3D * result = [self clone];
	
	result.x *= scale;
	result.y *= scale;
	result.z *= scale;
	
	return result;
}

- (float) dot:(Isgl3dVector3D *)vector {
	return mv3DDot(&_vector, vector.miniVec3DPointer);
}

- (Isgl3dVector3D *) cross:(Isgl3dVector3D *)vector {
	// ?? CORRECT ? Should be inversed ?
	return [[[Isgl3dVector3D alloc] initWithMiniVec3D:mv3DCross(vector.miniVec3DPointer, &_vector)] autorelease];
}

- (void) normalize {
	mv3DNormalize(&_vector);
}

- (void) translate:(float)x y:(float)y z:(float)z {
	mv3DTranslate(&_vector, x, y, z);
}

- (void) rotateX:(float)angle centerY:(float)centerY centerZ:(float)centerZ {
	mv3DRotateX(&_vector, angle, centerY, centerZ);
}	

- (void) rotateY:(float)angle centerX:(float)centerX centerZ:(float)centerZ {
	mv3DRotateY(&_vector, angle, centerX, centerZ);
}	
	
- (void) rotateZ:(float)angle centerX:(float)centerX centerY:(float)centerY  {
	mv3DRotateZ(&_vector, angle, centerX, centerY);
}

- (float) angleXY {
	return atan2f(_vector.y, _vector.x);
}

- (float) angleYZ {
	return atan2f(_vector.z, _vector.y);
}

- (BOOL) equals:(Isgl3dVector3D *)vector {
	return mv3DEquals(&_vector, vector.miniVec3DPointer, Isgl3dVector3D_precision);
}

- (float) angleToVector:(Isgl3dVector3D *)vector {
	return mv3DAngleBetween(&_vector, vector.miniVec3DPointer);
 }

@end
