/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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

#import "Isgl3dActionInterval.h"

@implementation Isgl3dActionInterval

@synthesize elapsedTime = _elapsedTime;

+ (id)actionWithDuration:(float)duration {
	return [[[self alloc] initWithDuration:duration] autorelease];
}

- (id)initWithDuration:(float)duration {
	if ((self = [super init])) {
		
		// Ensure that duration is positive and greater than 0
		duration = fmax(1.0e-6, duration);
		
		_duration = duration;
		_elapsedTime = 0.0f;
		_isFirstTick = YES;
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (id)copyWithZone:(NSZone*)zone {
	Isgl3dActionInterval * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration];

	return copy;
}

- (float) duration {
	return _duration;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];

	_elapsedTime = 0.0f;
	_isFirstTick = YES;
}

- (BOOL) hasTerminated {
	return _elapsedTime >= _duration;
}

- (void)tick:(float)dt {
	float progress = 0.0f;
	if (_isFirstTick) {
		_isFirstTick = NO;
	
	} else {
		_elapsedTime += dt;
		progress = fmin(1.0f, (_elapsedTime / _duration));
	}

	[self update:progress];
}

@end
