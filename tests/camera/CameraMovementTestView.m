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

#import "CameraMovementTestView.h"

@implementation CameraMovementTestView

- (void) dealloc {

	[super dealloc];
}

- (void) initView {
	[super initView];

	[_camera setTranslation:0 y:5 z:15];
		
	self.isLandscape = YES;
	
	_camera.focus = 4;
	_camera.zoom = 10;
	
	_zoom = _camera.zoom;
	_focus = _camera.focus;
	
	NSLog(@"focus = %f", _focus);
	
	[[Isgl3dTouchScreen sharedInstance] addResponder:self];
	_theta = 0;	 	
	_moving = NO;	
}

- (void) initScene {
	[super initScene];
	
	// Create the sphere
	Isgl3dTextureMaterial * material = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"isgl3d_logo.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dCube * cubeMesh = [[Isgl3dCube alloc] initWithGeometry:2 height:2 depth:2 nx:2 ny:2];
	[_scene createNodeWithMesh:[cubeMesh autorelease] andMaterial:[material autorelease]];
	
	// Add shadow casting light
	Isgl3dLight * light  = [[Isgl3dLight alloc] initWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
	[light setTranslation:5 y:10 z:10];
	[_scene addChild:light];

	// Initialise accelerometer
	[[Isgl3dAccelerometer sharedInstance] setup:30];	

}

- (void) updateScene {
	[super updateScene];
	
	float orbitDistance = 5;
	float y = orbitDistance * cos([[Isgl3dAccelerometer sharedInstance] tiltAngle]);
	float radius = orbitDistance * sin([[Isgl3dAccelerometer sharedInstance] tiltAngle]);

	_theta += 0.05 * [[Isgl3dAccelerometer sharedInstance] rotationAngle];
	float x = radius * sin(_theta);
	float z = radius * cos(_theta);
	[_camera setTranslation:x y:y z:z];

	if (_moving) {
		_focus += _dFocus;
		_zoom += _dZoom;
		
		if (_zoom < 0.1) {
			_zoom = 0.1;
		}
		if (_focus < 1) {
			_focus = 1;
		}
		
		_camera.focus = _focus;
		_camera.zoom = _zoom;
		
		_moving = NO;
	}

//	NSLog(@"Angle = %f", [[Accelerometer sharedInstance] rotationAngle] * 180 / M_PI);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSEnumerator * enumerator = [touches objectEnumerator];
	UITouch * touch = [enumerator nextObject];

	CGPoint	location = [touch locationInView:self];
    _lastTouchX = location.x;
    _lastTouchY = location.y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_moving = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSEnumerator * enumerator = [touches objectEnumerator];
	UITouch * touch = [enumerator nextObject];

	CGPoint	location = [touch locationInView:self];

	_dZoom = (location.x - _lastTouchX) / 20;
	_dFocus = (location.y - _lastTouchY) / 10;

    _lastTouchX = location.x;
    _lastTouchY = location.y;

	_moving = YES;
}


@end



#pragma mark AppController

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppController

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[CameraMovementTestView alloc] initWithFrame:frame] autorelease];
}

@end
