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

#import "Isgl3dGLObject3D.h"
#import "Isgl3dMatrix4D.h"
#import "Isgl3dVector3D.h"
#import "Isgl3dVector4D.h"

@implementation Isgl3dGLObject3D

@synthesize transformation = _transformation;

- (id) init {    
    if ((self = [super init])) {

    	_localTransformation = [[Isgl3dMatrix4D alloc] initWithIdentity];
    	_scaleTransformation = [[Isgl3dMatrix4D alloc] initWithIdentity];
    	_transformation = [[Isgl3dMatrix4D alloc] initWithIdentity];
    	
    	_scaling = false;
    	
    	_transformationDirty = YES;
    	
    }
	
    return self;
}

- (void) dealloc {

	[_localTransformation release];
	[_scaleTransformation release];
	[_transformation release];
	if (_position) {
		[_position release];
	}	
	[super dealloc];
}

- (void) rotate:(float)angle x:(float)x y:(float)y z:(float)z {
	[_localTransformation rotate:angle x:x y:y z:z];
	[self setTransformationDirty:YES];
}

- (void) setRotation:(float)angle x:(float)x y:(float)y z:(float)z {
	[_localTransformation setRotation:angle x:x y:y z:z];
	[self setTransformationDirty:YES];
}

- (void) translate:(float)x y:(float)y z:(float)z {
	[_localTransformation translate:x y:y z:z];
	[self setTransformationDirty:YES];
}

- (void) translateByVector:(Isgl3dVector3D *)vector {
	[_localTransformation translate:vector.x y:vector.y z:vector.z];
	[self setTransformationDirty:YES];
}

- (void) moveAlong:(Isgl3dVector3D *)direction distance:(float)distance {
	Isgl3dVector3D * axis = [Isgl3dVector3D vectorFromVector:direction];
	[axis normalize];
	Isgl3dVector3D * transformedAxis = [_transformation multVector3D3x3:axis];
	[self translate:transformedAxis.x * distance y:transformedAxis.y * distance z:transformedAxis.z * distance];
}

- (void) setTranslation:(float)x y:(float)y z:(float)z {
	[_localTransformation setTranslation:x y:y z:z];
	[self setTransformationDirty:YES];
}

- (void) setTranslationVector:(Isgl3dVector3D *)translation {
	[_localTransformation setTranslationVector:translation];
	[self setTransformationDirty:YES];
}

- (void) setTranslationMiniVec3D:(Isgl3dMiniVec3D *)translation {
	[_localTransformation setTranslationMiniVec3D:translation];
	[self setTransformationDirty:YES];
}

- (void) setScale:(float)scale {
	[self setScale:scale scaleY:scale scaleZ:scale];
}

- (void) setScale:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ {
	[_scaleTransformation release];
	if (scaleX != 1.0 || scaleY != 1.0 || scaleZ != 1.0) {
		_scaleTransformation = [[Isgl3dMatrix4D scaleMatrix:scaleX scaleY:scaleY scaleZ:scaleZ] retain];
		_scaling = YES;
	} else {
		_scaleTransformation = [[Isgl3dMatrix4D identityMatrix] retain];
		_scaling = NO;
	}
	[self setTransformationDirty:YES];
}

- (void) resetTransformation {
	[_localTransformation makeIdentity];
	[self setTransformationDirty:YES];
}

- (void) setTransformation:(Isgl3dMatrix4D *)transformation {
	if (transformation != _localTransformation) {
		[_localTransformation release];
	}
	_localTransformation = [transformation retain];
	[self setTransformationDirty:YES];
}

- (void) setTransformationFromOpenGLMatrix:(float *)transformation {
	[_localTransformation setTransformationFromOpenGLMatrix:transformation];
	[self setTransformationDirty:YES];
}

- (void) getTransformationAsOpenGLMatrix:(float *)transformation {
	[_localTransformation getTransformationAsOpenGLMatrix:transformation];
}


- (void) copyPositionTo:(float *)position {
	position[0] = [_transformation tx];
	position[1] = [_transformation ty];
	position[2] = [_transformation tz];
	position[3] = [_transformation tw];
}

- (void) copyPositionFromObject3D:(Isgl3dGLObject3D *)object3D {
	self.x = object3D.x;
	self.y = object3D.y;
	self.z = object3D.z;
	[self setTransformationDirty:YES];
}

- (Isgl3dVector3D *) position {
	if (!_position) {
		_position = [[Isgl3dVector3D alloc] init:[_transformation tx] y:[_transformation ty] z:[_transformation tz]];
	}
	
	return _position;
}

- (void) positionAsMiniVec3D:(Isgl3dMiniVec3D *)position {
	position->x = _transformation.tx;
	position->y = _transformation.ty;
	position->z = _transformation.tz;
}

- (float) x {
	return _localTransformation.tx;
}

- (void) setX:(float)x {
	_localTransformation.tx = x;
	[self setTransformationDirty:YES];
}

- (float) y {
	return _localTransformation.ty;
}

- (void) setY:(float)y {
	_localTransformation.ty = y;
	[self setTransformationDirty:YES];
}

- (float) z {
	return _localTransformation.tz;
}

- (void) setZ:(float)z {
	_localTransformation.tz = z;
	[self setTransformationDirty:YES];
}

- (void) setTransformationDirty:(BOOL)isDirty {
	_transformationDirty = isDirty;
}

- (void) updateGlobalTransformation:(Isgl3dMatrix4D *)parentTransformation {
	if (_transformationDirty) {
		if (parentTransformation) {
			[_transformation copyFrom:parentTransformation];
			[_transformation multiply:_localTransformation];
		
		} else {
			[_transformation copyFrom:_localTransformation];
		}
		
		if (_scaling) {
			[_transformation multiply:_scaleTransformation];
		}
		_transformationDirty = NO;
		
		if (_position) {
			[_position release];
			_position = nil;
		}
	}
}

- (float) getZTransformation:(Isgl3dMatrix4D *)viewMatrix {
	Isgl3dMatrix4D * modelViewMatrix = [[Isgl3dMatrix4D alloc] init];
	[modelViewMatrix copyFrom:viewMatrix];
	[modelViewMatrix multiply:_transformation];
	
	float z = modelViewMatrix.tz;
	
	[modelViewMatrix release];
	
	return z;
}

- (Isgl3dVector4D *) asPlaneWithNormal:(Isgl3dVector4D *)normal {
	
	Isgl3dMatrix4D * transformation = self.transformation;
	Isgl3dVector4D * transformedNormal = [transformation multVector4D:normal]; 
	
	float A = transformedNormal.x;
	float B = transformedNormal.y;
	float C = transformedNormal.z;
	float D = -(A * transformation.tx + B * transformation.ty + C * transformation.tz);
	
	return [Isgl3dVector4D vectorWithX:A y:B z:C w:D];
}

@end
