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
#import "Isgl3dMatrix4D.h"
#import "Isgl3dVector3D.h"
#import "Isgl3dGLU.h"
#import "Isgl3dView3D.h"
#import "Isgl3dLog.h"

@interface Isgl3dCamera (PrivateMethods)
- (void) calculateViewMatrix;
@end

@implementation Isgl3dCamera

@synthesize viewMatrix = _viewMatrix;
@synthesize projectionMatrix = _projectionMatrix;
@synthesize initialCameraPosition = _initialCameraPosition;
@synthesize initialCameraLookAt = _initialCameraLookAt;
@synthesize isPerspective = _isPerspective;
@synthesize aspect = _aspect;
@synthesize near = _near;
@synthesize far = _far;
@synthesize left = _left;
@synthesize right = _right;
@synthesize bottom = _bottom;
@synthesize top = _top;


- (id) init {
	Isgl3dLog(Warn, @"Camera must be initialized with a View3D.");
	return nil;
}


- (id) initWithView:(Isgl3dView3D *)view {
	
	if (self = [self initWithView:view andCoordinates:0.0f y:0.0f z:10.0f upX:0.0f upY:1.0f upZ:0.0f lookAtX:0.0f lookAtY:0.0f lookAtZ:0.0f]) {
		// Initialization
	}
	
	return self;
}

- (id) initWithView:(Isgl3dView3D *)view andCoordinates:(float)x y:(float)y z:(float)z upX:(float)upX upY:(float)upY upZ:(float)upZ lookAtX:(float)lookAtX lookAtY:(float)lookAtY lookAtZ:(float)lookAtZ {
	
	if (self = [super init]) {
		mv3DFill(&_lookAt, lookAtX, lookAtY, lookAtZ);
		mv3DFill(&_initialCameraPosition, x, y, z);
		mv3DCopy(&_initialCameraLookAt, &_lookAt);
		
		_upX = upX;
		_upY = upY;
		_upZ = upZ;
		
		_zoom = 1;
		_isPerspective = YES;
		
		_width = view.width;
		_height = view.height;
		
		[self setTranslation:x y:y z:z];
		
		_viewMatrix = [[Isgl3dMatrix4D alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	[_viewMatrix release];
	[_projectionMatrix release];

	[super dealloc];
}

- (void) reset {
	mv3DCopy(&_lookAt, &_initialCameraLookAt);
    [self setTranslation:_initialCameraPosition.x y:_initialCameraPosition.y z:_initialCameraPosition.z];	
}

- (void) setPerspectiveProjection:(float)fovy near:(float)near far:(float)far landscape:(BOOL)landscape {
	if (_projectionMatrix) {
		[_projectionMatrix release];
	}
	
	_aspect = _width / _height;
	
	_projectionMatrix = [Isgl3dGLU perspective:fovy aspect:_aspect near:near far:far zoom:_zoom landscape:landscape];
	[_projectionMatrix retain];

	_fov = fovy;
	//Isgl3dLog(Info, @"Fov = %f", _fov);
	_near = near;
	_far = far;
	_isLandscape = landscape;
	
	_top = tan(_fov * M_PI / 360.0) * _near;
	_bottom = -_top;
	_left = _aspect * _bottom;
	_right = _aspect * _top;
	
	if (_isLandscape) {
		_focus = 0.5 * _width / (_zoom * tan(_fov * M_PI / 360.0));
	} else {
		_focus = 0.5 * _height / (_zoom * tan(_fov * M_PI / 360.0));
	}
	
	_isPerspective = YES;
}

- (void) setOrthoProjection:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far landscape:(BOOL)landscape {
	if (_projectionMatrix) {
		[_projectionMatrix release];
	}
	
	_projectionMatrix = [Isgl3dGLU ortho:left right:right bottom:bottom top:top near:near far:far zoom:_zoom landscape:landscape];
	[_projectionMatrix retain];

	_left = left;
	_right = right;
	_bottom = bottom;
	_top = top;
	_near = near;
	_far = far;
	_isLandscape = landscape;

	_isPerspective = NO;
}

- (void) setFov:(float)fov {
	_fov = fov;
	if (_isPerspective) {
		[self setPerspectiveProjection:_fov near:_near far:_far landscape:_isLandscape];
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
			if (_isLandscape) {
				fov = (360.0 / M_PI) * atan2(_width, 2 * _zoom * _focus);
			} else {
				fov = (360.0 / M_PI) * atan2(_height, 2 * _zoom * _focus);
			}
			[self setPerspectiveProjection:fov near:_near far:_far landscape:_isLandscape];
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
			if (_isLandscape) {
				fov = (360.0 / M_PI) * atan2(_width, 2 * _zoom * _focus);
			} else {
				fov = (360.0 / M_PI) * atan2(_height, 2 * _zoom * _focus);
			}
			[self setPerspectiveProjection:fov near:_near far:_far landscape:_isLandscape];
		}
	}	
}

- (float) zoom {
	return _zoom;
}

- (void) setLookAt:(Isgl3dMiniVec3D *)lookAt {
	mv3DCopy(&_lookAt, lookAt);
	_transformationDirty = YES;
}

- (void) lookAt:(float)x y:(float)y z:(float)z {
	mv3DFill(&_lookAt, x, y, z);
	_transformationDirty = YES;
}

- (void) getLookAt:(Isgl3dMiniVec3D *)lookAt {
	mv3DCopy(lookAt, &_lookAt);
}

- (void) getEyeNormal:(Isgl3dMiniVec3D *)eyeNormal {
	mv3DCopy(eyeNormal, &_lookAt);
	[self positionAsMiniVec3D:&_tempVector];
	mv3DSub(eyeNormal, &_tempVector);
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
	mv3DTranslate(&_lookAt, x, y, z);

	_transformationDirty = YES;
}

- (void) rotateLookAtOnX:(float)angle centerY:(float)centerY centerZ:(float)centerZ {
	mv3DRotateX(&_lookAt, angle, centerY, centerZ);

	_transformationDirty = YES;
}

- (void) rotateLookAtOnY:(float)angle centerX:(float)centerX centerZ:(float)centerZ {
	mv3DRotateY(&_lookAt, angle, centerX, centerZ);

	_transformationDirty = YES;
}

- (void) rotateLookAtOnZ:(float)angle centerX:(float)centerX centerY:(float)centerY  {
	mv3DRotateZ(&_lookAt, angle, centerX, centerY);

	_transformationDirty = YES;
}

- (float) getDistanceToLookAt {
	[self positionAsMiniVec3D:&_tempVector];
	mv3DSub(&_tempVector, &_lookAt);
	
	return mv3DLength(&_tempVector);
}

- (void) setDistanceToLookAt:(float)distance {
	[self positionAsMiniVec3D:&_tempVector];
	mv3DSub(&_tempVector, &_lookAt);
	mv3DNormalize(&_tempVector);
	mv3DScale(&_tempVector, distance);
	
	[self setTranslation:_lookAt.x + _tempVector.x y:_lookAt.y + _tempVector.y z:_lookAt.z + _tempVector.z];
}

- (void) setUpX:(float)x y:(float)y z:(float)z {
	_upX = x;
	_upY = y;
	_upZ = z;
	_transformationDirty = YES;
}

- (void) udpateGlobalTransformation:(Isgl3dMatrix4D *)parentTransformation {

	BOOL calculateViewMatrix = _transformationDirty;
	[super udpateGlobalTransformation:parentTransformation];

	if (calculateViewMatrix) {
		[self calculateViewMatrix];
	}
}

- (void) calculateViewMatrix {
	
	[self positionAsMiniVec3D:&_cameraPosition];
	
	[Isgl3dGLU lookAt:_cameraPosition.x eyey:_cameraPosition.y eyez:_cameraPosition.z 
				  centerx:_lookAt.x centery:_lookAt.y centerz:_lookAt.z 
				  upx:_upX upy:_upY upz:_upZ inToMatrix:_viewMatrix];
}

@end
