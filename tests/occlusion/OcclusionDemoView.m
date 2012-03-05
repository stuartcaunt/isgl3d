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

#import "OcclusionDemoView.h"
#import "Isgl3dDemoCameraController.h"


@interface OcclusionDemoView () {
@private
    Isgl3dNodeCamera *_camera;
}
@property (nonatomic,retain) Isgl3dNodeCamera *camera;
@end


@implementation OcclusionDemoView

@synthesize camera = _camera;

- (id)init {
	
	if (self = [super init]) {

		// Enable zsorting and occlusion testing
		self.zSortingEnabled = YES;
		self.occlusionTestingEnabled = YES;
		self.occlusionTestingAngle = 20;
        
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithNodeCamera:(Isgl3dNodeCamera *)self.camera andView:self];
		_cameraController.orbit = 11;
		_cameraController.theta = 30;
		_cameraController.phi = 10;
		_cameraController.doubleTapEnabled = NO;

		// Construct scene
		Isgl3dTextureMaterial * textureMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"mars.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dSphere * sphereMesh = [Isgl3dSphere meshWithGeometry:1.0 longs:10 lats:10];
	
		_container = [self.scene createNode];
	
		float containerWidth = 10.0f;
		float containerLength = 10.0f;
		int nX = 5;
		int nZ = 5;
	
		for (int i = 0; i < nX; i++) {
			for (int k = 0; k < nZ; k++) {
				
				Isgl3dMeshNode * sphere = [_container createNodeWithMesh:sphereMesh andMaterial:textureMaterial];
				sphere.position = Isgl3dVector3Make(i * containerWidth / (nX - 1) - 0.5 * containerWidth, 0, k * containerLength / (nZ - 1) - 0.5 *containerLength);
			}
		}
	
		// Create the lights
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"444444" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.02];
		light.position = Isgl3dVector3Make(2, 6, 4);
		[self.scene addChild:light];
		
		[self setSceneAmbient:@"444444"];

		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void)dealloc {
	[_cameraController release];

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

- (void)onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController withView:self];
}

- (void)onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

- (void)tick:(float)dt {
	
	[_cameraController update];
}

@end



#pragma mark AppDelegate

/*
 * Implement principal class: simply override the createViews method to return the desired demo view.
 */
@implementation AppDelegate

- (void)createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;

	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [OcclusionDemoView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
