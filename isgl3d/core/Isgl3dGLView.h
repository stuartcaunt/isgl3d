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
#import <QuartzCore/QuartzCore.h>

@class Isgl3dGLContext;

/**
 * Taken from the original Apple documentation:
 * "This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
 * The view content is basically an EAGL surface you render your OpenGL scene into.
 * Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel."
 * 
 * This class inherits directly from UIView and is subclassed as Isgl3dView3D. It provides the low-level
 * connection to the iOS window system and is where all rending occurs. 
 * 
 * Isgl3dView3D provides the main area of configuration for user applications and this class is used to redraw
 * the current UIView. An animation timer (such as NSTimer or a CADisplayLink) is needed to perform the 
 * animation: at each frame a call to drawView must be called. For user-specific updates to the scene and 
 * event handling, the updateScene method should be overridden.
 * 
 * @deprecated Will be removed in v1.2
 * This class has been replaced by Isgl3dView, used in conjunction with Isgl3dDirector.
 */ 
@interface Isgl3dGLView : UIView {
	    
@protected
	Isgl3dGLContext * _glContext;
    
}

/**
 * Initialises the OpenGL context.
 */
- (BOOL) initializeContext;

/**
 * Must be called explicity at each frame to step the animation. This is typically called by a timer either 
 * in the inherited view class, or by a UIViewController encapsulating this UIView.
 */
- (void) drawView;

/**
 * Needs to be overloaded if any user events are to be handled and scene modifications to occur. This represents
 * the main loop of the applicaiton.
 */
- (void) updateScene;

/**
 * Returns the aspect ratio of the screen (width / height) in portrait mode.
 * @return The aspect ratio.
 */
- (float) defaultAspectRatio;

@end
