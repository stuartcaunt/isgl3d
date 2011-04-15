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

#import "Isgl3dTutorial4View.h"

@implementation Isgl3dTutorial4View

- (id) init {
	
	if ((self = [super init])) {
		
		// Translate the camera.
		self.camera.position = iv3(7, 4, 10);

		// Create texture material for the ball with darker ambient color.
		Isgl3dTextureMaterial * ballMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"ball.png" shininess:0.7 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		[ballMaterial setAmbientColorAsString:@"444444"];
		
		// Create texture material for the pitch.
		Isgl3dTextureMaterial * pitchMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"pitch.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
	
		// Create the primitive meshes: a sphere and a plane.
		Isgl3dSphere * sphere = [Isgl3dSphere meshWithGeometry:1 longs:16 lats:8];
		Isgl3dPlane * plane = [Isgl3dPlane meshWithGeometry:24 height:16 nx:2 ny:2];
		
		// Create a container node as a parent for all scene objects.
		_container = [self.scene createNode];
		
		// Create the pitch node from plane mesh and pitch material with container as parent. Rotate and translate it. Disable lighting effects.
		Isgl3dMeshNode * pitch = [_container createNodeWithMesh:plane andMaterial:pitchMaterial];
		pitch.rotationX = -90;
		pitch.position = iv3(0, -1, 0);
		pitch.lightingEnabled = NO;
		
		// Create a number of ball nodes.
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 3; j++) {
				
				// Create ball node from sphere mesh and ball material with container as parent. Translate it.
				Isgl3dMeshNode * ballNode = [_container createNodeWithMesh:sphere andMaterial:ballMaterial];
				ballNode.position = iv3(i * 4 - 6, 0, j * 4 - 4);
				
				// Set the ball as interactive and add an event listener for the touch event.
				ballNode.interactive = YES;
				[ballNode addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
				
			} 
		} 
		
		// Create directional white light and add to scene (will not move with container).
		Isgl3dLight * light = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0];
		light.lightType = DirectionalLight;
		[light setDirection:-1 y:-1 z:1];
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
	// Rotate the container.
	_container.rotationY += 0.3;
}

/*
 * Callback for touch event on 3D object
 */
- (void) objectTouched:(Isgl3dEvent3D *)event {
	
	// Get the object associated with the 3D event.
	Isgl3dNode * object = event.object;
	
	// Create a tween to move the object vertically (0.5s duration, callback to "tweenEnded" on completion).
	[Isgl3dTweener addTween:object withParameters:[NSDictionary dictionaryWithObjectsAndKeys:	
			[NSNumber numberWithFloat:0.5], TWEEN_DURATION, 
			TWEEN_FUNC_EASEOUTSINE, TWEEN_TRANSITION, 
			[NSNumber numberWithFloat:object.y + 5.0], @"y", 
			self, TWEEN_ON_COMPLETE_TARGET, 
			@"tweenEnded:", TWEEN_ON_COMPLETE_SELECTOR, 
			nil]];
}

/*
 * Callback when tween ended
 */
- (void) tweenEnded:(id)sender {
	// Create a new tween to move the object back to original position (duration 1.5s).
	[Isgl3dTweener addTween:sender withParameters:[NSDictionary dictionaryWithObjectsAndKeys:	
			[NSNumber numberWithFloat:1.5], TWEEN_DURATION, 
			TWEEN_FUNC_EASEOUTBOUNCE, TWEEN_TRANSITION, 
			[NSNumber numberWithFloat:0], @"y", 
			nil]];
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
	Isgl3dView * view = [Isgl3dTutorial4View view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
