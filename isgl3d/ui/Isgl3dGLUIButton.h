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

#import "Isgl3dGLUIComponent.h"

#define BUTTON_PRESS_EVENT 0
#define BUTTON_RELEASE_EVENT 1

@class Isgl3dEvent3DListener;

/**
 * The Isgl3dGLUIButton is added to the Isgl3DGLUI to have a clickable button available for user interaction.
 * 
 * An Isgl3dMaterial is used to render the button itself. 
 * 
 * User touch events can be listened to for BUTTON_PRESS_EVENT and BUTTON_RELEASE_EVENT.
 */
@interface Isgl3dGLUIButton : Isgl3dGLUIComponent {
	
@private
}

/**
 * Allocates and initialises (autorelease) button with a material and a button width and height in pixels.
 * @param material The material to be rendered on the button.
 * @param width The width of the button.
 * @param height The height of the button.
 */
+ (id) buttonWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height;

/**
 * Allocates and initialises (autorelease) button with a material and uses a default width and height (32 x 32 pixels).
 * @param material The material to be rendered on the button.
 */
+ (id) buttonWithMaterial:(Isgl3dMaterial *)material;

/**
 * Initialises the button with a material and a button width and height in pixels.
 * @param material The material to be rendered on the button.
 * @param width The width of the button.
 * @param height The height of the button.
 */
- (id) initWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height;

/**
 * Initialises the button with a material and uses a default width and height (32 x 32 pixels).
 * @param material The material to be rendered on the button.
 */
- (id) initWithMaterial:(Isgl3dMaterial *)material;

/**
 * Creates and adds an user touch event listener to the button.
 * @param eventType The type of event to be listened to: etiehr BUTTON_PRESS_EVENT or BUTTON_RELEASE_EVENT.
 * @param listener The id of the object will be called when the event happens.
 * @param handler The method that will be called when the event happens.
 * @return The Isgl3dEvent3DListener.
 */
- (Isgl3dEvent3DListener *) addEventListener:(unsigned int)eventType listener:(id)listener handler:(SEL)handler;

/**
 * Removes a user touch event listener from the button.
 * @param listener The listener to be removed.
 */
- (void) removeEventListener:(Isgl3dEvent3DListener *)listener;

@end
