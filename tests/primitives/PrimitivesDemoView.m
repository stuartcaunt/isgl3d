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

#import "PrimitivesDemoView.h"
#import "Isgl3dDemoCameraController.h"

@implementation PrimitivesDemoView

- (void) dealloc {
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
	[_cameraController release];

	[super dealloc];
}

- (void) initView {
	[super initView];

	// Create and configure touch-screen camera controller
	_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:_camera andView:self];
	_cameraController.orbit = 17;
	_cameraController.theta = 30;
	_cameraController.phi = 10;
	_cameraController.doubleTapEnabled = NO;
	
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController];

	self.isLandscape = YES;
	
}

- (void) initScene {
	[super initScene];
	
	_container = [[_scene createNode] retain];
	
	// Create the primitive
	Isgl3dTextureMaterial * material = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"red_checker.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];

	Isgl3dTorus * torusMesh = [[Isgl3dTorus alloc] initWithGeometry:2 tubeRadius:1 ns:32 nt:32];
	_torus = [_container createNodeWithMesh:[torusMesh autorelease] andMaterial:material];
	[_torus setTranslation:-7 y:0 z:0];

	Isgl3dCone * coneMesh = [[Isgl3dCone alloc] initWithGeometry:4 topRadius:0 bottomRadius:2 ns:32 nt:32 openEnded:NO];
	_cone = [_container createNodeWithMesh:[coneMesh autorelease] andMaterial:material];
	[_cone setTranslation:7 y:0 z:0];

	Isgl3dCylinder * cylinderMesh = [[Isgl3dCylinder alloc] initWithGeometry:4 radius:1 ns:32 nt:32 openEnded:NO];
	_cylinder = [_container createNodeWithMesh:[cylinderMesh autorelease] andMaterial:material];
	[_cylinder setTranslation:0 y:0 z:-7];

	Isgl3dArrow * arrowMesh = [[Isgl3dArrow alloc] initWithGeometry:4 radius:0.4 headHeight:1 headRadius:0.6 ns:32 nt:32];
	_arrow = [_container createNodeWithMesh:[arrowMesh autorelease] andMaterial:material];
	[_arrow setTranslation:0 y:0 z:7];
	
	Isgl3dOvoid * ovoidMesh = [[Isgl3dOvoid alloc] initWithGeometry:1.5 b:2 k:0.2 longs:32 lats:32];
	_ovoid = [_container createNodeWithMesh:[ovoidMesh autorelease] andMaterial:material];
	[_ovoid setTranslation:0 y:-4 z:0];
	
	Isgl3dGoursatSurface * gouratMesh = [[Isgl3dGoursatSurface alloc] initWithGeometry:0 b:0 c:-1 width:2 height:3 depth:2 longs:8 lats:16];
	_gourat = [_container createNodeWithMesh:[gouratMesh autorelease] andMaterial:material];
	[_gourat setTranslation:0 y:4 z:0];
	
	// Add light
	Isgl3dLight * light  = [[Isgl3dLight alloc] initWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
	[light setTranslation:5 y:15 z:15];
	[_scene addChild:light];
	
	[material release];
}

- (void) updateScene {
	[super updateScene];
	
	_containerRotation += 0.2;
	
	[_container setRotation:_containerRotation x:0 y:1 z:0];
	[_torus setRotation:_containerRotation x:0 y:1 z:0];
	[_cone setRotation:_containerRotation * 2 x:0 y:1 z:0];
	[_cylinder setRotation:-_containerRotation * 3 x:0 y:1 z:0];
	[_arrow setRotation:-_containerRotation * 6 x:0 y:1 z:0];
	[_gourat setRotation:-_containerRotation * 2 x:0 y:1 z:0];

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
	return [[[PrimitivesDemoView alloc] initWithFrame:frame] autorelease];
}

@end
