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

#import "Isgl3dTutorial1View.h"

@implementation Isgl3dTutorial1View

- (void) dealloc {
	// Release scene
	[_scene release];
	
	// Release cube
	[_cube release];
	
	[super dealloc];
}

- (void) initView {
	// Prepare the view with the background color.
	float clearColor[4] = {0.15, 0.15, 0.15, 1};
    [self prepareView:clearColor];

	// Create the root scene graph object and set it active in the view.
	_scene = [[Isgl3dScene3D alloc] init];
	[self setActiveScene:_scene];

	// Create a standard camera in the scene and set it active in the view.
	Isgl3dCamera * camera = [_scene createCameraNodeWithView:self];
	[self setActiveCamera:camera];

	// Translate the camera.
	[camera setTranslation:0 y:3 z:6];
	
	// Set the device in landscape mode.
	self.isLandscape = YES;
}

- (void) initScene {
	// Create an Isgl3dMultiMaterialCube with random colors.
	_cube = [[Isgl3dMultiMaterialCube alloc] initWithDimensionsAndRandomColors:3 height:3 depth:3 nSegmentWidth:2 nSegmentHeight:2 nSegmentDepth:2];
	
	// Add the cube to the scene.
	[_scene addChild:_cube];
}

- (void) updateScene {
	// Rotate the cube by 1 degree about its y-axis
	[_cube rotate:1 x:0 y:1 z:0];
}

@end

#pragma mark AppDelegate

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppDelegate

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[Isgl3dTutorial1View alloc] initWithFrame:frame] autorelease];
}
@end
