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

#import "SkinningTestView.h"
#include "Isgl3dPODImporter.h"
#import "Isgl3dDemoCameraController.h"


@implementation SkinningTestView

- (id) init {
	
	if ((self = [super init])) {
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 400;
		_cameraController.theta = 30;
		_cameraController.phi = 30;
		_cameraController.doubleTapEnabled = NO;

		// Enable shadow rendering
		[Isgl3dDirector sharedInstance].shadowRenderingMethod = Isgl3dShadowPlanar;
		[Isgl3dDirector sharedInstance].shadowAlpha = 0.4;

		Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:@"man.pod"];
		
		// Modify texture files
		[podImporter modifyTexture:@"body.bmp" withTexture:@"Body.pvr"];
		[podImporter modifyTexture:@"legs.bmp" withTexture:@"Legs.pvr"];
		[podImporter modifyTexture:@"belt.bmp" withTexture:@"Belt.pvr"];
	
		// Create skeleton node	
		Isgl3dSkeletonNode * skeleton = [self.scene createSkeletonNode];
		skeleton.position = iv3(0, -130, 0);
		
		// Add meshes to skeleton
		[podImporter addMeshesToScene:skeleton];
		[skeleton setAlphaWithChildren:0.8];
		[podImporter addBonesToSkeleton:skeleton];
		[skeleton enableShadowCastingWithChildren:YES];
	
		// Add animation controller
		_animationController = [[Isgl3dAnimationController alloc] initWithSkeleton:skeleton andNumberOfFrames:[podImporter numberOfFrames]];
		[_animationController start];
	
		// Create a simple plane
		Isgl3dTextureMaterial * groundMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"ground.png" shininess:0.9 precision:Isgl3dTexturePrecisionLow repeatX:NO repeatY:NO];
		Isgl3dPlane * plane = [Isgl3dPlane meshWithGeometry:800.0 height:800.0 nx:2 ny:2];
		Isgl3dMeshNode * ground = [self.scene createNodeWithMesh:plane andMaterial:groundMaterial];
		ground.position = iv3(0, -130, -100);
		ground.rotationX = -90;
	
		// Add light to scene and fix the Sphere01 mesh to it
		Isgl3dShadowCastingLight * light  = [Isgl3dShadowCastingLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		light.position = iv3(300, 600, 300);
		[self.scene addChild:light];
		light.planarShadowsNode = ground;

		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
	[_cameraController release];

	[_animationController release];

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
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;

	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [SkinningTestView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
