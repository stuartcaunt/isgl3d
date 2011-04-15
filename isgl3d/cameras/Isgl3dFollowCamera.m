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

#import "Isgl3dFollowCamera.h"
#import "Isgl3dNode.h"
#import "Isgl3dGLU.h"
#import "Isgl3dDirector.h"

@interface Isgl3dFollowCamera ()
- (void) initialiseTarget:(Isgl3dNode *)target;
@end

@implementation Isgl3dFollowCamera

@synthesize desiredPosition = _desiredPosition;
@synthesize stiffness = _stiffness;
@synthesize damping = _damping;
@synthesize mass = _mass;
@synthesize lookAhead = _lookAhead;
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
	
	_desiredPosition = iv3(0, 5, 10);
	
	_stiffness = 10;
	_damping = 4;
	_mass = 1.;
	_lookAhead = 10;
	_useRealTime = NO;
	
	_initialized = NO;
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
		// Get current positions
		_currentTargetPosition = [_target worldPosition];
		_currentPosition = [self worldPosition];
	
		// Initialise old follower position if necessary
		if (!_initialized) {
			iv3Copy(&_oldPosition, &_currentPosition);
			iv3Copy(&_oldTargetPosition, &_currentTargetPosition);
			_initialized = YES;
		}
	
		float dt = 1./60.;
		if (_useRealTime) {
			dt = [Isgl3dDirector sharedInstance].deltaTime;
		}
		
		if (iv3DistanceBetween(&_currentTargetPosition, &_oldTargetPosition) > 0.01) {
			// Calculate transformation matrix along line of movement of target
			Isgl3dMatrix4 targetMovementTransformation = [Isgl3dGLU lookAt:_oldTargetPosition.x eyey:_oldTargetPosition.y eyez:_oldTargetPosition.z centerx:_currentTargetPosition.x centery:_currentTargetPosition.y centerz:_currentTargetPosition.z upx:0 upy:1 upz:0];
			im4Copy(&_targetMovementIT, &targetMovementTransformation);
			im4Invert(&_targetMovementIT);
	
			// Get desired position in real-world coordinates
			_elasticForce = im4MultVector(&_targetMovementIT, &_desiredPosition);
			
			// Calculate elastic force from vector between current and desired position
			iv3Sub(&_elasticForce, &_currentPosition);
			iv3Scale(&_elasticForce, _stiffness);
		
			// Calculate resistance from current velocity
			iv3Copy(&_velocity, &_currentPosition);
			iv3Sub(&_velocity, &_oldPosition);
			iv3Scale(&_velocity, 1./dt);
			
			iv3Copy(&_dampingForce, &_velocity);
			iv3Scale(&_dampingForce, -_damping);
		
			// Convert resulting position from forces
			iv3Copy(&_acceleration, &_elasticForce),
			iv3Add(&_acceleration, &_dampingForce),
			iv3Scale(&_acceleration, 1./_mass);

			iv3Copy(&_newVelocity, &_acceleration);
			iv3Scale(&_newVelocity, dt);
			iv3Add(&_newVelocity, &_velocity);
			
			iv3Copy(&_newPosition, &_newVelocity);
			iv3Scale(&_newPosition, dt);
			iv3Add(&_newPosition, &_currentPosition);
			
			
			// Calculate lookAt along line between current position and target position
			iv3Copy(&_newPositionInPlane, &_newPosition);
			_newPositionInPlane.y = 0;
			iv3Copy(&_targetPosition, &_currentPosition);
			iv3Sub(&_targetPosition, &_newPositionInPlane);
			iv3Normalize(&_targetPosition),
			iv3Scale(&_targetPosition, _lookAhead);
			iv3Add(&_targetPosition, &_currentTargetPosition);
			
			// Set translation and lookAt
			[super setPosition:_newPosition];
			[super setLookAt:_targetPosition];
		}
	
		iv3Copy(&_oldTargetPosition, &_currentTargetPosition);
		iv3Copy(&_oldPosition, &_currentPosition);
	}
	
	[super updateWorldTransformation:parentTransformation];
}

- (void) setLookAt:(Isgl3dVector3)lookAt {
	_lookAhead = -lookAt.z;
	[super setLookAt:lookAt];
}

- (void) lookAt:(float)x y:(float)y z:(float)z {
	_lookAhead = -z;
	[super lookAt:x y:y z:z];
}

- (void) setPositionValues:(float)x y:(float)y z:(float)z {
	_desiredPosition = iv3(x, y, z);
	
	[super setPositionValues:x y:y z:z];
}

- (void) setPosition:(Isgl3dVector3)translation {
	_desiredPosition = translation;
	
	[super setPosition:translation];
}


@end
