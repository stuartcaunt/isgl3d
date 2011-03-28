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

#import "SandboxUIView.h"

@implementation SandboxUIView

- (id) init {
	
	if ((self = [super init])) {
		self.isOpaque = NO;

		// Create a button to calibrate the accelerometer
		Isgl3dTextureMaterial * calibrateButtonMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"angle.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * calibrateButton = [[Isgl3dGLUIButton alloc] initWithMaterial:[calibrateButtonMaterial autorelease]];
		[self.scene addChild:[calibrateButton autorelease]];
		[calibrateButton setX:8 andY:264];
		[calibrateButton addEvent3DListener:self method:@selector(calibrateButtonPressed:) forEventType:TOUCH_EVENT];
	
		// Create a button to pause the scene
		Isgl3dTextureMaterial * pauseButtonMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"pause.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * pauseButton = [[Isgl3dGLUIButton alloc] initWithMaterial:[pauseButtonMaterial autorelease]];
		[self.scene addChild:[pauseButton autorelease]];
		[pauseButton setX:424 andY:264];
		[pauseButton addEvent3DListener:self method:@selector(pauseButtonPressed:) forEventType:TOUCH_EVENT];
	
		// Create a button to allow movement of the camera
		Isgl3dTextureMaterial * cameraButtonMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"camera.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * cameraButton = [[Isgl3dGLUIButton alloc] initWithMaterial:[cameraButtonMaterial autorelease]];
		[self.scene addChild:[cameraButton autorelease]];
		[cameraButton setX:8 andY:8];
		[cameraButton addEvent3DListener:self method:@selector(cameraButtonPressed:) forEventType:TOUCH_EVENT];

		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
		
	[super dealloc];
}


- (void) tick:(float)dt {

}

- (void) calibrateButtonPressed:(Isgl3dEvent3D *)event {
	NSLog(@"Calibrate button pressed");
	[[Isgl3dDirector sharedInstance] resume];
}

- (void) pauseButtonPressed:(Isgl3dEvent3D *)event {
	NSLog(@"Pause button pressed");
	[[Isgl3dDirector sharedInstance] pause];
}

- (void) cameraButtonPressed:(Isgl3dEvent3D *)event {
	NSLog(@"Camera button pressed");
}


@end

#pragma mark Simple3DView

#import "SandboxCameraController.h"

@implementation Simple3DView 
- (id) init {
	
	if ((self = [super init])) {
		self.isOpaque = NO;

		// Create the primitive
		Isgl3dTextureMaterial * material = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"red_checker.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
		Isgl3dTorus * torusMesh = [[Isgl3dTorus alloc] initWithGeometry:2 tubeRadius:1 ns:32 nt:32];
		_torus = [self.scene createNodeWithMesh:[torusMesh autorelease] andMaterial:[material autorelease]];
	
		// Add light
		Isgl3dLight * light  = [[Isgl3dLight alloc] initWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
		[light setTranslation:5 y:15 z:15];
		[self.scene addChild:[light autorelease]];

		// Create camera controller
		_cameraController = [[SandboxCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 14;
		_cameraController.theta = 30;
		_cameraController.phi = 30;

		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
	[_cameraController release];
		
	[super dealloc];
}

- (void) tick:(float)dt {
	[_torus rotate:0.5 x:0 y:1 z:0];
	
	[_cameraController update];
}

- (void) onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController withView:self];
}

- (void) onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

@end


#pragma mark AppDelegate

/*
 * Implement principal class: creates the view(s) and adds them to the director
 */
@implementation AppDelegate

- (void) createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientation90CounterClockwise;

	Isgl3dView * view = [Simple3DView view];
	[[Isgl3dDirector sharedInstance] addView:view];

	Isgl3dView * ui = [SandboxUIView view];
	[[Isgl3dDirector sharedInstance] addView:ui];
}

@end

