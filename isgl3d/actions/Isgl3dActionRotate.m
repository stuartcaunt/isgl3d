/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2011 Stuart Caunt
 * 
 * This class is inspired from equivalent functionality provided by cocos2d :
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
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

#import "Isgl3dActionRotate.h"
#import "Isgl3dNode.h"

#pragma mark Isgl3dActionRotateXTo

@implementation Isgl3dActionRotateXTo

+ (id) actionWithDuration:(float)duration angle:(float)angle {
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (id) initWithDuration:(float)duration angle:(float)angle {
	if ((self = [super initWithDuration:duration])) {
		_finalAngle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionRotateXTo * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration angle:_finalAngle];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	_initialAngle = ((Isgl3dNode *)target).rotationX;
	_delta = _finalAngle - _initialAngle;
}

- (void) update:(float)progress {
	[_target setRotationX:_initialAngle + progress * _delta];
}

@end

#pragma mark Isgl3dActionRotateYTo

@implementation Isgl3dActionRotateYTo

+ (id) actionWithDuration:(float)duration angle:(float)angle {
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (id) initWithDuration:(float)duration angle:(float)angle {
	if ((self = [super initWithDuration:duration])) {
		_finalAngle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionRotateYTo * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration angle:_finalAngle];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	_initialAngle = ((Isgl3dNode *)target).rotationY;
	_delta = _finalAngle - _initialAngle;
}

- (void) update:(float)progress {
	[_target setRotationY:_initialAngle + progress * _delta];
}

@end

#pragma mark Isgl3dActionRotateZTo

@implementation Isgl3dActionRotateZTo

+ (id) actionWithDuration:(float)duration angle:(float)angle {
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (id) initWithDuration:(float)duration angle:(float)angle {
	if ((self = [super initWithDuration:duration])) {
		_finalAngle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionRotateZTo * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration angle:_finalAngle];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	_initialAngle = ((Isgl3dNode *)target).rotationZ;
	_delta = _finalAngle - _initialAngle;
}

- (void) update:(float)progress {
	[_target setRotationZ:_initialAngle + progress * _delta];
}

@end

#pragma mark Isgl3dActionRotateXBy

@implementation Isgl3dActionRotateXBy

+ (id) actionWithDuration:(float)duration angle:(float)angle {
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (id) initWithDuration:(float)duration angle:(float)angle {
	if ((self = [super initWithDuration:duration])) {
		_delta = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionRotateXBy * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration angle:_delta];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	_initialAngle = ((Isgl3dNode *)target).rotationX;
}

- (void) update:(float)progress {
	[_target setRotationX:_initialAngle + progress * _delta];
}

@end

#pragma mark Isgl3dActionRotateYBy

@implementation Isgl3dActionRotateYBy

+ (id) actionWithDuration:(float)duration angle:(float)angle {
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (id) initWithDuration:(float)duration angle:(float)angle {
	if ((self = [super initWithDuration:duration])) {
		_delta = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionRotateYBy * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration angle:_delta];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	_initialAngle = ((Isgl3dNode *)target).rotationY;
}

- (void) update:(float)progress {
	[_target setRotationY:_initialAngle + progress * _delta];
}

@end

#pragma mark Isgl3dActionRotateZBy

@implementation Isgl3dActionRotateZBy

+ (id) actionWithDuration:(float)duration angle:(float)angle {
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (id) initWithDuration:(float)duration angle:(float)angle {
	if ((self = [super initWithDuration:duration])) {
		_delta = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionRotateZBy * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration angle:_delta];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	_initialAngle = ((Isgl3dNode *)target).rotationZ;
}

- (void) update:(float)progress {
	[_target setRotationZ:_initialAngle + progress * _delta];
}

@end

#pragma mark Isgl3dActionYawBy

@implementation Isgl3dActionYawBy

+ (id) actionWithDuration:(float)duration angle:(float)angle {
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (id) initWithDuration:(float)duration angle:(float)angle {
	if ((self = [super initWithDuration:duration])) {
		_angle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionYawBy * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration angle:_angle];

	return copy;
}

-(void) startWithTarget:(id)target {
	_lastAngle = 0.0f;
	[super startWithTarget:target];
}

- (void) update:(float)progress {
	float desiredAngle = progress * _angle;
	[_target yaw:desiredAngle - _lastAngle];
	
	_lastAngle = desiredAngle;
}

@end

#pragma mark Isgl3dActionPitchBy

@implementation Isgl3dActionPitchBy

+ (id) actionWithDuration:(float)duration angle:(float)angle {
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (id) initWithDuration:(float)duration angle:(float)angle {
	if ((self = [super initWithDuration:duration])) {
		_angle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionPitchBy * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration angle:_angle];

	return copy;
}

-(void) startWithTarget:(id)target {
	_lastAngle = 0.0f;
	[super startWithTarget:target];
}

- (void) update:(float)progress {
	float desiredAngle = progress * _angle;
	[_target pitch:desiredAngle - _lastAngle];
	
	_lastAngle = desiredAngle;
}

@end

#pragma mark Isgl3dActionRollBy

@implementation Isgl3dActionRollBy

+ (id) actionWithDuration:(float)duration angle:(float)angle {
	return [[[self alloc] initWithDuration:duration angle:angle] autorelease];
}

- (id) initWithDuration:(float)duration angle:(float)angle {
	if ((self = [super initWithDuration:duration])) {
		_angle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionRollBy * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration angle:_angle];

	return copy;
}

-(void) startWithTarget:(id)target {
	_lastAngle = 0.0f;
	[super startWithTarget:target];
}

- (void) update:(float)progress {
	float desiredAngle = progress * _angle;
	[_target roll:desiredAngle - _lastAngle];
	
	_lastAngle = desiredAngle;
}

@end

#pragma mark Isgl3dActionSetRotationX

@implementation Isgl3dActionSetRotationX

+ (id) actionWithAngle:(float)angle {
	return [[[self alloc] initWithAngle:angle] autorelease];
}

- (id) initWithAngle:(float)angle {
	if ((self = [super init])) {
		_finalAngle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionSetRotationX * copy = [[[self class] allocWithZone:zone] initWithAngle:_finalAngle];

	return copy;
}

- (void) update:(float)progress {
	[_target setRotationX:_finalAngle];
}

@end

#pragma mark Isgl3dActionSetRotationY

@implementation Isgl3dActionSetRotationY

+ (id) actionWithAngle:(float)angle {
	return [[[self alloc] initWithAngle:angle] autorelease];
}

- (id) initWithAngle:(float)angle {
	if ((self = [super init])) {
		_finalAngle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionSetRotationY * copy = [[[self class] allocWithZone:zone] initWithAngle:_finalAngle];

	return copy;
}

- (void) update:(float)progress {
	[_target setRotationY:_finalAngle];
}

@end

#pragma mark Isgl3dActionSetRotationZ

@implementation Isgl3dActionSetRotationZ

+ (id) actionWithAngle:(float)angle {
	return [[[self alloc] initWithAngle:angle] autorelease];
}

- (id) initWithAngle:(float)angle {
	if ((self = [super init])) {
		_finalAngle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionSetRotationZ * copy = [[[self class] allocWithZone:zone] initWithAngle:_finalAngle];

	return copy;
}

- (void) update:(float)progress {
	[_target setRotationZ:_finalAngle];
}

@end

#pragma mark Isgl3dActionSetPitch

@implementation Isgl3dActionSetPitch

+ (id) actionWithAngle:(float)angle {
	return [[[self alloc] initWithAngle:angle] autorelease];
}

- (id) initWithAngle:(float)angle {
	if ((self = [super init])) {
		_finalAngle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionSetPitch * copy = [[[self class] allocWithZone:zone] initWithAngle:_finalAngle];

	return copy;
}

- (void) update:(float)progress {
	[_target pitch:_finalAngle];
}

@end

#pragma mark Isgl3dActionSetYaw

@implementation Isgl3dActionSetYaw

+ (id) actionWithAngle:(float)angle {
	return [[[self alloc] initWithAngle:angle] autorelease];
}

- (id) initWithAngle:(float)angle {
	if ((self = [super init])) {
		_finalAngle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionSetYaw * copy = [[[self class] allocWithZone:zone] initWithAngle:_finalAngle];

	return copy;
}

- (void) update:(float)progress {
	[_target yaw:_finalAngle];
}

@end

#pragma mark Isgl3dActionSetRoll

@implementation Isgl3dActionSetRoll

+ (id) actionWithAngle:(float)angle {
	return [[[self alloc] initWithAngle:angle] autorelease];
}

- (id) initWithAngle:(float)angle {
	if ((self = [super init])) {
		_finalAngle = angle;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionSetRoll * copy = [[[self class] allocWithZone:zone] initWithAngle:_finalAngle];

	return copy;
}

- (void) update:(float)progress {
	[_target roll:_finalAngle];
}

@end


