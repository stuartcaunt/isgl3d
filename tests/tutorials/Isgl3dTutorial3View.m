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

#import "Isgl3dTutorial3View.h"

@implementation Isgl3dTutorial3View

- (id) init {
	
	if ((self = [super init])) {
	
		// Translate the camera and modify the look-at position (used to center the torus in the screen).
		self.camera.position = iv3(2, 9, 10);
		[self.camera lookAt:0.5 y:0 z:1];
		
		// Create the torus texture material, with darker ambient color
		Isgl3dTextureMaterial *  torusMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"donut.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		[torusMaterial setAmbientColorAsString:@"444444"];
	
		// Create the plane texture material, specifying that it is to be repeated
		Isgl3dTextureMaterial *  planeMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"cloth.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:YES repeatY:YES];
		
		// Create a torus primitive
		Isgl3dTorus * torus = [Isgl3dTorus meshWithGeometry:3.5 tubeRadius:1.5 ns:32 nt:16];
		
		// Create a plane primitive with UV map (texture to be repeated 5 times in each direction)
		Isgl3dUVMap * uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:5.0 vB:0.0 uC:0.0 vC:5.0];
		Isgl3dPlane * plane = [Isgl3dPlane meshWithGeometryAndUVMap:100.0 height:100.0 nx:2 ny:2 uvMap:uvMap];
		
		// Create a mesh node in the scene using torus primitive and torus material
		_torusNode = [self.scene createNodeWithMesh:torus andMaterial:torusMaterial];
		
		// Create a mesh node in the scene using plane primitive and plane material, then rotate and translate it.
		Isgl3dMeshNode * planeNode = [self.scene createNodeWithMesh:plane andMaterial:planeMaterial];
		planeNode.rotationX = -90;
		planeNode.position = iv3(0, -10, 0);
	
		// Create directional white light and add to scene
		Isgl3dLight * light = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0];
		light.lightType = DirectionalLight;
		[light setDirection:-1 y:-1 z:0];
		[self.scene addChild:light];
		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {

	[super dealloc];
}

- (void) tick:(float)dt {
	// Rotate the torus
	_torusNode.rotationY += 1;
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
	Isgl3dView * view = [Isgl3dTutorial3View view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
