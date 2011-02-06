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
#import "Isgl3dVector3D.h"
#import "Isgl3dMatrix4D.h"

@implementation Isgl3dFollowCamera

@synthesize desiredPosition = _desiredPosition;
@synthesize stiffness = _stiffness;
@synthesize damping = _damping;
@synthesize mass = _mass;
@synthesize lookAhead = _lookAhead;
@synthesize target = _target;
@synthesize useRealTime = _useRealTime;

- (id) initWithView:(Isgl3dView3D *)view3D andTarget:(Isgl3dNode *)target {
	
	if (self = [self initWithView:view3D]) {
		
		if (_target) {
			_target = [target retain];
		}
		
		_targetMovementIT = [[Isgl3dMatrix4D identityMatrix] retain];
		
		_desiredPosition = mv3DCreate(0, 5, 10);
		
		_stiffness = 10;
		_damping = 4;
		_mass = 1.;
		_lookAhead = 10;
		_useRealTime = NO;
		
		_initialized = NO;
	}
	
	return self;
}


- (void) dealloc {
	if (_target) {
		[_target release];
	}

	if (_time) {
		[_time release];
	}
	
	[_targetMovementIT release];

	[super dealloc];
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


- (void) udpateGlobalTransformation:(Isgl3dMatrix4D *)parentTransformation {


	if (_target) {
		// Get current positions
		[_target positionAsMiniVec3D:&_currentTargetPosition];
		[self positionAsMiniVec3D:&_currentPosition];
	
		// Initialise old follower position if necessary
		if (!_initialized) {
			mv3DCopy(&_oldPosition, &_currentPosition);
			mv3DCopy(&_oldTargetPosition, &_currentTargetPosition);
			_initialized = YES;
		}
	
		float dt = 1./60.;
		if (_useRealTime) {
			if (!_time) {
				_time = [[NSDate alloc] init];
			} else {
				NSDate * currentTime = [[NSDate alloc] init];
				dt = [currentTime timeIntervalSinceDate:_time];
				[_time release];
				_time = currentTime;
			}
		}
		
		if (mv3DDistanceBetween(&_currentTargetPosition, &_oldTargetPosition) > 0.01) {
			// Calculate transformation matrix along line of movement of target
			Isgl3dMatrix4D * targetMovementTransformation = [Isgl3dGLU lookAt:_oldTargetPosition.x eyey:_oldTargetPosition.y eyez:_oldTargetPosition.z centerx:_currentTargetPosition.x centery:_currentTargetPosition.y centerz:_currentTargetPosition.z upx:0 upy:1 upz:0];
			[_targetMovementIT release];
			_targetMovementIT = [[Isgl3dMatrix4D matrixFromMatrix:targetMovementTransformation] retain];
			[_targetMovementIT invert];
	
			// Get desired position in real-world coordinates
			[_targetMovementIT multMiniVec3D:&_desiredPosition inToResult:&_elasticForce];
			
			// Calculate elastic force from vector between current and desired position
			mv3DSub(&_elasticForce, &_currentPosition);
			mv3DScale(&_elasticForce, _stiffness);
		
			// Calculate resistance from current velocity
			mv3DCopy(&_velocity, &_currentPosition);
			mv3DSub(&_velocity, &_oldPosition);
			mv3DScale(&_velocity, 1./dt);
			
			mv3DCopy(&_dampingForce, &_velocity);
			mv3DScale(&_dampingForce, -_damping);
		
			// Convert resulting position from forces
			mv3DCopy(&_acceleration, &_elasticForce),
			mv3DAdd(&_acceleration, &_dampingForce),
			mv3DScale(&_acceleration, 1./_mass);

			mv3DCopy(&_newVelocity, &_acceleration);
			mv3DScale(&_newVelocity, dt);
			mv3DAdd(&_newVelocity, &_velocity);
			
			mv3DCopy(&_newPosition, &_newVelocity);
			mv3DScale(&_newPosition, dt);
			mv3DAdd(&_newPosition, &_currentPosition);
			
			
			// Calculate lookAt along line between current position and target position
			mv3DCopy(&_newPositionInPlane, &_newPosition);
			_newPositionInPlane.y = 0;
			mv3DCopy(&_targetPosition, &_currentPosition);
			mv3DSub(&_targetPosition, &_newPositionInPlane);
			mv3DNormalize(&_targetPosition),
			mv3DScale(&_targetPosition, _lookAhead);
			mv3DAdd(&_targetPosition, &_currentTargetPosition);
			
			// Set translation and lookAt
			[super setTranslationMiniVec3D:&_newPosition];
			[super setLookAt:&_targetPosition];
		}
	
		mv3DCopy(&_oldTargetPosition, &_currentTargetPosition);
		mv3DCopy(&_oldPosition, &_currentPosition);
	}
	
	[super udpateGlobalTransformation:parentTransformation];
}

- (void) setLookAt:(Isgl3dMiniVec3D *)lookAt {
	_lookAhead = -lookAt->z;
	[super setLookAt:lookAt];
}

- (void) lookAt:(float)x y:(float)y z:(float)z {
	_lookAhead = -z;
	[super lookAt:x y:y z:z];
}

- (void) setTranslation:(float)x y:(float)y z:(float)z {
	_desiredPosition = mv3DCreate(x, y, z);
	
	[super setTranslation:x y:y z:z];
}

- (void) setTranslationVector:(Isgl3dVector3D *)translation {
	_desiredPosition = translation.miniVec3D;
	
	[super setTranslationVector:translation];
}

- (void) setTranslationMiniVec3D:(Isgl3dMiniVec3D *)translation {
	mv3DCopy(&_desiredPosition, translation);
}


@end
