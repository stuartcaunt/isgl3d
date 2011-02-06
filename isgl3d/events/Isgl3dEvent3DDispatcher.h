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

@class Isgl3dEvent3DListener;

/**
 * All objects that are capable of user interactions inherit from this class. Isgl3dGLObject3D extends this class so all
 * 3D objects rendered on the screen have the capability of reacting to user events.
 * 
 * The Isgl3dEvent3DDispatcher provides an interface to add event listeners to objectes rendered on the screen to enable
 * user interactions.
 * 
 * Any number of listeners can be added to the object and a number of different event types can be listened to. The event
 * types are declared in Isgl3dEventType.h and are TOUCH_EVENT, MOVE_EVENT or RELEASE_EVENT.
 */
@interface Isgl3dEvent3DDispatcher : NSObject {
	    
	NSMutableDictionary * _listeners;  
}

- (id) init;

/**
 * Adds a new event listener to the object (eg Isgl3dMeshNode) for a particular type of event.
 * @param object The object that contains the callback method when the event is triggered.
 * @param method The method in the object that is called when the event is triggered.
 * @param eventType The type of event to react to.
 * @result The new Event3DListener that provides the callback when the event is triggered.
 * 
 */
- (Isgl3dEvent3DListener *) addEvent3DListener:(id)object method:(SEL)method forEventType:(NSString *)eventType;

/**
 * Removes the event listener that corresponds to the callback method on a specific object, for a specific
 * event type.
 * @param object The object that contains the callback method when the event is triggered.
 * @param method The method in the object that is called when the event is triggered.
 * @param eventType The type of event to react to.
 */
- (void) removeEvent3DListenerForObject:(id)object method:(SEL)method forEventType:(NSString *)eventType;

/**
 * Directly removes the Isgl3dEvent3DListener.
 * @param listener The event listener.
 */
- (void) removeEvent3DListener:(Isgl3dEvent3DListener *)listener;

/*
 * Dispatches the event to all concerned listeners.
 * 
 * Note that this is intended for internal use only by iSGL3D and should never be called explicitly.
 * @param touches The set of UITouches.
 * @param eventType The type of event.
 */
- (void) dispatchEvent:(NSSet *)touches forEventType:(NSString *)eventType;


@end
