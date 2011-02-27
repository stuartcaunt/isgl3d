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

#import "Isgl3dView3D.h"
#import "Isgl3dScene3D.h"
#import "Isgl3dNode.h"
#import "Isgl3dCamera.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dObject3DGrabber.h"
#import "Isgl3dEvent3DHandler.h"
#import "Isgl3dTouchScreen.h"
#import "Isgl3dAccelerometer.h"
#import "Isgl3dTweener.h"
#import "Isgl3dGLTextureFactory.h"
#import "Isgl3dGLContext.h"
#import "Isgl3dGLUI.h"
#import "Isgl3dVector3D.h"
#import "Isgl3dVector4D.h"
#import "Isgl3dLog.h"

@interface Isgl3dView3D (PrivateMethods)
- (void) renderPlanarShadows;
@end

@implementation Isgl3dView3D

@synthesize zSortingEnabled = _zSortingEnabled;
@synthesize occlusionTestingEnabled = _occlusionTestingEnabled;
@synthesize occlusionTestingAngle = _occlusionTestingAngle;
@synthesize uiEventsOnly = _uiEventsOnly;
@synthesize objectTouched = _objectTouched;
@synthesize width = _width;
@synthesize height = _height;

- (BOOL) initializeContext {
	
    if ([super initializeContext]) {
		_renderer = [[_glContext createRenderer] retain];
		_renderer.stencilBufferAvailable = _glContext.stencilBufferAvailable; 
		
		_event3DHandler = [[Isgl3dEvent3DHandler alloc] initWithView3D:self];
	 	
		_isLandscape = NO;	
		_zSortingEnabled = NO;
		_occlusionTestingEnabled = NO;
		_occlusionTestingAngle = 20.0;
			
		[[Isgl3dTouchScreen sharedInstance] setupWithView:self];

		_width = [_glContext backingWidth];
		_height = [_glContext backingHeight];
			
		_skipUpdates = NO;
		_uiEventsOnly = NO;
		_objectTouched = NO;

		[self initView];
		[self initScene];
		[_activeScene udpateGlobalTransformation:nil];
		
		return YES;

    } else {
    	return NO;
    }
}

- (void) dealloc {
	[_renderer release];
	[_activeCamera release];
	[_event3DHandler release];

	[super dealloc];
}



- (void) reset {

	_isLandscape = NO;
	_zSortingEnabled = NO;
	_occlusionTestingEnabled = NO;
	_occlusionTestingAngle = 20.0;
	
	// clear screen
	float clearColor[4] = {0, 0, 0, 1};
    [self prepareView:clearColor];

	[_renderer reset];
	[_renderer release];

	[Isgl3dObject3DGrabber resetInstance];
	[[Isgl3dGLTextureFactory sharedInstance] clear];
	[Isgl3dTouchScreen resetInstance];
	[[Isgl3dTouchScreen sharedInstance] setupWithView:self];

	[self setActiveCamera:nil];
	[self setActiveScene:nil];

	_renderer = [[_glContext createRenderer] retain];
	_renderer.stencilBufferAvailable = _glContext.stencilBufferAvailable; 

	
	[Isgl3dTweener reset];
}

- (void) initView {
	Isgl3dLog(Error, @"You need to implement initView!");
}

- (void) initScene {
	Isgl3dLog(Error, @"You need to implement initScene!");
}

- (void) updateScene {
}

- (Isgl3dScene3D *) activeScene {
	return _activeScene;
}

- (void) setActiveScene:(Isgl3dScene3D *)scene {
	if (scene != _activeScene) {
		if (_activeScene != nil) {
			[_activeScene release];
			_activeScene = nil;
		}
		
		if (scene) {
			_activeScene = [scene retain];
		}
	}
}

- (Isgl3dCamera *) activeCamera {
	return _activeCamera;
}

- (void) setActiveCamera:(Isgl3dCamera *)camera {
	if (camera != _activeCamera) {
		if (_activeCamera != nil) {
			[_activeCamera release];
			_activeCamera = nil;
		}
		
		if (camera) {
			_activeCamera = [camera retain];
			// Set up with default projection matrix if necessary
			if (_activeCamera.projectionMatrix == nil) {
				[_activeCamera setPerspectiveProjection:60 near:1 far:10000 landscape:_isLandscape];
			}
		}
	}
}

- (Isgl3dGLUI *) activeUI {
	return _activeUI;
}

- (void) setActiveUI:(Isgl3dGLUI *)ui {
	if (_activeUI != ui) {
		if (_activeUI != nil) {
			[_activeUI release];
			_activeUI = nil;
		}
		
		if (ui != nil) {
			_activeUI = [ui retain];
		}
	}
}

- (void) setSceneAmbient:(NSString *)ambient {
	[_renderer setSceneAmbient:ambient];
}

- (void) setIsLandscape:(BOOL)isLandscape {
	_isLandscape = isLandscape;
	if (_activeCamera) {
		if (_activeCamera.isPerspective) {
			[_activeCamera setPerspectiveProjection:_activeCamera.fov near:_activeCamera.near far:_activeCamera.far landscape:_isLandscape];
		} else {
			[_activeCamera setOrthoProjection:_activeCamera.left right:_activeCamera.right bottom:_activeCamera.bottom top:_activeCamera.top near:_activeCamera.near far:_activeCamera.far landscape:_isLandscape];
		}
	}
	
	[Isgl3dAccelerometer sharedInstance].isLandscape = _isLandscape;
}

- (BOOL) isLandscape {
	return _isLandscape;
}

- (void) setZSortingEnabled:(BOOL)isZSortingEnabled {
	_zSortingEnabled = isZSortingEnabled;
}

- (void) setOcclusionTestingEnabledWithAngle:(float)angle {
	self.occlusionTestingEnabled = TRUE;
	self.occlusionTestingAngle = angle;
}

- (void) prepareView:(float *)clearColor {
    [_glContext prepare:clearColor];
}

- (void) initializeRender {
	// Cleanup from last render
	[_renderer clean];

	if (!_skipUpdates) {
		// Pass 1: update model matrices
		[_activeScene udpateGlobalTransformation:nil];
	} else {
		// update only camera
		[_activeCamera udpateGlobalTransformation:nil];
	}
}

- (void) render {
	if (_activeScene && _activeCamera) {
	
		// Set camera characteristics
		[_renderer setProjectionMatrix:[_activeCamera projectionMatrix]];
		[_renderer setViewMatrix:[_activeCamera viewMatrix]];
			
		// Pass 2: add lights to scene
		[_activeScene renderLights:_renderer];
		
		// Pass 3: test occlusion of objects
		if (_occlusionTestingEnabled) {
			[_activeCamera getEyeNormal:&_eyeNormal];
			float distance = mv3DLength(&_eyeNormal);
			mv3DNormalize(&_eyeNormal);
			[_activeCamera positionAsMiniVec3D:&_cameraPosition];

			[_activeScene occlusionTest:&_cameraPosition normal:&_eyeNormal targetDistance:distance maxAngle:_occlusionTestingAngle];
		}
		
		// Pass 4: render the opaque meshes
		[_activeScene render:_renderer opaque:true];
	
		[self renderPlanarShadows];
	
		// Pass 5: render the transparent meshes
		if (_zSortingEnabled) {
			[_activeScene renderZSortedAlphaObjects:_renderer viewMatrix:[_activeCamera viewMatrix]];
			
		} else {
			[_activeScene render:_renderer opaque:false];
		}
		
		[self renderPlanarShadows];
	}
	
	// Render the UI
	if (_activeUI) {
		[_glContext clearDepthBuffer];
		[_activeUI render:_renderer];
	}
	
	// Reset updates for next frame
	_skipUpdates = NO;
}

- (void) renderForShadowMaps {
	if ((_renderer.shadowRenderingMethod == GLRENDERER_SHADOW_RENDERING_MAPS) && _activeScene && _activeCamera) {
		[_activeScene createShadowMaps:_renderer forScene:_activeScene];
	}
}

- (void) renderPlanarShadows {
	if ((_renderer.shadowRenderingMethod == GLRENDERER_SHADOW_RENDERING_PLANAR) && _activeScene && _activeCamera) {

		// Set camera characteristics
		[_renderer setProjectionMatrix:[_activeCamera projectionMatrix]];
		[_renderer setViewMatrix:[_activeCamera viewMatrix]];
		
		// Initialise renderer for shadow projection
		[_renderer initRenderForPlanarShadows];

		// Render the scene passing relevant info to create projection matrix for each mesh
		[_activeScene createPlanarShadows:_renderer forScene:_activeScene];

		// Cleanup renderer after shadow projection
		[_renderer finishRenderForPlanarShadows];
	}
}



- (void) renderForEventCapture {

	[[Isgl3dObject3DGrabber sharedInstance] startCapture];

	if (_activeScene && _activeCamera) {
	
		// Cleanup from last render
		[_renderer clean];
		
		// Set camera characteristics
		[_renderer setProjectionMatrix:[_activeCamera projectionMatrix]];
		[_renderer setViewMatrix:[_activeCamera viewMatrix]];
		
		if (!_uiEventsOnly) {
			[_activeScene renderForEventCapture:_renderer];
		}

	}
	if (_activeUI) {
		[_glContext clearDepthBuffer];
		[_activeUI renderForEventCapture:_renderer];
	}
		
}


- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y {
	return [_glContext getPixelString:x y:y];
}

- (unsigned int) shadowRenderingMethod {
	return _renderer.shadowRenderingMethod;
}

- (void) setShadowRenderingMethod:(unsigned int)shadowRenderingMethod {
	if (shadowRenderingMethod == SHADOW_RENDERING_NONE) {
		_renderer.shadowRenderingMethod = GLRENDERER_SHADOW_RENDERING_NONE;
	} else if (shadowRenderingMethod == SHADOW_RENDERING_MAPS) {
		_renderer.shadowRenderingMethod = GLRENDERER_SHADOW_RENDERING_MAPS;
	} else if (shadowRenderingMethod == SHADOW_RENDERING_PLANAR) {
		_renderer.shadowRenderingMethod = GLRENDERER_SHADOW_RENDERING_PLANAR;
	} 
}

- (float) shadowAlpha {
	return _renderer.shadowAlpha;
}

- (void) setShadowAlpha:(float)shadowAlpha {
	_renderer.shadowAlpha = shadowAlpha;
}

- (void) skipUpdates {
	_skipUpdates = YES;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];

	// Handle Object3D events
	_objectTouched = [_event3DHandler touchesBegan:touches withEvent:event];

	[[Isgl3dTouchScreen sharedInstance] touchesBegan:touches withEvent:event];

	_objectTouched = NO;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];

	// Handle Object3D events
	[_event3DHandler touchesEnded:touches withEvent:event];

	[[Isgl3dTouchScreen sharedInstance] touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	// Handle Object3D events
	[_event3DHandler touchesMoved:touches withEvent:event];

	[[Isgl3dTouchScreen sharedInstance] touchesMoved:touches withEvent:event];
}


@end
