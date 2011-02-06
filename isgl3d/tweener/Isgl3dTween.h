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

#import <Foundation/Foundation.h>

#define TWEEN_DURATION @"duration"
#define TWEEN_TRANSITION @"transition"
#define TWEEN_ON_COMPLETE_TARGET @"onCompleteTarget"
#define TWEEN_ON_COMPLETE_SELECTOR @"onCompleteSelector"

#define TWEEN_FUNC_LINEAR @"linear"
#define TWEEN_FUNC_EASEINSINE @"easeInSine"
#define TWEEN_FUNC_EASEOUTSINE @"easeOutSine"
#define TWEEN_FUNC_EASEINOUTSINE @"easeInOutSine"
#define TWEEN_FUNC_EASEINBOUNCE @"easeInBounce"
#define TWEEN_FUNC_EASEOUTBOUNCE @"easeOutBounce"
#define TWEEN_FUNC_EASEINTHROW @"easeInThrow"
#define TWEEN_FUNC_EASEOUTTHROW @"easeOutThrow"

/**
 * The Isgl3dTween provides Tweening functionality in iSGL3D.
 * 
 * Tweening (or "in-betweening") is a simple method of animating objects, or simply modifying the properties of an object automatically over time.
 * 
 * Tweening is very simple:
 * <ol>
 * <li>Choose an object to tween</li>
 * <li>Choose one of more properties to manipulate</li>
 * <li>Specify the desired values for the properties</li>
 * <li>Specify a transition function (discussed later)</li>
 * <li>Sepcify a time for the properties to change from their current value to the desired ones</li>
 * </ol> 
 * 
 * Once a tween has been created by Isgl3dTweener, the property values are automatically modified over time by interpolating between the original
 * value and the desired one.
 * 
 * For example, to animate an object in iSGL3D (inheriting from Isgl3dNode) simply specify the x, y and/or z property and the position you want the object
 * to move to.
 * 
 * Tweening in iSGL3D works through "introspection": the properties are specified as NSStrings and Isgl3DTween will obtain information corresponding to the
 * property on the object specified. Note that the properties used in a tween must be numeric types otherwise the tween will not be constructed.
 * 
 * Depending on the type of animation required different "transition functions" are available. These describe how the property value changes in time and are
 * used to interpolate the property value at a given time. The following transition functions are available:
 * <ul>
 * <li>TWEEN_FUNC_LINEAR: Linear interpolation over time.</li>
 * <li>TWEEN_FUNC_EASEINSINE: The interpolation follows 90 degrees of a sine wave, starting slowly and accelerating towards the end.</li>
 * <li>TWEEN_FUNC_EASEOUTSINE: The interpolation follows 90 degrees of a sine wave, starting quickly and slowing down towards the end.</li>
 * <li>TWEEN_FUNC_EASEINOUTSINE: The interpolation follows 180 degrees of a sine wave, starting slowly, quickly at the center and slowing down towards the end.</li>
 * <li>TWEEN_FUNC_EASEOUTBOUNCE: The interpolation produces a bouncing motion with smaller bounces at the end.</li>
 * <li>TWEEN_FUNC_EASEINBOUNCE: The interpolation produces a bouncing motion with smaller bounces at the beginning.</li>
 * <li>TWEEN_FUNC_EASEINTHROW: The interpolation produced is that of a thrown object with the property value going beyond and then back to the desired value.</li>
 * <li>TWEEN_FUNC_EASEOUTTHROW: The interpolation produced is that of a thrown object with the property value going below the original value and then to the desired value.</li>
 * </ul>
 * 
 * When the tween has completed, it is possible for a callback to be made to another object. This can be useful for example to return the tweened object
 * to its original state (via another tween for example) or just a simple notification that the tween has completed.
 * 
 * The Isgl3dTweener is used to construct all Isgl3dTweens and handles the destruction of them as well when they have completed. It also handles the
 * animation.
 * 
 * Note, if two or more tweens are created that modify the same property of the same object, the last tween created has precedence and the property
 * is removed from the other tweens.
 * 
 */
@interface Isgl3dTween : NSObject {
	
@private
	NSDate * _startTime;
	BOOL _isCompleted; 
	float _duration;
	NSString * _transition;
	id _onCompleteTarget;
	SEL _onCompleteSelector;

	id _object;
	NSMutableDictionary * _finalValues;
	NSMutableDictionary * _initialValues;
}

/**
 * The object on which the tween is performed.
 */
@property (readonly) id object;

/**
 * An array of NSString property names to be tweened.
 */
@property (readonly) NSArray * properties;

/**
 * Initialises the Isgl3dTween with an object to be tweened and an NSDictionary of parameters for it.
 * The parameters contains the following
 * <ul>
 * <li>TWEEN_DURATION: the duration of the tween (required)</li>
 * <li>TWEEN_TRANSITION: the transition function (required)</li>
 * <li>TWEEN_ON_COMPLETE_TARGET: the object containing the callback method when the tween has completed (optional)</li>
 * <li>TWEEN_ON_COMPLETE_SELECTOR: the callback method of the target object when the tween has completed (optional)</li>
 * </ul>
 * All properties to be tweened are contained as additional key-values in the dictionary of parameters, the key being the property name.
 * @param object The object to be tweened.
 * @param parameters An NSDictionary of key-values to parameterize the tween (see discussion).
 */
- (id) initWithObject:(id)object forParameters:(NSDictionary *)parameters;

/**
 * Returns YES if the tween has completed.
 * @return YES if the tween has completed.
 */
- (BOOL) isCompleted;

/**
 * Returns YES if the tween contains no properties.
 * @return YES if the tween contains no properties.
 */
- (BOOL) isEmpty;

/*
 * Updates all properties of the tween for the current time.
 * Note: this is called internally by Isgl3dTweener and should not be called explicitly.
 * @param currentTime the current real time.
 */
- (void) update:(NSDate *)currentTime;

/*
 * Executes the callback method if one has been provided. 
 * Note: this is called internally by Isgl3dTweener and should not be called explicitly.
 */
- (void) onComplete;

/*
 * Removes a property to be tweened.
 * Note: this is called internally by Isgl3dTweener and should not be called explicitly.
 * @param property The name of the property.
 */
- (void) removeProperty:(NSString *)property;

@end
