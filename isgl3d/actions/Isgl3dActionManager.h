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

@class Isgl3dAction;

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */

/**
 * The Isgl3dActionManager is a singleton class used to manage all Isgl3dActions.
 * 
 * Note : this class is used internally by iSGL3D and should not be called via user operations.
 */
@interface Isgl3dActionManager : NSObject {
@private
	NSMutableArray * _actionsHandlers;
}

/**
 * Returns the singleton instance of the Isgl3dActionManager.
 * @return The singleton instance of the Isgl3dActionManager.
 */
+ (Isgl3dActionManager *) sharedInstance;

/**
 * Resets the singleton instance of the Isgl3dActionManager. All values return to their defaults.
 */
+ (void) resetInstance;

/**
 * Updates all running actions with the delta time since the last frame.
 * @param dt The delta time since the last frame.
 */
- (void) tick:(float)dt;

/**
 * Adds an action to a specified target that will be run in the next tick after when the target is not paused.
 * @param action The action to be run.
 * @param target The target to run the action on.
 * @param isPaused Specified if the target is currently paused.
 */
- (void) addAction:(Isgl3dAction *)action toTarget:(id)target isPaused:(BOOL)isPaused;

/**
 * Stops an action.
 * @param action The action to be stopped.
 */
- (void) stopAction:(Isgl3dAction *)action;

/**
 * Stops all actions associated with a particular target.
 * @param target The target on which all the actions are to be stopped.
 */
- (void) stopAllActionsForTarget:(id)target;

/**
 * Pauses all actions associated with a particular target.
 * @param target The target on which all the actions are to be paused.
 */
- (void) pauseActionsForTarget:(id)target;

/**
 * Resumes all actions associated with a particular target.
 * @param target The target on which all the actions are to be resumed.
 */
- (void) resumeActionsForTarget:(id)target;



@end


#pragma mark Isgl3dActionsHandler

/**
 * An internal class used to encapsulate all action-target data.
 */
@interface Isgl3dActionsHandler : NSObject {

@private
	id _target;
	BOOL _isPaused;
	NSMutableArray * _actions;
}

@property (nonatomic, readonly) id target;
@property (nonatomic) BOOL isPaused;
@property (nonatomic, readonly) BOOL containsActions;

/**
 * Allocates and initialises an actions handler for a specific target
 * @param target The target object.
 * @param isPaused Specified whether the handler is initially paused.
 */
+ (id) handlerWithTarget:(id)target isPaused:(BOOL)isPaused;

/**
 * Initialises an actions handler for a specific target
 * @param target The target object.
 * @param isPaused Specified whether the handler is initially paused.
 */
- (id) initWithTarget:(id)target isPaused:(BOOL)isPaused;

/**
 * Calls the tick method on all actions associated with the target
 * @param dt The delta time since the last call.
 */
- (void) tick:(float)dt;

/**
 * Returns true if the handler contains the specified action.
 */
- (BOOL) containsAction:(Isgl3dAction *)action;

/**
 * Adds an action to to the handler.
 * @param action The action to be run.
 */
- (void) addAction:(Isgl3dAction *)action;

/**
 * Stops an action.
 * @param action The action to be stopped.
 */
- (void) stopAction:(Isgl3dAction *)action;

/**
 * Stops all actions.
 * @param target The target on which all the actions are to be stopped.
 */
- (void) stopAllActions;

@end
