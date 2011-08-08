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

#import "Isgl3dTouchScreen.h"
#import "Isgl3dTouchScreenResponder.h"
#import "Isgl3dView.h"

static Isgl3dTouchScreen * _instance = nil;

@implementation Isgl3dTouchScreen

- (id) init {

	if ((self = [super init])) {
		_responders = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc {

	[_responders release];
    [super dealloc];
}

+ (Isgl3dTouchScreen *) sharedInstance {
	
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dTouchScreen alloc] init];
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

- (void) addResponder:(id <Isgl3dTouchScreenResponder>)responder {
	[_responders addObject:[Isgl3dViewTouchResponder responderWithResponder:responder]];
}

- (void) addResponder:(id <Isgl3dTouchScreenResponder>)responder withView:(Isgl3dView *)view {
	[_responders addObject:[Isgl3dViewTouchResponder responderWithResponder:responder andView:view]];
}

- (void) removeResponder:(id <Isgl3dTouchScreenResponder>)responder {
	for (Isgl3dViewTouchResponder * viewResponder in _responders) {
		if (viewResponder.responder == responder) {
			[_responders removeObject:viewResponder];
			return;
		}
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	for (Isgl3dViewTouchResponder * viewResponder in _responders) {
		if (viewResponder.view) {
			// Filter events in view
			NSMutableSet * filter = [NSMutableSet setWithCapacity:[touches count]];
			NSEnumerator * enumerator = [touches objectEnumerator];
			UITouch * touch;
			
			while ((touch = [enumerator nextObject])) {
				CGPoint uiPoint = [touch locationInView:touch.view];
				if ([viewResponder.view isUIPointInView:uiPoint]) {
					[filter addObject:touch];
				}
			}
			[viewResponder.responder touchesBegan:filter withEvent:event];
			
		} else {
			// Send all events to responder
			[viewResponder.responder touchesBegan:touches withEvent:event];
		}
	}
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	for (Isgl3dViewTouchResponder * viewResponder in _responders) {
		if (viewResponder.view) {
			// Filter events in view
			NSMutableSet * filter = [NSMutableSet setWithCapacity:[touches count]];
			NSEnumerator * enumerator = [touches objectEnumerator];
			UITouch * touch;
			
			while ((touch = [enumerator nextObject])) {
				CGPoint uiPoint = [touch locationInView:touch.view];
				if ([viewResponder.view isUIPointInView:uiPoint]) {
					[filter addObject:touch];
				}
			}
			[viewResponder.responder touchesMoved:filter withEvent:event];
			
		} else {
			// Send all events to responder
			[viewResponder.responder touchesMoved:touches withEvent:event];
		}
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (Isgl3dViewTouchResponder * viewResponder in _responders) {
		// Send all events to all responder
		[viewResponder.responder touchesEnded:touches withEvent:event];
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	for (Isgl3dViewTouchResponder * viewResponder in _responders) {
		// Send all events to all responder
		if ([viewResponder.responder respondsToSelector:@selector(touchesCancelled:withEvent:)]) {
			[viewResponder.responder touchesCancelled:touches withEvent:event];
		}
	}
}

@end


#pragma mark Isgl3dViewTouchResponder

@implementation Isgl3dViewTouchResponder

@synthesize view = _view;
@synthesize responder = _responder;


+ (id) responderWithResponder:(id<Isgl3dTouchScreenResponder>)responder {
	return [[[self alloc] initWithResponder:responder] autorelease];
}

+ (id) responderWithResponder:(id<Isgl3dTouchScreenResponder>)responder andView:(Isgl3dView *)view {
	return [[[self alloc] initWithResponder:responder andView:view] autorelease];
}

- (id) initWithResponder:(id<Isgl3dTouchScreenResponder>)responder {
	if ((self = [super init])) {
		_responder = [responder retain];
		_view = nil;
	}
	
	return self;
	
}

- (id) initWithResponder:(id<Isgl3dTouchScreenResponder>)responder andView:(Isgl3dView *)view {
	if ((self = [super init])) {
		_responder = [responder retain];
		_view = view;
	}
	
	return self;
	
}

- (void) dealloc {
	[_responder release];
    [super dealloc];
}

@end

