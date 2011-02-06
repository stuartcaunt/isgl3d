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

@class Isgl3dEvent3D;

/**
 * Container class for event callbacks when objects are touched on the screen.
 * 
 * When a request is made to listen to an Isgl3dEvent3DDispatcher, a new Isgl3dEvent3DListener is created.
 * Although this has no practical use during the runtime, it is useful when the listener needs to be
 * removed: simply pass this object to the dispatcher.
 * 
 * Intended principally for internal use by iSGL3D. 
 */
@interface Isgl3dEvent3DListener : NSObject {
	    
@private
	id _object;
	SEL _method;
}

/**
 * Returns the id of the object with the callback method.
 */
@property (readonly) id object;

/**
 * Returns the selector of the callback method. 
 */
@property (readonly) SEL method;

/*
 * Initialises the Isgl3dEvent3DListener with the object and method that are called when the event is triggered.
 * Note that this is intended for internal use only by iSGL3D and should never be called explicitly.
 * 
 * @param object The object with the callback method.
 * @param method The method to be called when the event is triggered.
 */
- (id) initWithObject:(id)object method:(SEL)method;

/*
 * Calls the handler specified by the object and method.
 * Note that this is intended for internal use only by iSGL3D and should never be called explicitly.
 * 
 * @param event the Isgl3dEvent3D.
 */
- (void) handleEvent:(Isgl3dEvent3D *)event;

@end
