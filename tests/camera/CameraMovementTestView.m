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

#import "CameraMovementTestView.h"


@interface CameraMovementTestView () {
@private
    Isgl3dFocusZoomPerspectiveLens *_perspectiveLens;
    Isgl3dLookAtCamera *_camera;
}
@property (nonatomic,retain) Isgl3dLookAtCamera *camera;
@end


#pragma mark -
@implementation CameraMovementTestView

@synthesize camera = _camera;

- (id)init {
	
	if ((self = [super init])) {

        _perspectiveLens.focus = 4.0f;
        _perspectiveLens.zoom = 10.0f;
        
		_zoom = _perspectiveLens.zoom;
		//_focus = self.camera.focus;
		_theta = 0.0f;
		_moving = NO;	

		// Create the sphere
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"isgl3d_logo.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dCube * cubeMesh = [Isgl3dCube meshWithGeometry:2 height:2 depth:2 nx:2 ny:2];
		[self.scene createNodeWithMesh:cubeMesh andMaterial:material];
		
		// Add shadow casting light
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
		light.position = Isgl3dVector3Make(5.0f, 10.0f, 10.0f);
		[self.scene addChild:light];
	
		// Initialize accelerometer
		[[Isgl3dAccelerometer sharedInstance] setup:30];	
		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void)dealloc {
    
    _perspectiveLens = nil;
    
	[super dealloc];
}

- (void)createSceneCamera {
    CGSize viewSize = self.viewport.size;
    float fovyRadians = Isgl3dMathDegreesToRadians(45.0f);
    
    Isgl3dFocusZoomPerspectiveLens *perspectiveLens = [[Isgl3dFocusZoomPerspectiveLens alloc] initFromViewSize:viewSize fovyRadians:fovyRadians nearZ:1.0f farZ:10000.0f];
    
    Isgl3dVector3 cameraPosition = Isgl3dVector3Make(0.0f, 5.0f, 15.0f);
    Isgl3dVector3 cameraLookAt = Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
    Isgl3dVector3 cameraLookUp = Isgl3dVector3Make(0.0f, 1.0f, 0.0f);
    Isgl3dLookAtCamera *standardCamera = [[Isgl3dLookAtCamera alloc] initWithLens:perspectiveLens
                                                                             eyeX:cameraPosition.x eyeY:cameraPosition.y eyeZ:cameraPosition.z
                                                                          centerX:cameraLookAt.x centerY:cameraLookAt.y centerZ:cameraLookAt.z
                                                                              upX:cameraLookUp.x upY:cameraLookUp.y upZ:cameraLookUp.z];
    _perspectiveLens = perspectiveLens;
    [perspectiveLens release];
    
    self.camera = standardCamera;
    [standardCamera release];
}

- (void)onActivated {
	[[Isgl3dTouchScreen sharedInstance] addResponder:self];
}

- (void)onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:self];
}

- (void)tick:(float)dt {
	
	float orbitDistance = 5.0f;
	float y = orbitDistance * cos([[Isgl3dAccelerometer sharedInstance] tiltAngle]);
	float radius = orbitDistance * sin([[Isgl3dAccelerometer sharedInstance] tiltAngle]);

	_theta += 0.05 * [[Isgl3dAccelerometer sharedInstance] rotationAngle];
	float x = radius * sin(_theta);
	float z = radius * cos(_theta);
	self.camera.eyePosition = Isgl3dVector3Make(x, y, z);

	if (_moving) {
		_focus += _dFocus;
		_zoom += _dZoom;
		
		if (_zoom < 0.1) {
			_zoom = 0.1;
		}
		if (_focus < 1) {
			_focus = 1;
		}
		
        _perspectiveLens.focus = _focus;
        _perspectiveLens.zoom = _zoom;
		
		_moving = NO;
	}

//	NSLog(@"Angle = %f", [[Accelerometer sharedInstance] rotationAngle] * 180 / M_PI);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch = [enumerator nextObject];

	CGPoint	location = [touch locationInView:touch.view];
    _lastTouchX = location.x;
    _lastTouchY = location.y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_moving = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch = [enumerator nextObject];

	CGPoint	location = [touch locationInView:touch.view];

	_dZoom = (location.x - _lastTouchX) / 20.0f;
	_dFocus = (location.y - _lastTouchY) / 10.0f;

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

- (void)createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;

	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [CameraMovementTestView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
