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

#import "Isgl3dTweener.h"
#import "Isgl3dTween.h"

@interface Isgl3dTweener (PrivateMethods)
- (void) addTweenToInstance:(id)object withParameters:(NSDictionary *)parameters;
- (void) startAnimation;
- (void) stopAnimation;
@end

@implementation Isgl3dTweener

static Isgl3dTweener * _instance;

- (id)init {
	if ((self = [super init])) {
		_activeTweens = [[NSMutableArray alloc] init];
		
		_animating = FALSE;
		_animationTimer = nil;
	}
	return self;
}

- (void) dealloc {
	//Isgl3dLog(Info, @"Deleting tweener");
	[self stopAnimation];
	[_activeTweens release];
	
	
	[super dealloc];
}

+ (void) addTween:(id)object withParameters:(NSDictionary *)parameters {
	if (_instance == nil) {
		_instance = [[Isgl3dTweener alloc] init];
	}
	
	[_instance addTweenToInstance:object withParameters:parameters];
}

+ (void) reset {
	if (_instance) {
		[_instance stopAnimation];
		[_instance release];
		_instance = nil;
	}
}

- (void) addTweenToInstance:(id)object withParameters:(NSDictionary *)parameters {
	
	Isgl3dTween * newTween = [[Isgl3dTween alloc] initWithObject:object forParameters:parameters];
	
	NSMutableArray * tweensToRemove = [[NSMutableArray alloc] init];
	
	// See if a tween already exists for this object, and check that properties don't clash
	for (Isgl3dTween * tween in _activeTweens) {
		if (tween.object == object) {
			
			NSArray * newProperties = newTween.properties;
			NSArray * existingProperties = tween.properties;
			for (NSString * property in newProperties) {
				if ([existingProperties containsObject:property]) {
					[tween removeProperty:property];
					
					// Check if tween is empty of properties
					if ([tween isEmpty]) {
						[tweensToRemove addObject:tween];
					}
				}
			}
			
		}
	}

	// Remove tweens if necessary
	for (Isgl3dTween * tween in tweensToRemove) {
		[_activeTweens removeObject:tween];
	}
	[tweensToRemove release];
	
	[_activeTweens addObject:[newTween autorelease]];
	
	// Start the animation
	[self startAnimation];
}

- (void) updateTweens:(id)sender {
	
	NSMutableArray * completedTweens = [[NSMutableArray alloc] init];
	
	// Get current time
	NSDate * currentTime = [NSDate date];
	
	// Update all tweens
	for (Isgl3dTween * tween in _activeTweens) {
		[tween update:currentTime];
		
		// Store all completed tweens
		if ([tween isCompleted]) {
			[completedTweens addObject:tween];
		}
	}
	
	// Remove all completed tweens
	for (Isgl3dTween * tween in completedTweens) {
		[_activeTweens removeObject:tween];
	}
		
	// Determine if tween animation should stop
	if ([_activeTweens count] == 0) {
		[self stopAnimation];
	}

	// Handle any onCompeletion selectors and release completed tween
	for (Isgl3dTween * tween in completedTweens) {
		[tween onComplete];
	}	
	
	// Release completed tweens
	[completedTweens release];
}


- (void) startAnimation {
	// Check to see if animation already happening
	if (!_animating) {
		_animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1.0 / 60.0) target:self selector:@selector(updateTweens:) userInfo:nil repeats:TRUE];
		
		_animating = TRUE;
	}
}

- (void)stopAnimation {
	if (_animating) {
		[_animationTimer invalidate];
		_animationTimer = nil;
		_animating = FALSE;
	}
}

@end
