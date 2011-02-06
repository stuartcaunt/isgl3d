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

#import "TerrainMeshDemoView.h"
#import "Isgl3dDemoCameraController.h"

@implementation TerrainMeshDemoView

- (void) dealloc {
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
	[_cameraController release];

	[_container release];

	[super dealloc];
}

- (void) initView {
	[super initView];

	// Create and configure touch-screen camera controller
	_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:_camera andView:self];
	_cameraController.orbit = 40;
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
	Isgl3dTextureMaterial * textureMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"RaceTrack1Terrain_1024.png" shininess:0 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dTextureMaterial * dataMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"RaceTrack1Path_512.png" shininess:0 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];

	Isgl3dPlane * planeMesh = [[Isgl3dPlane alloc] initWithGeometry:40 height:40 nx:4 ny:4];
	_plane = [_container createNodeWithMesh:[planeMesh autorelease] andMaterial:[dataMaterial autorelease]];
	[_plane rotate:-90 x:1 y:0 z:0];
	[_plane setTranslation:0 y:-5 z:0];
	_plane.lightingEnabled = NO;

	Isgl3dTerrainMesh * terrainMesh = [[Isgl3dTerrainMesh alloc] initWithTerrainDataFile:@"RaceTrack1Path_512.png" channel:2 width:32 depth:32 height:10 nx:32 nz:32];
	_terrain = [_container createNodeWithMesh:[terrainMesh autorelease] andMaterial:[textureMaterial autorelease]];

	// Add light
	Isgl3dLight * light  = [[Isgl3dLight alloc] initWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
	[light setTranslation:5 y:10 z:10];
	[_scene addChild:light];	

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
	return [[[TerrainMeshDemoView alloc] initWithFrame:frame] autorelease];
}

@end
