#import "Isgl3dDemoCameraController.h"

@interface Isgl3dDemoCameraController ()
- (void) reset;
- (float) distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2;
@end

/**
 * A Simple camera controller: the camera orbits around the origin or a target node (if one has been set). Single touch
 * movement adds rotation to the camera in altitude and azimuth directions. Double touch will modify the orbital
 * radius of the camera.
 * 
 * This camera controller will only modify the camera if the touches begain in the specified view
 */
@implementation Isgl3dDemoCameraController

@synthesize target = _target;
@synthesize orbit = _orbit;
@synthesize orbitMin = _orbitMin;
@synthesize theta = _theta;
@synthesize phi = _phi;
@synthesize damping = _damping;
@synthesize doubleTapEnabled = _doubleTapEnabled;

- (id) initWithCamera:(Isgl3dCamera *)camera andView:(Isgl3dView *)view {
	
    if ((self = [super init])) {

		_camera = [camera retain];
		_view = [view retain];

		// Initialise the controller
		[self reset];
    }
	
    return self;
}

- (void) dealloc {
	[_camera release];
	[_view release];
	
	if (_target) {
		[_target release];
	}

	[super dealloc];
}

- (void) reset {
	
	// Reset all variables to their defaults
	_orbit = 10;
	_orbitMin = 3;
	_theta = 0;
	_phi = 0;
	_vTheta = 0;
	_vPhi = 0;
	_damping = 0.99;
	_doubleTapEnabled = YES;
	
	// Release the target if it exists and reset camera look-at
	if (_target) {
		[_target release];
		_target = nil;
		
		[_camera lookAt:0 y:0 z:0];
	}
	
}

- (void) update {
	// Update and limit the camera angles
	_theta -= _vTheta;
	_phi -= _vPhi;
	if (_phi >= 90.0) {
		_phi = 89.9;
	}
	if (_phi <= -90.0) {
		_phi = -89.9;
	}
	
	if (_orbit < _orbitMin) {
		_orbit = _orbitMin;
	}
		
	// Convert camera angles to positions
	float y = _orbit * sin(_phi * M_PI / 180);
	float l = _orbit * cos(_phi * M_PI / 180);
	float x = l * sin(_theta * M_PI / 180);
	float z = l * cos(_theta * M_PI / 180);

	// Take target into account if it exists
	if (_target) {
		float targetPosition[4];
		[_target copyPositionTo:targetPosition];
		
		x += targetPosition[0];
		y += targetPosition[1];
		z += targetPosition[2];
		[_camera lookAt:targetPosition[0] y:targetPosition[1] z:targetPosition[2]];
	}

	// Translate camera
	[_camera setTranslation:x y:y z:z];
	
	// Add damping to camera velocities
	_vTheta *= 0.99;
	_vPhi *= 0.99;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// Test for touches if no 3D object has been touched
	if (![Isgl3dDirector sharedInstance].objectTouched && ![Isgl3dDirector sharedInstance].isPaused) {
		
		NSEnumerator * enumerator = [touches objectEnumerator];
		UITouch * touch1 = [enumerator nextObject];
		
		// Test for single touch only
		if ([touches count] == 1) {
			
			// Reset camera controller on double tap (if enabled)...
			if ([touch1 tapCount] >= 2 && _doubleTapEnabled)	{
				[self reset];

			// ... otherwise stop the movement
			} else {
				_vTheta = 0;
				_vPhi = 0;
			}
		}
	}
} 

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// Do nothing
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	if (![Isgl3dDirector sharedInstance].isPaused) {
		NSEnumerator * enumerator = [touches objectEnumerator];
		UITouch * touch1 = [enumerator nextObject];
	
		// For single touch event: set the camera velocities...
		if ([touches count] == 1) {
			CGPoint	location = [_view convertUIPointToView:[touch1 locationInView:touch1.view]];
			CGPoint	previousLocation = [_view convertUIPointToView:[touch1 previousLocationInView:touch1.view]];
		
			_vPhi = (location.y - previousLocation.y) / 4;
			_vTheta = (location.x - previousLocation.x) / 4;
			
		// ... for double touch, modify the orbital distance of the camera
		} else if ([touches count] == 2) {
			UITouch * touch2 = [enumerator nextObject];
			
			CGPoint	location1 = [_view convertUIPointToView:[touch1 locationInView:touch1.view]];
			CGPoint	previousLocation1 = [_view convertUIPointToView:[touch1 previousLocationInView:touch1.view]];
			CGPoint	location2 = [_view convertUIPointToView:[touch2 locationInView:touch2.view]];
			CGPoint	previousLocation2 = [_view convertUIPointToView:[touch2 previousLocationInView:touch2.view]];
			
			float previousDistance = [self distanceBetweenPoint1:previousLocation1 andPoint2:previousLocation2]; 
			float currentDistance = [self distanceBetweenPoint1:location1 andPoint2:location2]; 
			
			float changeInDistance = currentDistance - previousDistance;
			_orbit += changeInDistance * 0.1;
		}
	}
}

/**
 * Calculate the distance between two CGPoints
 */
- (float) distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
	float dx = point1.x - point2.x;
	float dy = point1.y - point2.y;
	
	return sqrt(dx*dx + dy*dy);
}

@end
