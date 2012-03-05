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

#import "Isgl3dSpringCamera.h"
#import "Isgl3dNode.h"
#import "Isgl3dDirector.h"
#import "Isgl3dMatrix4.h"


@interface Isgl3dSpringCamera () {
@private
	Isgl3dNode * _target;
    
	//Matrix4D * _targetTransformation;
    
	Isgl3dVector3 _positionOffset;
	Isgl3dVector3 _lookOffset;
	Isgl3dVector3 _velocity;
    
	Isgl3dVector3 _desiredPosition;
	Isgl3dVector3 _desiredLookAtPosition;
	Isgl3dVector3 _acceleration;
    
    
	float _stiffness;
	float _damping;
	float _mass;
	
	BOOL _initialized;
	BOOL _useRealTime;
}
- (void)initializeTarget:(Isgl3dNode *)target;
@end


#pragma mark -
@implementation Isgl3dSpringCamera

@synthesize positionOffset = _positionOffset;
@synthesize lookOffset = _lookOffset;
@synthesize stiffness = _stiffness;
@synthesize damping = _damping;
@synthesize mass = _mass;
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
	
	_positionOffset = Isgl3dVector3Make(0.0f, 5.0f, 10.0f);
	_lookOffset = Isgl3dVector3Make(0.0f, 5.0f, 10.0f);
	
	_velocity = Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
	
	_stiffness = 10;
	_damping = 4;
	_mass = 1.;

	_initialized = NO;	
	_useRealTime = NO;
}

- (void)setTarget:(Isgl3dNode *)target {
	if (_target != target) {
        [_target release];
		_target = [target retain];
	}
}


- (void)updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {

	if (_target) {
		if (_initialized) {
			
			Isgl3dVector3 currentPos = [self worldPosition];
			Isgl3dMatrix4 targetTransformation = _target.worldTransformation;
			
            _acceleration = Isgl3dMatrix4MultiplyVector3WithTranslation(targetTransformation, _positionOffset);
            _desiredLookAtPosition = Isgl3dMatrix4MultiplyVector3WithTranslation(targetTransformation, _lookOffset);

			// Calculate elastic force from vector between current and desired position
            _acceleration = Isgl3dVector3Subtract(_acceleration, currentPos);
            _acceleration = Isgl3dVector3MultiplyScalar(_acceleration, _stiffness);
	
            Isgl3dVector3 tmp = Isgl3dVector3MultiplyScalar(_velocity, _damping);
			
            _acceleration = Isgl3dVector3Subtract(_acceleration, tmp);
            _acceleration = Isgl3dVector3MultiplyScalar(_acceleration, 1.0f/_mass);
            
			float dt = 1.0f / 60.0f;
			if (_useRealTime) {
				dt = [Isgl3dDirector sharedInstance].deltaTime;
			}

            _acceleration = Isgl3dVector3MultiplyScalar(_acceleration, dt);
            _velocity = Isgl3dVector3Add(_velocity, _acceleration);
	
            _desiredPosition = Isgl3dVector3MultiplyScalar(_velocity, dt);
            _desiredPosition = Isgl3dVector3Add(_desiredPosition, currentPos);
	
			// Set translation and lookAt
			[super setPosition:_desiredPosition];
			[super setLookAtTarget:_desiredLookAtPosition];
		
		} else {
			_initialized = YES;
	
			Isgl3dVector3 currentPos = [self worldPosition];
			Isgl3dMatrix4 targetTransformation = _target.worldTransformation;

            _desiredPosition = Isgl3dMatrix4MultiplyVector3WithTranslation(targetTransformation, _positionOffset);
            _desiredPosition = Isgl3dVector3Add(_desiredPosition, currentPos);
			
            _desiredLookAtPosition = Isgl3dMatrix4MultiplyVector3WithTranslation(targetTransformation, _lookOffset);
			
			// Set translation and lookAt
			[super setPosition:_desiredPosition];
			[super setLookAtTarget:_desiredLookAtPosition];
		}
	}
	
	[super updateWorldTransformation:parentTransformation];
}

- (void)setLookAtTarget:(Isgl3dVector3)lookAtTarget {
    _lookOffset = lookAtTarget;
	[super setLookAtTarget:lookAtTarget];
}

- (void)setPositionValues:(float)x y:(float)y z:(float)z {
	_positionOffset = Isgl3dVector3Make(x, y, z);
	
	[super setPositionValues:x y:y z:z];
}

- (void)setPosition:(Isgl3dVector3)translation {
	_positionOffset = translation;
	
	[super setPosition:translation];
}

@end
