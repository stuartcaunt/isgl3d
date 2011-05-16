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

#import "Isgl3dCamera.h"
#import "Isgl3dGLU.h"
#import "Isgl3dLog.h"

@interface Isgl3dCamera (PrivateMethods)
- (void) calculateViewMatrix;
- (void) calculateViewProjectionMatrix;
@end

@implementation Isgl3dCamera

@synthesize viewMatrix = _viewMatrix;
@synthesize projectionMatrix = _projectionMatrix;
@synthesize initialCameraPosition = _initialCameraPosition;
@synthesize initialCameraLookAt = _initialCameraLookAt;
@synthesize up = _up;
@synthesize isPerspective = _isPerspective;
@synthesize aspect = _aspect;
@synthesize width = _width;
@synthesize height = _height;
@synthesize near = _near;
@synthesize far = _far;
@synthesize left = _left;
@synthesize right = _right;
@synthesize bottom = _bottom;
@synthesize top = _top;
@synthesize isTargetCamera = _isTargetCamera;

+ (id) camera {
	return [[[self alloc] init] autorelease];
}

+ (id) cameraWithWidth:(float)width andHeight:(float)height {
	return [[[self alloc] initWithWidth:width andHeight:height] autorelease];
}

+ (id) cameraWithWidth:(float)width height:(float)height andCoordinates:(float)x y:(float)y z:(float)z upX:(float)upX upY:(float)upY upZ:(float)upZ lookAtX:(float)lookAtX lookAtY:(float)lookAtY lookAtZ:(float)lookAtZ {
	return [[[self alloc] initWithWidth:width height:height andCoordinates:x y:y z:z upX:upX upY:upY upZ:upZ lookAtX:lookAtX lookAtY:lookAtY lookAtZ:lookAtZ] autorelease];
}


- (id) init {
	return [self initWithWidth:0 height:0 andCoordinates:0.0f y:0.0f z:10.0f upX:0.0f upY:1.0f upZ:0.0f lookAtX:0.0f lookAtY:0.0f lookAtZ:0.0f];
}

- (id) initWithWidth:(float)width andHeight:(float)height {
	
	return [self initWithWidth:width height:height andCoordinates:0.0f y:0.0f z:10.0f upX:0.0f upY:1.0f upZ:0.0f lookAtX:0.0f lookAtY:0.0f lookAtZ:0.0f];
}

- (id) initWithWidth:(float)width height:(float)height andCoordinates:(float)x y:(float)y z:(float)z upX:(float)upX upY:(float)upY upZ:(float)upZ lookAtX:(float)lookAtX lookAtY:(float)lookAtY lookAtZ:(float)lookAtZ {
	
	if ((self = [super init])) {
		iv3Fill(&_lookAt, lookAtX, lookAtY, lookAtZ);
		iv3Fill(&_initialCameraPosition, x, y, z);
		iv3Copy(&_initialCameraLookAt, &_lookAt);
		iv3Fill(&_up, upX, upY, upZ);		
		
		_isTargetCamera = YES;
		
		_zoom = 1;
		_isPerspective = YES;
		
		_viewProjectionMatrixDirty = YES;
		
		_width = width;
		_height = height;
		
		[self setPositionValues:x y:y z:z];

		// Initialise view matrix
		_localTransformationDirty = YES;
		Isgl3dMatrix4 identity = im4Identity();
		[self updateWorldTransformation:&identity];
	}
	
	return self;
}

- (void) dealloc {

	[super dealloc];
}

- (void) reset {
	iv3Copy(&_lookAt, &_initialCameraLookAt);
    [self setPositionValues:_initialCameraPosition.x y:_initialCameraPosition.y z:_initialCameraPosition.z];
}

- (void) setPerspectiveProjection:(float)fovy near:(float)near far:(float)far orientation:(isgl3dOrientation)orientation {
	if (_width == 0 || _height == 0) {
		Isgl3dLog(Error, @"Isgl3dCamera : cannot set perspective projection because width and height of view are unknown.");
		return;
	}
	
	_aspect = _width / _height;
	
	_projectionMatrix = [Isgl3dGLU perspective:fovy aspect:_aspect near:near far:far zoom:_zoom orientation:orientation];

	_fov = fovy;
	//Isgl3dLog(Info, @"Fov = %f", _fov);
	_near = near;
	_far = far;
	
	_orientation = orientation;
	
	_top = tan(_fov * M_PI / 360.0) * _near;
	_bottom = -_top;
	_left = _aspect * _bottom;
	_right = _aspect * _top;
	
	if (_orientation == Isgl3dOrientation90CounterClockwise || _orientation == Isgl3dOrientation90Clockwise) {
		_focus = 0.5 * _width / (_zoom * tan(_fov * M_PI / 360.0));
	} else {
		_focus = 0.5 * _height / (_zoom * tan(_fov * M_PI / 360.0));
	}
	
	_isPerspective = YES;
	
	_viewProjectionMatrixDirty = YES;
}

- (void) setOrthoProjection:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far orientation:(isgl3dOrientation)orientation {
	
	_projectionMatrix = [Isgl3dGLU ortho:left right:right bottom:bottom top:top near:near far:far zoom:_zoom orientation:orientation];

	_left = left;
	_right = right;
	_bottom = bottom;
	_top = top;
	_near = near;
	_far = far;

	_orientation = orientation;

	_isPerspective = NO;

	_viewProjectionMatrixDirty = YES;
}

- (void) setWidth:(float)width andHeight:(float)height {
	if (width != _width || height != _height) {
		_width = width;
		_height = height;
	}
}

- (void) setOrientation:(isgl3dOrientation)orientation {
	_orientation = orientation;
	if (_isPerspective) {
		[self setPerspectiveProjection:_fov near:_near far:_far orientation:_orientation];
		
	} else {
		[self setOrthoProjection:_left right:_right bottom:_bottom top:_top near:_near far:_far orientation:_orientation];
	}
}

- (void) setFov:(float)fov {
	_fov = fov;
	if (_isPerspective) {
		[self setPerspectiveProjection:_fov near:_near far:_far orientation:_orientation];
	}
}

- (float) fov {
	return _fov;
}

- (void) setFocus:(float)focus {
	if (focus > 0) {
		_focus = focus;

		//Isgl3dLog(Info, @"Focus = %f", _focus);
		if (_isPerspective) {
			float fov;
			
			if (_orientation == Isgl3dOrientation90CounterClockwise) {
				fov = (360.0 / M_PI) * atan2(_width, 2 * _zoom * _focus);
			} else {
				fov = (360.0 / M_PI) * atan2(_height, 2 * _zoom * _focus);
			}
			[self setPerspectiveProjection:fov near:_near far:_far orientation:_orientation];
		}
	}	
}

- (float) focus {
	return _focus;
}

- (void) setZoom:(float)zoom {
	if (zoom > 0) {
		_zoom = zoom;

		//Isgl3dLog(Info, @"Zoom = %f", _zoom);
		if (_isPerspective) {
			float fov;
			if (_orientation == Isgl3dOrientation90CounterClockwise) {
				fov = (360.0 / M_PI) * atan2(_width, 2 * _zoom * _focus);
			} else {
				fov = (360.0 / M_PI) * atan2(_height, 2 * _zoom * _focus);
			}
			[self setPerspectiveProjection:fov near:_near far:_far orientation:_orientation];
		}
	}	
}

- (float) zoom {
	return _zoom;
}

- (void) setLookAt:(Isgl3dVector3)lookAt {
	iv3Copy(&_lookAt, &lookAt);
	_localTransformationDirty = YES;
	if (!_isTargetCamera) {
		Isgl3dLog(Warn, @"Isgl3dCamera : not a target camera, setting lookAt has no effect");
	}
}

- (void) lookAt:(float)x y:(float)y z:(float)z {
	iv3Fill(&_lookAt, x, y, z);
	_localTransformationDirty = YES;
}

- (Isgl3dVector3) getLookAt {
	return _lookAt;
}

- (Isgl3dVector3) getEyeNormal {
	Isgl3dVector3 eyeNormal = iv3(_lookAt.x, _lookAt.y, _lookAt.z);
	Isgl3dVector3 position = [self worldPosition];
	iv3Sub(&eyeNormal, &position);
	return eyeNormal;
}

- (float) getLookAtX {
	return _lookAt.x;
}

- (float) getLookAtY {
	return _lookAt.y;
}

- (float) getLookAtZ {
	return _lookAt.z;
}

- (void) translateLookAt:(float)x y:(float)y z:(float)z {
	iv3Translate(&_lookAt, x, y, z);

	_localTransformationDirty = YES;
	if (!_isTargetCamera) {
		Isgl3dLog(Warn, @"Isgl3dCamera : not a target camera, setting lookAt has no effect");
	}
}

- (void) rotateLookAtOnX:(float)angle centerY:(float)centerY centerZ:(float)centerZ {
	iv3RotateX(&_lookAt, angle, centerY, centerZ);

	_localTransformationDirty = YES;
	if (!_isTargetCamera) {
		Isgl3dLog(Warn, @"Isgl3dCamera : not a target camera, setting lookAt has no effect");
	}
}

- (void) rotateLookAtOnY:(float)angle centerX:(float)centerX centerZ:(float)centerZ {
	iv3RotateY(&_lookAt, angle, centerX, centerZ);

	_localTransformationDirty = YES;
	if (!_isTargetCamera) {
		Isgl3dLog(Warn, @"Isgl3dCamera : not a target camera, setting lookAt has no effect");
	}
}

- (void) rotateLookAtOnZ:(float)angle centerX:(float)centerX centerY:(float)centerY  {
	iv3RotateZ(&_lookAt, angle, centerX, centerY);

	_localTransformationDirty = YES;
	if (!_isTargetCamera) {
		Isgl3dLog(Warn, @"Isgl3dCamera : not a target camera, setting lookAt has no effect");
	}
}

- (float) getDistanceToLookAt {
	Isgl3dVector3 position = [self worldPosition];
	return iv3DistanceBetween(&position, &_lookAt);
}

- (void) setDistanceToLookAt:(float)distance {
	Isgl3dVector3 position = [self worldPosition];
	iv3Sub(&position, &_lookAt);
	iv3Normalize(&position);
	iv3Scale(&position, distance);
	
	[self setPositionValues:_lookAt.x + position.x y:_lookAt.y + position.y z:_lookAt.z + position.z];
	if (!_isTargetCamera) {
		Isgl3dLog(Warn, @"Isgl3dCamera : not a target camera, setting lookAt has no effect");
	}
}

- (void) setUpX:(float)x y:(float)y z:(float)z {
	iv3Fill(&_up, x, y, z);		
	_localTransformationDirty = YES;
	if (!_isTargetCamera) {
		Isgl3dLog(Warn, @"Isgl3dCamera : not a target camera, setting \"up\" has no effect");
	}
}

- (void) updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {

	BOOL calculateViewMatrix = (_localTransformationDirty || _transformationDirty);
	[super updateWorldTransformation:parentTransformation];

	if (calculateViewMatrix) {
		[self calculateViewMatrix];
	}
}

- (void) calculateViewMatrix {
	
	_cameraPosition = [self worldPosition];
	
	if (_isTargetCamera) {
		// Calculate view matrix from lookat position
		_viewMatrix = [Isgl3dGLU lookAt:_cameraPosition.x eyey:_cameraPosition.y eyez:_cameraPosition.z 
					  centerx:_lookAt.x centery:_lookAt.y centerz:_lookAt.z 
					  upx:_up.x upy:_up.y upz:_up.z];
	} else {	
		// Calculate view matrix as the inverse of the current world transformation
		im4Copy(&_viewMatrix, &_worldTransformation);
		im4Invert(&_viewMatrix);
	}
		
	_viewProjectionMatrixDirty = YES;
}

- (Isgl3dMatrix4) viewProjectionMatrix {
	if (_viewProjectionMatrixDirty) {
		im4Copy(&_viewProjectionMatrix, &_projectionMatrix);
		im4Multiply(&_viewProjectionMatrix, &_viewMatrix);
		_viewProjectionMatrixDirty = NO;
	}
	return _viewProjectionMatrix;
}

@end
