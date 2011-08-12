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

#pragma mark Isgl3dActionTweenTo

/**
 * The Isgl3dActionTweenTo modifies a property of an object to a specified value.
 */
@interface Isgl3dActionTweenTo : Isgl3dActionInterval <NSCopying> {
	NSString * _property;
	float _initialValue;
	float _finalValue;
	float _delta;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionTweenTo with a duration, property and end value.
 * @param duration The duration of the action
 * @param property The name of the property to tween
 * @param value The desired value for the property
 */
+ (id) actionWithDuration:(float)duration property:(NSString *)property value:(float)value;

/**
 * Initialises the an Isgl3dActionTweenTo with a duration, property and end value.
 * @param duration The duration of the action
 * @param property The name of the property to tween
 * @param value The desired value for the property
 */
- (id) initWithDuration:(float)duration property:(NSString *)property value:(float)value;

@end

#pragma mark Isgl3dActionTweenBy

/**
 * The Isgl3dActionTweenBy modifies a property of an object by a specified delta value.
 */
@interface Isgl3dActionTweenBy : Isgl3dActionInterval <NSCopying> {
	NSString * _property;
	float _initialValue;
	float _delta;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionTweenBy with a duration, property and delta value.
 * @param duration The duration of the action
 * @param property The name of the property to tween
 * @param value The desired change in value of the property 
 */
+ (id) actionWithDuration:(float)duration property:(NSString *)property value:(float)value;

/**
 * Initialises the an Isgl3dActionTweenBy with a duration, property and delta value.
 * @param duration The duration of the action
 * @param property The name of the property to tween
 * @param value The desired change in value of the property 
 */
- (id) initWithDuration:(float)duration property:(NSString *)property value:(float)value;

@end
