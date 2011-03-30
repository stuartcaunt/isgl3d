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

#import "CubeAndCameraView.h"
#import "Isgl3dDemoCameraController.h"

@implementation CubeAndCameraView

- (id) init {
	
	if ((self = [super init])) {

		// Set transparent
		self.isOpaque = NO;

		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 16;
		_cameraController.theta = 30;
		_cameraController.phi = 30;
		_cameraController.doubleTapEnabled = NO;

		// Create an Isgl3dMultiMaterialCube with random colors.
		_cube = [[Isgl3dMultiMaterialCube alloc] initWithDimensionsAndRandomColors:3 height:3 depth:3 nSegmentWidth:2 nSegmentHeight:2 nSegmentDepth:2];
		
		// Add the cube to the scene.
		[self.scene addChild:_cube];

		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
	[_cameraController release];
	[_cube release];

	[super dealloc];
}


- (void) onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController];
}

- (void) onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

- (void) tick:(float)dt {
	
	// Rotate the cube by 1 degree about its y-axis
	[_cube rotate:1 x:0 y:1 z:0];
	
	// update camera
	[_cameraController update];
}

@end



#pragma mark AppDelegate

/*
 * Implement principal class: simply override the createViews method to return the desired demo view.
 */
@implementation AppDelegate

- (void) createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationPortrait;

	// Set the background transparent
	[Isgl3dDirector sharedInstance].backgroundColorString = @"00000000"; 

	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [CubeAndCameraView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
