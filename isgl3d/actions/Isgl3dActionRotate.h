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
 *
 */
 
#import "Isgl3dActionInterval.h"
#import "Isgl3dActionInstant.h"

#pragma mark Isgl3dActionRotateXTo

/**
 * The Isgl3dActionRotateXTo rotates an object to a specified rotation around the X axis.
 */
@interface Isgl3dActionRotateXTo : Isgl3dActionInterval <NSCopying> {
	float _initialAngle;
	float _finalAngle;
	float _delta;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionRotateXTo with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate to
 */
+ (id) actionWithDuration:(float)duration angle:(float)angle;

/**
 * Initialises the an Isgl3dActionRotateXTo with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate to
 */
- (id) initWithDuration:(float)duration angle:(float)angle;

@end

#pragma mark Isgl3dActionRotateYTo

/**
 * The Isgl3dActionRotateYTo rotates an object to a specified rotation around the Y axis.
 */
@interface Isgl3dActionRotateYTo : Isgl3dActionInterval <NSCopying> {
	float _initialAngle;
	float _finalAngle;
	float _delta;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionRotateYTo with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate to
 */
+ (id) actionWithDuration:(float)duration angle:(float)angle;

/**
 * Initialises the an Isgl3dActionRotateYTo with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate to
 */
- (id) initWithDuration:(float)duration angle:(float)angle;

@end

#pragma mark Isgl3dActionRotateZTo

/**
 * The Isgl3dActionRotateZTo rotates an object to a specified rotation around the X axis.
 */
@interface Isgl3dActionRotateZTo : Isgl3dActionInterval <NSCopying> {
	float _initialAngle;
	float _finalAngle;
	float _delta;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionRotateZTo with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate to
 */
+ (id) actionWithDuration:(float)duration angle:(float)angle;

/**
 * Initialises the an Isgl3dActionRotateZTo with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate to
 */
- (id) initWithDuration:(float)duration angle:(float)angle;

@end

#pragma mark Isgl3dActionRotateXBy

/**
 * The Isgl3dActionRotateXBy rotates an object by a specified angle around the X axis.
 */
@interface Isgl3dActionRotateXBy : Isgl3dActionInterval <NSCopying> {
	float _initialAngle;
	float _delta;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionRotateXBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
+ (id) actionWithDuration:(float)duration angle:(float)angle;

/**
 * Initialises the an Isgl3dActionRotateXBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
- (id) initWithDuration:(float)duration angle:(float)angle;

@end

#pragma mark Isgl3dActionRotateYBy

/**
 * The Isgl3dActionRotateYBy rotates an object by a specified angle around the X axis.
 */
@interface Isgl3dActionRotateYBy : Isgl3dActionInterval <NSCopying> {
	float _initialAngle;
	float _delta;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionRotateYBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
+ (id) actionWithDuration:(float)duration angle:(float)angle;

/**
 * Initialises the an Isgl3dActionRotateYBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
- (id) initWithDuration:(float)duration angle:(float)angle;

@end

#pragma mark Isgl3dActionRotateZBy

/**
 * The Isgl3dActionRotateZBy rotates an object by a specified angle around the X axis.
 */
@interface Isgl3dActionRotateZBy : Isgl3dActionInterval <NSCopying> {
	float _initialAngle;
	float _delta;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionRotateZBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
+ (id) actionWithDuration:(float)duration angle:(float)angle;

/**
 * Initialises the an Isgl3dActionRotateZBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
- (id) initWithDuration:(float)duration angle:(float)angle;

@end


#pragma mark Isgl3dActionYawBy

/**
 * The Isgl3dActionYawBy peform a yaw rotation on an object by a specified angle.
 */
@interface Isgl3dActionYawBy : Isgl3dActionInterval <NSCopying> {
	float _angle;
	float _lastAngle;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionYawBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
+ (id) actionWithDuration:(float)duration angle:(float)angle;

/**
 * Initialises the an Isgl3dActionYawBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
- (id) initWithDuration:(float)duration angle:(float)angle;

@end

#pragma mark Isgl3dActionPitchBy

/**
 * The Isgl3dActionPitchBy peform a pitch rotation on an object by a specified angle.
 */
@interface Isgl3dActionPitchBy : Isgl3dActionInterval <NSCopying> {
	float _angle;
	float _lastAngle;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionPitchBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
+ (id) actionWithDuration:(float)duration angle:(float)angle;

/**
 * Initialises the an Isgl3dActionPitchBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
- (id) initWithDuration:(float)duration angle:(float)angle;

@end

#pragma mark Isgl3dActionRollBy

/**
 * The Isgl3dActionRollBy peform a roll rotation on an object by a specified angle.
 */
@interface Isgl3dActionRollBy : Isgl3dActionInterval <NSCopying> {
	float _angle;
	float _lastAngle;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionRollBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
+ (id) actionWithDuration:(float)duration angle:(float)angle;

/**
 * Initialises the an Isgl3dActionRollBy with a duration and end rotation.
 * @param duration The duration of the action
 * @param angle The angle to rotate by
 */
- (id) initWithDuration:(float)duration angle:(float)angle;

@end


#pragma mark Isgl3dActionSetRotationX

/**
 * The Isgl3dActionSetRotationX rotates an object to a specified rotation around the X axis immediately.
 */
@interface Isgl3dActionSetRotationX : Isgl3dActionInstant <NSCopying> {
	float _finalAngle;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionSetRotationX with a rotation.
 * @param angle The angle to rotate to
 */
+ (id) actionWithAngle:(float)angle;

/**
 * Initialises the an Isgl3dActionSetRotationX with a rotation.
 * @param angle The angle to rotate to
 */
- (id) initWithAngle:(float)angle;

@end

#pragma mark Isgl3dActionSetRotationY

/**
 * The Isgl3dActionSetRotationY rotates an object to a specified rotation around the Y axis immediately.
 */
@interface Isgl3dActionSetRotationY : Isgl3dActionInstant <NSCopying> {
	float _finalAngle;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionSetRotationY with a rotation.
 * @param angle The angle to rotate to
 */
+ (id) actionWithAngle:(float)angle;

/**
 * Initialises the an Isgl3dActionSetRotationY with a rotation.
 * @param angle The angle to rotate to
 */
- (id) initWithAngle:(float)angle;

@end

#pragma mark Isgl3dActionSetRotationZ

/**
 * The Isgl3dActionSetRotationZ rotates an object to a specified rotation around the Z axis immediately.
 */
@interface Isgl3dActionSetRotationZ : Isgl3dActionInstant <NSCopying> {
	float _finalAngle;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionSetRotationZ with a rotation.
 * @param angle The angle to rotate to
 */
+ (id) actionWithAngle:(float)angle;

/**
 * Initialises the an Isgl3dActionSetRotationZ with a rotation.
 * @param angle The angle to rotate to
 */
- (id) initWithAngle:(float)angle;

@end

#pragma mark Isgl3dActionSetYaw

/**
 * The Isgl3dActionSetYaw peform a yaw rotation on an object by a specified angle instantly.
 */
@interface Isgl3dActionSetYaw : Isgl3dActionInstant <NSCopying> {
	float _finalAngle;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionSetYaw with a rotation.
 * @param angle The angle to rotate by
 */
+ (id) actionWithAngle:(float)angle;

/**
 * Initialises the an Isgl3dActionSetYaw with a rotation.
 * @param angle The angle to rotate by
 */
- (id) initWithAngle:(float)angle;

@end

#pragma mark Isgl3dActionSetPitch

/**
 * The Isgl3dActionSetYaw peform a pitch rotation on an object by a specified angle instantly.
 */
@interface Isgl3dActionSetPitch : Isgl3dActionInstant <NSCopying> {
	float _finalAngle;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionSetPitch with a rotation.
 * @param angle The angle to rotate by
 */
+ (id) actionWithAngle:(float)angle;

/**
 * Initialises the an Isgl3dActionSetPitch with a rotation.
 * @param angle The angle to rotate by
 */
- (id) initWithAngle:(float)angle;

@end

#pragma mark Isgl3dActionSetRoll

/**
 * The Isgl3dActionSetRoll peform a roll rotation on an object by a specified angle instantly.
 */
@interface Isgl3dActionSetRoll : Isgl3dActionInstant <NSCopying> {
	float _finalAngle;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionSetRoll with a rotation.
 * @param angle The angle to rotate by
 */
+ (id) actionWithAngle:(float)angle;

/**
 * Initialises the an Isgl3dActionSetRoll with a rotation.
 * @param angle The angle to rotate by
 */
- (id) initWithAngle:(float)angle;

@end


