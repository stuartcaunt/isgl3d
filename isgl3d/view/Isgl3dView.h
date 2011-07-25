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
#import "Isgl3dVector.h"
#import "Isgl3dMatrix.h"

@class Isgl3dScene3D;
@class Isgl3dCamera;
@class Isgl3dGLRenderer;

/**
 * The Isgl3dView provides the main mechanism for rendering a "view". A view is composed of a single Isgl3dScene3d scene and
 * a single Isgl3dCamera camera. The view provides the viewport by which the scene is viewed by the camera.
 * 
 * An Isgl3dView has a specified viewport (a rectangle within the main window). By default a viewport rectangle is the
 * same as the window rectangle. A viewport rectangle is ALWAYS specified as coordinates relative to a device in portrait
 * orientation, with (0, 0) at the bottom left of the screen.
 * 
 * An iSGL3D application can be composed of a number of views. These views can either be rendered in different parts of the 
 * window or can be over-layed as layers (this being the case, for example, when creating a 2D user interface above a 3D
 * scene).
 * 
 * An Isgl3dView is by default opaque: this means that anything rendered behind it is erased. A view can be made transparent
 * by setting isOpaque to false. Opaque Isgl3dViews can be rendered with a specified background color.
 * 
 * Isgl3dViews have independent orientations. As well as the device orientation (specified in Isgl3dDirector) a view can be
 * further rotated by specifying the viewOrientation. By default the view is rendered in the same orientation as the device.
 * When an orientation is specified, the rendered scene orientation is the combination of both device and view orientations.
 * The orientation of the Isgl3dView has no effect on the coordinates specified in the viewport: these are always relative
 * to the device in portrait mode.
 * 
 * Isgl3dViews need to be added to the Isgl3dDirector to be rendered. Each view is rendered in the order by which it is added
 * to the Isgl3dDirector. An Isgl3dView will not be rendered if it doesn't have both a scene and a camera.
 * 
 */
@interface Isgl3dView : NSObject {

@private
	isgl3dOrientation _viewOrientation;
	isgl3dOrientation _deviceViewOrientation;

	Isgl3dScene3D * _scene;
	Isgl3dCamera * _camera;

	BOOL _isRunning;

	BOOL _zSortingEnabled;

	BOOL _occlusionTestingEnabled;
	float _occlusionTestingAngle;
	Isgl3dVector3 _eyeNormal;
	Isgl3dVector3 _cameraPosition;
	
	CGRect _viewport;
	CGRect _viewportInPixels;
	BOOL _isOpaque;
	float _backgroundColor[4];
	
	BOOL _isEventCaptureEnabled;
	
	NSString * _sceneAmbient;
	
	BOOL _cameraUpdateOnly;
	
	BOOL _autoResizeViewport;
}

/**
 * The scene to be rendered. Only one scene at a time can be rendered but it can be changed dynamically at runtime.
 */
@property (nonatomic, retain) Isgl3dScene3D * scene;

/**
 * The camera to view the scene from. The camera can be changed at runtime.
 */
@property (nonatomic, retain) Isgl3dCamera * camera;

/**
 * Indicates whether z-sorting should be enabled for transparent objects. This resolves some z-buffer rendering problems but is 
 * slower than a non-sorted render.
 * By default zsorting is not enabled.
 */
@property (nonatomic) BOOL zSortingEnabled;

/**
 * Indicates whether occlusion testing is enabled. A target is specified in the camera (as the "look-at" position): nodes
 * that are between the camera and the target will become transparent. The amount of transparency can be modified by changing
 * the occlusion mode in Isgl3dNode.
 * By default occlusion testing is not enabled.
 */
@property (nonatomic) BOOL occlusionTestingEnabled;

/**
 * Specifies the maximum angle (between the camera-target vector and the camera-node vector) for which nodes become transparent.
 * By default the angle is 20 degrees.
 */
@property (nonatomic) float occlusionTestingAngle;

/**
 * The viewport (rectangle on the screen) in which the scene is rendered. The coordinates of the viewport are always relative
 * to the device in portrait mode with (0, 0) at the bottom left of the screen. Modifying device or view orientations has
 * no effect on these coordinates.
 * 
 * Note that this sets the viewport in <em>points</em> which are identical on retina and non-retina devices. The viewport
 * rectangle in pixels is scaled by the Isgl3dDirector contentScaleFactor.
 */
@property (nonatomic) CGRect viewport;

/**
 * The viewport (rectangle on the screen) in which the scene is rendered. The coordinates of the viewport are always relative
 * to the device in portrait mode with (0, 0) at the bottom left of the screen. Modifying device or view orientations has
 * no effect on these coordinates.
 * 
 * Note that this sets the viewport in pixels which differs between retina and non-retina display devices. Using the <code>viewport</code> 
 * property will ensure identical results on both types of devices.
 */
@property (nonatomic) CGRect viewportInPixels;

/**
 * The orientation of the view.
 * Possible values are:
 * <ul>
 * <li>Isgl3dOrientation0: portrait.</li>
 * <li>Isgl3dOrientation90Clockwise: landscape, device rotated clockwise.</li>
 * <li>Isgl3dOrientation90CounterClockwise: landscape, device rotated counter-clockwise.</li>
 * <li>Isgl3dOrientation180: portrait, upside down.</li>
 * </ul>
 * 
 * The rendered scene will have an orientation being the combination of this orientation with the Isgl3dDirector device orientation.
 */
@property (nonatomic) isgl3dOrientation viewOrientation;

/**
 * Returns the combined view and device orientations.
 */
@property (nonatomic, readonly) isgl3dOrientation deviceViewOrientation;

/**
 * Specifies whether the view is opaque or not. By default it is opaque meaning than anything rendered behind will be erased.
 */
@property (nonatomic) BOOL isOpaque;

/**
 * The background color (four float values ,rgba, between 0 and 1) of the view.
 */
@property (nonatomic) float * backgroundColor;

/**
 * The background color (rgba) of the view specified as a hex string.
 */
@property (nonatomic, assign) NSString * backgroundColorString;

/**
 * Indicates whether the view is interactive or not for 3D events. By default the view is enabled to capture 3D
 * events.
 */
@property (nonatomic) BOOL isEventCaptureEnabled;

/**
 * Specifies the ambient scene lighting colour in hexidecimal format.
 * In a lit scene, all nodes will have this as their ambient light source.
 */
@property (nonatomic, retain) NSString * sceneAmbient;

/**
 * Specifies whether all the scene objects (nodes) are to be updated at each frame or just the camera. By default
 * all objects are updated. This is useful as a means of pausing a scene but allowing the user to move the camera
 * to look around with all other objects frozen.
 */
@property (nonatomic) BOOL cameraUpdateOnly;


/**
 * Allocates, initialises and returns an autoreleased Isgl3dView.
 */
+ (id) view;

/**
 * Initialises an Isgl3dView.
 */
- (id) init;

/**
 * Sets occlusion testing to true and the maximum angle for which it occurs.
 * @param angle The maximum angle (between the camera-target vector and the camera-node vector) for which nodes become transparent.
 */
- (void) setOcclusionTestingEnabledWithAngle:(float)angle;

/**
 * Activates the Isgl3dView.
 * Note, this should never be called manually. This is called by the Isgl3dDirector when the view is added to it. Any code that needs to
 * be handled when the view is activated should be added in "onActivated".
 */
- (void) activate;

/**
 * Deactivates the Isgl3dView.
 * Note, this should never be called manually. This is called by the Isgl3dDirector when the view is removed from it. Any code that needs to
 * be handled when the view is deactivated should be added in "onDeactivated".
 */
- (void) deactivate;

/**
 * Called by "activate": any code that needs to be called when a view is activated should be implemented here in sub-classes.
 */
- (void) onActivated;

/**
 * Called by "deactivate": any code that needs to be called when a view is deactivated should be implemented here in sub-classes.
 */
- (void) onDeactivated;

/**
 * Adds a specified selector method to the Isgl3dScheduler. 
 * The selector is called at every frame allowing for scene updates to be coded.
 */
- (void) schedule:(SEL)selector;

/**
 * Unschedules the selector (specified in "schedule:") in the Isgl3dScheduler.
 */
- (void) unschedule;

/**
 * Updates all model matrices in the scene.
 * Note this should never be called manually. This is called by the Isgl3dDirector at each frame during the render process.
 */
- (void) updateModelMatrices;

/**
 * Renders the scene as viewed by the camera through the specified viewport.
 * Note this should never be called manually. This is called by the Isgl3dDirector at each frame during the render process.
 */
- (void) render:(Isgl3dGLRenderer *)renderer;

/**
 * Renders the scene as viewed by the shadow casting light to produce a shadow map. This is only available when 
 * OpenGL ES 2.0 is used.
 * Warning: this is experimental.
 * Note this should never be called manually. This is called by the Isgl3dDirector at each frame during the render process.
 */
- (void) renderForShadowMaps:(Isgl3dGLRenderer *)renderer;

/**
 * Renders the scene as viewed by the camera through the specified viewport to produce data used in the 3D event capturing.
 * Note this should never be called manually. This is called by the Isgl3dDirector at each frame during the render process.
 */
- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer;

/**
 * Converts a window point relative to the UIKit user interface to a point in the local coordinate system of the viewport.
 * This can be used when handling touch events to determine the position in the Isgl3dView. The viewport coordinate
 * system has (0, 0) at the bottom left, taking into account the orientation of the device and the Isgl3dView.
 * 
 * Note that this returns a CGPoint containing the <em>point</em> position in the view which is identical for
 * retina and non-retina enabled devices.
 * 
 * @param uiPoint A CGPoint relative to the main window. Note that (0, 0) is top left
 * @return A CGPoint relative to the viewport with (0, 0) at the bottom left.
 */
- (CGPoint) convertUIPointToView:(CGPoint)uiPoint;

/**
 * Converts a window point relative to the UIKit user interface to a point in the local coordinate system of the viewport.
 * This can be used when handling touch events to determine the position in the Isgl3dView. The viewport coordinate
 * system has (0, 0) at the bottom left, taking into account the orientation of the device and the Isgl3dView.
 * 
 * Note that this returns a CGPoint containing the pixel position in the view which is differs for
 * retina and non-retina enabled devices.
 * 
 * @param uiPoint A CGPoint relative to the main window. Note that (0, 0) is top left
 * @return A CGPoint relative to the viewport with (0, 0) at the bottom left in pixels.
 */
- (CGPoint) convertUIPointToViewInPixels:(CGPoint)uiPoint;

/**
 * Returns true if a window point relative to the UIKit user interface is inside the viewport of the Isgl3dView.
 * @param uiPoint A CGPoint relative to the main window. Note that (0, 0) is top left
 * @return true if the point is inside the Isgl3dView viewport.
 */
- (BOOL) isUIPointInView:(CGPoint)uiPoint;

/**
 * Converts a 3D world position to a 2D position in the viewport equivalent to where the position is rendered
 * in it. The viewport coordinate system has (0, 0) at the bottom left, taking into account device and
 * viewport rotations.
 * 
 * Note that this returns a CGPoint containing the <em>point</em> position in the view which is identical for
 * retina and non-retina enabled devices.
 * 
 * @param worldPosition an Isgl3dVector3 containing the 3D world position to be translated to 2D viewport point.
 * @return A CGPoint relative to the viewport with (0, 0) at the bottom left.
 */
- (CGPoint) convertWorldPositionToView:(Isgl3dVector3)worldPosition;
- (CGPoint) convertWorldPositionToView:(Isgl3dVector3)worldPosition orientation:(isgl3dOrientation)orientation;

/**
 * Converts a 3D world position to a 2D position in the viewport equivalent to where the position is rendered
 * in it. The viewport coordinate system has (0, 0) at the bottom left, taking into account device and
 * viewport rotations.
 * 
 * Note that this returns a CGPoint containing the pixel position in the view which differs for
 * retina and non-retina enabled devices.
 * 
 * @param worldPosition an Isgl3dVector3 containing the 3D world position to be translated to 2D viewport point.
 * @return A CGPoint relative to the viewport with (0, 0) at the bottom left in pixels.
 */
- (CGPoint) convertWorldPositionToViewInPixels:(Isgl3dVector3)worldPosition;
- (CGPoint) convertWorldPositionToViewInPixels:(Isgl3dVector3)worldPosition orientation:(isgl3dOrientation)orientation;

/**
 * Resizes the viewport automatically if it is using the same rectangle as the main window, otherwise does nothing.
 * Note this should never be called manually. This is called by the Isgl3dDirector during a window resize operation.
 */
- (void) onResizeFromLayer;

@end


#pragma mark Isgl3dBasic3DView

/**
 * The Isgl3dBasic3DView is a utility class, inheriting from Isgl3dView, that will allocate and initialise a scene and camera with perspective projection.
 * Both scene and camera can be modified if needed. When modifying the viewport, the camera projection matrix is automatically ajusted.
 */
@interface Isgl3dBasic3DView : Isgl3dView {
}
@end

#pragma mark Isgl3dBasic2DView

/**
 * The Isgl3dBasic2DView is a utility class, inheriting from Isgl3dView, that will allocate and initialise a scene and camera with ortho projection.
 * This can be used, for example, when creating a user interface (or HUD) for the iSGL3D application.
 * Both scene and camera can be modified if needed. When modifying the viewport, the camera projection matrix is automatically ajusted.
 */
@interface Isgl3dBasic2DView : Isgl3dView
@end
