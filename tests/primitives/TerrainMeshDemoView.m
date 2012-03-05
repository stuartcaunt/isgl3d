/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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


@interface TerrainMeshDemoView () {
@private
    Isgl3dNodeCamera *_camera;
}
@property (nonatomic,retain) Isgl3dNodeCamera *camera;
@end


#pragma mark -
@implementation TerrainMeshDemoView

@synthesize camera = _camera;

- (id)init {
	
	if ((self = [super init])) {
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithNodeCamera:self.camera andView:self];
		_cameraController.orbit = 40;
		_cameraController.theta = 30;
		_cameraController.phi = 10;
		_cameraController.doubleTapEnabled = NO;
		
		_container = [self.scene createNode];
		
		// Create the primitive
		Isgl3dTextureMaterial * textureMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"RaceTrack1Terrain_1024.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dTextureMaterial * dataMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"RaceTrack1Path_512.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
	
		Isgl3dPlane * planeMesh = [Isgl3dPlane meshWithGeometry:32 height:32 nx:4 ny:4];
		_plane = [_container createNodeWithMesh:planeMesh andMaterial:dataMaterial];
		_plane.rotationX = -90;
		_plane.position = Isgl3dVector3Make(0, -5, 0);
		_plane.lightingEnabled = NO;
	
		Isgl3dTerrainMesh * terrainMesh = [Isgl3dTerrainMesh meshWithTerrainDataFile:@"RaceTrack1Path_512.png" channel:2 width:32 depth:32 height:10 nx:32 nz:32];
		_terrain = [_container createNodeWithMesh:terrainMesh andMaterial:textureMaterial];
	
		// Add light
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
		light.position = Isgl3dVector3Make(5, 10, 10);
		[self.scene addChild:light];	

		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
	[_cameraController release];
    _cameraController = nil;

	[super dealloc];
}

- (void)createSceneCamera {
    CGSize viewSize = self.viewport.size;
    float fovyRadians = Isgl3dMathDegreesToRadians(45.0f);
    Isgl3dPerspectiveProjection *perspectiveLens = [[Isgl3dPerspectiveProjection alloc] initFromViewSize:viewSize fovyRadians:fovyRadians nearZ:1.0f farZ:10000.0f];
    
    Isgl3dVector3 cameraPosition = Isgl3dVector3Make(0.0f, 0.0f, 10.0f);
    Isgl3dVector3 cameraLookAt = Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
    Isgl3dVector3 cameraLookUp = Isgl3dVector3Make(0.0f, 1.0f, 0.0f);
    Isgl3dNodeCamera *standardCamera = [[Isgl3dNodeCamera alloc] initWithLens:perspectiveLens position:cameraPosition lookAtTarget:cameraLookAt up:cameraLookUp];
    [perspectiveLens release];
    
    self.camera = standardCamera;
    [standardCamera release];
    [self.scene addChild:standardCamera];
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
	
	// update camera
	[_cameraController update];
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
	Isgl3dView * view = [TerrainMeshDemoView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
