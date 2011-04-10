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

#import "TweeningDemoView.h"

@implementation TweeningDemoView

- (id) init {
	
	if ((self = [super init])) {
		
		[self.camera setTranslation:0 y:2 z:7];
		[self.camera lookAt:0 y:0 z:-2];

		// Enable zsorting
		self.zSortingEnabled = YES;
	
		_containerAngle = 0;
		_sphereAngle = 0;
		_moving = NO;	

		_container = [self.scene createNode];
		
		Isgl3dNode * container1 = [_container createNode];
		[container1 setTranslation:-2 y:0 z:0];
	
		Isgl3dNode * container2 = [_container createNode];
		[container2 setTranslation:2 y:0 z:0];
		
		// Create a texture material
		Isgl3dTextureMaterial * textureMaterial1 = [Isgl3dTextureMaterial materialWithTextureFile:@"checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		
		// Create a sphere mesh
		Isgl3dGLMesh * sphereMesh = [Isgl3dSphere meshWithGeometry:1.0 longs:25 lats:25];
	
		// Create an interactive mesh node, transparent for correct z sorting
		_sphere1 = [container1 createNodeWithMesh:sphereMesh andMaterial:textureMaterial1];
		_sphere1.interactive = YES;
		_sphere1.transparent = YES;
		
		// Add an event filter for single touch events
		_eventFilter = [[Isgl3dSingleTouchFilter alloc] initWithObject:_sphere1];
		[_eventFilter addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
		[_eventFilter addEvent3DListener:self method:@selector(objectMoved:) forEventType:MOVE_EVENT];
		[_eventFilter addEvent3DListener:self method:@selector(objectReleased:) forEventType:RELEASE_EVENT];
	
		// Create a sphere, double sided and culled so that inside of sphere is visible
		_sphere2 = [container2 createNodeWithMesh:sphereMesh andMaterial:textureMaterial1];
		_sphere2.interactive = YES;
		_sphere2.transparent = YES;
		_sphere2.doubleSided = YES;
		[_sphere2 enableAlphaCullingWithValue:0.0];
		[_sphere2 addEvent3DListener:self method:@selector(objectTouched:) forEventType:TOUCH_EVENT];
		
		// Create the lights
		Isgl3dLight * light1 = [Isgl3dLight lightWithHexColor:@"111111" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
		[light1 setTranslation:0 y:2 z:5];
		[self.scene addChild:light1];
		
		Isgl3dLight * light2 = [Isgl3dLight lightWithHexColor:@"110000" diffuseColor:@"FF0000" specularColor:@"FFFFFF" attenuation:0.001];
		[light2 setTranslation:-2 y:0 z:0];
		[container1 addChild:light2];
		
		Isgl3dLight * light3 = [Isgl3dLight lightWithHexColor:@"000011" diffuseColor:@"0000FF" specularColor:@"FFFFFF" attenuation:0.001];
		[light3 setTranslation:2 y:0 z:0];
		[container2 addChild:light3];
		
		// Set the scene ambient color
		[self setSceneAmbient:@"111111"];	


		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
	[_eventFilter release];

	[super dealloc];
}

- (void) tick:(float)dt {
	[_container setRotation:_containerAngle x:0 y:1 z:0];

	[_sphere1 setRotation:_sphereAngle x:0 y:1 z:0];
	[_sphere2 setRotation:_sphereAngle x:0 y:1 z:0];

	_sphereAngle = _sphereAngle + 1;
	_containerAngle = _containerAngle + 1;
}


- (void) objectTouched:(Isgl3dEvent3D *)event {
	NSLog(@"object touched %i", [event.touches count]);
	
	Isgl3dNode * object = event.object;
	
	[Isgl3dTweener addTween:object withParameters:[NSDictionary dictionaryWithObjectsAndKeys:	[NSNumber numberWithFloat:0.5], TWEEN_DURATION, 
																							TWEEN_FUNC_EASEOUTSINE, TWEEN_TRANSITION, 
																							[NSNumber numberWithFloat:object.y + 3.0], @"y", 
																							self, TWEEN_ON_COMPLETE_TARGET, 
																							@"tweenEnded:", TWEEN_ON_COMPLETE_SELECTOR, 
																							nil]];
}

- (void) objectMoved:(Isgl3dEvent3D *)event {
	NSLog(@"object moved %i", [event.touches count]);
}

- (void) objectReleased:(Isgl3dEvent3D *)event {
	NSLog(@"object released %i", [event.touches count]);
}

- (void) tweenEnded:(id)sender {
	
	[Isgl3dTweener addTween:sender withParameters:[NSDictionary dictionaryWithObjectsAndKeys:	[NSNumber numberWithFloat:1.0], TWEEN_DURATION, 
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
	Isgl3dView * view = [TweeningDemoView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
