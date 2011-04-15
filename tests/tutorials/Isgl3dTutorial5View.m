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
- (void) createUfoAtX:(float)x y:(float)y z:(float)z 
			hullMesh:(Isgl3dGLMesh *)hullMesh hullMaterial:(Isgl3dMaterial *)hullMaterial
			shellMesh:(Isgl3dGLMesh *)shellMesh shellMaterial:(Isgl3dMaterial *)shellMaterial;
@end

@implementation Isgl3dTutorial5View

- (id) init {
	
	if ((self = [super init])) {
	
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 25;
		_cameraController.theta = 60;
		_cameraController.phi = 20;
		_cameraController.doubleTapEnabled = NO;
		
		// Create array to store ufo mesh nodes
		_ufos = [[NSMutableArray alloc] init];

		// Create the space station mesh node (torus rotated)
		Isgl3dTorus * torus = [Isgl3dTorus meshWithGeometry:10 tubeRadius:1.5 ns:32 nt:16];
		Isgl3dTextureMaterial * torusMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"SpaceStation.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		_spaceStation = [self.scene createNodeWithMesh:torus andMaterial:torusMaterial];
		_spaceStation.rotationX = 90;
		
		// Add a touch event listener to the space station
		_spaceStation.interactive = YES;
		[_spaceStation addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
		
		// double sided so interior can be seen
		_spaceStation.doubleSided = YES;
		
		// Alpha culling enabled to remove rendering artifacts: alpha less that 0.1 are culled
		[_spaceStation enableAlphaCullingWithValue:0.1];
	
		// Create sphere mesh node to render stars: double sided so that the stars are rendered "inside", and without lighting
		Isgl3dSphere * sphere = [Isgl3dSphere meshWithGeometry:1000 longs:32 lats:8];
		Isgl3dTextureMaterial * starsMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"stars.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dMeshNode * stars = [self.scene createNodeWithMesh:sphere andMaterial:starsMaterial];
		stars.doubleSided = YES;
		stars.lightingEnabled = NO;
	
		// Create texture and color materials and meshes for UFOs
		Isgl3dMaterial * hullMaterial = [Isgl3dAnimatedTextureMaterial materialWithTextureFilenameFormat:@"ufo%02d.png" textureFirstID:0 textureLastID:15 animationName:@"ufo" shininess:0.7 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dMaterial * shellMaterial = [Isgl3dColorMaterial materialWithHexColors:@"9999CC" diffuse:@"9999CC" specular:@"FFFFFF" shininess:0.7];
		Isgl3dEllipsoid *hullMesh = [Isgl3dEllipsoid meshWithGeometry:4 radiusY:0.5 radiusZ:4 longs:32 lats:8];
		Isgl3dOvoid * shellMesh = [Isgl3dOvoid meshWithGeometry:1.6 b:1.1 k:0.2 longs:16 lats:16];
	
		// Create 4 UFOs at different positions
		[self createUfoAtX:0 y:0 z:10 hullMesh:hullMesh hullMaterial:hullMaterial shellMesh:shellMesh shellMaterial:shellMaterial];
		[self createUfoAtX:-8 y:0 z:-10 hullMesh:hullMesh hullMaterial:hullMaterial shellMesh:shellMesh shellMaterial:shellMaterial];
		[self createUfoAtX:20 y:0 z:-2 hullMesh:hullMesh hullMaterial:hullMaterial shellMesh:shellMesh shellMaterial:shellMaterial];
		[self createUfoAtX:10 y:0 z:15 hullMesh:hullMesh hullMaterial:hullMaterial shellMesh:shellMesh shellMaterial:shellMaterial];
	
		// Create directional white light and add to scene
		Isgl3dLight * light = [Isgl3dLight lightWithHexColor:@"444444" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0];
		light.lightType = DirectionalLight;
		[light setDirection:-1 y:-1 z:0];
		[self.scene addChild:light];

		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
	// Release camera controller
	[_cameraController release];
	
	// Release UFO array
	[_ufos release];

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
	
	// Rotate all UFOs
	for (Isgl3dMeshNode * ufo in _ufos) {
		ufo.rotationY += 1;
	}
	
	// Rotate space station
	_spaceStation.rotationZ += 0.5;
	
	// update camera
	[_cameraController update];
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
- (void) createUfoAtX:(float)x y:(float)y z:(float)z 
			hullMesh:(Isgl3dGLMesh *)hullMesh hullMaterial:(Isgl3dMaterial *)hullMaterial
			shellMesh:(Isgl3dGLMesh *)shellMesh shellMaterial:(Isgl3dMaterial *)shellMaterial {
	// Create mesh node for main hull of UFO: translate and set interactive to be able to target camera on it
	Isgl3dMeshNode * ufo = [self.scene createNodeWithMesh:hullMesh andMaterial:hullMaterial];
	ufo.position = iv3(x, y, z);
	ufo.interactive = YES;
	[ufo addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];

	// Create UFO shell (child of hull node)
	Isgl3dMeshNode * ufoShell = [ufo createNodeWithMesh:shellMesh andMaterial:shellMaterial];
	ufoShell.position = iv3(0, 0.6, 0);
	
	// Make shell transparent
	ufoShell.alpha = 0.7;
	
	// Add UFO to array of UFOs
	[_ufos addObject:ufo];
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
	Isgl3dView * view = [Isgl3dTutorial5View view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
