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

#import "Isgl3dActionParallel.h"

@implementation Isgl3dActionParallel

+ (id) actionWithActions:(Isgl3dActionFixedDuration *)action, ... {
	NSMutableArray * actions = [NSMutableArray arrayWithCapacity:2];

	va_list params;
	va_start(params, action);
	
	while (action) {
		[actions addObject:action];
		action = va_arg(params, Isgl3dActionFixedDuration *);
	}

	va_end(params);

	return [[[self alloc] initWithActionsArray:actions] autorelease];
}

+ (id) actionWithActionsArray:(NSArray *)actions {
	return [[[self alloc] initWithActionsArray:actions] autorelease];
}

- (id) initWithActions:(Isgl3dActionFixedDuration *)action, ... {
	if ((self = [super init])) {
		_actions = [[NSMutableArray alloc] init];

		va_list params;
		va_start(params, action);
		
		while (action) {
			[_actions addObject:action];
			action = va_arg(params, Isgl3dActionFixedDuration *);
		}
	
		va_end(params);
		
	}
	
	return self;
}

- (id) initWithActionsArray:(NSArray *)actions {
	if ((self = [super init])) {
		_actions = [actions retain];

	}
	
	return self;	
}


- (void) dealloc {
	[_actions release];
	
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	NSMutableArray * actionsCopy = [[NSMutableArray alloc] initWithArray:_actions copyItems:YES];
	Isgl3dActionParallel * copy = [[[self class] allocWithZone:zone] initWithActionsArray:[actionsCopy autorelease]];

	return copy;
}

- (float) duration {
	float duration = 0.0f;
	for (Isgl3dActionFixedDuration * action in _actions) {
		duration = fmax(duration, action.duration);
	}
	return duration;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];

	for (Isgl3dActionFixedDuration * action in _actions) {
		[action startWithTarget:_target];
	}
}

- (BOOL) hasTerminated {
	BOOL hasTerminated = YES;
	for (Isgl3dActionFixedDuration * action in _actions) {
		hasTerminated &= [action hasTerminated];
	}
	return hasTerminated;
}

- (void) tick:(float)dt {
	for (Isgl3dActionFixedDuration * action in _actions) {
		if (!action.hasTerminated) {
			[action tick:dt];
		}
	}
}

@end
