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

#import "Isgl3dView.h"
#import "Isgl3dScene3D.h"
#import "Isgl3dNode.h"
#import "Isgl3dCamera.h"
#import "Isgl3dDirector.h"
#import "Isgl3dScheduler.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dLog.h"
#import "Isgl3dColorUtil.h"

@interface Isgl3dView ()
- (void) clearBuffers:(Isgl3dGLRenderer *)renderer;
- (void) renderForShadowMaps:(Isgl3dGLRenderer *)renderer;
- (void) renderPlanarShadows:(Isgl3dGLRenderer *)renderer;
@end

@implementation Isgl3dView

@synthesize scene = _scene;
@synthesize camera = _camera;
@synthesize zSortingEnabled = _zSortingEnabled;
@synthesize occlusionTestingEnabled = _occlusionTestingEnabled;
@synthesize occlusionTestingAngle = _occlusionTestingAngle;
@synthesize viewport = _viewport;
@synthesize deviceViewOrientation = _deviceViewOrientation;
@synthesize isOpaque = _isOpaque;
@synthesize isEventCaptureEnabled = _isEventCaptureEnabled;
@synthesize sceneAmbient = _sceneAmbient;
@synthesize cameraUpdateOnly = _cameraUpdateOnly;

+ (id) view {
	return [[[self alloc] init] autorelease];
}

- (id) init {
	
	if ((self = [super init])) {
	 	
		_isRunning = NO;
		_zSortingEnabled = NO;
		
		_viewOrientation = Isgl3dOrientation0;
		_deviceViewOrientation = [Isgl3dDirector sharedInstance].deviceOrientation;
		
		// Get default viewport size from Isgl3dDirector (UIView window size)
		CGSize windowSize = [Isgl3dDirector sharedInstance].windowSize;
		_viewport = CGRectMake(0, 0, windowSize.width, windowSize.height);
			
		_isOpaque = NO;
		
		self.backgroundColorString = [Isgl3dDirector sharedInstance].backgroundColorString;

		_isEventCaptureEnabled = YES;
		
		_sceneAmbient = @"333333ff";		
	}
    
	return self;
}

- (void) dealloc {
	[_camera release];
	[_scene release];

	// Make sure we're not receiving any more updates
	[[Isgl3dScheduler sharedInstance] unschedule:self];

	[super dealloc];
}

// Properties

- (isgl3dOrientation) viewOrientation {
	return _viewOrientation;
}

- (void) setViewOrientation:(isgl3dOrientation)orientation {
	_viewOrientation = orientation;
	_deviceViewOrientation = ([Isgl3dDirector sharedInstance].deviceOrientation - _viewOrientation) % 4;
	
	// Update camera orientation
	if (_camera) {
		[_camera setOrientation:_deviceViewOrientation];
	}
}

- (float *) backgroundColor {
	return _backgroundColor;
}

- (void) setBackgroundColor:(float *)color {
	memcpy(_backgroundColor, color, sizeof(float) * 4);
}

- (NSString *) backgroundColorString {
	return [Isgl3dColorUtil rgbaString:_backgroundColor];
}

- (void) setBackgroundColorString:(NSString *)colorString {
	[Isgl3dColorUtil hexColorStringToFloatArray:colorString floatArray:_backgroundColor];
}

- (CGRect) viewport {
	return _viewport;
}

- (void) setViewport:(CGRect)viewport {
	_viewport = viewport;
	if (_camera) {
		[_camera setWidth:viewport.size.width andHeight:viewport.size.height];
	}
}

// Methods

- (void) setOcclusionTestingEnabledWithAngle:(float)angle {
	_occlusionTestingEnabled = YES;
	_occlusionTestingAngle = angle;
}

- (void) activate {
	_isRunning = YES;
	[[Isgl3dScheduler sharedInstance] resume:self];
	
	[self onActivated];
}

- (void) deactivate {
	_isRunning = NO;
	[[Isgl3dScheduler sharedInstance] pause:self];

	[self onDeactivated];
}

- (void) onActivated {
	// To be implemented in sub-classes
}

- (void) onDeactivated {
	// To be implemented in sub-classes
}

- (void) schedule:(SEL)selector {
	[[Isgl3dScheduler sharedInstance] schedule:self selector:selector isPaused:!_isRunning];
}

- (void) unschedule {
	[[Isgl3dScheduler sharedInstance] unschedule:self];
}


- (void) updateModelMatrices {
	// update model matrices
	if (_cameraUpdateOnly) {
		// Update only camera
		[_camera updateGlobalTransformation:nil];
	
	} else {
		// Update full scene
		[_scene updateGlobalTransformation:nil];
	}
}

- (void) clearBuffers:(Isgl3dGLRenderer *)renderer {
	if (_isOpaque) {
		// Clear color buffer with background color
		[renderer clear:(ISGL3D_COLOR_BUFFER_BIT | ISGL3D_DEPTH_BUFFER_BIT | ISGL3D_STENCIL_BUFFER_BIT) color:_backgroundColor viewport:_viewport];
		
	} else {
		// Don't clear color buffer, only depth and stencil
		[renderer clear:(ISGL3D_DEPTH_BUFFER_BIT | ISGL3D_STENCIL_BUFFER_BIT) viewport:_viewport];
	}
}

- (void) render:(Isgl3dGLRenderer *)renderer {
	
	if (_scene && _camera) {

		// Render to create a shadow map (if needed)
		[self renderForShadowMaps:renderer];
	
		// Clear renderer buffers
		[self clearBuffers:renderer];

		// Cleanup from last render
		[renderer clean];
	
		// Set camera characteristics
		[renderer setProjectionMatrix:[_camera projectionMatrix]];
		[renderer setViewMatrix:[_camera viewMatrix]];
			
		// Render any lights in the scene
		[_scene renderLights:renderer];
		
		// Set scene ambient color
		[renderer setSceneAmbient:_sceneAmbient];

		// handle occlusion testing		
		if (_occlusionTestingEnabled) {
			[_camera getEyeNormal:&_eyeNormal];
			float distance = mv3DLength(&_eyeNormal);
			mv3DNormalize(&_eyeNormal);
			[_camera positionAsMiniVec3D:&_cameraPosition];

			[_scene occlusionTest:&_cameraPosition normal:&_eyeNormal targetDistance:distance maxAngle:_occlusionTestingAngle];
		}

		// Render opaque objects
		[_scene render:renderer opaque:true];
	
		// First planar shadow pass (if needed)
		[self renderPlanarShadows:renderer];
	
		// Render transparent objects
		if (_zSortingEnabled) {
			[_scene renderZSortedAlphaObjects:renderer viewMatrix:[_camera viewMatrix]];
			
		} else {
			[_scene render:renderer opaque:false];
		}
		
		// Second planar shadow pass (if needed) (why ?)
//		[self renderPlanarShadows:renderer];
	}
	
}

- (void) renderForShadowMaps:(Isgl3dGLRenderer *)renderer {
	if (renderer.shadowRenderingMethod == Isgl3dShadowMaps) {
		[_scene createShadowMaps:renderer forScene:_scene];
	}
}

- (void) renderPlanarShadows:(Isgl3dGLRenderer *)renderer {
	if (renderer.shadowRenderingMethod == Isgl3dShadowPlanar) {
		
		// Initialise renderer for shadow projection
		[renderer initRenderForPlanarShadows];

		// Render the scene passing relevant info to create projection matrix for each mesh
		[_scene createPlanarShadows:renderer forScene:_scene];

		// Cleanup renderer after shadow projection
		[renderer finishRenderForPlanarShadows];
	}
}

- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer {
	if (_isEventCaptureEnabled && _scene && _camera) {
	
		// Clear the depth buffer	
		[renderer clear:ISGL3D_DEPTH_BUFFER_BIT viewport:_viewport];
		
		// Set camera characteristics
		[renderer setProjectionMatrix:[_camera projectionMatrix]];
		[renderer setViewMatrix:[_camera viewMatrix]];
		
		// Render the scene for event capture
		[_scene renderForEventCapture:renderer];
	}
}

- (CGPoint) convertUIPointToView:(CGPoint)uiPoint {
	// Invert y coordinate (viewport in GL coordinates: origin at bottom left)
	CGSize windowSize = [Isgl3dDirector sharedInstance].windowSize;
	uiPoint.y = windowSize.height - uiPoint.y;
	
	CGPoint viewportOrigin = _viewport.origin;
	CGSize viewportSize = _viewport.size;
	
	// Convert relative to viewport
	uiPoint.x -= viewportOrigin.x;
	uiPoint.y -= viewportOrigin.y;

	CGPoint viewPoint = CGPointZero;
	
	switch (_deviceViewOrientation) {
		case Isgl3dOrientation0:
			viewPoint = uiPoint;
			break;

		case Isgl3dOrientation180:
			viewPoint.x = viewportSize.width - uiPoint.x;
			viewPoint.y = viewportSize.height - uiPoint.y;
			break;

		case Isgl3dOrientation90Clockwise:
			viewPoint.x = uiPoint.y;
			viewPoint.y = viewportSize.width - uiPoint.x;
			break;

		case Isgl3dOrientation90CounterClockwise:
			viewPoint.x = viewportSize.height - uiPoint.y;
			viewPoint.y = uiPoint.x;
			break;
	}
	
	return viewPoint;
}

- (BOOL) isUIPointInView:(CGPoint)uiPoint {
	// Invert y coordinate (viewport in GL coordinates: origin at bottom left)
	CGSize windowSize = [Isgl3dDirector sharedInstance].windowSize;
	uiPoint.y = windowSize.height - uiPoint.y;

	CGPoint viewportOrigin = _viewport.origin;
	CGSize viewportSize = _viewport.size;

	if (uiPoint.x < viewportOrigin.x || uiPoint.y < viewportOrigin.y || uiPoint.x > viewportOrigin.x + viewportSize.width || uiPoint.y > viewportOrigin.y + viewportSize.height) {
		return NO;
	}
	return YES;
}

@end

#pragma mark Isgl3dBasic3DView

@implementation Isgl3dBasic3DView

- (id) init {

	if ((self = [super init])) {
		self.scene = [[[Isgl3dScene3D alloc] init] autorelease];
		Isgl3dLog(Info, @"Isgl3dBasic3DView : creating default scene.");
		
		CGSize viewSize = self.viewport.size;
		self.camera = [[[Isgl3dCamera alloc] initWithWidth:viewSize.width andHeight:viewSize.height] autorelease];
		[self.camera setPerspectiveProjection:45 near:1 far:10000 orientation:self.deviceViewOrientation];
		Isgl3dLog(Info, @"Isgl3dBasic3DView : creating default camera with perspective projection. Viewport size = %@", NSStringFromCGSize(viewSize));

		[self.scene addChild:self.camera];
	}
	
    return self;
}

- (void) setViewport:(CGRect)viewport {
	[super setViewport:viewport];

	if (self.camera) {
		[self.camera setPerspectiveProjection:self.camera.fov near:self.camera.near far:self.camera.far orientation:self.deviceViewOrientation];
		Isgl3dLog(Info, @"Isgl3dBasic3DView : setting camera with perspective projection. Viewport size = %@", NSStringFromCGSize(viewport.size));
	}
}

@end

#pragma mark Isgl3dBasic2DView

@implementation Isgl3dBasic2DView

- (id) init {

	if ((self = [super init])) {
		self.scene = [[[Isgl3dScene3D alloc] init] autorelease];
		Isgl3dLog(Info, @"Isgl3dBasic2DView : creating default scene.");

		CGSize viewSize = self.viewport.size;
		self.camera = [[[Isgl3dCamera alloc] initWithWidth:viewSize.width andHeight:viewSize.height] autorelease];
		[self.camera setOrthoProjection:0 right:self.viewport.size.width bottom:0 top:self.viewport.size.height near:1 far:1000 orientation:self.deviceViewOrientation];
		Isgl3dLog(Info, @"Isgl3dBasic2DView : creating default camera with ortho projection. Viewport size = %@", NSStringFromCGSize(viewSize));

		[self.scene addChild:self.camera];

	}
	
    return self;
}

- (void) setViewport:(CGRect)viewport {
	[super setViewport:viewport];

	if (self.camera) {
		[self.camera setOrthoProjection:0 right:self.viewport.size.width bottom:0 top:self.viewport.size.height near:self.camera.near far:self.camera.far orientation:self.deviceViewOrientation];
		Isgl3dLog(Info, @"Isgl3dBasic2DView : setting camera with ortho projection. Viewport size = %@", NSStringFromCGSize(viewport.size));
	}
}

@end

