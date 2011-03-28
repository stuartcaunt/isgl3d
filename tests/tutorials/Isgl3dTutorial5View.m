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

#import "Isgl3dTutorial5View.h"
#import "Isgl3dDemoCameraController.h"

@interface Isgl3dTutorial5View ()
- (void) createUfoAtX:(float)x y:(float)y z:(float)z;
@end

@implementation Isgl3dTutorial5View

- (void) dealloc {
	// Release scene
	[_scene release];
	
	// Remove camera controller from touch-screen manager and release
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
	[_cameraController release];
	
	// Release UFO materials and meshes
	[_ufoHullMaterial release];
	[_ufoShellMaterial release];
	[_ufoHullMesh release];
	[_ufoShellMesh release];
	[_ufos release];

	[super dealloc];
}

- (void) initView {
	// Prepare the view with the background color.
	float clearColor[4] = {0.2, 0.2, 0.2, 1};
	[self prepareView:clearColor];

	// Create the root scene graph object and set it active in the view.
	_scene = [[Isgl3dScene3D alloc] init];
	[self setActiveScene:_scene];

	// Create a standard camera in the scene and set it active in the view.
	Isgl3dCamera * camera = [_scene createCameraNodeWithView:self];
	[self setActiveCamera:camera];

	// Create and configure touch-screen camera controller
	_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:camera andView:self];
	_cameraController.orbit = 20;
	_cameraController.theta = 60;
	_cameraController.phi = 20;
	_cameraController.doubleTapEnabled = NO;
	
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController];
	
	// Set the device in landscape mode.
	self.isLandscape = YES;
	
	// Create array to store ufo mesh nodes
	_ufos = [[NSMutableArray alloc] init];
}

- (void) initScene {

	// Create the space station mesh node (torus rotated)
	Isgl3dTorus * torus = [[Isgl3dTorus alloc] initWithGeometry:10 tubeRadius:1.5 ns:32 nt:16];
	Isgl3dTextureMaterial * torusMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"SpaceStation.png" shininess:0 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	_spaceStation = [_scene createNodeWithMesh:[torus autorelease] andMaterial:[torusMaterial autorelease]];
	[_spaceStation setRotation:90 x:1 y:0 z:0];
	
	// Add a touch event listener to the space station
	_spaceStation.interactive = YES;
	[_spaceStation addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
	
	// double sided so interior can be seen
	_spaceStation.doubleSided = YES;
	
	// Alpha culling enabled to remove rendering artifacts: alpha less that 0.1 are culled
	[_spaceStation enableAlphaCullingWithValue:0.1];

	// Create sphere mesh node to render stars: double sided so that the stars are rendered "inside", and without lighting
	Isgl3dSphere * sphere = [[Isgl3dSphere alloc] initWithGeometry:1000 longs:32 lats:8];
	Isgl3dTextureMaterial * starsMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"stars.png" shininess:0 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dMeshNode * stars = [_scene createNodeWithMesh:[sphere autorelease] andMaterial:[starsMaterial autorelease]];
	stars.doubleSided = YES;
	stars.lightingEnabled = NO;

	// Create texture and color materials and meshes for UFOs
	_ufoHullMaterial = [[Isgl3dAnimatedTextureMaterial alloc] initWithTextureFilenameFormat:@"ufo%02d.png" textureFirstID:0 textureLastID:15 animationName:@"ufo" shininess:0.7 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	_ufoShellMaterial = [[Isgl3dColorMaterial alloc] initWithHexColors:@"9999CC" diffuse:@"9999CC" specular:@"FFFFFF" shininess:0.7];
	_ufoHullMesh = [[Isgl3dEllipsoid alloc] initWithGeometry:4 radiusY:0.5 radiusZ:4 longs:32 lats:8];
	_ufoShellMesh = [[Isgl3dOvoid alloc] initWithGeometry:1.6 b:1.1 k:0.2 longs:16 lats:16];

	// Create 4 UFOs at different positions
	[self createUfoAtX:0 y:0 z:10];
	[self createUfoAtX:-8 y:0 z:-10];
	[self createUfoAtX:20 y:0 z:-2];
	[self createUfoAtX:10 y:0 z:15];

	// Create directional white light and add to scene
	Isgl3dLight * light = [[Isgl3dLight alloc] initWithHexColor:@"444444" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0];
	light.lightType = DirectionalLight;
	[light setDirection:-1 y:-1 z:0];
	[_scene addChild:[light autorelease]];
}

- (void) updateScene {
	// update camera
	[_cameraController update];
	
	// Rotate all UFOs
	for (Isgl3dMeshNode * ufo in _ufos) {
		[ufo rotate:1 x:0 y:1 z:0];
	}
	
	// Rotate space station
	[_spaceStation rotate:0.5 x:0 y:0 z:1];
}

/*
 * Callback for touch event on 3D object
 */
- (void) objectTouched:(Isgl3dEvent3D *)event {
	// Update camera target
	_cameraController.target = event.object;
}

/*
 * Create UFO object at specific position
 */
- (void) createUfoAtX:(float)x y:(float)y z:(float)z {
	// Create mesh node for main hull of UFO: translate and set interactive to be able to target camera on it
	Isgl3dMeshNode * ufo = [_scene createNodeWithMesh:_ufoHullMesh andMaterial:_ufoHullMaterial];
	[ufo setTranslation:x y:y z:z];
	ufo.interactive = YES;
	[ufo addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];

	// Create UFO shell (child of hull node)
	Isgl3dMeshNode * ufoShell = [ufo createNodeWithMesh:_ufoShellMesh andMaterial:_ufoShellMaterial];
	[ufoShell setTranslation:0 y:0.6 z:0];
	
	// Make shell transparent
	ufoShell.alpha = 0.7;
	
	// Add UFO to array of UFOs
	[_ufos addObject:ufo];
}

@end

#pragma mark AppDelegate

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppDelegate

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[Isgl3dTutorial5View alloc] initWithFrame:frame] autorelease];
}
@end
