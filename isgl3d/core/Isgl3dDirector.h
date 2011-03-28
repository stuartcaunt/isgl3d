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

#import "isgl3dTypes.h"
#import "Isgl3dEAGLView.h"

@class Isgl3dView;
@class Isgl3dGLRenderer;
@class Isgl3dEvent3DHandler;
@class Isgl3dFpsRenderer;

/**
 * The Isgl3dDirector singleton provides the control for the iSGL3D application. All animation, rendering and event handling is handled 
 * by this class.
 * 
 * The Isgl3dDirector requires an Isgl3dEAGLView: this is used to determine the window size and create the OpenGL renderer.
 * 
 * The Isgl3dDirector contains an array of all views (Isgl3dView) to be rendered on the display. Each one is rendered in the
 * order in which they are added to ther Isgl3dDirector. 
 * 
 * Device orientation is set through the Isgl3dDirector. Each Isgl3dView can have its own separate orientation, the resulting orientation
 * being the combination of the two. For example the device can have an orientation of 90¡ clockwise and a view also of 90¡ clockwise: the
 * resulting orientation of the view is 180¡ relative to the default portrait orientation of the device.
 * 
 * The Isgl3dDirector can be set to display the FPS of the application. It also allows for a background color to be set. Individual views
 * can override this by having their own background color set.
 */
@interface Isgl3dDirector : NSObject <Isgl3dTouchDelegate> {

@private
	BOOL _isAnimating;
	BOOL _isPaused;

	BOOL _displayLinkSupported;

	float _animationInterval;
	float _oldAnimationInterval;

	id _displayLink;
	NSTimer * _animationTimer;
	
	isgl3dOrientation _deviceOrientation;
	
	Isgl3dEAGLView * _glView;
	CGRect _windowRect;
	
	NSMutableArray * _views;
	
	Isgl3dGLRenderer * _renderer;
	
	struct timeval _lastFrameTime;
	BOOL _hasSignificationTimeChange;
	float _dt;
	
	float _backgroundColor[4];

	Isgl3dEvent3DHandler * _event3DHandler;
	BOOL _objectTouched;
	
	BOOL _displayFPS;
	Isgl3dFpsRenderer * _fpsRenderer;
}

/**
 * Returns the window size.
 */
@property (nonatomic, readonly) CGSize windowSize;

/**
 * Returns the window rectangle.
 */
@property (nonatomic, readonly) CGRect windowRect;

/**
 * The background color (four float values ,rgba, between 0 and 1) of the main window.
 */
@property (nonatomic) float * backgroundColor;

/**
 * The background color (rgba) specified as a hex string
 */
@property (nonatomic, assign) NSString * backgroundColorString;

/**
 * The orientation of the device.
 * Possible values are:
 * <ul>
 * <li>Isgl3dOrientation0: portrait.</li>
 * <li>Isgl3dOrientation90Clockwise: landscape, device rotated clockwise.</li>
 * <li>Isgl3dOrientation90CounterClockwise: landscape, device rotated counter-clockwise.</li>
 * <li>Isgl3dOrientation180: portrait, upside down.</li>
 * </ul>
 * 
 */
@property (nonatomic) isgl3dOrientation deviceOrientation;

/**
 * The Isgl3dEAGLView with OpenGL-specific contexts.
 */
@property (nonatomic, retain) Isgl3dEAGLView * openGLView;

/**
 * Returns a BOOL value of whether the Isgl3dDirector (and thereby all Isgl3dViews) are paused.
 */
@property (nonatomic, readonly) BOOL isPaused;

/**
 * Indicates whether the FPS should be displayed.
 */
@property (nonatomic) BOOL displayFPS;

/**
 * Returns true if a rendered object has been touched. 
 */
@property (nonatomic, readonly) BOOL objectTouched;

/**
 * Specifies the shadow rendering method to be used.
 * Possible values are:
 * <ul>
 * <li>Isgl3dShadowNone: No shadows to be rendered.</li>
 * <li>Isgl3dShadowPlanar: Planar shadows to be rendered.</li>
 * <li>Isgl3dShadowMaps: Shadow rendering using shadow maps (available only with OpenGL ES 2.0 and is experimental).</li>
 * </ul>
 * 
 * If shadow maps is the chosen shadow rendering method but the device is not OpenGL ES 2.0 capable, then planar shadows are rendered. 
 * By default shadows are not rendered.
 */
@property (nonatomic) isgl3dShadowType shadowRenderingMethod;

/**
 * Specifies the alpha value for the rendered shadows.
 * By default the shadow alpha is 1.
 */
@property (nonatomic) float shadowAlpha;

/**
 * Returns the singleton instance of the Isgl3dDirector.
 * @return The singleton instance of the Isgl3dDirector.
 */
+ (Isgl3dDirector *) sharedInstance;

/**
 * Resets the singleton instance of the Isgl3dDirector. All values return to their defaults.
 */
+ (void) resetInstance;

/**
 * Sets the animation interval in seconds.
 * @param animationInterval The animation interval in seconds. 
 */
- (void) setAnimationInterval:(float)animationInterval;

/**
 * Starts the animation timer.
 * This should be used with caution : the main point of entry to the animation is via "run".
 */
- (void) startAnimation;

/**
 * Stops the animation timer.
 * This should be used with caution : if this is called nothing will be rendered. To continue rendering use "pause".
 */
- (void) stopAnimation;

/**
 * Starts the main loop and animation for the Isgl3dDirector. 
 * This is the main point of entry to run an iSGL3D application.
 */
- (void) run;

/**
 * Stops the animation and resets the Isgl3dDirector. 
 * This should only be used when the application ends. After being called the Isgl3dUIView and all Isgl3dViews need to 
 * be added again to the director.
 */
- (void) end;

/**
 * Pauses the animation.
 */
- (void) pause;

/**
 * Resumes the animation after pause.
 */
- (void) resume;

/**
 * Should be called when the application receives a memory warning.
 */
- (void) onMemoryWarning;

/**
 * Should be called when a significant time elapses between two frames.
 */
- (void) onSignificantTimeChange;

/**
 * Sets the Isgl3dUIView.
 * From the Isgl3dEAGLView the Isgl3dDirector determines the size of the window and creates the renderers.
 * @param glView The Isgl3dEAGLView containing the OpenGL buffers. 
 */
- (void) setOpenGLView:(Isgl3dEAGLView *)glView;

/**
 * Returns the Isgl3dEAGLView currently in use.
 * @return The Isgl3dEAGLView currently in use.
 */
- (Isgl3dEAGLView *)openGLView;

/**
 * Adds an Isgl3dView to the array of views to be rendered. Each view is rendered in the order of addition
 * to the Isgl3dDirector.
 * @param view The Isgl3dView to be added and rendered at each frame. 
 */
- (void) addView:(Isgl3dView *)view;

/**
 * Removes and Isgl3dView from the Isgl3dDirector.
 * @param view The Isgl3dView to be removed. 
 */
- (void) removeView:(Isgl3dView *)view;

/**
 * Returns the pixel colour as a hex string for a specific x and y location on the screen.
 * @param x The x location of the pixel (always assuming the device is in portrait mode)
 * @param y The y location of the pixel (always assuming the device is in portrait mode)
 * @return The hexidecimal value for the pixel colour.
 */
- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y;

@end

