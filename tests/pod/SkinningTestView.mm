/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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


@interface SkinningTestView () {
@private
    Isgl3dNodeCamera *_camera;
}
@property (nonatomic,retain) Isgl3dNodeCamera *camera;
@end


#pragma mark -
@implementation SkinningTestView

@synthesize camera = _camera;

- (id)init {
	
	if ((self = [super init])) {
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithNodeCamera:self.camera andView:self];
		_cameraController.orbit = 400;
		_cameraController.theta = 30;
		_cameraController.phi = 30;
		_cameraController.doubleTapEnabled = NO;

		// Enable shadow rendering
		[Isgl3dDirector sharedInstance].shadowRenderingMethod = Isgl3dShadowPlanar;
		[Isgl3dDirector sharedInstance].shadowAlpha = 0.4;

		Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithResource:@"man.pod"];
		
		// Modify texture files
		[podImporter modifyTexture:@"body.bmp" withTexture:@"Body.pvr"];
		[podImporter modifyTexture:@"legs.bmp" withTexture:@"Legs.pvr"];
		[podImporter modifyTexture:@"belt.bmp" withTexture:@"Belt.pvr"];
	
		// Create skeleton node	
		Isgl3dSkeletonNode * skeleton = [self.scene createSkeletonNode];
		skeleton.position = Isgl3dVector3Make(0, -130, 0);
		
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
		ground.position = Isgl3dVector3Make(0, -130, -100);
		ground.rotationX = -90;
	
		// Add light to scene and fix the Sphere01 mesh to it
		Isgl3dShadowCastingLight * light  = [Isgl3dShadowCastingLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		light.position = Isgl3dVector3Make(300, 600, 300);
		[self.scene addChild:light];
		light.planarShadowsNode = ground;

		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void)dealloc {
	[_cameraController release];
    _cameraController = nil;

	[_animationController release];
    _animationController = nil;

	[super dealloc];
}

- (void)createSceneCamera {
    CGSize viewSize = self.viewport.size;
    float fovyRadians = Isgl3dMathDegreesToRadians(45.0f);
    Isgl3dPerspectiveProjection *perspectiveLens = [[Isgl3dPerspectiveProjection alloc] initFromViewSize:viewSize fovyRadians:fovyRadians nearZ:1.0f farZ:10000.0f];
    
    Isgl3dVector3 cameraPosition = Isgl3dVector3Make(0.0f, 0.0f, 10.0f);
    Isgl3dVector3 cameraLookAt = Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
    Isgl3dVector3 cameraLookUp = Isgl3dVector3Make(0.0f, 1.0f, 0.0f);
    Isgl3dNodeCamera *standardCamera = [[Isgl3dNodeCamera alloc] initWithLens:perspectiveLens position:cameraPosition lookAtTarget:cameraLookAt up:cameraLookUp];
    [perspectiveLens release];
    
    self.camera = standardCamera;
    [standardCamera release];
    [self.scene addChild:standardCamera];
}

- (void)onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController];
}

- (void)onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

- (void)tick:(float)dt {
	
	// update camera
	[_cameraController update];
}


@end



#pragma mark AppDelegate

/*
 * Implement principal class: simply override the createViews method to return the desired demo view.
 */
@implementation AppDelegate

- (void)createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;

	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [SkinningTestView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
