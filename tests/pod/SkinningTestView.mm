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

- (void) dealloc {
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
	[_cameraController release];

	[_animationController release];

	[super dealloc];
}

- (void) initView {
	[super initView];


	// Create and configure touch-screen camera controller
	_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:_camera andView:self];
	_cameraController.orbit = 400;
	_cameraController.theta = 30;
	_cameraController.phi = 30;
	_cameraController.doubleTapEnabled = NO;
	
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController];
	
	self.isLandscape = YES;
	self.shadowRenderingMethod = SHADOW_RENDERING_PLANAR;
	self.shadowAlpha = 0.5;
	
	_lastTime = [[NSDate alloc] init];	
}

- (void) initScene {
	[super initScene];
	
	Isgl3dPODImporter * podImporter = [[Isgl3dPODImporter alloc] initWithFile:@"man.pod" andView3D:self];
	
	// Modify texture files
	[podImporter modifyTexture:@"body.bmp" withTexture:@"Body.pvr"];
	[podImporter modifyTexture:@"legs.bmp" withTexture:@"Legs.pvr"];
	[podImporter modifyTexture:@"belt.bmp" withTexture:@"Belt.pvr"];

	// Create skeleton node	
	Isgl3dSkeletonNode * skeleton = [_scene createSkeletonNode];
	[skeleton setTranslation:0 y:-130 z:0];
	
	// Add meshes to skeleton
	[podImporter addMeshesToScene:skeleton];
	[skeleton setAlphaWithChildren:0.8];
	[podImporter addBonesToSkeleton:skeleton];
	[skeleton enableShadowCastingWithChildren:YES];

	// Add animation controller
	_animationController = [[Isgl3dAnimationController alloc] initWithSkeleton:skeleton andNumberOfFrames:[podImporter numberOfFrames]];
	[_animationController start];

	// Create a simple plane
	Isgl3dTextureMaterial * groundMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"ground.png" shininess:0.9 precision:TEXTURE_MATERIAL_LOW_PRECISION repeatX:NO repeatY:NO];
	Isgl3dPlane * plane = [[Isgl3dPlane alloc] initWithGeometry:800.0 height:800.0 nx:2 ny:2];
	Isgl3dMeshNode * ground = [_scene createNodeWithMesh:[plane autorelease] andMaterial:[groundMaterial autorelease]];
	[ground setRotation:-90 x:1 y:0 z:0];
	[ground setTranslation:0 y:-130 z:-100];

	// Add light to scene and fix the Sphere01 mesh to it
	Isgl3dShadowCastingLight * light  = [[Isgl3dShadowCastingLight alloc] initWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
	[light setTranslation:300 y:600 z:300];
	[_scene addChild:[light autorelease]];
	light.planarShadowsNode = ground;
	
	[podImporter release];	

}

- (void) updateScene {
	[super updateScene];
	
	// update camera
	[_cameraController update];
}

@end



#pragma mark AppController

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppController

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[SkinningTestView alloc] initWithFrame:frame] autorelease];
}

@end
