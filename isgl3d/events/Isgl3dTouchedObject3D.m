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

#import "Isgl3dTouchedObject3D.h"
#import "Isgl3dEvent3DDispatcher.h"
#import "Isgl3dNode.h"

@interface Isgl3dTouchedObject3D (PrivateMethods)
- (BOOL) areTheSamePoints:(CGPoint)point1 point2:(NSString *)point2;
@end

@implementation Isgl3dTouchedObject3D

@synthesize object = _object;

- (id) initWithObject:(Isgl3dNode *)object {
	if ((self = [super init])) {
		_object = [object retain];
		
		_previousLocations = [[NSMutableSet alloc] init];
		_newTouches = [[NSMutableSet alloc] init];
	}

	return self;
}

- (void) dealloc {
	[_object release];
	[_previousLocations release];
	[_newTouches release];
	
    [super dealloc];
}

- (void) addTouch:(UITouch *)touch {
	[_newTouches addObject:touch];
	[_previousLocations addObject:NSStringFromCGPoint([touch locationInView:touch.view])];
}

- (void) removeTouch:(UITouch *)touch {

	// Find touch at CURRENT location (touch has not moved)
	NSString * previousLocation;
	for (previousLocation in _previousLocations) {
		if ([self areTheSamePoints:[touch locationInView:touch.view] point2:previousLocation]) {
			break;
		}
	}
	
	// Try the touche's previous location if not found (iphone funny behaviour)
	if (previousLocation == nil) {
		for (previousLocation in _previousLocations) {
			if ([self areTheSamePoints:[touch previousLocationInView:touch.view] point2:previousLocation]) {
				break;
			}
		}
	}
	
	// Remove previous touch if it exists
	if (previousLocation != nil) {
		[_newTouches addObject:touch];
		[_previousLocations removeObject:previousLocation];
	}
}

- (void) moveTouch:(UITouch *)touch  {

	// Find touch at PREVIOUS location (touch HAS moved)
	NSString * previousLocation;
	for (previousLocation in _previousLocations) {
		if ([self areTheSamePoints:[touch previousLocationInView:touch.view] point2:previousLocation]) {
			break;
		}
	}
	
	// Remove previous touch if it exists, and add new one
	if (previousLocation != nil) {
		[_newTouches addObject:touch];
		[_previousLocations removeObject:previousLocation];
		[_previousLocations addObject:NSStringFromCGPoint([touch locationInView:touch.view])];
	}
	
}

- (BOOL) respondsToObject:(Isgl3dNode *)object {
	return (object == _object);
}


- (BOOL) respondsToLocation:(NSString *)location {
	// Find touch at previous location
	NSString * previousLocation;
	for (previousLocation in _previousLocations) {
		if ([location isEqualToString:previousLocation]) {
			return YES;
		}
	}

	return NO;
}

- (BOOL) hasNoTouches {
	return [_previousLocations count] == 0;
}


- (void) startEventCycle {
	[_newTouches removeAllObjects];
}

- (void) fireEventForType:(NSString *)eventType {
	if ([_newTouches count] > 0) {
		[_object dispatchEvent:_newTouches forEventType:eventType];
	}
}


- (BOOL) areTheSamePoints:(CGPoint)point1 point2:(NSString *)point2 {
	return [NSStringFromCGPoint(point1) isEqualToString:point2]; 
}

@end
