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

#import "PODTestView.h"
#include "Isgl3dPODImporter.h"

@implementation PODTestView

- (id) init {
	
	if ((self = [super init])) {

		// Enable shadow rendering
		[Isgl3dDirector sharedInstance].shadowRenderingMethod = Isgl3dShadowPlanar;
		[Isgl3dDirector sharedInstance].shadowAlpha = 0.5;

		Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:@"Scene_float.pod"];
//		[podImporter printPODInfo];
		
		// Add all meshes in POD to scene
		[podImporter addMeshesToScene:self.scene];
	
		// Add light to scene and fix the Sphere01 mesh to it
		Isgl3dShadowCastingLight * light  = [Isgl3dShadowCastingLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
		[self.scene addChild:light];
		[podImporter configureLight:light fromNode:@"Sphere01"];
		
		// Get the teapot for later use
		_teapot = [podImporter meshNodeWithName:@"Teapot01"];
		
		// POD data has non-normalised normals
		_teapot.mesh.normalizationEnabled = YES;
		[podImporter meshNodeWithName:@"Plane01"].mesh.normalizationEnabled = YES;
	
		// Make the teapot render shadows
		_teapot.enableShadowCasting = YES;
	
		light.planarShadowsNode = [podImporter meshNodeWithName:@"Plane01"];
		light.planarShadowsNodeNormal = iv3(0, 1, 0);
	
		// Set the camera up as it has been saved in the POD
		// Remove camera created in super, added from POD later
		[self.camera removeFromParent];
		self.camera = [podImporter cameraAtIndex:0];
		[self.scene addChild:self.camera];
		
		[self setSceneAmbient:[Isgl3dColorUtil rgbString:[podImporter ambientColor]]];
		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}


- (void) tick:(float)dt {
	[_teapot setRotation:_angle += 1 x:0 y:1 z:0];
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
	Isgl3dView * view = [PODTestView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
