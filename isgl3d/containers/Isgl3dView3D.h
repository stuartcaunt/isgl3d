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

#define SHADOW_RENDERING_NONE 0
#define SHADOW_RENDERING_MAPS 1
#define SHADOW_RENDERING_PLANAR 2


#import "Isgl3dGLView.h"
#import "Isgl3dMiniVec.h"

@class Isgl3dGLRenderer;
@class Isgl3dScene3D;
@class Isgl3dCamera;
@class Isgl3dCameraController;
@class Isgl3dEvent3DHandler;
@class Isgl3dGLUI;

/**
 * The Isgl3dView3D class is the principal class in charge or the scene to be rendered and contains the main event
 * loop for an application.
 * 
 * It is intended that this class is extended for all applications using iSGL3D and added to the UIWindow (it inherits
 * from UIView). All drawing in the application occurs through this class.
 * 
 * Three principal are overridden by the developer to initialise, set up and modify the rendered scene:
 * <ul>
 * <li>initView: Initialises the properties of the view such as whether it is in landscape, if transparent objects should be z-sorted
 * and the scene and camera can be initialised here.</li>
 * <li>initScene: Used to construct the initial scene to be rendered.</li>
 * <li>updateScene: Called at every frame, modifications to the scene and user interactions should be handled here.</li>
 * </ul>
 * 
 * To function, the Isgl3dView3D requires an active scene and an active camera. These can be modified dynamically during
 * the runtime of the application.
 * 
 * As well as, or instead of a scene, an Isgl3dGLUI can be added to the view: this provides a simple 2D framework for constructing
 * a user interface. The user interface is always rendered above the 3D scene.
 * 
 * User interactions (touch event handling) is also handled here on a high level: as with all UIViews the touchesBegan, touchesEnded
 * and touchesMoved methods are available. In Isgl3dView3D the events occuring on rendered nodes is handled intially and then delegated to
 * the Isgl3dTouchScreen for user-defined call-backs. It is also possible to override these methods but the super methods must always
 * be called first to ensure correct functionign of iSGL3D.
 */
@interface Isgl3dView3D : Isgl3dGLView {

@private
	Isgl3dGLRenderer * _renderer;

	Isgl3dScene3D * _activeScene;
	Isgl3dCamera * _activeCamera;
	Isgl3dEvent3DHandler * _event3DHandler;

	BOOL _isLandscape;
	BOOL _zSortingEnabled;
	BOOL _occultationTestingEnabled;
	float _occultationTestingAngle;
	
	BOOL _skipUpdates;
	
	Isgl3dGLUI * _activeUI;
	BOOL _uiEventsOnly;
	BOOL _objectTouched;
	
	unsigned int _width;
	unsigned int _height;
	
	Isgl3dMiniVec3D _eyeNormal;
	Isgl3dMiniVec3D _cameraPosition;
}

/**
 * The active scene to be rendered. Only one scene at a time can be rendered but it can be changed dynamically at runtime.
 */
@property (nonatomic, retain) Isgl3dScene3D * activeScene;

/**
 * The active camera to view the scene from. The camera can be changed at runtime.
 */
@property (nonatomic, retain) Isgl3dCamera * activeCamera;

/**
 * The active ui in the view.  The ui can be changed at runtime.
 */
@property (nonatomic, retain) Isgl3dGLUI * activeUI;

/**
 * Inidicates whether the view is to be in landscape or portrait mode (depending on how the device is intended to be oriented).
 * By default the device is assumed to be in portrait mode.
 */
@property (nonatomic) BOOL isLandscape;

/**
 * Indicates whether z-sorting should be enabled for transparent objects. This resolves some z-buffer rendering problems but is 
 * slower than a non-sorted render.
 * By default zsorting is not enabled.
 */
@property (nonatomic) BOOL zSortingEnabled;

/**
 * Indicates whether occultation testing is enabled. A target is specified in the camera (as the "look-at" position): nodes
 * that are between the camera and the target will become transparent. The amount of transparency can be modified by changing
 * the occultation mode in Isgl3dNode.
 * By default occultation testing is not enabled.
 */
@property (nonatomic) BOOL occultationTestingEnabled;

/**
 * Specifies the maximum angle (between the camera-target vector and the camera-node vector) for which nodes become transparent.
 * By default the angle is 20 degrees.
 */
@property (nonatomic) float occultationTestingAngle;

/**
 * Specifies the shadow rendering method to be used.
 * Possible values are:
 * <ul>
 * <li>SHADOW_RENDERING_NONE: No shadows to be rendered.</li>
 * <li>SHADOW_RENDERING_MAPS: Shadow rendering using shadow maps (available only with OpenGL ES 2.0 and is experimental).</li>
 * <li>SHADOW_RENDERING_PLANAR: Planar shadows to be rendered.</li>
 * </ul>
 * 
 * If shadow maps is the chosen shadow rendering method but the device is not OpenGL ES 2.0 capable, then planar shadows are rendered. 
 * By default shadows are not rendered.
 */
@property (nonatomic) unsigned int shadowRenderingMethod;

/**
 * Specifies the alpha value for the rendered shadows.
 * By default the shadow alpha is 1.
 */
@property (nonatomic) float shadowAlpha;

/**
 * Indicates that on the user interface should react to user touch events. This can improve the rendering speed if other 
 * nodes have been specified as being interactive (with uiEventsOnly however they will no longer be interactive).
 * By default events not only from the user interface are handled.
 */
@property (nonatomic) BOOL uiEventsOnly;

/**
 * Returns true if a rendered object has been touched. 
 */
@property (readonly) BOOL objectTouched;

/**
 * Returns the width of the view in pixels.
 */
@property (readonly) unsigned int width;

/**
 * Returns the height of the view in pixels.
 */
@property (readonly) unsigned int height;

/**
 * Initialises the Isgl3dView3D object and OpenGL context.
 */
- (BOOL) initializeContext;

/**
 * Method that needs to be implemented in extended classes to initialise the Isgl3dView3D properties.
 */
- (void) initView;

/**
 * Method that nees to be implemented in extended classes to initialise the scene.
 */
- (void) initScene;

/**
 * Method that needs to be implemented in extended classes to update the scene and handle user events.
 * This method is called every frame.
 */
- (void) updateScene;

/**
 * Sets the camera that is active for the view.
 * @param camera The camera that will be used as the observer's view point.
 */
- (void) setActiveCamera:(Isgl3dCamera *)camera;

/**
 * Sets the active user interface to be displayed.
 * @param ui The user interface to be displayed.
 */
- (void) setActiveUI:(Isgl3dGLUI *)ui;

/**
 * Sets the ambient scene lighting colour in hexidecimal format.
 * In a lit scene, all nodes will have this as their ambient light source.
 * @param ambient The hexidecimal value for the ambient scene light.
 */
- (void) setSceneAmbient:(NSString *)ambient;

/**
 * Specifies whether or not transparent nodes should be z-sorted before rendering. 
 * By default no z-sorting occurs. Using z-sorting can reduce the performance of the application.
 * @param isZSortingEnabled Boolean value to indicate whether z-sorting should be enabled.
 */
- (void) setZSortingEnabled:(BOOL)isZSortingEnabled;

/**
 * Sets occultation testing to true and the maximum angle for which it occurs.
 * @param angle The maximum angle (between the camera-target vector and the camera-node vector) for which nodes become transparent.
 */
- (void) setOccultationTestingEnabledWithAngle:(float)angle;

/**
 * Prepares the view for rendering (initialising and clearing OpenGL buffers for example) and sets the background colour.
 * This method must be called once (typically in initView) to initialise OpenGL.
 * @param clearColor A four-value float array (RGBA) for the background colour. 
 */
- (void) prepareView:(float *)clearColor;

/**
 * Returns the pixel colour as a hex string for a specific x and y location on the screen.
 * @param x The x location of the pixel (always assuming the device is in portrait mode)
 * @param y The y location of the pixel (always assuming the device is in portrait mode)
 * @return The hexidecimal value for the pixel colour.
 */
- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y;

/**
 * Resets the Isgl3dView3D and also all iSGL3D components to their default state. 
 * The active scene and active camera are removed and elsewhere Tweens are stopped and cleared
 * and objects reacting to the touch screen (implementing the Isgl3dTouchScreenResponder) need to be 
 * added to the Isgl3dTouchScreen again.
 */
- (void) reset;

/**
 * Called to stop updateScene being called in the following cycle.
 * After the next cycle, updateScene will continue to be called.
 */
- (void) skipUpdates;

/*
 * Renders the scene.
 * 
 * Note that this is called internally in iSGL3D and should never be called explicitly.
 */
- (void) render;

/*
 * Renders the scene during the event capturing process.
 * 
 * Note that this is called internally in iSGL3D and should never be called explicitly.
 */
- (void) renderForEventCapture;


/**
 * Called automatically during each cycle to indicate that new touches have occured.
 * If this method is overridden in the extended class, the super method must be called to ensure correct functionality of iSGL3D.
 * @param touches The set of touches that started in this cycle.
 * @param event The UIEvent that occured.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 * Called automatically during each cycle to indicate that touches have ended.
 * If this method is overridden in the extended class, the super method must be called to ensure correct functionality of iSGL3D.
 * @param touches The set of touches that ended in this cycle.
 * @param event The UIEvent that occured.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 * Called automatically during each cycle to indicate that touches have moved.
 * If this method is overridden in the extended class, the super method must be called to ensure correct functionality of iSGL3D.
 * @param touches The set of touches that moved in this cycle.
 * @param event The UIEvent that occured.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;


@end
