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

- (void) dealloc {
	// Release the torus node
	[_torusNode release];
	
	// Release scene
	[_scene release];

	[super dealloc];
}

- (void) initView {
	// Prepare the view with the background color.
	float clearColor[4] = {0.05, 0.05, 0.05, 1};
	[self prepareView:clearColor];

	// Create the root scene graph object and set it active in the view.
	_scene = [[Isgl3dScene3D alloc] init];
	[self setActiveScene:_scene];

	// Create a standard camera in the scene and set it active in the view.
	Isgl3dCamera * camera = [_scene createCameraNodeWithView:self];
	[self setActiveCamera:camera];

	// Translate the camera and modify the look-at position (used to center the torus in the screen).
	[camera setTranslation:2 y:9 z:6];
	[camera lookAt:0.5 y:0 z:1];
	
	// Set the device in landscape mode.
	self.isLandscape = YES;
}

- (void) initScene {

	// Create the torus texture material, with darker ambient color
	Isgl3dTextureMaterial *  torusMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"donut.png" shininess:0 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	[torusMaterial setAmbientColorAsString:@"444444"];

	// Create the plane texture material, specifying that it is to be repeated
	Isgl3dTextureMaterial *  planeMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"cloth.png" shininess:0 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:YES repeatY:YES];
	
	// Create a torus primitive
	Isgl3dTorus * torus = [[Isgl3dTorus alloc] initWithGeometry:3.5 tubeRadius:1.5 ns:32 nt:16];
	
	// Create a plane primitive with UV map (texture to be repeated 5 times in each direction)
	Isgl3dUVMap * uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:5.0 vB:0.0 uC:0.0 vC:5.0];
	Isgl3dPlane * plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:100.0 height:100.0 nx:2 ny:2 uvMap:uvMap];
	
	// Create a mesh node in the scene using torus primitive and torus material
	_torusNode = [_scene createNodeWithMesh:[torus autorelease] andMaterial:[torusMaterial autorelease]];
	
	// Create a mesh node in the scene using plane primitive and plane material, then rotate and translate it.
	Isgl3dMeshNode * planeNode = [_scene createNodeWithMesh:[plane autorelease] andMaterial:[planeMaterial autorelease]];
	[planeNode setRotation:-90 x:1 y:0 z:0];
	[planeNode setTranslation:0 y:-10 z:0];

	// Create directional white light and add to scene
	Isgl3dLight * light = [[Isgl3dLight alloc] initWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0];
	light.lightType = DirectionalLight;
	[light setDirection:-1 y:-1 z:0];
	[_scene addChild:[light autorelease]];
	
}

- (void) updateScene {
	// Rotate the torus
	[_torusNode rotate:1 x:0 y:1 z:0];
}

@end

#pragma mark AppDelegate

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppDelegate

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[Isgl3dTutorial3View alloc] initWithFrame:frame] autorelease];
}
@end
