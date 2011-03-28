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

@class UIEvent;

/**
 * Provides the interface to classes that want to be notified of touch events.
 * 
 * Classes implementing this protocol can be added to the Isgl3dTouchScreen singleton. All touch screen events
 * are forwarded to these classes.
 * 
 * The methods here correspond exactly to those defined in the UIResponder.
 */
@protocol Isgl3dTouchScreenResponder <NSObject>
/**
 * Tells the receiver when one or more fingers touch down in a view or window.
 * @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 * Tells the receiver when one or more fingers associated with an event move within a view or window.
 * @param touches A set of UITouch instances that represent the touches that are moving during the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 * Tells the receiver when one or more fingers are raised from a view or window.
 * @param touches A set of UITouch instances that represent the touches for the ending phase of the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;


/**
 * Sent to the receiver when a system event (such as a low-memory warning) cancels a touch event.
 * @param touches A set of UITouch instances that represent the touches for the ending phase of the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
@optional
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
