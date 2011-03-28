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

#import "Isgl3dMatrix4D.h"
#import "Isgl3dVector4D.h"
#import "Isgl3dVector3D.h"
#import "Isgl3dLog.h"

@interface Isgl3dMatrix4D (PrivateMethods) 
- (Isgl3dMatrix4D *) identityTmpMatrix;
@end

@implementation Isgl3dMatrix4D

@synthesize sxx = _sxx;
@synthesize sxy = _sxy;
@synthesize sxz = _sxz;
@synthesize tx  = _tx;
@synthesize syx = _syx;
@synthesize syy = _syy;
@synthesize syz = _syz;
@synthesize ty  = _ty;
@synthesize szx = _szx;
@synthesize szy = _szy;
@synthesize szz = _szz;
@synthesize tz  = _tz;
@synthesize swx = _swx;
@synthesize swy = _swy;
@synthesize swz = _swz;
@synthesize tw  = _tw;

- (id) init {    
	if ((self = [super init])) {
	}
	
	return self;
}

- (id) initWithIdentity {    
	if ((self = [super init])) {
		_sxx = _syy = _szz = _tw = 1.0;
		_sxy = _sxz = _tx  = 0.0;
		_syx = _syz = _ty  = 0.0;
		_swx = _swy = _swz = 0.0;
	}
	
	return self;
}

- (id) initFromMatrix:(Isgl3dMatrix4D*)matrix {    
	if ((self = [super init])) {
		_sxx = matrix.sxx;
		_sxy = matrix.sxy;
		_sxz = matrix.sxz;
		_tx = matrix.tx;
		_syx = matrix.syx;
		_syy = matrix.syy;
		_syz = matrix.syz;
		_ty = matrix.ty;
		_szx = matrix.szx;
		_szy = matrix.szy;
		_szz = matrix.szz;
		_tz = matrix.tz;
		_swx = matrix.swx;
		_swy = matrix.swy;
		_swz = matrix.swz;
		_tw = matrix.tw;
	}
	
	return self;
}

- (id) initFromFloatArray:(float *)array size:(int)size {    
	if ((self = [super init])) {
		if (size != 9 && size != 16) {
			Isgl3dLog(Error, @"Cannot create Isgl3dMatrix4D from array of size %i", size);
	        [self release];
            return nil;
		}

		if (size == 9) {
			_sxx = array[0];
			_sxy = array[1];
			_sxz = array[2];
			_tx  = 0.0;
			_syx = array[3];
			_syy = array[4];
			_syz = array[5];
			_ty  = 0.0;
			_szx = array[6];
			_szy = array[7];
			_szz = array[8];
			_tz  = 0.0;
			_swx = 0.0;
			_swy = 0.0;
			_swz = 0.0;
			_tw  = 1.0;
			
		} else {
			_sxx = array[0];
			_sxy = array[1];
			_sxz = array[2];
			_tx  = array[3];
			_syx = array[4];
			_syy = array[5];
			_syz = array[6];
			_ty  = array[7];
			_szx = array[8];
			_szy = array[9];
			_szz = array[10];
			_tz  = array[11];
			_swx = array[12];
			_swy = array[13];
			_swz = array[14];
			_tw  = array[15];
		}	
	}
	
	return self;
}

- (id) initFromOpenGLMatrix:(float *)array {    
	if ((self = [super init])) {
		_sxx = array[ 0];
		_sxy = array[ 4];
		_sxz = array[ 8];
		_tx  = array[12];
		_syx = array[ 1];
		_syy = array[ 5];
		_syz = array[ 9];
		_ty  = array[13];
		_szx = array[ 2];
		_szy = array[ 6];
		_szz = array[10];
		_tz  = array[14];
		_swx = array[ 3];
		_swy = array[ 7];
		_swz = array[11];
		_tw  = array[15];
	}
	
	return self;
}

- (id) initWithScale:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ {
	if ((self = [super init])) {
		_sxx = scaleX;
		_syy = scaleY;
		_szz = scaleZ;
		_tw = 1.0;
		_sxy = _sxz = _tx  = 0.0;
		_syx = _syz = _ty  = 0.0;
		_swx = _swy = _swz = 0.0;

	}
	
	return self;
}

- (void) dealloc {
	if (_tmpMatrix) {
		[_tmpMatrix release];
	}
	
	[super dealloc];
}

+ (Isgl3dMatrix4D *) matrix {
	return [[[Isgl3dMatrix4D alloc] init] autorelease];
}

+ (Isgl3dMatrix4D *) identityMatrix {
	return [[[Isgl3dMatrix4D alloc] initWithIdentity] autorelease];
}

+ (Isgl3dMatrix4D *) matrixFromMatrix:(Isgl3dMatrix4D*)matrix {
	return [[[Isgl3dMatrix4D alloc] initFromMatrix:matrix] autorelease];
}

+ (Isgl3dMatrix4D *) matrixFromFloatArray:(float *)array size:(int)size {
	return [[[Isgl3dMatrix4D alloc] initFromFloatArray:array size:size] autorelease];
}

+ (Isgl3dMatrix4D *) matrixFromOpenGLMatrix:(float *)array {
	return [[[Isgl3dMatrix4D alloc] initFromOpenGLMatrix:array] autorelease];
}

+ (Isgl3dMatrix4D *) scaleMatrix:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ {
	return [[[Isgl3dMatrix4D alloc] initWithScale:scaleX scaleY:scaleY scaleZ:scaleZ] autorelease];
}

+ (Isgl3dMatrix4D *) planarProjectionMatrix:(Isgl3dVector4D *)plane fromPosition:(Isgl3dVector3D *)position {
	
	float dot = plane.x * position.x + plane.y * position.y + plane.z * position.z + plane.w;
	
	float array[16] = {
		dot - plane.x * position.x,			 -plane.y * position.x,			- plane.z * position.x,			- plane.w * position.x,
			- plane.x * position.y,		dot - plane.y * position.y,			- plane.z * position.y,			- plane.w * position.y,
			- plane.x * position.z,			- plane.y * position.z,		dot - plane.z * position.z,			- plane.w * position.z,
			- plane.x,						- plane.y,						- plane.z,					dot - plane.w
	};
	
	return [[[Isgl3dMatrix4D alloc] initFromFloatArray:array size:16] autorelease];
}

+ (Isgl3dMatrix4D *) planarProjectionMatrix:(Isgl3dVector4D *)plane fromDirection:(Isgl3dVector3D *)direction {
	
	float k = -1.0 / (plane.x * direction.x + plane.y * direction.y + plane.z * direction.z);
	
	float array[16] = {
		1 + k * plane.x * direction.x,		    k * plane.y * direction.x,		    k * plane.z * direction.x,			k * plane.w * direction.x,
			k * plane.x * direction.y,		1 + k * plane.y * direction.y,		    k * plane.z * direction.y,			k * plane.w * direction.y,
			k * plane.x * direction.z,		    k * plane.y * direction.z,		1 + k * plane.z * direction.z,			k * plane.w * direction.z,
			0,									0,									0,									1
	};
	
	return [[[Isgl3dMatrix4D alloc] initFromFloatArray:array size:16] autorelease];
}


- (NSString *) toString {
	return [NSString stringWithFormat:@"\n[%f, %f, %f, %f]\n[%f, %f, %f, %f]\n[%f, %f, %f, %f]\n[%f, %f, %f, %f]",
					_sxx, _sxy, _sxz, _tx,
					_syx, _syy, _syz, _ty,
					_szx, _szy, _szz, _tz,
					_swx, _swy, _swz, _tw];
}

- (void) convertTo3x3ColumnMajorFloatArray:(float *)array {
	array[0] = _sxx;
	array[1] = _syx;
	array[2] = _szx;
	array[3] = _sxy;
	array[4] = _syy;
	array[5] = _szy;
	array[6] = _sxz;
	array[7] = _syz;
	array[8] = _szz;
}

- (void) convertToColumnMajorFloatArray:(float *)array {
	array[0] = _sxx;
	array[1] = _syx;
	array[2] = _szx;
	array[3] = _swx;
	array[4] = _sxy;
	array[5] = _syy;
	array[6] = _szy;
	array[7] = _swy;
	array[8] = _sxz;
	array[9] = _syz;
	array[10] = _szz;
	array[11] = _swz;
	array[12] = _tx;
	array[13] = _ty;
	array[14] = _tz;
	array[15] = _tw;
}


- (void) makeIdentity {
	_sxx = _syy = _szz = _tw = 1;
	_sxy = _sxz = _tx  = 0;
	_syx = _syz = _ty  = 0;
	_szx = _szy = _tz  = 0;
	_swx = _swy = _swz = 0;
}

- (float) determinant {
	return	  (_sxx * _syy - _syx * _sxy) * (_szz * _tw - _swz * _tz) 
			- (_sxx * _szy - _szx * _sxy) * (_syz * _tw - _swz * _ty) 
			+ (_sxx * _swy - _swx * _sxy) * (_syz * _tz - _szz * _ty) 
			+ (_syx * _szy - _szx * _syy) * (_sxz * _tw - _swz * _tx) 
			- (_syx * _swy - _swx * _syy) * (_sxz * _tz - _szz * _tx) 
			+ (_szx * _swy - _swx * _szy) * (_sxz * _ty - _syz * _tx);
}

- (float) determinant3x3 {
	return	  (_sxx * _syy - _syx * _sxy) * _szz 
			- (_sxx * _szy - _szx * _sxy) * _syz 
			+ (_syx * _szy - _szx * _syy) * _sxz;
}

- (void) invert {
	// If the determinant is zero then no inverse exists
	float det = [self determinant];

	if (fabs(det) < 1e-8) {
		Isgl3dLog(Error, @"Isgl3dMatrix4D: matrix invert request fails");
		return;
	}
	
	float invDet = 1.0 / det;

	float m11 = _sxx;
	float m12 = _sxy;
	float m13 = _sxz;
	float m14 = _tx;
	float m21 = _syx;
	float m22 = _syy;
	float m23 = _syz;
	float m24 = _ty;
	float m31 = _szx;
	float m32 = _szy;
	float m33 = _szz;
	float m34 = _tz; 
	float m41 = _swx;
	float m42 = _swy;
	float m43 = _swz;
	float m44 = _tw;
	
	_sxx =  invDet * (m22 * (m33 * m44 - m43 * m34) - m32 * (m23 * m44 - m43 * m24) + m42 * (m23 * m34 - m33 * m24));
	_sxy = -invDet * (m12 * (m33 * m44 - m43 * m34) - m32 * (m13 * m44 - m43 * m14) + m42 * (m13 * m34 - m33 * m14));
	_sxz =  invDet * (m12 * (m23 * m44 - m43 * m24) - m22 * (m13 * m44 - m43 * m14) + m42 * (m13 * m24 - m23 * m14));
	_tx  = -invDet * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));

	_syx = -invDet * (m21 * (m33 * m44 - m43 * m34) - m31 * (m23 * m44 - m43 * m24) + m41 * (m23 * m34 - m33 * m24));
	_syy =  invDet * (m11 * (m33 * m44 - m43 * m34) - m31 * (m13 * m44 - m43 * m14) + m41 * (m13 * m34 - m33 * m14));
	_syz = -invDet * (m11 * (m23 * m44 - m43 * m24) - m21 * (m13 * m44 - m43 * m14) + m41 * (m13 * m24 - m23 * m14));
	_ty  =  invDet * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));

	_szx =  invDet * (m21 * (m32 * m44 - m42 * m34) - m31 * (m22 * m44 - m42 * m24) + m41 * (m22 * m34 - m32 * m24));
	_szy = -invDet * (m11 * (m32 * m44 - m42 * m34) - m31 * (m12 * m44 - m42 * m14) + m41 * (m12 * m34 - m32 * m14));
	_szz =  invDet * (m11 * (m22 * m44 - m42 * m24) - m21 * (m12 * m44 - m42 * m14) + m41 * (m12 * m24 - m22 * m14));
	_tz  = -invDet * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));

	_swx = -invDet * (m21 * (m32 * m43 - m42 * m33) - m31 * (m22 * m43 - m42 * m23) + m41 * (m22 * m33 - m32 * m23));
	_swy =  invDet * (m11 * (m32 * m43 - m42 * m33) - m31 * (m12 * m43 - m42 * m13) + m41 * (m12 * m33 - m32 * m13));
	_swz = -invDet * (m11 * (m22 * m43 - m42 * m23) - m21 * (m12 * m43 - m42 * m13) + m41 * (m12 * m23 - m22 * m13));
	_tw  =  invDet * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13));	
}

- (void) invert3x3 {
	// If the determinant is zero then no inverse exists
	float det = [self determinant3x3];

	if (fabs(det) < 1e-8) {
		Isgl3dLog(Error, @"Isgl3dMatrix4D: matrix invert3x3 request fails");
		return;
	}
	
	float invDet = 1 / det;

	float m11 = _sxx;
	float m12 = _sxy;
	float m13 = _sxz;
	float m21 = _syx;
	float m22 = _syy;
	float m23 = _syz;
	float m31 = _szx;
	float m32 = _szy;
	float m33 = _szz;

	_sxx =  invDet * (m22 * m33 - m32 * m23),
	_sxy = -invDet * (m12 * m33 - m32 * m13),
	_sxz =  invDet * (m12 * m23 - m22 * m13),
	_syx = -invDet * (m21 * m33 - m31 * m23),
	_syy =  invDet * (m11 * m33 - m31 * m13),
	_syz = -invDet * (m11 * m23 - m21 * m13),
	_szx =  invDet * (m21 * m32 - m31 * m22),
	_szy = -invDet * (m11 * m32 - m31 * m12),
	_szz =  invDet * (m11 * m22 - m21 * m12),


	_swx = _swy = _swz = 0;
	_tx = _ty = _tz = 0;
	_tw = 1;
}

- (void) copyFrom:(Isgl3dMatrix4D *)matrix {
	_sxx = matrix.sxx;
	_sxy = matrix.sxy;
	_sxz = matrix.sxz;
	_tx  = matrix.tx;
	_syx = matrix.syx;
	_syy = matrix.syy;
	_syz = matrix.syz;
	_ty  = matrix.ty;
	_szx = matrix.szx;
	_szy = matrix.szy;
	_szz = matrix.szz;
	_tz  = matrix.tz;
	_swx = matrix.swx;
	_swy = matrix.swy;
	_swz = matrix.swz;
	_tw  = matrix.tw;
}

- (void) copyFromMiniMat4D:(Isgl3dMiniMat4D *)matrix {
	_sxx = matrix->sxx;
	_sxy = matrix->sxy;
	_sxz = matrix->sxz;
	_tx  = matrix->tx;
	_syx = matrix->syx;
	_syy = matrix->syy;
	_syz = matrix->syz;
	_ty  = matrix->ty;
	_szx = matrix->szx;
	_szy = matrix->szy;
	_szz = matrix->szz;
	_tz  = matrix->tz;
	_swx = matrix->swx;
	_swy = matrix->swy;
	_swz = matrix->swz;
	_tw  = matrix->tw;
}


- (void) rotate:(float)angle x:(float)x y:(float)y z:(float)z {
		
	// angles are in degrees. Switch to radians
	angle = angle / 180 * M_PI;
	
	angle /= 2.0;
	float sinA = sin(angle);
	float cosA = cos(angle);
	float sinA2 = sinA * sinA;
	
	// normalize
	float length = sqrt(x * x + y * y + z * z);
	if (length == 0) {
		// bad vector, just use something reasonable
		x = 0;
		y = 0;
		z = 1;
	} else if (length != 1) {
		x /= length;
		y /= length;
		z /= length;
	}
	
	Isgl3dMatrix4D* matrix = [self identityTmpMatrix];

	// optimize case where axis is along major axis
	if (x == 1 && y == 0 && z == 0) {
		matrix.sxx = 1;
		matrix.syx = 0;
		matrix.szx = 0;
		matrix.sxy = 0;
		matrix.syy = 1 - 2 * sinA2;
		matrix.szy = 2 * sinA * cosA;
		matrix.sxz = 0;
		matrix.syz = -2 * sinA * cosA;
		matrix.szz = 1 - 2 * sinA2;
		matrix.swx = matrix.swy = matrix.swz = 0;
		matrix.tx = matrix.ty = matrix.tz = 0;
		matrix.tw = 1;
	} else if (x == 0 && y == 1 && z == 0) {
		matrix.sxx = 1 - 2 * sinA2;
		matrix.syx = 0;
		matrix.szx = -2 * sinA * cosA;
		matrix.sxy = 0;
		matrix.syy = 1;
		matrix.szy = 0;
		matrix.sxz = 2 * sinA * cosA;
		matrix.syz = 0;
		matrix.szz = 1 - 2 * sinA2;
		matrix.swx = matrix.swy = matrix.swz = 0;
		matrix.tx = matrix.ty = matrix.tz = 0;
		matrix.tw = 1;
	} else if (x == 0 && y == 0 && z == 1) {
		matrix.sxx = 1 - 2 * sinA2;
		matrix.syx = 2 * sinA * cosA;
		matrix.szx = 0;
		matrix.sxy = -2 * sinA * cosA;
		matrix.syy = 1 - 2 * sinA2;
		matrix.szy = 0;
		matrix.sxz = 0;
		matrix.syz = 0;
		matrix.szz = 1;
		matrix.swx = matrix.swy = matrix.swz = 0;
		matrix.tx = matrix.ty = matrix.tz = 0;
		matrix.tw = 1;
	} else {
		float x2 = x*x;
		float y2 = y*y;
		float z2 = z*z;
	
		matrix.sxx = 1 - 2 * (y2 + z2) * sinA2;
		matrix.syx = 2 * (x * y * sinA2 + z * sinA * cosA);
		matrix.szx = 2 * (x * z * sinA2 - y * sinA * cosA);
		matrix.sxy = 2 * (y * x * sinA2 - z * sinA * cosA);
		matrix.syy = 1 - 2 * (z2 + x2) * sinA2;
		matrix.szy = 2 * (y * z * sinA2 + x * sinA * cosA);
		matrix.sxz = 2 * (z * x * sinA2 + y * sinA * cosA);
		matrix.syz = 2 * (z * y * sinA2 - x * sinA * cosA);
		matrix.szz = 1 - 2 * (x2 + y2) * sinA2;
		matrix.swx = matrix.swy = matrix.swz = 0;
		matrix.tx = matrix.ty = matrix.tz = 0;
		matrix.tw = 1;
	}	
	
	[self multiplyOnLeft3x3:matrix];
}


- (void) translate:(float)x y:(float)y z:(float)z {
	Isgl3dMatrix4D* matrix = [self identityTmpMatrix];
	 matrix.tx = x;
	 matrix.ty = y;
	 matrix.tz = z;

	[self multiplyOnLeft:matrix];
}

- (void) scale:(float)x y:(float)y z:(float)z {
		
	_sxx *= x;
	_syx *= x;
	_szx *= x;
	_sxy *= y;
	_syy *= y;
	_szy *= y;
	_sxz *= z;
	_syz *= z;
	_szz *= z;
}

- (void) transpose {
	
	float tmp = _sxy;
    _sxy = _syx;
    _syx = tmp;
    
    tmp = _sxz;
    _sxz = _szx;
    _szx = tmp;
    
    tmp = _tx;
    _tx = _swx;
    _swx = tmp;
    
    tmp = _syz;
    _syz = _szy;
    _szy = tmp;
    
    tmp = _ty;
    _ty = _swy;
    _swy = tmp;
    
    tmp = _tz;
    _tz = _swz;
    _swz = tmp;
}

- (void) setRotation:(float)angle x:(float)x y:(float)y z:(float)z {
	
	Isgl3dMatrix4D* matrix = [self identityTmpMatrix];
	[matrix rotate:angle x:x y:y z:z];
	
	_sxx = matrix.sxx;
	_sxy = matrix.sxy;
	_sxz = matrix.sxz;
	_syx = matrix.syx;
	_syy = matrix.syy;
	_syz = matrix.syz;
	_szx = matrix.szx;
	_szy = matrix.szy;
	_szz = matrix.szz;
}

- (void) setTranslation:(float)x y:(float)y z:(float)z {
	
	_tx = x;
	_ty = y;
	_tz = z;
}

- (void) setTranslationVector:(Isgl3dVector3D *)translation {
	_tx = translation.x;
	_ty = translation.y;
	_tz = translation.z;
}

- (void) setTranslationMiniVec3D:(Isgl3dMiniVec3D *)translation {
	_tx = translation->x;
	_ty = translation->y;
	_tz = translation->z;
}


- (float) translationLength {
	return sqrt(_tx * _tx + _ty * _ty + _tz * _tz);
}


/**
 * Result is: this = this x matrix
 */
- (void) multiply:(Isgl3dMatrix4D *)matrix {
	
	float m111 = _sxx;
	float m112 = _sxy;
	float m113 = _sxz;
	float m114 = _tx;
	float m121 = _syx;
	float m122 = _syy;
	float m123 = _syz;
	float m124 = _ty;
	float m131 = _szx;
	float m132 = _szy;
	float m133 = _szz;
	float m134 = _tz;
	float m141 = _swx;
	float m142 = _swy;
	float m143 = _swz;
	float m144 = _tw;
	
	float m211 = matrix.sxx;
	float m212 = matrix.sxy;
	float m213 = matrix.sxz;
	float m214 = matrix.tx;
	float m221 = matrix.syx;
	float m222 = matrix.syy;
	float m223 = matrix.syz;
	float m224 = matrix.ty;
	float m231 = matrix.szx;
	float m232 = matrix.szy;
	float m233 = matrix.szz;
	float m234 = matrix.tz;
	float m241 = matrix.swx;
	float m242 = matrix.swy;
	float m243 = matrix.swz;
	float m244 = matrix.tw;
	
	_sxx = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	_sxy = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	_sxz = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	_tx  = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	_syx = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	_syy = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	_syz = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	_ty  = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	_szx = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	_szy = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	_szz = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	_tz  = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	_swx = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	_swy = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	_swz = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	_tw  = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
}

/**
 * Result is: this = matrix x this
 */
- (void) multiplyOnLeft:(Isgl3dMatrix4D *)matrix {
	
	float m111 = matrix.sxx;
	float m112 = matrix.sxy;
	float m113 = matrix.sxz;
	float m114 = matrix.tx;
	float m121 = matrix.syx;
	float m122 = matrix.syy;
	float m123 = matrix.syz;
	float m124 = matrix.ty;
	float m131 = matrix.szx;
	float m132 = matrix.szy;
	float m133 = matrix.szz;
	float m134 = matrix.tz;
	float m141 = matrix.swx;
	float m142 = matrix.swy;
	float m143 = matrix.swz;
	float m144 = matrix.tw;

	float m211 = _sxx;
	float m212 = _sxy;
	float m213 = _sxz;
	float m214 = _tx;
	float m221 = _syx;
	float m222 = _syy;
	float m223 = _syz;
	float m224 = _ty;
	float m231 = _szx;
	float m232 = _szy;
	float m233 = _szz;
	float m234 = _tz;
	float m241 = _swx;
	float m242 = _swy;
	float m243 = _swz;
	float m244 = _tw;
	
	_sxx = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	_sxy = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	_sxz = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	_tx  = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	_syx = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	_syy = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	_syz = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	_ty  = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	_szx = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	_szy = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	_szz = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	_tz  = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	_swx = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	_swy = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	_swz = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	_tw  = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
}

/**
 * Result is: this = matrix x this (using only 3x3 part)
 */
- (void) multiplyOnLeft3x3:(Isgl3dMatrix4D *)matrix {
	
	float m111 = matrix.sxx;
	float m112 = matrix.sxy;
	float m113 = matrix.sxz;
	float m121 = matrix.syx;
	float m122 = matrix.syy;
	float m123 = matrix.syz;
	float m131 = matrix.szx;
	float m132 = matrix.szy;
	float m133 = matrix.szz;

	float m211 = _sxx;
	float m212 = _sxy;
	float m213 = _sxz;
	float m221 = _syx;
	float m222 = _syy;
	float m223 = _syz;
	float m231 = _szx;
	float m232 = _szy;
	float m233 = _szz;
	
	_sxx = m111 * m211 + m112 * m221 + m113 * m231;
	_sxy = m111 * m212 + m112 * m222 + m113 * m232;
	_sxz = m111 * m213 + m112 * m223 + m113 * m233;
	_syx = m121 * m211 + m122 * m221 + m123 * m231;
	_syy = m121 * m212 + m122 * m222 + m123 * m232;
	_syz = m121 * m213 + m122 * m223 + m123 * m233;
	_szx = m131 * m211 + m132 * m221 + m133 * m231;
	_szy = m131 * m212 + m132 * m222 + m133 * m232;
	_szz = m131 * m213 + m132 * m223 + m133 * m233;
}

- (void) multVec4:(float *)vector {
	float ax = vector[0];
	float ay = vector[1];
	float az = vector[2];
	float aw = vector[3];
	
	float vx = _sxx * ax + _sxy * ay + _sxz * az + _tx * aw;
	float vy = _syx * ax + _syy * ay + _syz * az + _ty * aw;
	float vz = _szx * ax + _szy * ay + _szz * az + _tz * aw;
	float vw = _swx * ax + _swy * ay + _swz * az + _tw * aw;
	
	vector[0] = vx;
	vector[1] = vy;
	vector[2] = vz;
	vector[3] = vw;
}

- (void) multVec3:(float *)vector {
	float ax = vector[0];
	float ay = vector[1];
	float az = vector[2];
	
	float vx = _sxx * ax + _sxy * ay + _sxz * az + _tx;
	float vy = _syx * ax + _syy * ay + _syz * az + _ty;
	float vz = _szx * ax + _szy * ay + _szz * az + _tz;
	
	vector[0] = vx;
	vector[1] = vy;
	vector[2] = vz;
}

- (void) multMiniVec3D:(Isgl3dMiniVec3D *)vector inToResult:(Isgl3dMiniVec3D *)result {
	result->x = _sxx * vector->x + _sxy * vector->y + _sxz * vector->z + _tx;
	result->y = _syx * vector->x + _syy * vector->y + _syz * vector->z + _ty;
	result->z = _szx * vector->x + _szy * vector->y + _szz * vector->z + _tz;
}

- (Isgl3dVector4D *) multVector4D:(Isgl3dVector4D *)vector {
	float ax = vector.x;
	float ay = vector.y;
	float az = vector.z;
	float aw = vector.w;
	
	float vx = _sxx * ax + _sxy * ay + _sxz * az + _tx * aw;
	float vy = _syx * ax + _syy * ay + _syz * az + _ty * aw;
	float vz = _szx * ax + _szy * ay + _szz * az + _tz * aw;
	float vw = _swx * ax + _swy * ay + _swz * az + _tw * aw;

	return [Isgl3dVector4D vectorWithX:vx y:vy z:vz w:vw];	
}

- (Isgl3dVector3D *) multVector3D:(Isgl3dVector3D *)vector {
	float ax = vector.x;
	float ay = vector.y;
	float az = vector.z;
	
	float vx = _sxx * ax + _sxy * ay + _sxz * az + _tx;
	float vy = _syx * ax + _syy * ay + _syz * az + _ty;
	float vz = _szx * ax + _szy * ay + _szz * az + _tz;

	return [Isgl3dVector3D vectorWithX:vx y:vy z:vz];	
}

- (Isgl3dVector3D *) multVector3D3x3:(Isgl3dVector3D *)vector {
	float ax = vector.x;
	float ay = vector.y;
	float az = vector.z;
	
	float vx = _sxx * ax + _sxy * ay + _sxz * az;
	float vy = _syx * ax + _syy * ay + _syz * az;
	float vz = _szx * ax + _szy * ay + _szz * az;

	return [Isgl3dVector3D vectorWithX:vx y:vy z:vz];	
}


- (void) setTransformationFromOpenGLMatrix:(float *)transformation {
	_sxx = transformation[ 0];
	_sxy = transformation[ 4];
	_sxz = transformation[ 8];
	_tx  = transformation[12];
	_syx = transformation[ 1];
	_syy = transformation[ 5];
	_syz = transformation[ 9];
	_ty  = transformation[13];
	_szx = transformation[ 2];
	_szy = transformation[ 6];
	_szz = transformation[10];
	_tz  = transformation[14];
	_swx = transformation[ 3];
	_swy = transformation[ 7];
	_swz = transformation[11];
	_tw  = transformation[15];
}

- (void) getTransformationAsOpenGLMatrix:(float *)transformation {
	 transformation[ 0] = _sxx;
	 transformation[ 4] = _sxy;
	 transformation[ 8] = _sxz;
	 transformation[12] = _tx;
	 transformation[ 1] = _syx;
	 transformation[ 5] = _syy;
	 transformation[ 9] = _syz;
	 transformation[13] = _ty;
	 transformation[ 2] = _szx;
	 transformation[ 6] = _szy;
	 transformation[10] = _szz;
	 transformation[14] = _tz;
	 transformation[ 3] = _swx;
	 transformation[ 7] = _swy;
	 transformation[11] = _swz;
	 transformation[15] = _tw;
}

- (Isgl3dVector3D *) toEulerAngles {

//	float roty = -asin(_szx);
//	Isgl3dLog(Info, @"rotY = %f", -asin(_szx) * 180 / M_PI);
//	Isgl3dLog(Info, @"rotX = %f", acos(_szy / cos(roty)) * 180 / M_PI);
//	Isgl3dLog(Info, @"rotZ = %f", asin(_syx / cos(roty)) * 180 / M_PI);
	
	// Get rotation about X
	float rotX = -atan2(_szy, _szz);
	
	// Create rotation matrix around X 
	Isgl3dMatrix4D* matrix = [self identityTmpMatrix];
	[matrix rotate:rotX * 180.0 / M_PI x:1 y:0 z:0];

	// left-multipy rotation matrix with self to remove X rotation from transformation
	[matrix multiplyOnLeft:self];
	
	// Get rotation about Y
	float cosRotY = sqrt(matrix.sxx * matrix.sxx + matrix.syx * matrix.syx);
	float rotY = atan2(-matrix.szx, cosRotY);
	
	// get rotation about Z
	float rotZ = atan2(-matrix.sxy, matrix.syy);
	
	// Fix angles (from Away3D)
	if (lroundf(rotZ / M_PI) == 1) {
		if (rotY > 0) {
			rotY = -(rotY - M_PI);
		} else {
			rotY = -(rotY + M_PI);
		}
		
		rotZ -= M_PI;
		
		if (rotX > 0) {
			rotX -= M_PI;
		} else {
			rotX += M_PI;
		}
		
	} else if (lroundf(rotZ / M_PI) == -1) {
		if (rotY > 0)
			rotY = -(rotY - M_PI);
		else
			rotY = -(rotY + M_PI);

		rotZ += M_PI;
		
		if (rotX > 0) {
			rotX -= M_PI;
		} else {
			rotX += M_PI;
		}

	} else if (lroundf(rotX / M_PI) == 1) {
		if (rotY > 0) {
			rotY = -(rotY - M_PI);
		} else {
			rotY = -(rotY + M_PI);
		}
		
		rotX -= M_PI;
		
		if (rotZ > 0) {
			rotZ -= M_PI;
		} else {
			rotZ += M_PI;
		}
		
	} else if (lroundf(rotX / M_PI) == -1) {
		if (rotY > 0) {
			rotY = -(rotY - M_PI);
		} else {
			rotY = -(rotY + M_PI);
		}
		
		rotX += M_PI;
		
		if (rotZ > 0) {
			rotZ -= M_PI;
		} else {
			rotZ += M_PI;
		}
	}

	return [Isgl3dVector3D vectorWithX:-rotX * 180.0 / M_PI y:rotY * 180.0 / M_PI z:rotZ * 180.0 / M_PI];
	
}

- (Isgl3dVector3D *) toScaleValues {

	float scaleX = sqrt(_sxx*_sxx + _syx*_syx + _szx*_szx);
	float scaleY = sqrt(_sxy*_sxy + _syy*_syy + _szy*_szy);
	float scaleZ = sqrt(_sxz*_sxz + _syz*_syz + _szz*_szz);

	return [Isgl3dVector3D vectorWithX:scaleX y:scaleY z:scaleZ];

}

- (Isgl3dMatrix4D *) identityTmpMatrix {
	if (_tmpMatrix) {
		[_tmpMatrix makeIdentity];
	} else {
		_tmpMatrix = [[Isgl3dMatrix4D alloc] initWithIdentity];
	}
	
	return _tmpMatrix;
}

@end
