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
 */

#import "Isgl3dActionManager.h"
#import "Isgl3dLog.h"
#import "Isgl3dAction.h"

static Isgl3dActionManager * _instance = nil;

@interface Isgl3dActionManager ()
- (id) initSingleton;
@end

@implementation Isgl3dActionManager

- (id) init {
	NSLog(@"Isgl3dActionManager::init should not be called on singleton. Instance should be accessed via sharedInstance");
	
	return nil;
}

- (id) initSingleton {
	
	if ((self = [super init])) {
		_actionsHandlers = [[NSMutableArray alloc] init];

	}

	return self;
}

- (void) dealloc {
	[_actionsHandlers release];

	[super dealloc];
}

+ (Isgl3dActionManager *) sharedInstance {
	
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dActionManager alloc] initSingleton];
		}
	}
		
	return _instance;
}

+ (void) resetInstance {
	if (_instance) {

		[_instance release];
		_instance = nil;
	}
}

- (void) tick:(float)dt {
	// tick all action handlers
	NSMutableArray * terminatedActionsHandlers = [NSMutableArray arrayWithCapacity:0];
	for (Isgl3dActionsHandler * actionsHandler in _actionsHandlers) {
		if (!actionsHandler.isPaused) {
			[actionsHandler tick:dt];
		}

		if (!actionsHandler.containsActions) {
			[terminatedActionsHandlers addObject:actionsHandler];
		}
	} 
	
	// Remove terminated action handlers
	for (Isgl3dActionsHandler * actionsHandler in terminatedActionsHandlers) {
		[_actionsHandlers removeObject:actionsHandler];
	}
}

- (void) addAction:(Isgl3dAction *)action toTarget:(id)target isPaused:(BOOL)isPaused {
	// determine if action is already running or get action handler if it exists
	Isgl3dActionsHandler * targetActionsHandler = nil;
	for (Isgl3dActionsHandler * actionsHandler in _actionsHandlers) {
		if ([actionsHandler containsAction:action]) {
			Isgl3dLog(Error, @"Isgl3dActionManager : running action cannot be added twice");
			return;
			
		} else if (actionsHandler.target == target) {
			targetActionsHandler = actionsHandler;
		}
	}
	
	// Create new action handler if needed
	if (!targetActionsHandler) {
		targetActionsHandler = [Isgl3dActionsHandler handlerWithTarget:target isPaused:isPaused];
		[_actionsHandlers addObject:targetActionsHandler];
	}
	
	// Add action to action handler
	[targetActionsHandler addAction:action];
}

- (void) stopAction:(Isgl3dAction *)action {
	for (Isgl3dActionsHandler * actionsHandler in _actionsHandlers) {
		if ([actionsHandler containsAction:action]) {
			[actionsHandler stopAction:action];

			if (!actionsHandler.containsActions) {
				[_actionsHandlers removeObject:actionsHandler];
			}
			
			return;
		}
	}
}

- (void) stopAllActionsForTarget:(id)target {
	for (Isgl3dActionsHandler * actionsHandler in _actionsHandlers) {
		if (actionsHandler.target == target) {
			[actionsHandler stopAllActions];

			[_actionsHandlers removeObject:actionsHandler];

			return;
		}
	}
}

- (void) pauseActionsForTarget:(id)target {
	for (Isgl3dActionsHandler * actionsHandler in _actionsHandlers) {
		if (actionsHandler.target == target) {
			actionsHandler.isPaused = YES;
			return;
		}
	}
}

- (void) resumeActionsForTarget:(id)target {
	for (Isgl3dActionsHandler * actionsHandler in _actionsHandlers) {
		if (actionsHandler.target == target) {
			actionsHandler.isPaused = NO;
			return;
		}
	}
}


@end


#pragma mark Isgl3dActionsHandler

@implementation Isgl3dActionsHandler

@synthesize target = _target;
@synthesize isPaused = _isPaused;

+ (id) handlerWithTarget:(id)target isPaused:(BOOL)isPaused {
	return [[[self alloc] initWithTarget:target isPaused:isPaused] autorelease];
}

- (id) initWithTarget:(id)target isPaused:(BOOL)isPaused {
	if ((self = [super init])) {
		_target = target;
		_isPaused = isPaused;
		
		_actions = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[_actions release];

	[super dealloc];
}

- (BOOL) containsActions {
	return ([_actions count] != 0);
}

- (void) tick:(float)dt {
	NSMutableArray * terminatedActions = [NSMutableArray arrayWithCapacity:0];

	// Update all actions	
	for (Isgl3dAction * action in _actions) {
		[action tick:dt];
		
		if (action.hasTerminated) {
			[terminatedActions addObject:action];
		}
	} 
	
	// Remove terminated actions
	for (Isgl3dAction * action in terminatedActions) {
		[_actions removeObject:action];
	}
	
}

- (BOOL) containsAction:(Isgl3dAction *)action {
	return [_actions containsObject:action];
}

- (void) addAction:(Isgl3dAction *)action {
	[_actions addObject:action];
	
	// Star the action
	[action startWithTarget:_target];
}

- (void) stopAction:(Isgl3dAction *)action {
	[_actions removeObject:action];
}

- (void) stopAllActions {
	[_actions removeAllObjects];
}

@end
