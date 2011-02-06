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

- (void) dealloc {
	[_teapot release];	

	[super dealloc];
}

- (void) initView {
	[super initView];

	// Remove camera created in super, added from POD later
	[_camera removeFromParent];
	[_camera release];
	[self setActiveCamera:nil];

	self.isLandscape = YES;
	self.shadowRenderingMethod = SHADOW_RENDERING_PLANAR;
	self.shadowAlpha = 0.5;	
}

- (void) initScene {
	[super initScene];
	
	Isgl3dPODImporter * podImporter = [[Isgl3dPODImporter alloc] initWithFile:@"Scene_float.pod" andView3D:self];
//	[podImporter printPODInfo];
	
	// Add all meshes in POD to scene
	[podImporter addMeshesToScene:_scene];

	// Add light to scene and fix the Sphere01 mesh to it
	Isgl3dShadowCastingLight * light  = [[Isgl3dShadowCastingLight alloc] initWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
	[_scene addChild:[light autorelease]];
	[podImporter configureLight:light fromNode:@"Sphere01"];
	
	// Get the teapot for later use
	_teapot = [[podImporter meshNodeWithName:@"Teapot01"] retain];
	
	// POD data has non-normalised normals
	_teapot.mesh.normalizationEnabled = YES;
	[podImporter meshNodeWithName:@"Plane01"].mesh.normalizationEnabled = YES;

	// Make the teapot render shadows
	_teapot.enableShadowCasting = YES;

	light.planarShadowsNode = [podImporter meshNodeWithName:@"Plane01"];
	light.planarShadowsNodeNormal = [Isgl3dVector4D vectorWithX:0 y:1 z:0 w:0];

	// Set the camera up as it has been saved in the POD
	_camera = [[podImporter cameraAtIndex:0] retain];
	[_scene addChild:_camera];
	[self setActiveCamera:_camera];
	
	[self setSceneAmbient:[Isgl3dColorUtil colorString:[podImporter ambientColor]]];
	
	[podImporter release];	

}

- (void) updateScene {
	[super updateScene];
	
	[_teapot setRotation:_angle += 1 x:0 y:1 z:0];
}


@end



#pragma mark AppController

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppController

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[PODTestView alloc] initWithFrame:frame] autorelease];
}

@end
