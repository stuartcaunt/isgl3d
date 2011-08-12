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

#import <Foundation/Foundation.h>

/**
 * The Isgl3dAction is the base class for all actions in Isgl3d : it essentially provides
 * an interface to all sub-classed actions.
 */
@interface Isgl3dAction : NSObject <NSCopying> {
	id _target;
}

/**
 * The target running the action.
 */
@property (nonatomic, readonly) id target;

/**
 * Allocates and initialises (autorelease) the base Isl3dAction.
 */
+ (id) action;

/**
 * Initialises the base Isgl3dAction.
 */
- (id) init;

/**
 * Copies the action.
 */
- (id) copyWithZone:(NSZone *) zone;

/**
 * Called internally when starting the action to associate it with the target and perform any other initialisation.
 * Note : This is called internally by the iSGL3D framework and should not be called manually.
 * @param target The target to run the action on.
 */
- (void) startWithTarget:(id)target;

/**
 * Returns true if the action has terminated.
 */
- (BOOL) hasTerminated;

/**
 * Called by the action manager to update the action with the time between render frames. 
 * Note : This is called internally by the iSGL3D framework and should not be called manually.
 * @param dt The delta time since the last update.
 */
- (void) tick:(float)dt;

/**
 * Updates the action with a progress between 0 (started) and 1 (terminated).
 * Note : This is called internally by the iSGL3D framework and should not be called manually.
 * @param progress The progress of the action between 0 and 1.
 */
- (void) update:(float)progress;

@end
