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

#import "ActionsDemoView.h"
#import "Isgl3dDemoCameraController.h"

@implementation ActionsDemoView

- (id) init {
	
	if ((self = [super init])) {
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 17;
		_cameraController.theta = 30;
		_cameraController.phi = 10;
		_cameraController.doubleTapEnabled = NO;

		
		// Create the primitive
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9];
	
		Isgl3dArrow * arrowMesh = [Isgl3dArrow meshWithGeometry:4 radius:0.4 headHeight:1 headRadius:0.6 ns:32 nt:32];
		_arrow = [self.scene createNodeWithMesh:arrowMesh andMaterial:material];
		_arrow.position = iv3(0, 0, 0);
		
		// Add light
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
		light.position = iv3(5, 15, 15);
		[self.scene addChild:light];
		
		// Schedule updates
		[self schedule:@selector(tick:)];
		
		
		Isgl3dAction * action = [Isgl3dActionSequence actionWithActions:
									[Isgl3dActionFadeIn actionWithDuration:1.0],
									[Isgl3dActionScaleTo actionWithDuration:1.0 scaleX:0.5f scaleY:2.0f scaleZ:1.0f],
									[Isgl3dActionSetPosition actionWithPosition:iv3(0.0f, 0.0f, -3.0f)],
									[Isgl3dActionScaleBy actionWithDuration:1.0 scale:0.5f],
									[Isgl3dActionSetRotationZ actionWithAngle:90.0f],
									[Isgl3dActionDelay actionWithDuration:1.0f],
									[Isgl3dActionMoveTo actionWithDuration:1.0 position:iv3(3.0f, 0.0f, 0.0f)],
									[Isgl3dActionCallFunc actionWithTarget:self selector:@selector(callback1)],
									[Isgl3dActionMoveTo actionWithDuration:1.0 position:iv3(3.0f, 2.0f, 0.0f)],
									[Isgl3dActionMoveBy actionWithDuration:1.0 vector:iv3(0.0f, 0.0f, 3.0f)],
									[Isgl3dActionAlphaTo actionWithDuration:1.0 alpha:0.2f],
									[Isgl3dActionRotateZBy actionWithDuration:0.5f angle:-45.0f],
									[Isgl3dActionMoveTo actionWithDuration:2.0 position:iv3(0.0f, 0.0f, 0.0f)],
									[Isgl3dActionAlphaTo actionWithDuration:1.0 alpha:1.0f],
									[Isgl3dActionYawBy actionWithDuration:0.5f angle:90.0f],
									[Isgl3dActionPitchBy actionWithDuration:0.5f angle:90.0f],
									[Isgl3dActionRollBy actionWithDuration:0.5f angle:90.0f],
									[Isgl3dActionScaleTo actionWithDuration:1.0 scale:1.0f],
									[Isgl3dActionFadeOut actionWithDuration:1.0],
									[Isgl3dActionFadeIn actionWithDuration:1.0],
									nil];
		[_arrow runAction:action];
		
	}
	
	return self;
}

- (void) dealloc {
	[_cameraController release];

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
	// update camera
	[_cameraController update];
}

- (void) callback1 {
	NSLog(@"Callback1 called !");
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
	Isgl3dView * view = [ActionsDemoView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
