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
#import "Isgl3dGLView.h"

@class Isgl3dView;
@class Isgl3dGLRenderer;
@class Isgl3dEvent3DHandler;
@class Isgl3dFpsRenderer;
@class Isgl3dCamera;
@class Isgl3dGestureManager;
@class Isgl3dNode;
@class Isgl3dCustomShader;


@protocol Isgl3dRenderPhaseCallback
- (void) preRender;
- (void) postRender;
@end

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
 * being the combination of the two. For example the device can have an orientation of 90 degrees clockwise and a view also of 90 degrees clockwise: the
 * resulting orientation of the view is 180 degrees relative to the default portrait orientation of the device.
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
	isgl3dAutoRotationStrategy _autoRotationStrategy;
	isgl3dAllowedAutoRotations _allowedAutoRotations;
	
	UIView<Isgl3dGLView> * _glView;
	CGRect _windowRect;
	CGRect _windowRectInPixels;
	
	NSMutableArray * _views;
	
	// Active camera, used during rendering, represents camera used for each view
	Isgl3dCamera * _activeCamera; 
	
	Isgl3dGLRenderer * _renderer;
	
	struct timeval _lastFrameTime;
	BOOL _hasSignificationTimeChange;
	float _dt;
	
	float _backgroundColor[4];

	Isgl3dEvent3DHandler * _event3DHandler;
	BOOL _objectTouched;
	
	BOOL _displayFPS;
	Isgl3dFpsRenderer * _fpsRenderer;
	
	BOOL _retinaDisplayEnabled;
	float _contentScaleFactor;
    
    BOOL _antiAliasingEnabled;
	
	id<Isgl3dRenderPhaseCallback> _renderPhaseCallback;
	
	Isgl3dGestureManager *_gestureManager;
}

/**
 * Returns the window size in <em>points</em> which are identical on retina and non-retina devices.
 */
@property (nonatomic, readonly) CGSize windowSize;

/**
 * Returns the window size in pixels which can differ between retina and non-retina devices.
 */
@property (nonatomic, readonly) CGSize windowSizeInPixels;

/**
 * Returns the window rectangle in <em>points</em> which are identical on retina and non-retina devices.
 */
@property (nonatomic, readonly) CGRect windowRect;

/**
 * Returns the window rectangle in pixels which can differ between retina and non-retina devices.
 */
@property (nonatomic, readonly) CGRect windowRectInPixels;

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
 * Specifies how iSGL3D should handle auto rotation of the device.
 * Possible values are:
 * <ul>
 * <li>Isgl3dAutoRotationNone: no auto-rotation, keep user-specified value.</li>
 * <li>Isgl3dAutoRotationByIsgl3dDirector: auto-rotation enabled and handled internally.</li>
 * <li>Isgl3dAutoRotationByUIViewController: auto-rotation handled by UIViewController (over-rides all user
 * specified values).</li>
 * </ul>
 * 
 */
@property (nonatomic) isgl3dAutoRotationStrategy autoRotationStrategy;

/**
 * Specifies which orientation types are allowed when auto-rotation is enabled
 * Possible values are:
 * <ul>
 * <li>Isgl3dAllowedAutoRotationsAll: all orientations are allowed.</li>
 * <li>Isgl3dAllowedAutoRotationsPortraitOnly: only portrait orientations are allowed.</li>
 * <li>Isgl3dAllowedAutoRotationsLandscapeOnly: only landscape orientations are allowed.</li>
 * </ul>
 * 
 */
@property (nonatomic) isgl3dAllowedAutoRotations allowedAutoRotations;

/**
 * The Isgl3dEAGLView with OpenGL-specific contexts.
 */
@property (nonatomic, retain) UIView<Isgl3dGLView> * openGLView;

/**
 * Returns the change in time since the last frame.
 */
@property (nonatomic, readonly) float deltaTime;

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
 * Returns the current content scale factor (1 for non-retina displays, 2 for retina displays).
 */
@property (nonatomic, readonly) float contentScaleFactor;

/**
 * Returns true if the retina display is enabled.
 */
@property (nonatomic, readonly) BOOL retinaDisplayEnabled;

/**
 * Returns the currently active camera during the render phase.
 */
@property (nonatomic, readonly) Isgl3dCamera * activeCamera;

/**
 * The render phase callback allows for user operations to occur during the main laop.
 */
@property (nonatomic, assign) id<Isgl3dRenderPhaseCallback> renderPhaseCallback;

/**
 * Returns true if anti-aliasing (MSAA) is supported.
 */
@property (nonatomic, readonly) BOOL antiAliasingAvailable;

/**
 * Indicates whether anti-aliasing (MSAA) should be enabled. Anti-aliasing won't be enabled if it's not available.
 */
@property (nonatomic) BOOL antiAliasingEnabled;


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
 * Called internally when the UIView rendering layer is resized.
 * Note, this should never be called manually. This is called internally by the Isgl3dEAGLView.
 */
- (void) onResizeFromLayer;

/**
 * Sets the Isgl3dUIView.
 * From the Isgl3dEAGLView the Isgl3dDirector determines the size of the window and creates the renderers.
 * @param glView The Isgl3dEAGLView containing the OpenGL buffers. 
 */
- (void) setOpenGLView:(UIView<Isgl3dGLView> *)glView;

/**
 * Returns the Isgl3dEAGLView currently in use.
 * @return The Isgl3dEAGLView currently in use.
 */
- (UIView<Isgl3dGLView> *)openGLView;

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

/**
 * Returns the node for the touch. 
 * @return The node for the touch.
 */
- (Isgl3dNode *)nodeForTouch:(UITouch *)touch;

/**
 * Enables or disables the retina display if the device allows it.
 * @param enabled True if the retina display should be enabled.
 */
- (void) enableRetinaDisplay:(BOOL)enabled;

/**
 * Add a gesture recognizer for the node. The same gesture recognizer may be added for different nodes.
 * @param gestureRecognizer The gesture recognizer to be added. Must not be nil.
 * @param node The node for which the gesture recognizer will handle touches. If node is nil then the gesture recognizer only handles gestures if no node is being touched.
 */
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer forNode:(Isgl3dNode *)node;

/**
 * Removes a gesture recognizer handling touches for the given node.
 * @param gestureRecognizer The gesture recognizer to be removed. Must not be nil.
 * @param node The node for which the gesture recognizer will handle touches.
 */
- (void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer fromNode:(Isgl3dNode *)node;

/**
 * Removes a gesture recognizer from all nodes.
 * @param gestureRecognizer The gesture recognizer to be removed.
 */
- (void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

/**
 * Returns an array of all gesture recognizers attached to the specified node.
 * @result Array of gesture recognizers attached to the node.
 */
- (NSArray *)gestureRecognizersForNode:(Isgl3dNode *)node;

/**
 * Returns the original gesture recognizer delegate for the specified gesture recognizer.
 * To be used after a gesture recognizer has been added to a node.
 * @result The gesture recognizer delegate if the node contains the specified gesture recognizer.
 */
- (id<UIGestureRecognizerDelegate>)gestureRecognizerDelegateFor:(UIGestureRecognizer *)gestureRecognizer;

/**
 * Sets the gesture recognizer delegate for a gesture recognizer of the node.
 * To be used after a gesture recognizer has been added to a node.
 * param aDelegate The gesture recognizer delegate to set.
 * param gestureRecognizer The gesture recognizer of the node for which the delegate should be set.
 */
- (void)setGestureRecognizerDelegate:(id<UIGestureRecognizerDelegate>)aDelegate forGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

/**
 * Registers a custom shader when used by an Isgl3dShaderMaterial.
 * Note, this should never be called manually. This is called internally by the Isgl3dEAGLView.
 */
- (BOOL) registerCustomShader:(Isgl3dCustomShader *)shader;

@end

