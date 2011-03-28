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

#import "SandboxOcclusionView.h"
#import "SandboxCameraController.h"

@implementation SandboxOcclusionView

- (id) init {
	
	if ((self = [super init])) {

		// Enable zsorting and occlusion testing
		self.zSortingEnabled = YES;
		self.occlusionTestingEnabled = YES;
		self.occlusionTestingAngle = 20;

		// Create and configure touch-screen camera controller
		_cameraController = [[SandboxCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 11;
		_cameraController.theta = 30;
		_cameraController.phi = 10;
		_cameraController.doubleTapEnabled = NO;

		// Construct scene
		Isgl3dTextureMaterial * textureMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"mars.png" shininess:0 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
		Isgl3dSphere * sphereMesh = [[Isgl3dSphere alloc] initWithGeometry:1.0 longs:10 lats:10];
	
		_container = [self.scene createNode];
		[_container retain];
	
		float containerWidth = 10;
		float containerLength = 10;
		int nX = 5;
		int nZ = 5;
	
		for (int i = 0; i < nX; i++) {
			for (int k = 0; k < nZ; k++) {
				
				Isgl3dMeshNode * sphere = [_container createNodeWithMesh:sphereMesh andMaterial:textureMaterial];
				[sphere setTranslation:i * containerWidth / (nX - 1) - 0.5 * containerWidth y:0 z:k * containerLength / (nZ - 1) - 0.5 *containerLength];
			}
		}
	
		[textureMaterial release];
		[sphereMesh release];
	
		// Create the lights
		Isgl3dLight * light  = [[Isgl3dLight alloc] initWithHexColor:@"444444" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.02];
		[light setTranslation:2 y:6 z:4];
		[self.scene addChild:light];
		
		[light release];
	
		[self setSceneAmbient:@"444444"];

		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
	[_cameraController release];

	[_container release];

	[super dealloc];
}


- (void) onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController withView:self];
}

- (void) onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

- (void) tick:(float)dt {
	
	[_cameraController update];
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

	Isgl3dView * view1 = [SandboxOcclusionView view];
	[[Isgl3dDirector sharedInstance] addView:view1];
}

@end

