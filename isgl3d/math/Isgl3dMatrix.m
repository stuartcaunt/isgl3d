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

#import "Isgl3dMatrix.h"
#import "math.h"
#import "Isgl3dLog.h"
#import <TargetConditionals.h>

#if (TARGET_IPHONE_SIMULATOR == 0) && (TARGET_OS_IPHONE == 1)
#define USE_ACC_MATH

#ifdef _ARM_ARCH_7
#define USE_NEON_MATH
#else
#define USE_VFP_MATH
#endif
#endif

#ifdef USE_NEON_MATH
#import "neon/neon_matrix_impl.h"
#endif

#ifdef USE_VFP_MATH
#import "vfp/matrix_impl.h"
#endif

#ifdef USE_VDSP_MATH
#import <Accelerate/Accelerate.h>
#endif


Isgl3dMatrix4 im4PlanarProjectionMatrixFromPosition(Isgl3dVector4 * plane, Isgl3dVector3 * position) {
	float dot = plane->x * position->x + plane->y * position->y + plane->z * position->z + plane->w;
	
	Isgl3dMatrix4 matrix = {
		dot - plane->x * position->x,  - plane->x * position->y,      - plane->x * position->z,      - plane->x,
		    - plane->y * position->x,  dot - plane->y * position->y,  - plane->y * position->z,      - plane->y,
		    - plane->z * position->x,  - plane->z * position->y,      dot - plane->z * position->z,  - plane->z,
		    - plane->w * position->x,  - plane->w * position->y,      - plane->w * position->z,      dot - plane->w
	};
	
	return matrix;
}

Isgl3dMatrix4 im4PlanarProjectionMatrixFromDirection(Isgl3dVector4 * plane, Isgl3dVector3 * direction) {
	float k = -1.0 / (plane->x * direction->x + plane->y * direction->y + plane->z * direction->z);
	
	Isgl3dMatrix4 matrix = {
		1 + k * plane->x * direction->x,      k * plane->x * direction->y,      k * plane->x * direction->z, 0,
		    k * plane->y * direction->x,  1 + k * plane->y * direction->y,      k * plane->y * direction->z, 0,
		    k * plane->z * direction->x,      k * plane->z * direction->y,  1 + k * plane->z * direction->z, 0,
		    k * plane->w * direction->x,      k * plane->w * direction->y,      k * plane->w * direction->z, 1
	};
	
	return matrix;	
}

void im4Invert(Isgl3dMatrix4 * m) {
	// If the determinant is zero then no inverse exists
	float det = im4Determinant(m);

	if (fabs(det) < 1e-8) {
		Isgl3dLog(Error, @"Isgl3dMatrix4: matrix invert request fails");
		return;
	}
	
	float invDet = 1.0 / det;

	float m11 = m->sxx;
	float m12 = m->sxy;
	float m13 = m->sxz;
	float m14 = m->tx;
	float m21 = m->syx;
	float m22 = m->syy;
	float m23 = m->syz;
	float m24 = m->ty;
	float m31 = m->szx;
	float m32 = m->szy;
	float m33 = m->szz;
	float m34 = m->tz; 
	float m41 = m->swx;
	float m42 = m->swy;
	float m43 = m->swz;
	float m44 = m->tw;
	
	m->sxx =  invDet * (m22 * (m33 * m44 - m43 * m34) - m32 * (m23 * m44 - m43 * m24) + m42 * (m23 * m34 - m33 * m24));
	m->sxy = -invDet * (m12 * (m33 * m44 - m43 * m34) - m32 * (m13 * m44 - m43 * m14) + m42 * (m13 * m34 - m33 * m14));
	m->sxz =  invDet * (m12 * (m23 * m44 - m43 * m24) - m22 * (m13 * m44 - m43 * m14) + m42 * (m13 * m24 - m23 * m14));
	m->tx  = -invDet * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));

	m->syx = -invDet * (m21 * (m33 * m44 - m43 * m34) - m31 * (m23 * m44 - m43 * m24) + m41 * (m23 * m34 - m33 * m24));
	m->syy =  invDet * (m11 * (m33 * m44 - m43 * m34) - m31 * (m13 * m44 - m43 * m14) + m41 * (m13 * m34 - m33 * m14));
	m->syz = -invDet * (m11 * (m23 * m44 - m43 * m24) - m21 * (m13 * m44 - m43 * m14) + m41 * (m13 * m24 - m23 * m14));
	m->ty  =  invDet * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));

	m->szx =  invDet * (m21 * (m32 * m44 - m42 * m34) - m31 * (m22 * m44 - m42 * m24) + m41 * (m22 * m34 - m32 * m24));
	m->szy = -invDet * (m11 * (m32 * m44 - m42 * m34) - m31 * (m12 * m44 - m42 * m14) + m41 * (m12 * m34 - m32 * m14));
	m->szz =  invDet * (m11 * (m22 * m44 - m42 * m24) - m21 * (m12 * m44 - m42 * m14) + m41 * (m12 * m24 - m22 * m14));
	m->tz  = -invDet * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));

	m->swx = -invDet * (m21 * (m32 * m43 - m42 * m33) - m31 * (m22 * m43 - m42 * m23) + m41 * (m22 * m33 - m32 * m23));
	m->swy =  invDet * (m11 * (m32 * m43 - m42 * m33) - m31 * (m12 * m43 - m42 * m13) + m41 * (m12 * m33 - m32 * m13));
	m->swz = -invDet * (m11 * (m22 * m43 - m42 * m23) - m21 * (m12 * m43 - m42 * m13) + m41 * (m12 * m23 - m22 * m13));
	m->tw  =  invDet * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13));		
}

void im4Invert3x3(Isgl3dMatrix4 * m) {
	// If the determinant is zero then no inverse exists
	float det = im4Determinant3x3(m);

	if (fabs(det) < 1e-8) {
		Isgl3dLog(Error, @"Isgl3dMatrix4: matrix invert3x3 request fails");
		return;
	}
	
	float invDet = 1 / det;

	float m11 = m->sxx;
	float m12 = m->sxy;
	float m13 = m->sxz;
	float m21 = m->syx;
	float m22 = m->syy;
	float m23 = m->syz;
	float m31 = m->szx;
	float m32 = m->szy;
	float m33 = m->szz;

	m->sxx =  invDet * (m22 * m33 - m32 * m23),
	m->sxy = -invDet * (m12 * m33 - m32 * m13),
	m->sxz =  invDet * (m12 * m23 - m22 * m13),
	m->syx = -invDet * (m21 * m33 - m31 * m23),
	m->syy =  invDet * (m11 * m33 - m31 * m13),
	m->syz = -invDet * (m11 * m23 - m21 * m13),
	m->szx =  invDet * (m21 * m32 - m31 * m22),
	m->szy = -invDet * (m11 * m32 - m31 * m12),
	m->szz =  invDet * (m11 * m22 - m21 * m12),


	m->swx = m->swy = m->swz = 0;
	m->tx = m->ty = m->tz = 0;
	m->tw = 1;	
}

void im4Rotate(Isgl3dMatrix4 * m, float angle, float x, float y, float z) {
		
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
	
	Isgl3dMatrix4 matrix;

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
	
	im4MultiplyOnLeft3x3(m, &matrix);
}

void im4Translate(Isgl3dMatrix4 * m, float x, float y, float z) {
	Isgl3dVector3 v = iv3(x, y, z);
	Isgl3dVector3 tv = im4MultVector3x3(m, &v);

	m->tx += tv.x;
	m->ty += tv.y;
	m->tz += tv.z;
}

void im4TranslateByVector(Isgl3dMatrix4 * m, Isgl3dVector3 * v) {
	Isgl3dVector3 tv = im4MultVector3x3(m, v);

	m->tx += tv.x;
	m->ty += tv.y;
	m->tz += tv.z;
}

void im4Scale(Isgl3dMatrix4 * m, float x, float y, float z) {
		
	Isgl3dVector3 currentScale = im4ToScaleValues(m);
		
		
	m->sxx *= x / currentScale.x;
	m->syx *= x / currentScale.x;
	m->szx *= x / currentScale.x;
	m->sxy *= y / currentScale.y;
	m->syy *= y / currentScale.y;
	m->szy *= y / currentScale.y;
	m->sxz *= z / currentScale.z;
	m->syz *= z / currentScale.z;
	m->szz *= z / currentScale.z;	
}

void im4Transpose(Isgl3dMatrix4 * m) {
	float tmp = m->sxy;
    m->sxy = m->syx;
    m->syx = tmp;
    
    tmp = m->sxz;
    m->sxz = m->szx;
    m->szx = tmp;
    
    tmp = m->tx;
    m->tx = m->swx;
    m->swx = tmp;
    
    tmp = m->syz;
    m->syz = m->szy;
    m->szy = tmp;
    
    tmp = m->ty;
    m->ty = m->swy;
    m->swy = tmp;
    
    tmp = m->tz;
    m->tz = m->swz;
    m->swz = tmp;
	
}

void im4SetRotation(Isgl3dMatrix4 * m, float angle, float x, float y, float z) {

	Isgl3dMatrix4 matrix = im4Identity();
	im4Rotate(&matrix, angle, x, y, z);
	
	m->sxx = matrix.sxx;
	m->sxy = matrix.sxy;
	m->sxz = matrix.sxz;
	m->syx = matrix.syx;
	m->syy = matrix.syy;
	m->syz = matrix.syz;
	m->szx = matrix.szx;
	m->szy = matrix.szy;
	m->szz = matrix.szz;
}

void im4SetRotationFromEuler(Isgl3dMatrix4 * m, float ax, float ay, float az) {
	Isgl3dQuaternion q = iqnCreateFromEuler(ax, ay, az);
//	Isgl3dQuaternion q = iqnCreateFromEuler(ay, az, ax);
	
	im4SetRotationFromQuaternion(m, &q);
}

void im4SetRotationFromQuaternion(Isgl3dMatrix4 * m, Isgl3dQuaternion * q) {
	float x = q->x;
	float y = q->y;
	float z = q->z;
	float w = q->w;
	
	float xy = x * y;
	float xz = x * z;
	float xw = x * w;
	
	float yy = y * y;
	float yz = y * z;
	float yw = y * w;
	
	float zz = z * z;
	float zw = z * w;

	float ww = w * w;
	
	m->sxx = 1 - 2 * (zz + ww);
	m->sxy =     2 * (yz - xw);
	m->sxz =     2 * (xz + yw);
	m->syx =     2 * (yz + xw);
	m->syy = 1 - 2 * (yy + ww);
	m->syz =     2 * (zw - xy);
	m->szx =     2 * (yw - xz);
	m->szy =     2 * (xy + zw);
	m->szz = 1 - 2 * (yy + zz);
}


void im4Multiply(Isgl3dMatrix4 * a, Isgl3dMatrix4 * b)
{
#ifdef USE_ACC_MATH	
	float *mA = im4ColumnMajorFloatArrayFromMatrix(a);
	float *mB = im4ColumnMajorFloatArrayFromMatrix(b);
	
#if defined(USE_NEON_MATH)
	NEON_Matrix4Mul(mB, mA, mA);
#elif defined(USE_VDSP_MATH)
	Isgl3dMatrix4 res = im4CreateEmpty();
	float *mRes = im4ColumnMajorFloatArrayFromMatrix(&res);
	vDSP_mmul(mB, 1, mA, 1, mRes, 1, 4, 4, 4);
	im4Copy(a, &res);
#else
	Matrix4Mul(mB, mA, mA);
#endif

#else
	float m111 = a->sxx;
	float m112 = a->sxy;
	float m113 = a->sxz;
	float m114 = a->tx;
	float m121 = a->syx;
	float m122 = a->syy;
	float m123 = a->syz;
	float m124 = a->ty;
	float m131 = a->szx;
	float m132 = a->szy;
	float m133 = a->szz;
	float m134 = a->tz;
	float m141 = a->swx;
	float m142 = a->swy;
	float m143 = a->swz;
	float m144 = a->tw;
	
	float m211 = b->sxx;
	float m212 = b->sxy;
	float m213 = b->sxz;
	float m214 = b->tx;
	float m221 = b->syx;
	float m222 = b->syy;
	float m223 = b->syz;
	float m224 = b->ty;
	float m231 = b->szx;
	float m232 = b->szy;
	float m233 = b->szz;
	float m234 = b->tz;
	float m241 = b->swx;
	float m242 = b->swy;
	float m243 = b->swz;
	float m244 = b->tw;
	
	a->sxx = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	a->sxy = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	a->sxz = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	a->tx  = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	a->syx = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	a->syy = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	a->syz = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	a->ty  = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	a->szx = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	a->szy = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	a->szz = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	a->tz  = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	a->swx = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	a->swy = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	a->swz = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	a->tw  = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
#endif	
}

void im4MultiplyOnLeft(Isgl3dMatrix4 * a, Isgl3dMatrix4 * b)
{
#ifdef USE_ACC_MATH	
	float *mA = im4ColumnMajorFloatArrayFromMatrix(a);
	float *mB = im4ColumnMajorFloatArrayFromMatrix(b);
	
#if defined(USE_NEON_MATH)
	NEON_Matrix4Mul(mA, mB, mA);
#elif defined(USE_VDSP_MATH)
	Isgl3dMatrix4 res = im4CreateEmpty();
	float *mRes = im4ColumnMajorFloatArrayFromMatrix(&res);
	vDSP_mmul(mA, 1, mB, 1, mRes, 1, 4, 4, 4);
	im4Copy(a, &res);
#else
	Matrix4Mul(mA, mB, mA);
#endif
	
#else
	float m111 = b->sxx;
	float m112 = b->sxy;
	float m113 = b->sxz;
	float m114 = b->tx;
	float m121 = b->syx;
	float m122 = b->syy;
	float m123 = b->syz;
	float m124 = b->ty;
	float m131 = b->szx;
	float m132 = b->szy;
	float m133 = b->szz;
	float m134 = b->tz;
	float m141 = b->swx;
	float m142 = b->swy;
	float m143 = b->swz;
	float m144 = b->tw;
	
	float m211 = a->sxx;
	float m212 = a->sxy;
	float m213 = a->sxz;
	float m214 = a->tx;
	float m221 = a->syx;
	float m222 = a->syy;
	float m223 = a->syz;
	float m224 = a->ty;
	float m231 = a->szx;
	float m232 = a->szy;
	float m233 = a->szz;
	float m234 = a->tz;
	float m241 = a->swx;
	float m242 = a->swy;
	float m243 = a->swz;
	float m244 = a->tw;
	
	a->sxx = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	a->sxy = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	a->sxz = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	a->tx  = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	a->syx = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	a->syy = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	a->syz = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	a->ty  = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	a->szx = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	a->szy = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	a->szz = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	a->tz  = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	a->swx = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	a->swy = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	a->swz = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	a->tw  = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
#endif
}

void im4MultiplyOnLeft3x3(Isgl3dMatrix4 * a, Isgl3dMatrix4 * b) {
	float m111 = b->sxx;
	float m112 = b->sxy;
	float m113 = b->sxz;
	float m121 = b->syx;
	float m122 = b->syy;
	float m123 = b->syz;
	float m131 = b->szx;
	float m132 = b->szy;
	float m133 = b->szz;

	float m211 = a->sxx;
	float m212 = a->sxy;
	float m213 = a->sxz;
	float m221 = a->syx;
	float m222 = a->syy;
	float m223 = a->syz;
	float m231 = a->szx;
	float m232 = a->szy;
	float m233 = a->szz;
	
	a->sxx = m111 * m211 + m112 * m221 + m113 * m231;
	a->sxy = m111 * m212 + m112 * m222 + m113 * m232;
	a->sxz = m111 * m213 + m112 * m223 + m113 * m233;
	a->syx = m121 * m211 + m122 * m221 + m123 * m231;
	a->syy = m121 * m212 + m122 * m222 + m123 * m232;
	a->syz = m121 * m213 + m122 * m223 + m123 * m233;
	a->szx = m131 * m211 + m132 * m221 + m133 * m231;
	a->szy = m131 * m212 + m132 * m222 + m133 * m232;
	a->szz = m131 * m213 + m132 * m223 + m133 * m233;
}	

Isgl3dVector4 im4MultVector4(Isgl3dMatrix4 * m, Isgl3dVector4 * vector)
{
	Isgl3dVector4 result;

#ifdef USE_ACC_MATH
	float *mA = im4ColumnMajorFloatArrayFromMatrix(m);
#if defined(USE_NEON_MATH)
	NEON_Matrix4Vector4Mul(mA, &vector->x, &result.x);
#else
	Matrix4Vector4Mul(mA, &vector->x, &result.x);
#endif
#else
	float ax = vector->x;
	float ay = vector->y;
	float az = vector->z;
	float aw = vector->w;
	
	float vx = m->sxx * ax + m->sxy * ay + m->sxz * az + m->tx * aw;
	float vy = m->syx * ax + m->syy * ay + m->syz * az + m->ty * aw;
	float vz = m->szx * ax + m->szy * ay + m->szz * az + m->tz * aw;
	float vw = m->swx * ax + m->swy * ay + m->swz * az + m->tw * aw;
	
	iv4Fill(&result, vx, vy, vz, vw);
#endif
	return result;
}


Isgl3dVector3 im4MultVector(Isgl3dMatrix4 * m, Isgl3dVector3 * vector) {
	float ax = vector->x;
	float ay = vector->y;
	float az = vector->z;
	
	float vx = m->sxx * ax + m->sxy * ay + m->sxz * az + m->tx;
	float vy = m->syx * ax + m->syy * ay + m->syz * az + m->ty;
	float vz = m->szx * ax + m->szy * ay + m->szz * az + m->tz;

	return iv3(vx, vy, vz);	
} 


Isgl3dVector3 im4MultVector3x3(Isgl3dMatrix4 * m, Isgl3dVector3 * vector) {
	float ax = vector->x;
	float ay = vector->y;
	float az = vector->z;
	
	float vx = m->sxx * ax + m->sxy * ay + m->sxz * az;
	float vy = m->syx * ax + m->syy * ay + m->syz * az;
	float vz = m->szx * ax + m->szy * ay + m->szz * az;

	return iv3(vx, vy, vz);		
} 

void im4MultArray4(Isgl3dMatrix4 * m, float * array) {
	float ax = array[0];
	float ay = array[1];
	float az = array[2];
	float aw = array[3];
	
	float vx = m->sxx * ax + m->sxy * ay + m->sxz * az + m->tx * aw;
	float vy = m->syx * ax + m->syy * ay + m->syz * az + m->ty * aw;
	float vz = m->szx * ax + m->szy * ay + m->szz * az + m->tz * aw;
	float vw = m->swx * ax + m->swy * ay + m->swz * az + m->tw * aw;

	array[0] = vx;
	array[1] = vy;
	array[2] = vz;
	array[3] = vw;
}


Isgl3dVector3 im4ToEulerAngles(Isgl3dMatrix4 * m) {

	// Get rotation about X
	float rotX = -atan2(m->szy, m->szz);
	
	// Create rotation matrix around X
	Isgl3dMatrix4 matrix = im4Identity();
	im4Rotate(&matrix, rotX * 180.0 / M_PI, 1, 0, 0);

	// left-multipy rotation matrix with self to remove X rotation from transformation
	im4MultiplyOnLeft(&matrix, m);
	
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

	return iv3(-rotX * 180.0 / M_PI, rotY * 180.0 / M_PI, rotZ * 180.0 / M_PI);
	
}

Isgl3dVector3 im4ToScaleValues(Isgl3dMatrix4 * m) {

	float scaleX = sqrt(m->sxx*m->sxx + m->syx*m->syx + m->szx*m->szx);
	float scaleY = sqrt(m->sxy*m->sxy + m->syy*m->syy + m->szy*m->szy);
	float scaleZ = sqrt(m->sxz*m->sxz + m->syz*m->syz + m->szz*m->szz);

	return iv3(scaleX, scaleY, scaleZ);

}
