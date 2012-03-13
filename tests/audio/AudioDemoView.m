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

#import "AudioDemoView.h"
#import "Isgl3dDemoCameraController.h"
#import "Isgl3dAudioManager.h"


@interface AudioDemoView ()
@end


#pragma mark -
@implementation AudioDemoView

- (id)init {
	
	if (self = [super init]) {

		// Create and configure touch-screen camera controller
        Isgl3dNodeCamera *standardNodeCamera = (Isgl3dNodeCamera *)self.defaultCamera;
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithNodeCamera:standardNodeCamera andView:self];
		_cameraController.orbit = 17;
		_cameraController.theta = 30;
		_cameraController.phi = 10;
		_cameraController.doubleTapEnabled = NO;

        [Isgl3dAudioManager sharedInstance];
        [[Isgl3dAudioManager sharedInstance] setListenerPosition:standardNodeCamera.eyePosition];

		// Create the primitive
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9];
	
		Isgl3dTorus * torusMesh = [Isgl3dTorus meshWithGeometry:2 tubeRadius:1 ns:32 nt:32];
		_torus = [self.scene createNodeWithMesh:torusMesh andMaterial:material];
		_torus.position = Isgl3dVector3Make(-7, 0, 0);
        [_torus loadAudioForNode:@"ColdFunk.caf" ReferenceDistance:1 MaxDistance:20];
        [_torus playAudio:YES];
	
		Isgl3dCone * coneMesh = [Isgl3dCone meshWithGeometry:4 topRadius:0 bottomRadius:2 ns:32 nt:32 openEnded:NO];
		_cone = [self.scene createNodeWithMesh:coneMesh andMaterial:material];
		_cone.position = Isgl3dVector3Make(7, 0, 0);
        [_cone loadAudioForNode:@"HappyAlley.caf" ReferenceDistance:1 MaxDistance:20];
        [_cone playAudio:YES];
	
		Isgl3dCylinder * cylinderMesh = [Isgl3dCylinder meshWithGeometry:4 radius:1 ns:32 nt:32 openEnded:NO];
		_cylinder = [self.scene createNodeWithMesh:cylinderMesh andMaterial:material];
		_cylinder.position = Isgl3dVector3Make(0, 0, -7);
        //[_cylinder loadAudioForNode:@"ColdFunk.caf" ReferenceDistance:5 MaxDistance:10];
	
		Isgl3dArrow * arrowMesh = [Isgl3dArrow meshWithGeometry:4 radius:0.4 headHeight:1 headRadius:0.6 ns:32 nt:32];
		_arrow = [self.scene createNodeWithMesh:arrowMesh andMaterial:material];
		_arrow.position = Isgl3dVector3Make(0, 0, 7);
        //[_arrow loadAudioForNode:@"ColdFunk.caf" ReferenceDistance:5 MaxDistance:10];
		
		Isgl3dOvoid * ovoidMesh = [Isgl3dOvoid meshWithGeometry:1.5 b:2 k:0.2 longs:32 lats:32];
		_ovoid = [self.scene createNodeWithMesh:ovoidMesh andMaterial:material];
		_ovoid.position = Isgl3dVector3Make(0, -4, 0);
        //[_ovoid loadAudioForNode:@"ColdFunk.caf" ReferenceDistance:5 MaxDistance:10];
		
		Isgl3dGoursatSurface * gouratMesh = [Isgl3dGoursatSurface meshWithGeometry:0 b:0 c:-1 width:2 height:3 depth:2 longs:8 lats:16];
		_gourat = [self.scene createNodeWithMesh:gouratMesh andMaterial:material];
		_gourat.position = Isgl3dVector3Make(0, 4, 0);
        //[_gourat loadAudioForNode:@"ColdFunk.caf" ReferenceDistance:5 MaxDistance:10];
		
		// Add light
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
		light.position = Isgl3dVector3Make(5, 15, 15);
		[self.scene addChild:light];
		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void)dealloc {
	[_cameraController release];
    _cameraController = nil;

	[super dealloc];
}

- (void)onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController];
}

- (void)onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

- (void)tick:(float)dt {
	// update camera
	[_cameraController update];
    [[Isgl3dAudioManager sharedInstance] setListenerPosition:self.defaultCamera.eyePosition];
}


@end



#pragma mark AppDelegate

/*
 * Implement principal class: simply override the createViews method to return the desired demo view.
 */
@implementation AppDelegate

- (void) createViews {
	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [AudioDemoView view];
    view.displayFPS = YES;
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
