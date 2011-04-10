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

#import "Isgl3dAnimationController.h"
#import "Isgl3dSkeletonNode.h"

@implementation Isgl3dAnimationController

@synthesize repeat = _repeat;
@synthesize frameRate = _frameRate;

+ (id) controllerWithSkeleton:(Isgl3dSkeletonNode *)skeleton andNumberOfFrames:(unsigned int)numberOfFrames {
	return [[[self alloc] initWithSkeleton:skeleton andNumberOfFrames:numberOfFrames] autorelease];
}

- (id) initWithSkeleton:(Isgl3dSkeletonNode *)skeleton andNumberOfFrames:(unsigned int)numberOfFrames {
    if ((self = [super init])) {
		_skeleton = [skeleton retain];
		_numberOfFrames = numberOfFrames;
		_currentFrame = 0;
		
		_frameRate = 30;
		_repeat = YES;
		_animating = NO;
		_animationTimer = nil;
    }
	
    return self;
}

- (void) dealloc {
	[_skeleton release];
	if (_animating) {
		[self pause];
	}
	
	[super dealloc];
}

- (void) setFrame:(unsigned int)frame {
	if (frame < _numberOfFrames) {
		_currentFrame = frame;
		[_skeleton setFrame:_currentFrame];
	}
}

- (void) nextFrame {
	_currentFrame++;
	if (_currentFrame == _numberOfFrames) {
		
		if (_repeat) {
			_currentFrame = 0;
			[_skeleton setFrame:_currentFrame];
		
		} else {
			_currentFrame = _numberOfFrames - 1;
			[self pause];
		}
	} else {
		[_skeleton setFrame:_currentFrame];
	}
	
}

- (void) start {
	if (!_animating) {
		_animating = YES;

		_animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1.0 / _frameRate) target:self selector:@selector(updateAnimation:) userInfo:nil repeats:TRUE];
	}
}

- (void) stop {
	if (_animating) {
		[_animationTimer invalidate];

		_animationTimer = nil;
		_animating = NO;
		
		_currentFrame = 0;
	}
	
}

- (void) pause {
	if (_animating) {
		[_animationTimer invalidate];

		_animationTimer = nil;
		_animating = NO;
	}
}

- (void) updateAnimation:(id)sender {
	[self nextFrame];
}

@end
