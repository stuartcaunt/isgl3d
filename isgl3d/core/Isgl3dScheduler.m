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

#import "Isgl3dScheduler.h"
#import "Isgl3dLog.h"

static Isgl3dScheduler * _instance = nil;

@interface Isgl3dScheduler ()
- (id) initSingleton;
@end

@implementation Isgl3dScheduler

- (id) init {
	NSLog(@"Isgl3dScheduler::init should not be called on singleton. Instance should be accessed via sharedInstance");
	
	return nil;
}

- (id) initSingleton {
	
	if ((self = [super init])) {
		_timers = [[NSMutableArray alloc] init];
	}

	return self;
}

- (void) dealloc {
	[_timers release];
	
	[super dealloc];
}

+ (Isgl3dScheduler *) sharedInstance {
	
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dScheduler alloc] initSingleton];
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

- (void) schedule:(id)target selector:(SEL)selector isPaused:(BOOL)isPaused {
	// check that target doesn't already exist
	BOOL exists = NO;
	for (Isgl3dTimer * timer in _timers) {
		if (timer.target == target) {
			exists = YES;
			break;
		}
	}
	
	if (exists) {
		Isgl3dLog(Error, @"Isgl3dScheduler : target added that is already scheduled.");
	} else {
		[_timers addObject:[Isgl3dTimer timerWithTarget:target selector:selector isPaused:isPaused]];
	}
}

- (void) unschedule:(id)target {
	for (Isgl3dTimer * timer in _timers) {
		if (timer.target == target) {
			[_timers removeObject:timer];
			break;
		}
	}
	
}

- (void) pause:(id)target {
	for (Isgl3dTimer * timer in _timers) {
		if (timer.target == target) {
			timer.isPaused = YES;
			break;
		}
	}
}

- (void) resume:(id)target {
	for (Isgl3dTimer * timer in _timers) {
		if (timer.target == target) {
			timer.isPaused = NO;
			break;
		}
	}
}

- (void) tick:(float)dt {
	for (Isgl3dTimer * timer in _timers) {
		if (!timer.isPaused) {
			[timer tick:dt];
		}
	}
	
}


@end


#pragma mark Isgl3dTimer

@implementation Isgl3dTimer

@synthesize target = _target;
@synthesize isPaused = _isPaused;

+ (id) timerWithTarget:(id)target selector:(SEL)selector isPaused:(BOOL)isPaused {
	return [[[self alloc] initWithTarget:target selector:selector isPaused:isPaused] autorelease];
}

- (id) initWithTarget:(id)target selector:(SEL)selector isPaused:(BOOL)isPaused {
	if ((self = [super init])) {
		_target = target;
		_selector = selector;
		_isPaused = isPaused;
		_method = (void (*)(id, SEL, float))[_target methodForSelector:_selector];
	}
	return self;
}

- (void) tick:(float)dt {
	_method(_target, _selector, dt);
}


@end
