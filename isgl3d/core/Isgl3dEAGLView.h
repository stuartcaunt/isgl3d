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

#import <UIKit/UIKit.h>
#import "Isgl3dGLView.h"

@class Isgl3dGLContext;
@class Isgl3dGLRenderer;


/**
 * The Isgl3dEAGLView provides the main interface between the device (and Cocoa) and iSGL3D. It inherits from UIView and
 * is added to the UIKit window (normally via a UIViewController).
 * 
 * Depending on the device capabilities and the developer choices, an "OpenGL context" is created either for OpenGL ES 1.1
 * or OpenGL ES 2.0. These provide the frame buffers and render buffers on which the rendering is performed.
 * 
 * Taken from the original Apple documentation:
 * "This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
 * The view content is basically an EAGL surface you render your OpenGL scene into.
 * Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel."
 * 
 * The use of the protocol Isgl3dGLView allows for potentially any UIView to be used with the Isgl3dDirector, for example
 * other OpenGL-based frameworks.
 * 
 */ 
@interface Isgl3dEAGLView : UIView <Isgl3dGLView> {
	
@protected
	CGSize _size;
	Isgl3dGLContext * _glContext;
    id<Isgl3dTouchDelegate> _touchDelegate;
}

/**
 * Allocates, initialises and returns an autoreleased Isgl3dEAGLView with a given frame.
 * The OpenGL vesion is determined by the capabilities of the device: the latest version is chosen.
 */
+ (id) viewWithFrame:(CGRect)frame;

/**
 * Allocates, initialises and returns an autoreleased Isgl3dEAGLView with a given frame.
 * The OpenGL vesion is set in isgl3d.plist.
 */
+ (id) viewWithFrameFromPlist:(CGRect)frame;

/**
 * Allocates, initialises and returns an autoreleased Isgl3dEAGLView with a given frame.
 * The OpenGL vesion is set to OpenGL ES 1.1.
 */
+ (id) viewWithFrameForES1:(CGRect)frame;

/**
 * Allocates, initialises and returns an autoreleased Isgl3dEAGLView with a given frame.
 * The OpenGL vesion is set to OpenGL ES 2.0.
 */
+ (id) viewWithFrameForES2:(CGRect)frame;

/**
 * Initialises an Isgl3dEAGLView with a given frame.
 * The OpenGL vesion is determined by the capabilities of the device: the latest version is chosen.
 */
- (id) initWithFrame:(CGRect)frame;

/**
 * Initialises an Isgl3dEAGLView with a given frame.
 * The OpenGL vesion is set in isgl3d.plist.
 */
- (id) initWithFrameFromPlist:(CGRect)frame;

/**
 * Initialises an Isgl3dEAGLView with a given frame.
 * The OpenGL vesion is set to OpenGL ES 1.1.
 */
- (id) initWithFrameForES1:(CGRect)frame;

/**
 * Initialises an Isgl3dEAGLView with a given frame.
 * The OpenGL vesion is set to OpenGL ES 2.0.
 */
- (id) initWithFrameForES2:(CGRect)frame;

/**
 * Initialises an Isgl3dEAGLView with a code. This is used when created with interface builder which is not the expected usage.
 * The OpenGL vesion is set in isgl3d.plist.
 */
- (id) initWithCoder:(NSCoder*)coder; 

/**
 * Allocates, initialises and returns an autoreleased Isgl3dGLRenderer for either OpenGL 1.1 or 2.0.
 * This is used by the Isgl3dDirector to obtain an OpenGL renderer.
 * @returns the Isgl3dGLRenderer.
 */
- (Isgl3dGLRenderer *)createRenderer;

/**
 * Used to finalize the rendering in OpenGL. 
 * This should never be called manually.
 */
- (void) finalizeRender;

/**
 * Returns the pixel colour as a hex string for a specific x and y location on the screen.
 * @param x The x location of the pixel (always assuming the device is in portrait mode)
 * @param y The y location of the pixel (always assuming the device is in portrait mode)
 * @return The hexidecimal value for the pixel colour.
 */
- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y;

@end



