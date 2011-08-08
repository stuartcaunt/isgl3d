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

#import "Isgl3dEvent3DHandler.h"
#import "Isgl3dEventType.h"
#import "Isgl3dObject3DGrabber.h"
#import "Isgl3dTouchedObject3D.h"
#import "Isgl3dDirector.h"
#import "Isgl3dNode.h"

@interface Isgl3dEvent3DHandler (PrivateMethods)
- (Isgl3dTouchedObject3D *)touchedObjectForObject:(Isgl3dNode *)object;
- (Isgl3dTouchedObject3D *)touchedObjectForLocation:(NSString *)location;
@end

@implementation Isgl3dEvent3DHandler

- (id) init {
	if ((self = [super init])) {
		_touchedObjects = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	[_touchedObjects release];
		
    [super dealloc];
}


/**
 * Redirect touches events to associated Object3Ds: simply forwarding events from view to objects
 */
- (BOOL) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	Isgl3dTouchedObject3D * touchedObject;
	BOOL objectTouched = NO;

	// Initialise all touched objects
	for (touchedObject in _touchedObjects) {
		[touchedObject startEventCycle];
	}


	// Iterate over all touches
	for (UITouch * touch in touches) {
		Isgl3dNode * object = [[Isgl3dDirector sharedInstance] nodeForTouch:touch];							   
		
		// If object found then associate the touch with it
		if (object) {
			touchedObject = [self touchedObjectForObject:object];
			objectTouched = YES;
			
			// Create new touched object if necessary, associate touch with it
			if (touchedObject == nil) {
				touchedObject = [[Isgl3dTouchedObject3D alloc] initWithObject:object];
				[_touchedObjects addObject:[touchedObject autorelease]];
			}
			[touchedObject addTouch:touch];
		}
		
	}

	// Iterate over all touched objects and fire associated events
	for (touchedObject in _touchedObjects) {
		[touchedObject fireEventForType:TOUCH_EVENT];
	}
		
	return objectTouched;
}


/**
 * Redirect touches events to associated Object3Ds: simply forwarding events from view to objects
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	Isgl3dTouchedObject3D * touchedObject;

	// Initialise all touched objects
	for (touchedObject in _touchedObjects) {
		[touchedObject startEventCycle];
	}

	// Iterate over all touches
	for (UITouch * touch in touches) {
		
		// Find TouchedObject that has previous position equal to previous position of touch (has moved)
		touchedObject = [self touchedObjectForLocation:NSStringFromCGPoint([touch previousLocationInView:touch.view])];
		
		// Create new touched object if necessary, associate touch with it
		if (touchedObject != nil) {
			[touchedObject moveTouch:touch];
		}
		
	}

	// Iterate over all touched objects and fire associated events
	for (touchedObject in _touchedObjects) {
		[touchedObject fireEventForType:MOVE_EVENT];
	}
}

/**
 * Redirect touches events to associated Object3Ds: simply forwarding events from view to objects
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	Isgl3dTouchedObject3D * touchedObject;

	// Initialise all touched objects
	for (touchedObject in _touchedObjects) {
		[touchedObject startEventCycle];
	}

	// Iterate over all touches
	for (UITouch * touch in touches) {
		
		// Find TouchedObject that has previous position equal to current position of touch (not moved)
		touchedObject = [self touchedObjectForLocation:NSStringFromCGPoint([touch locationInView:touch.view])];
		
		// If not found, try previous location (iphone seems a bit funny about this)
		if (touchedObject == nil) {
			touchedObject = [self touchedObjectForLocation:NSStringFromCGPoint([touch previousLocationInView:touch.view])];
		}
		
		// Create new touched object if necessary, associate touch with it
		if (touchedObject != nil) {
			[touchedObject removeTouch:touch];
		}
		
	}

	// Iterate over all touched objects and fire associated events. Keep list of finished touched objects
	NSMutableSet * finishedObjects = [[NSMutableSet alloc] init];
	for (touchedObject in _touchedObjects) {
		[touchedObject fireEventForType:RELEASE_EVENT];
		
		if ([touchedObject hasNoTouches]) {
			[finishedObjects addObject:touchedObject];
		}
	}
	
	for (touchedObject in finishedObjects) {
		[_touchedObjects removeObject:touchedObject];
	}
	
	[finishedObjects release];
}

/**
 *
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

/**
 * Get TouchedObject containing Object3D if it exists
 */
- (Isgl3dTouchedObject3D *)touchedObjectForObject:(Isgl3dNode *)object {
	Isgl3dTouchedObject3D * touchedObject;
	for (touchedObject in _touchedObjects) {
		if ([touchedObject respondsToObject:object]) {
			return touchedObject;
		}
	}
	return nil;
}

/**
 * Get TouchedObject containing touch's previous position if it exists
 */
- (Isgl3dTouchedObject3D *)touchedObjectForLocation:(NSString *)location {
	Isgl3dTouchedObject3D * touchedObject;
	for (touchedObject in _touchedObjects) {
		if ([touchedObject respondsToLocation:location]) {
			return touchedObject;
		}
	}
	return nil;
}



@end
