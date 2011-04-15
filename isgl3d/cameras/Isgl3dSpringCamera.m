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

#import "Isgl3dSpringCamera.h"
#import "Isgl3dNode.h"
#import "Isgl3dDirector.h"

@interface Isgl3dSpringCamera ()
- (void) initialiseTarget:(Isgl3dNode *)target;
@end

@implementation Isgl3dSpringCamera

@synthesize positionOffset = _positionOffset;
@synthesize lookOffset = _lookOffset;
@synthesize stiffness = _stiffness;
@synthesize damping = _damping;
@synthesize mass = _mass;
@synthesize target = _target;
@synthesize useRealTime = _useRealTime;

+ (id) cameraWithTarget:(Isgl3dNode *)target {
	return [[[self alloc] initWithTarget:target] autorelease];
}

+ (id) cameraWithWidth:(float)width andHeight:(float)height andTarget:(Isgl3dNode *)target {
	return [[[self alloc] initWithWidth:width andHeight:height andTarget:target] autorelease];
}

+ (id) cameraWithWidth:(float)width height:(float)height andCoordinates:(float)x y:(float)y z:(float)z upX:(float)upX upY:(float)upY upZ:(float)upZ lookAtX:(float)lookAtX lookAtY:(float)lookAtY lookAtZ:(float)lookAtZ andTarget:(Isgl3dNode *)target {
	return [[[self alloc] initWithWidth:width height:height andCoordinates:x y:y z:z upX:upX upY:upY upZ:upZ lookAtX:lookAtX lookAtY:lookAtY lookAtZ:lookAtZ andTarget:target] autorelease];
}

- (id) initWithTarget:(Isgl3dNode *)target {
	
	if ((self = [super init])) {
		[self initialiseTarget:target];
	}
	
	return self;
}

- (id) initWithWidth:(float)width andHeight:(float)height andTarget:(Isgl3dNode *)target {
	
	if ((self = [super initWithWidth:width andHeight:height])) {
		[self initialiseTarget:target];
	}
	
	return self;
}

- (id) initWithWidth:(float)width height:(float)height andCoordinates:(float)x y:(float)y z:(float)z upX:(float)upX upY:(float)upY upZ:(float)upZ lookAtX:(float)lookAtX lookAtY:(float)lookAtY lookAtZ:(float)lookAtZ andTarget:(Isgl3dNode *)target {
	
	if ((self = [super initWithWidth:width height:height andCoordinates:x y:y z:z upX:upX upY:upY upZ:upZ lookAtX:lookAtX lookAtY:lookAtY lookAtZ:lookAtZ])) {
		[self initialiseTarget:target];
	}
	
	return self;
}

- (void) dealloc {
	if (_target) {
		[_target release];
	}
	
	[super dealloc];
}

- (void) initialiseTarget:(Isgl3dNode *)target {
		
	if (target) {
		_target = [target retain];
	}
	
	_positionOffset = iv3(0, 5, 10);
	_lookOffset = iv3(0, 5, 10);
	
	_velocity = iv3(0, 0, 0);
	
	_stiffness = 10;
	_damping = 4;
	_mass = 1.;

	_initialized = NO;	
	_useRealTime = NO;
}

- (void) setTarget:(Isgl3dNode *)target {
	if (_target != target) {
		if (_target) {
			[_target release];
		}
		
		_target = target;
		if (_target) {
			[_target retain];
		}
		
	}
}


- (void) updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {


	if (_target) {
		if (_initialized) {
			
			Isgl3dVector3 currentPos = [self worldPosition];
			Isgl3dMatrix4 targetTransformation = _target.worldTransformation;
			
			_acceleration = im4MultVector(&targetTransformation, &_positionOffset);
			_desiredLookAtPosition = im4MultVector(&targetTransformation, &_lookOffset);

			// Calculate elastic force from vector between current and desired position
			iv3Sub(&_acceleration, &currentPos);
			iv3Scale(&_acceleration, _stiffness);
	
			Isgl3dVector3 tmp = _velocity;
			iv3Scale(&tmp, _damping);
			
			iv3Sub(&_acceleration, &tmp);
			iv3Scale(&_acceleration, 1./_mass);
	
			float dt = 1./60.;
			if (_useRealTime) {
				dt = [Isgl3dDirector sharedInstance].deltaTime;
			}

			iv3Scale(&_acceleration, dt);
			iv3Add(&_velocity, &_acceleration);
	
			iv3Copy(&_desiredPosition, &_velocity);
			iv3Scale(&_desiredPosition, dt);
			iv3Add(&_desiredPosition, &currentPos);
	
			// Set translation and lookAt
			[super setPosition:_desiredPosition];
			[super setLookAt:_desiredLookAtPosition];
		
		} else {
			_initialized = YES;
	
			Isgl3dVector3 currentPos = [self worldPosition];
			Isgl3dMatrix4 targetTransformation = _target.worldTransformation;

			_desiredPosition = im4MultVector(&targetTransformation, &_positionOffset);
			iv3Add(&_desiredPosition, &currentPos);
			
			_desiredLookAtPosition = im4MultVector(&targetTransformation, &_lookOffset);
			
			// Set translation and lookAt
			[super setPosition:_desiredPosition];
			[super setLookAt:_desiredLookAtPosition];
		}
	}
	
	[super updateWorldTransformation:parentTransformation];
}

- (void) setLookAt:(Isgl3dVector3)lookAt {
	iv3Copy(&_lookOffset, &lookAt);
	[super setLookAt:lookAt];
}

- (void) lookAt:(float)x y:(float)y z:(float)z {
	_lookOffset.x = x;
	_lookOffset.y = y;
	_lookOffset.z = z;
	[super lookAt:x y:y z:z];
}

- (void) setPositionValues:(float)x y:(float)y z:(float)z {
	_positionOffset = iv3(x, y, z);
	
	[super setPositionValues:x y:y z:z];
}

- (void) setPosition:(Isgl3dVector3)translation {
	_positionOffset = translation;
	
	[super setPosition:translation];
}


@end
