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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Isgl3dNode;
@class Isgl3dEvent3D;

/**
 * Utility class to handle single touches on rendered objects (multi-touches are ignored). When multi
 * touches occur, only the first touch is handled, the others are ignored.
 */
@interface Isgl3dSingleTouchFilter : NSObject {
	    
@private
	Isgl3dNode * _object;

	NSString * _eventId;
	
	NSMutableDictionary * _listeners;
}

/**
 * Allocates and initialises (autorelease) Isgl3dSingleTouchFilter with an Isgl3dNode that we
 * wish to add an event listener to.
 * @param object The interactive object for which event listeners should be attached.
 */
+ (id) filterWithObject:(Isgl3dNode *)object;

/**
 * Initialises the Isgl3dSingleTouchFilter with an Isgl3dNode that we
 * wish to add an event listener to.
 * @param object The interactive object for which event listeners should be attached.
 */
- (id) initWithObject:(Isgl3dNode *)object;

/**
 * Adds an event listener to the filter. A callback is sent to the specified object and method
 * for the given event type.
 * The event types are specified in Isgl3dEventType and can be TOUCH_EVENT, MOVE_EVENT or RELEASE_EVENT.
 * @param object The id of the object that will handle the event.
 * @param method The method of the object that will handle the event.
 * @param eventType The type of event for which the method will be called. 
 */
- (void) addEvent3DListener:(id)object method:(SEL)method forEventType:(NSString *)eventType;


@end
