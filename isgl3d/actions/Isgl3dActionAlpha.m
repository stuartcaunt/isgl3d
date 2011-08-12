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

#import "Isgl3dActionAlpha.h"
#import "Isgl3dNode.h"

#pragma mark Isgl3dActionAlphaTo

@implementation Isgl3dActionAlphaTo

+ (id) actionWithDuration:(float)duration alpha:(float)alpha {
	return [[[self alloc] initWithDuration:duration alpha:alpha] autorelease];
}

- (id) initWithDuration:(float)duration alpha:(float)alpha {
	if ((self = [super initWithDuration:duration])) {
		_finalAlpha = alpha;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionAlphaTo * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration alpha:_finalAlpha];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	_initialAlpha = ((Isgl3dNode *)target).alpha;
	_delta = _finalAlpha - _initialAlpha;
}

- (void) update:(float)progress {
	[_target setAlpha:_initialAlpha + progress * _delta];
}

@end

#pragma mark Isgl3dActionFadeIn

@implementation Isgl3dActionFadeIn

+ (id) actionWithDuration:(float)duration {
	return [[[self alloc] initWithDuration:duration] autorelease];
}

- (id) initWithDuration:(float)duration {
	if ((self = [super initWithDuration:duration])) {
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionFadeIn * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	((Isgl3dNode *)target).alpha = 0.0f;
}

- (void) update:(float)progress {
	[_target setAlpha:progress];
}

@end

#pragma mark Isgl3dActionFadeOut

@implementation Isgl3dActionFadeOut

+ (id) actionWithDuration:(float)duration {
	return [[[self alloc] initWithDuration:duration] autorelease];
}

- (id) initWithDuration:(float)duration {
	if ((self = [super initWithDuration:duration])) {
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionFadeOut * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	((Isgl3dNode *)target).alpha = 1.0f;
}

- (void) update:(float)progress {
	[_target setAlpha:(1.0f - progress)];
}

@end

#pragma mark Isgl3dActionSetAlpha

@implementation Isgl3dActionSetAlpha

+ (id) actionWithAlpha:(float)alpha {
	return [[[self alloc] initWithAlpha:alpha] autorelease];
}

- (id) initWithAlpha:(float)alpha {
	if ((self = [super init])) {
		_finalAlpha = alpha;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionSetAlpha * copy = [[[self class] allocWithZone:zone] initWithAlpha:_finalAlpha];

	return copy;
}

- (void) update:(float)progress {
	[_target setAlpha:_finalAlpha];
}

@end

