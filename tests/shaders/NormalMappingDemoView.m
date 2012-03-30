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

#import "NormalMappingDemoView.h"
#import "Isgl3dDemoCameraController.h"
#import "DemoShader.h"
#import "PowerVRShader.h"


@interface NormalMappingDemoView (){
@private
	Isgl3dMeshNode * _torus;
	Isgl3dMeshNode * _cone;
	Isgl3dMeshNode * _cylinder;
	Isgl3dMeshNode * _arrow;
	Isgl3dMeshNode * _ovoid;
	Isgl3dMeshNode * _gourat;
    
    Isgl3dLight * _light;
    Isgl3dNodeCamera * _camera;
	Isgl3dDemoCameraController * _cameraController;
}
@end


#pragma mark -
@implementation NormalMappingDemoView

- (id)init {
	
	if (self = [super init]) {
        
        _camera = (Isgl3dNodeCamera *)self.defaultCamera;
        
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithNodeCamera:_camera andView:self];
		_cameraController.orbit = 17;
		_cameraController.theta = 30;
		_cameraController.phi = 10;
		_cameraController.doubleTapEnabled = NO;

		// Standard material
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.2];
        [material setNormalMapFromFile:@"norm4.png"];
	
		// Apply custom shader material to torus
		Isgl3dTorus * torusMesh = [Isgl3dTorus meshWithGeometry:2 tubeRadius:1 ns:32 nt:32];
		_torus = [self.scene createNodeWithMesh:torusMesh andMaterial:material];
		_torus.position = Isgl3dVector3Make(-7, 0, 0);
//		_torus.interactive = YES;
//		[_torus addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
	
		Isgl3dCone * coneMesh = [Isgl3dCone meshWithGeometry:4 topRadius:0 bottomRadius:2 ns:32 nt:32 openEnded:NO];
		_cone = [self.scene createNodeWithMesh:coneMesh andMaterial:material];
		_cone.position = Isgl3dVector3Make(7, 0, 0);
	
		Isgl3dCylinder * cylinderMesh = [Isgl3dCylinder meshWithGeometry:4 radius:1 ns:32 nt:32 openEnded:NO];
		_cylinder = [self.scene createNodeWithMesh:cylinderMesh andMaterial:material];
		_cylinder.position = Isgl3dVector3Make(0, 0, -7);
	
		Isgl3dArrow * arrowMesh = [Isgl3dArrow meshWithGeometry:4 radius:0.4 headHeight:1 headRadius:0.6 ns:32 nt:32];
		_arrow = [self.scene createNodeWithMesh:arrowMesh andMaterial:material];
		_arrow.position = Isgl3dVector3Make(0, 0, 7);
		
		Isgl3dOvoid * ovoidMesh = [Isgl3dOvoid meshWithGeometry:1.5 b:2 k:0.2 longs:32 lats:32];
		_ovoid = [self.scene createNodeWithMesh:ovoidMesh andMaterial:material];
		_ovoid.position = Isgl3dVector3Make(0, -4, 0);
		
		Isgl3dGoursatSurface * gouratMesh = [Isgl3dGoursatSurface meshWithGeometry:0 b:0 c:-1 width:2 height:3 depth:2 longs:8 lats:16];
		_gourat = [self.scene createNodeWithMesh:gouratMesh andMaterial:material];
		_gourat.position = Isgl3dVector3Make(0, 4, 0);
		
        Isgl3dTextureMaterial *specMat = [Isgl3dTextureMaterial materialWithTextureFile:@"tex.png" shininess:0.9f];
        [specMat setSpecularMapFromFile:@"spec.png"];
        //[specMat setNormalMapFromFile:@"nor.png"];
        Isgl3dPlane *planeMesh = [Isgl3dPlane meshWithGeometry:10 height:10 nx:20 ny:20];
        Isgl3dMeshNode *plane = [self.scene createNodeWithMesh:planeMesh andMaterial:specMat];
        plane.doubleSided = YES;
        
		// Add light
		_light  = [Isgl3dLight lightWithHexColor:@"ffffff" diffuseColor:@"555555" specularColor:@"555555" attenuation:0];
		[_light setDirection:-1 y:-2 z:1];
		_light.lightType = DirectionalLight;
		[self.scene addChild:_light];
		
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
    _light.position = _camera.position;
}

- (void)objectTouched:(Isgl3dEvent3D *)event {
	Isgl3dClassDebugLog2(Isgl3dLogLevelInfo, @"object touched");
}

@end



#pragma mark AppDelegate

/*
 * Implement principal class: simply override the createViews method to return the desired demo view.
 */
@implementation AppDelegate

- (void)createViews {
	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [NormalMappingDemoView view];
    view.displayFPS = YES;
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
