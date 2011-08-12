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

#pragma mark Isgl3dActionEase

/** 
 * The Isgl3dActionEase is the base class for easing actions
 */
@interface Isgl3dActionEase : Isgl3dActionInterval <NSCopying> {
	Isgl3dActionInterval * _action;
}

/**
 * Allocates and initialises (autorelease) the Isgl3dActionEase with an action to ease.
 * @param action The action to ease
 */
+ (id) actionWithAction:(Isgl3dActionInterval *)action;

/**
 * Initialises (autorelease) the Isgl3dActionEase with an action to ease.
 * @param action The action to ease
 */
- (id) initWithAction:(Isgl3dActionInterval *)action;

@end


#pragma mark Isgl3dActionEaseRate

/** 
 * The Isgl3dActionEaseRate is the base class for easing actions with rate parameters
 */
@interface Isgl3dActionEaseRate :  Isgl3dActionEase <NSCopying> {
	float _rate;
}

/**
 * Allocates and initialises (autorelease) the Isgl3dActionEase with an action to ease and rate.
 * @param action The action to ease
 * @param rate The rate of ease
 */
+ (id) actionWithAction:(Isgl3dActionInterval *)action rate:(float)rate;

/**
 * Initialises (autorelease) the Isgl3dActionEase with an action to ease and rate.
 * @param action The action to ease
 * @param rate The rate of ease
 */
- (id) initWithAction:(Isgl3dActionInterval *)action rate:(float)rate;

@end

#pragma mark Isgl3dActionEaseIn

/** 
 * Isgl3dActionEaseIn : ease in with rate
 */
@interface Isgl3dActionEaseIn : Isgl3dActionEaseRate <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseOut

/** 
 * Isgl3dActionEaseOut : ease out with rate
 */
@interface Isgl3dActionEaseOut : Isgl3dActionEaseRate <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseInOut

/** 
 * Isgl3dActionEaseInOut : ease in-out with rate
 */
@interface Isgl3dActionEaseInOut : Isgl3dActionEaseRate <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseExponentialIn

/** 
 * Isgl3dActionEaseExponentialIn : ease exponential in
 */
@interface Isgl3dActionEaseExponentialIn : Isgl3dActionEase <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseExponentialOut

/** 
 * Isgl3dActionEaseExponentialOut : ease exponential out
 */
@interface Isgl3dActionEaseExponentialOut : Isgl3dActionEase <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseExponentialInOut

/** 
 * Isgl3dActionEaseExponentialInOut : ease exponential in-out
 */
@interface Isgl3dActionEaseExponentialInOut : Isgl3dActionEase <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseSineIn

/** 
 * Isgl3dActionEaseSineIn : ease sine in
 */
@interface Isgl3dActionEaseSineIn : Isgl3dActionEase <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseSineOut

/** 
 * Isgl3dActionEaseSineOut : ease sine out
 */
@interface Isgl3dActionEaseSineOut : Isgl3dActionEase <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseSineInOut

/** 
 * Isgl3dActionEaseSineInOut : ease sine in-out
 */
@interface Isgl3dActionEaseSineInOut : Isgl3dActionEase <NSCopying> {
} 
@end


#pragma mark Isgl3dActionEaseElastic

/** 
 * The Isgl3dActionEaseElastic is the base class for easing actions with elastic characteristics
 */
@interface Isgl3dActionEaseElastic :  Isgl3dActionEase <NSCopying> {
	float _period;
}

/**
 * Allocates and initialises (autorelease) the Isgl3dActionEaseElastic with an action to ease and period (default = 0.3).
 * @param action The action to ease
 * @param period The period
 */
+ (id) actionWithAction:(Isgl3dActionInterval *)action period:(float)period;

/**
 * Initialises (autorelease) the Isgl3dActionEaseElastic with an action to ease and period (default = 0.3).
 * @param action The action to ease
 * @param period The period
 */
- (id) initWithAction:(Isgl3dActionInterval *)action period:(float)period;

@end

#pragma mark Isgl3dActionEaseElasticIn

/** 
 * Isgl3dActionEaseElasticIn : ease elastic in
 */
@interface Isgl3dActionEaseElasticIn : Isgl3dActionEaseElastic <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseElasticIn

/** 
 * Isgl3dActionEaseElasticOut : ease elastic out
 */
@interface Isgl3dActionEaseElasticOut : Isgl3dActionEaseElastic <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseElasticInOut

/** 
 * Isgl3dActionEaseElasticInOut : ease elastic in-out
 */
@interface Isgl3dActionEaseElasticInOut : Isgl3dActionEaseElastic <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseBounce

/** 
 * Isgl3dActionEaseBounce : base class for ease bounces
 */
@interface Isgl3dActionEaseBounce : Isgl3dActionEase <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseBounceIn

/** 
 * Isgl3dActionEaseBounceIn : ease bounce in
 */
@interface Isgl3dActionEaseBounceIn : Isgl3dActionEaseBounce <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseBounceOut

/** 
 * Isgl3dActionEaseBounceOut : ease bounce out
 */
@interface Isgl3dActionEaseBounceOut : Isgl3dActionEaseBounce <NSCopying> {
} 
@end

#pragma mark Isgl3dActionEaseBounceInOut

/** 
 * Isgl3dActionEaseBounceInOut : ease bounce in-out
 */
@interface Isgl3dActionEaseBounceInOut : Isgl3dActionEaseBounce <NSCopying> {
} 
@end
