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
#import "Isgl3dVector3D.h"
#import "Isgl3dMatrix4D.h"

@implementation Isgl3dSpringCamera

@synthesize positionOffset = _positionOffset;
@synthesize lookOffset = _lookOffset;
@synthesize stiffness = _stiffness;
@synthesize damping = _damping;
@synthesize mass = _mass;
@synthesize target = _target;
@synthesize useRealTime = _useRealTime;

- (id) initWithView:(Isgl3dView3D *)view3D andTarget:(Isgl3dNode *)target {
	
	if (self = [self initWithView:view3D]) {
		
		if (target) {
			_target = [target retain];
		}
		
		_positionOffset = mv3DCreate(0, 5, 10);
		_lookOffset = mv3DCreate(0, 5, 10);
		
		_velocity = mv3DCreate(0, 0, 0);
		
		_stiffness = 10;
		_damping = 4;
		_mass = 1.;
	
		_initialized = NO;	
		_useRealTime = NO;
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


- (void) updateGlobalTransformation:(Isgl3dMatrix4D *)parentTransformation {


	if (_target) {
		if (_initialized) {
			
			Isgl3dMiniVec3D * currentPos = self.position.miniVec3DPointer;
			Isgl3dMatrix4D * targetTransformation = _target.transformation;
			
			[targetTransformation multMiniVec3D:&_positionOffset inToResult:&_acceleration];
			[targetTransformation multMiniVec3D:&_lookOffset inToResult:&_desiredLookAtPosition];
			
			// Calculate elastic force from vector between current and desired position
			mv3DSub(&_acceleration, currentPos);
			mv3DScale(&_acceleration, _stiffness);
	
			Isgl3dMiniVec3D tmp = _velocity;
			mv3DScale(&tmp, _damping);
			
			mv3DSub(&_acceleration, &tmp);
			mv3DScale(&_acceleration, 1./_mass);
	
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

			mv3DScale(&_acceleration, dt);
			mv3DAdd(&_velocity, &_acceleration);
	
			mv3DCopy(&_desiredPosition, &_velocity);
			mv3DScale(&_desiredPosition, dt);
			mv3DAdd(&_desiredPosition, currentPos);
	
			// Set translation and lookAt
			[super setTranslationMiniVec3D:&_desiredPosition];
			[super setLookAt:&_desiredLookAtPosition];
		
		} else {
			_initialized = YES;
	
			Isgl3dMiniVec3D * currentPos = self.position.miniVec3DPointer;
			Isgl3dMatrix4D * targetTransformation = _target.transformation;

			[targetTransformation multMiniVec3D:&_positionOffset inToResult:&_desiredPosition];
			mv3DAdd(&_desiredPosition, currentPos);
			
			[targetTransformation multMiniVec3D:&_lookOffset inToResult:&_desiredLookAtPosition];
			
			// Set translation and lookAt
			[super setTranslationMiniVec3D:&_desiredPosition];
			[super setLookAt:&_desiredLookAtPosition];
		}
	}
	
	[super updateGlobalTransformation:parentTransformation];
}

- (void) setLookAt:(Isgl3dMiniVec3D *)lookAt {
	mv3DCopy(&_lookOffset, lookAt);
	[super setLookAt:lookAt];
}

- (void) lookAt:(float)x y:(float)y z:(float)z {
	_lookOffset.x = x;
	_lookOffset.y = y;
	_lookOffset.z = z;
	[super lookAt:x y:y z:z];
}

- (void) setTranslation:(float)x y:(float)y z:(float)z {
	_positionOffset = mv3DCreate(x, y, z);
	
	[super setTranslation:x y:y z:z];
}

- (void) setTranslationVector:(Isgl3dVector3D *)translation {
	_positionOffset = translation.miniVec3D;
	
	[super setTranslationVector:translation];
}

- (void) setTranslationMiniVec3D:(Isgl3dMiniVec3D *)translation {
	mv3DCopy(&_positionOffset, translation);
}


@end
