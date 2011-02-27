//
//  HelloWorldView.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "HelloWorldView.h"

@implementation HelloWorldView

- (void) dealloc {
	// Release scene
	[_scene release];
	
	// Release cube
	[_cube release];

	// Release fps display
	[_fpsDisplay release];

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
	[camera setTranslation:0 y:2 z:5];
	
	// Set the device in landscape mode.
	self.isLandscape = YES;

	// Add the FPS display
	_fpsDisplay = [[Isgl3dFpsDisplay alloc] initWithView:self];
}

- (void) initScene {
	
	// Create texture material with text
	Isgl3dTextureMaterial * material = [[Isgl3dTextureMaterial alloc] initWithText:@"Hello World!" fontName:@"Arial" fontSize:48];

	// Create a UV Map so that only the rendered content of the texture is shown on plane
	float uMax = material.contentSize.width / material.width;
	float vMax = material.contentSize.height / material.height;
	Isgl3dUVMap * uvMap = [Isgl3dUVMap uvMapWithUA:0 vA:0 uB:uMax vB:0 uC:0 vC:vMax];
	
	// Create a plane with corresponding UV map
	Isgl3dPlane * plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:6 height:2 nx:2 ny:2 uvMap:uvMap];
	
	// Create node to render the material on the plane (double sided to see back of plane)
	_3dText = [_scene createNodeWithMesh:[plane autorelease] andMaterial:[material autorelease]];
	_3dText.doubleSided = YES;
}

- (void) updateScene {
	// Rotate the text around the y axis
	[_3dText rotate:2 x:0 y:1 z:0];

	[_fpsDisplay update];
}


@end

