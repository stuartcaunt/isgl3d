/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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


@interface Isgl3dFollowCamera () {
@private
	Isgl3dNode * _target;
    
	Isgl3dMatrix4 _targetMovementIT;
    
	Isgl3dVector3 _currentTargetPosition;
	Isgl3dVector3 _currentPosition;
	
	Isgl3dVector3 _oldTargetPosition;
	Isgl3dVector3 _oldPosition;
	
	Isgl3dVector3 _desiredPosition;
	Isgl3dVector3 _elasticForce;
	Isgl3dVector3 _dampingForce;
	Isgl3dVector3 _velocity;
	Isgl3dVector3 _acceleration;
	Isgl3dVector3 _newVelocity;
	Isgl3dVector3 _newPosition;
	Isgl3dVector3 _newPositionInPlane;
	Isgl3dVector3 _targetPosition;
    
	float _stiffness;
	float _damping;
	float _mass;
	float _lookAhead;
    
	BOOL _useRealTime;
	
	BOOL _initialized;
}
- (void)initializeTarget:(Isgl3dNode *)target;
@end

@implementation Isgl3dFollowCamera

@synthesize desiredPosition = _desiredPosition;
@synthesize stiffness = _stiffness;
@synthesize damping = _damping;
@synthesize mass = _mass;
@synthesize lookAhead = _lookAhead;
@synthesize target = _target;
@synthesize useRealTime = _useRealTime;


- (id)initWithLens:(id<Isgl3dCameraLens>)lens position:(Isgl3dVector3)position andTarget:(Isgl3dNode *)target up:(Isgl3dVector3)up {
	
    Isgl3dVector3 lookAtTarget = [target worldPosition];
    
    if (self = [super initWithLens:lens position:position lookAtTarget:lookAtTarget up:up]) {
		[self initializeTarget:target];
	}
	
	return self;
}

- (void)dealloc {
    [_target release];
    _target = nil;

	[super dealloc];
}

- (void)initializeTarget:(Isgl3dNode *)target {
    
    self.target = target;
	
	_desiredPosition = Isgl3dVector3Make(0.0f, 5.0f, 10.0f);
	
	_stiffness = 10.0f;
	_damping = 4.0f;
	_mass = 1.0f;
	_lookAhead = 10.0f;
	_useRealTime = NO;
	
	_initialized = NO;
}

- (void)setTarget:(Isgl3dNode *)target {
	if (_target != target) {
        [_target release];
		_target = [target retain];
	}
}


- (void)updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {

	if (_target) {
		// Get current positions
		_currentTargetPosition = [_target worldPosition];
		_currentPosition = [self worldPosition];
	
		// Initialise old follower position if necessary
		if (!_initialized) {
            _oldPosition = _currentPosition;
            _oldTargetPosition = _currentTargetPosition;
			_initialized = YES;
		}
	
		float dt = 1.0f / 60.0f;
		if (_useRealTime) {
			dt = [Isgl3dDirector sharedInstance].deltaTime;
		}
		
		if (Isgl3dVector3Distance(_currentTargetPosition, _oldTargetPosition) > 0.01f) {
            
			// Calculate transformation matrix along line of movement of target
            Isgl3dMatrix4 targetMovementTransformation = Isgl3dMatrix4MakeLookAt(_oldTargetPosition.x, _oldTargetPosition.y, _oldTargetPosition.z,
                                                                                 _currentTargetPosition.x, _currentTargetPosition.y, _currentTargetPosition.z,
                                                                                 0.0f, 1.0f, 0.0f);
            _targetMovementIT = Isgl3dMatrix4Invert(targetMovementTransformation, NULL);
	
			// Get desired position in real-world coordinates
            _elasticForce = Isgl3dMatrix4MultiplyVector3WithTranslation(_targetMovementIT, _desiredPosition);
			
			// Calculate elastic force from vector between current and desired position
            _elasticForce = Isgl3dVector3Subtract(_elasticForce, _currentPosition);
            _elasticForce = Isgl3dVector3MultiplyScalar(_elasticForce, _stiffness);
		
			// Calculate resistance from current velocity
            _velocity = Isgl3dVector3Subtract(_currentPosition, _oldPosition);
            _velocity = Isgl3dVector3MultiplyScalar(_velocity, 1.0f/dt);
			
            _dampingForce = Isgl3dVector3MultiplyScalar(_velocity, -_damping);
		
			// Convert resulting position from forces
            _acceleration = Isgl3dVector3Add(_elasticForce, _dampingForce);
            _acceleration = Isgl3dVector3MultiplyScalar(_acceleration, 1.0f/_mass);

            _newVelocity = Isgl3dVector3MultiplyScalar(_acceleration, dt);
            _newVelocity = Isgl3dVector3Add(_newVelocity, _velocity);
			
            _newPosition = Isgl3dVector3MultiplyScalar(_newVelocity, dt);
            _newPosition = Isgl3dVector3Add(_newPosition, _currentPosition);
			
			// Calculate lookAt along line between current position and target position
            _newPositionInPlane = _newPosition;
			_newPositionInPlane.y = 0;
            
            _targetPosition = Isgl3dVector3Subtract(_currentPosition, _newPositionInPlane);
            _targetPosition = Isgl3dVector3Normalize(_targetPosition);
            _targetPosition = Isgl3dVector3MultiplyScalar(_targetPosition, _lookAhead);
            _targetPosition = Isgl3dVector3Add(_targetPosition, _currentTargetPosition);
			
			// Set translation and lookAt
			[super setPosition:_newPosition];
			[super setLookAtTarget:_targetPosition];
		}
	
        _oldTargetPosition = _currentTargetPosition;
        _oldPosition = _currentPosition;
	}
	
	[super updateWorldTransformation:parentTransformation];
}

- (void)setLookAtTarget:(Isgl3dVector3)lookAtTarget {
	_lookAhead = -lookAtTarget.z;
	[super setLookAtTarget:lookAtTarget];
}

@end
