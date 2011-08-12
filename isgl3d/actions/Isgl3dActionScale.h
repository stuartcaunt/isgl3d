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
#import "Isgl3dVector.h"

#pragma mark Isgl3dActionScaleTo

/**
 * The Isgl3dActionScaleTo scales an object to a specified scale.
 */
@interface Isgl3dActionScaleTo : Isgl3dActionInterval <NSCopying> {
	Isgl3dVector3 _initialScale;
	Isgl3dVector3 _finalScale;
	Isgl3dVector3 _vector;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionScaleTo with a duration and end scale.
 */
+ (id) actionWithDuration:(float)duration scale:(float)scale ;

/**
 * Initialises the an Isgl3dActionScaleTo with a duration and end scale.
 */
- (id) initWithDuration:(float)duration scale:(float)scale;

/**
 * Allocates and initialises (autorelease) an Isgl3dActionScaleTo with a duration and end scales.
 */
+ (id) actionWithDuration:(float)duration scaleX:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ;

/**
 * Initialises the an Isgl3dActionScaleTo with a duration and end scales.
 */
- (id) initWithDuration:(float)duration scaleX:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ;

@end


#pragma mark Isgl3dActionScaleBy

/**
 * The Isgl3dActionScaleBy scales an object by a specified scale.
 */
@interface Isgl3dActionScaleBy : Isgl3dActionInterval <NSCopying> {
	Isgl3dVector3 _initialScale;
	Isgl3dVector3 _finalScaling;
	Isgl3dVector3 _vector;
}

/**
 * Allocates and initialises (autorelease) an Isgl3dActionScaleBy with a duration and delta scale.
 */
+ (id) actionWithDuration:(float)duration scale:(float)scale ;

/**
 * Initialises the an Isgl3dActionScaleBy with a duration and delta scale.
 */
- (id) initWithDuration:(float)duration scale:(float)scale;

/**
 * Allocates and initialises (autorelease) an Isgl3dActionScaleBy with a duration and delta scales.
 */
+ (id) actionWithDuration:(float)duration scaleX:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ;

/**
 * Initialises the an Isgl3dActionScaleBy with a duration and delta scales.
 */
- (id) initWithDuration:(float)duration scaleX:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ;

@end

