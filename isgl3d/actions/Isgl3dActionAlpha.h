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

#pragma mark Isgl3dActionAlphaTo

/**
 * The Isgl3dActionAlphaTo modifies the transparency of an object to a specified alpha.
 */
@interface Isgl3dActionAlphaTo : Isgl3dActionInterval <NSCopying> {
	float _initialAlpha;
	float _finalAlpha;
	float _delta;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionAlphaTo with a duration and end alpha.
 * @param duration The duration of the action
 * @param alpha The desired alpha
 */
+ (id) actionWithDuration:(float)duration alpha:(float)alpha;

/**
 * Initialises the an Isgl3dActionAlphaTo with a duration and end alpha.
 * @param duration The duration of the action
 * @param alpha The desired alpha
 */
- (id) initWithDuration:(float)duration alpha:(float)alpha;

@end

#pragma mark Isgl3dActionFadeIn

/**
 * The Isgl3dActionFadeIn modifies the transparency of an object from 0 to 1.
 */
@interface Isgl3dActionFadeIn : Isgl3dActionInterval <NSCopying> {
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionFadeIn.
 * @param duration The duration of the action
 */
+ (id) actionWithDuration:(float)duration;

/**
 * Initialises the an Isgl3dActionFadeIn.
 * @param duration The duration of the action
 */
- (id) initWithDuration:(float)duration;

@end

#pragma mark Isgl3dActionFadeOut

/**
 * The Isgl3dActionFadeOut modifies the transparency of an object from 1 to 0.
 */
@interface Isgl3dActionFadeOut : Isgl3dActionInterval <NSCopying> {
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionFadeOut.
 * @param duration The duration of the action
 */
+ (id) actionWithDuration:(float)duration;

/**
 * Initialises the an Isgl3dActionFadeIn.
 * @param duration The duration of the action
 */
- (id) initWithDuration:(float)duration;

@end

#pragma mark Isgl3dActionSetAlpha

/**
 * The Isgl3dActionSetAlpha modifies the transparency of an object to a specified alpha instantly.
 */
@interface Isgl3dActionSetAlpha : Isgl3dActionInstant <NSCopying> {
	float _finalAlpha;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionSetAlpha with an alpha.
 * @param alpha The desired alpha
 */
+ (id) actionWithAlpha:(float)alpha;

/**
 * Initialises the an Isgl3dActionSetAlpha with analpha.
 * @param alpha The desired alpha
 */
- (id) initWithAlpha:(float)alpha;

@end
