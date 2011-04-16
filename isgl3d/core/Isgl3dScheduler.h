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
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */

/**
 * The Isgl3dScheduler is used call specific target::selectors at each frame. This is essentially
 * the case for user callbacks to update 3D scenes.
 * 
 * The schedule should not be called manually: the Isgl3dView provides a simplified interface to access
 * the same functionality.
 * 
 * Only one selector can be specified per target. A target can be paused and resumed.
 * 
 * The scheduler is "ticked" automatically at every frame by the Isgl3dDirector (while the Isgl3dDirector
 * is not paused).
 */
@interface Isgl3dScheduler : NSObject {

@private
	NSMutableArray * _timers;
	
}

/**
 * Returns the singleton instance of the Isgl3dScheduler.
 * @return The singleton instance of the Isgl3dScheduler.
 */
+ (Isgl3dScheduler *) sharedInstance;

/**
 * Resets the singleton instance of the Isgl3dScheduler. All values return to their defaults.
 */
+ (void) resetInstance;

/**
 * Adds a timer for a specific target::selector to be scheduled.
 * @param target The target object.
 * @param selector The selector method in the target.
 * @param isPaused Specified whether the timer is initially paused.
 */
- (void) schedule:(id)target selector:(SEL)selector isPaused:(BOOL)isPaused;

/**
 * Removes a scheduled timer for a specific target.
 * @param target The target object.
 */
- (void) unschedule:(id)target;

/**
 * Pauses the scheduled timer for a specific target.
 * @param target The target object.
 */
- (void) pause:(id)target;

/**
 * Resumes a paused timer for a specific target.
 * @param target The target object.
 */
- (void) resume:(id)target;

/**
 * Calls the target::selector in all timers (that are not currently paused).
 * This should never be called: for internal use by Isgl3dDirector.
 * @param dt The delta time since the last call.
 */
- (void) tick:(float)dt;

@end


#pragma mark Isgl3dTimer

/**
 * An internal class used to encapsulate all timer data.
 */
@interface Isgl3dTimer : NSObject {

@private
	id _target;
	SEL _selector;
	BOOL _isPaused;
	void (*_method)(id, SEL, float);
}

@property (nonatomic, readonly) id target;
@property (nonatomic) BOOL isPaused;

/**
 * Allocates and initialises a timer with a target and selector
 * @param target The target object.
 * @param selector The selector method in the target.
 * @param isPaused Specified whether the timer is initially paused.
 */
+ (id) timerWithTarget:(id)target selector:(SEL)selector isPaused:(BOOL)isPaused;

/**
 * Initialises a timer with a target and selector
 * @param target The target object.
 * @param selector The selector method in the target.
 * @param isPaused Specified whether the timer is initially paused.
 */
- (id) initWithTarget:(id)target selector:(SEL)selector isPaused:(BOOL)isPaused;

/**
 * Calls the target::selector.
 * @param dt The delta time since the last call.
 */
- (void) tick:(float)dt;

@end
