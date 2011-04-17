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

#import "Isgl3dSingleTouchFilter.h"
#import "Isgl3dEvent3D.h"
#import "Isgl3dEvent3DListener.h"
#import "Isgl3dNode.h"

@interface Isgl3dSingleTouchFilter (PrivateMethods)
- (void) touchesBegan:(Isgl3dEvent3D *)event;
- (void) touchesMoved:(Isgl3dEvent3D *)event;
- (void) touchesEnded:(Isgl3dEvent3D *)event;
- (void) handleEvent:(UITouch *)touch forEventType:(NSString *)eventType;
@end


@implementation Isgl3dSingleTouchFilter

+ (id) filterWithObject:(Isgl3dNode *)object {
	return [[[self alloc] initWithObject:object] autorelease];
}

- (id) initWithObject:(Isgl3dNode *)object {

	if ((self = [super init])) {
		_object = object;
		
		_listeners = [[NSMutableDictionary alloc] init];

		[_object addEvent3DListener:self method:@selector(touchesBegan:) forEventType:TOUCH_EVENT];
		[_object addEvent3DListener:self method:@selector(touchesMoved:) forEventType:MOVE_EVENT];
		[_object addEvent3DListener:self method:@selector(touchesEnded:) forEventType:RELEASE_EVENT];
	}
	
	return self;
}

- (void) dealloc {
	[_listeners release];
	
    [super dealloc];
}

- (void) addEvent3DListener:(id)object method:(SEL)method forEventType:(NSString *)eventType {
	Isgl3dEvent3DListener * listener = [[[Isgl3dEvent3DListener alloc] initWithObject:object method:method] autorelease];
	
	[_listeners setObject:listener forKey:eventType];
}

- (void) touchesBegan:(Isgl3dEvent3D *)event {
	if (_eventId == nil) {
		UITouch * touch = [[event.touches allObjects] objectAtIndex:0];
		// do not remove retain : _eventId released otherwise
		_eventId = [NSStringFromCGPoint([touch locationInView:touch.view]) retain];
		
		[self handleEvent:touch forEventType:TOUCH_EVENT];
	}
	
} 

- (void) touchesMoved:(Isgl3dEvent3D *)event {
	if (_eventId != nil) {
		for (UITouch * touch in event.touches) {

			if ([_eventId isEqualToString:NSStringFromCGPoint([touch previousLocationInView:touch.view])]) {
                [_eventId release];
				// do not remove retain : _eventId released otherwise
				_eventId = [NSStringFromCGPoint([touch locationInView:touch.view]) retain];
		
				[self handleEvent:touch forEventType:MOVE_EVENT];
				return;
			}
		}
	}
} 

- (void) touchesEnded:(Isgl3dEvent3D *)event {
	if (_eventId != nil) {
		for (UITouch * touch in event.touches) {
			if ([_eventId isEqualToString:NSStringFromCGPoint([touch previousLocationInView:touch.view])]) {
				// Try previous location
				[_eventId release];
				_eventId = nil;
		
				[self handleEvent:touch forEventType:RELEASE_EVENT];
				return;
				
			} else if ([_eventId isEqualToString:NSStringFromCGPoint([touch locationInView:touch.view])]) {
				// Otherwise try current location
				[_eventId release];
				_eventId = nil;
		
				[self handleEvent:touch forEventType:RELEASE_EVENT];
				return;
			} 
		}
	}
	
} 

- (void) handleEvent:(UITouch *)touch forEventType:(NSString *)eventType {
	Isgl3dEvent3DListener * listener = [_listeners objectForKey:eventType];
	if (listener != nil) {

		NSMutableSet * touches = [[NSMutableSet alloc] init];
		[touches addObject:touch];
		Isgl3dEvent3D * event = [[Isgl3dEvent3D alloc] initWithObject:_object forTouches:touches];
	
		[listener handleEvent:event];

		[touches release];
		[event release];
	}
}

@end
