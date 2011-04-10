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

#import "CameraZoomAndFocusDemoView.h"

@implementation CameraZoomAndFocusDemoView

- (id) init {
	
	if ((self = [super init])) {

		[self.camera setTranslation:0 y:0 z:1000];
		self.camera.focus = 4;
		self.camera.zoom = 10;
		_zoom = self.camera.zoom;
		_focus = self.camera.focus;
		_theta = 0;	 	
		_moving = NO;	


		Isgl3dColorMaterial * redMaterial = [Isgl3dColorMaterial materialWithHexColors:@"FF0000" diffuse:@"FF0000" specular:@"FF0000" shininess:0];
		Isgl3dColorMaterial * greenMaterial = [Isgl3dColorMaterial materialWithHexColors:@"00FF00" diffuse:@"00FF00" specular:@"00FF00" shininess:0];
		Isgl3dColorMaterial * blueMaterial = [Isgl3dColorMaterial materialWithHexColors:@"0000FF" diffuse:@"0000FF" specular:@"0000FF" shininess:0];
		Isgl3dColorMaterial * yellowMaterial = [Isgl3dColorMaterial materialWithHexColors:@"FFFF00" diffuse:@"FFFF00" specular:@"FFFF00" shininess:0];
		
		Isgl3dPlane * sidePlane = [Isgl3dPlane meshWithGeometry:150 height:350 nx:10 ny:10];
		Isgl3dPlane * horizontalPlane = [Isgl3dPlane meshWithGeometry:850 height:150 nx:10 ny:10];
		
		for (int i = 0; i < 3; i++) {
	
			Isgl3dMeshNode * bottomNode = [self.scene createNodeWithMesh:horizontalPlane andMaterial:blueMaterial];
			[bottomNode rotate:-90 x:1 y:0 z:0];
			[bottomNode translate:0 y:-200 z:-(i - 1) * 1000];
			bottomNode.doubleSided = YES;
	
			Isgl3dMeshNode * topNode = [self.scene createNodeWithMesh:horizontalPlane andMaterial:greenMaterial];
			[topNode rotate:90 x:1 y:0 z:0];
			[topNode translate:0 y:200 z:-(i - 1) * 1000];
			topNode.doubleSided = YES;
	
			Isgl3dMeshNode * rightNode = [self.scene createNodeWithMesh:sidePlane andMaterial:redMaterial];
			[rightNode rotate:-90 x:0 y:1 z:0];
			[rightNode translate:450 y:0 z:-(i - 1) * 1000];
			rightNode.doubleSided = YES;
			
			Isgl3dMeshNode * leftNode = [self.scene createNodeWithMesh:sidePlane andMaterial:yellowMaterial];
			[leftNode rotate:90 x:0 y:1 z:0];
			[leftNode translate:-450 y:0 z:-(i - 1) * 1000];
			leftNode.doubleSided = YES;
		}
		
		// Add shadow casting light
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0];
		[light setTranslation:400 y:1000 z:400];
		[self.scene addChild:light];
	
		// Initialise accelerometer
		[[Isgl3dAccelerometer sharedInstance] setup:30];

		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {

	[super dealloc];
}

- (void) onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:self];
}

- (void) onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:self];
}

- (void) tick:(float)dt {
	
	float orbitDistance = 1000;
	float y = orbitDistance * cos([[Isgl3dAccelerometer sharedInstance] tiltAngle]);
	float radius = orbitDistance * sin([[Isgl3dAccelerometer sharedInstance] tiltAngle]);

	_theta += 0.05 * [[Isgl3dAccelerometer sharedInstance] rotationAngle];
	float x = radius * sin(_theta);
	float z = radius * cos(_theta);
	[self.camera setTranslation:x y:y z:z];

	if (_moving) {
		_focus += _dFocus;
		_zoom += _dZoom;
		
		if (_zoom < 0.1) {
			_zoom = 0.1;
		}
		if (_focus < 1) {
			_focus = 1;
		}
		
		self.camera.focus = _focus;
		self.camera.zoom = _zoom;
		
		_moving = NO;
	}

//	NSLog(@"Angle = %f", [[Accelerometer sharedInstance] rotationAngle] * 180 / M_PI);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSEnumerator * enumerator = [touches objectEnumerator];
	UITouch * touch = [enumerator nextObject];

	CGPoint	location = [touch locationInView:touch.view];
    _lastTouchX = location.x;
    _lastTouchY = location.y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_moving = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSEnumerator * enumerator = [touches objectEnumerator];
	UITouch * touch = [enumerator nextObject];

	CGPoint	location = [touch locationInView:touch.view];

	_dZoom = (location.x - _lastTouchX) / 20;
	_dFocus = (location.y - _lastTouchY) / 10;

    _lastTouchX = location.x;
    _lastTouchY = location.y;

	_moving = YES;
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
	Isgl3dView * view = [CameraZoomAndFocusDemoView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
