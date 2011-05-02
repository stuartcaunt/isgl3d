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

/**
 * The Isgl3dTweener provides a control class to all Isgl3dTweens. 
 * 
 * All tweens should be created here. The animation occurs immediately and the Isgl3dTween object is destroyed automatically when
 * it has completed.
 * 
 * The Isgl3dTweener works with an NSTimer to automatically update all Isgl3dTweens in its possession. The timer is created on the
 * first tween to be added and is deleted when the last one has terminated.
 * 
 * Access to tween creation is through a static method: only a single Isgl3dTweener exists for the whole application. 
 * 
 */
@interface Isgl3dTweener : NSObject {
	
@private
	BOOL _animating;
	
    NSTimer * _animationTimer;

	NSMutableArray * _activeTweens;
}

/**
 * Creates and adds a new Isgl3dTween to the array of active tweens. The tween is started immediately, updated automatically and
 * destroyed when it has completed.
 * @param object The id of the object to be tweened.
 * @param parameters An NSDictionary of parameters that characterise the tween. See the relevant discussion in Isgl3dTween for more information. 
 */
+ (void) addTween:(id)object withParameters:(NSDictionary *)parameters;

/**
 * All tweens are stopped and deleted.
 */
+ (void) reset;


@end
