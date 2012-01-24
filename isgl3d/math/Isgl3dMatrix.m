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

	float m11 = m->m00;
	float m12 = m->m10;
	float m13 = m->m20;
	float m14 = m->m30;
	float m21 = m->m01;
	float m22 = m->m11;
	float m23 = m->m21;
	float m24 = m->m31;
	float m31 = m->m02;
	float m32 = m->m12;
	float m33 = m->m22;
	float m34 = m->m32; 
	float m41 = m->m03;
	float m42 = m->m13;
	float m43 = m->m23;
	float m44 = m->m33;
	
	m->m00 =  invDet * (m22 * (m33 * m44 - m43 * m34) - m32 * (m23 * m44 - m43 * m24) + m42 * (m23 * m34 - m33 * m24));
	m->m10 = -invDet * (m12 * (m33 * m44 - m43 * m34) - m32 * (m13 * m44 - m43 * m14) + m42 * (m13 * m34 - m33 * m14));
	m->m20 =  invDet * (m12 * (m23 * m44 - m43 * m24) - m22 * (m13 * m44 - m43 * m14) + m42 * (m13 * m24 - m23 * m14));
	m->m30  = -invDet * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));

	m->m01 = -invDet * (m21 * (m33 * m44 - m43 * m34) - m31 * (m23 * m44 - m43 * m24) + m41 * (m23 * m34 - m33 * m24));
	m->m11 =  invDet * (m11 * (m33 * m44 - m43 * m34) - m31 * (m13 * m44 - m43 * m14) + m41 * (m13 * m34 - m33 * m14));
	m->m21 = -invDet * (m11 * (m23 * m44 - m43 * m24) - m21 * (m13 * m44 - m43 * m14) + m41 * (m13 * m24 - m23 * m14));
	m->m31  =  invDet * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));

	m->m02 =  invDet * (m21 * (m32 * m44 - m42 * m34) - m31 * (m22 * m44 - m42 * m24) + m41 * (m22 * m34 - m32 * m24));
	m->m12 = -invDet * (m11 * (m32 * m44 - m42 * m34) - m31 * (m12 * m44 - m42 * m14) + m41 * (m12 * m34 - m32 * m14));
	m->m22 =  invDet * (m11 * (m22 * m44 - m42 * m24) - m21 * (m12 * m44 - m42 * m14) + m41 * (m12 * m24 - m22 * m14));
	m->m32  = -invDet * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));

	m->m03 = -invDet * (m21 * (m32 * m43 - m42 * m33) - m31 * (m22 * m43 - m42 * m23) + m41 * (m22 * m33 - m32 * m23));
	m->m13 =  invDet * (m11 * (m32 * m43 - m42 * m33) - m31 * (m12 * m43 - m42 * m13) + m41 * (m12 * m33 - m32 * m13));
	m->m23 = -invDet * (m11 * (m22 * m43 - m42 * m23) - m21 * (m12 * m43 - m42 * m13) + m41 * (m12 * m23 - m22 * m13));
	m->m33  =  invDet * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13));		
}

void im4Invert3x3(Isgl3dMatrix4 * m) {
	// If the determinant is zero then no inverse exists
	float det = im4Determinant3x3(m);

	if (fabs(det) < 1e-8) {
		Isgl3dLog(Error, @"Isgl3dMatrix4: matrix invert3x3 request fails");
		return;
	}
	
	float invDet = 1 / det;

	float m11 = m->m00;
	float m12 = m->m10;
	float m13 = m->m20;
	float m21 = m->m01;
	float m22 = m->m11;
	float m23 = m->m21;
	float m31 = m->m02;
	float m32 = m->m12;
	float m33 = m->m22;

	m->m00 =  invDet * (m22 * m33 - m32 * m23),
	m->m10 = -invDet * (m12 * m33 - m32 * m13),
	m->m20 =  invDet * (m12 * m23 - m22 * m13),
	m->m01 = -invDet * (m21 * m33 - m31 * m23),
	m->m11 =  invDet * (m11 * m33 - m31 * m13),
	m->m21 = -invDet * (m11 * m23 - m21 * m13),
	m->m02 =  invDet * (m21 * m32 - m31 * m22),
	m->m12 = -invDet * (m11 * m32 - m31 * m12),
	m->m22 =  invDet * (m11 * m22 - m21 * m12),


	m->m03 = m->m13 = m->m23 = 0;
	m->m30 = m->m31 = m->m32 = 0;
	m->m33 = 1;	
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
		matrix.m00 = 1;
		matrix.m01 = 0;
		matrix.m02 = 0;
		matrix.m10 = 0;
		matrix.m11 = 1 - 2 * sinA2;
		matrix.m12 = 2 * sinA * cosA;
		matrix.m20 = 0;
		matrix.m21 = -2 * sinA * cosA;
		matrix.m22 = 1 - 2 * sinA2;
		matrix.m03 = matrix.m13 = matrix.m23 = 0;
		matrix.m30 = matrix.m31 = matrix.m32 = 0;
		matrix.m33 = 1;
	} else if (x == 0 && y == 1 && z == 0) {
		matrix.m00 = 1 - 2 * sinA2;
		matrix.m01 = 0;
		matrix.m02 = -2 * sinA * cosA;
		matrix.m10 = 0;
		matrix.m11 = 1;
		matrix.m12 = 0;
		matrix.m20 = 2 * sinA * cosA;
		matrix.m21 = 0;
		matrix.m22 = 1 - 2 * sinA2;
		matrix.m03 = matrix.m13 = matrix.m23 = 0;
		matrix.m30 = matrix.m31 = matrix.m32 = 0;
		matrix.m33 = 1;
	} else if (x == 0 && y == 0 && z == 1) {
		matrix.m00 = 1 - 2 * sinA2;
		matrix.m01 = 2 * sinA * cosA;
		matrix.m02 = 0;
		matrix.m10 = -2 * sinA * cosA;
		matrix.m11 = 1 - 2 * sinA2;
		matrix.m12 = 0;
		matrix.m20 = 0;
		matrix.m21 = 0;
		matrix.m22 = 1;
		matrix.m03 = matrix.m13 = matrix.m23 = 0;
		matrix.m30 = matrix.m31 = matrix.m32 = 0;
		matrix.m33 = 1;
	} else {
		float x2 = x*x;
		float y2 = y*y;
		float z2 = z*z;
	
		matrix.m00 = 1 - 2 * (y2 + z2) * sinA2;
		matrix.m01 = 2 * (x * y * sinA2 + z * sinA * cosA);
		matrix.m02 = 2 * (x * z * sinA2 - y * sinA * cosA);
		matrix.m10 = 2 * (y * x * sinA2 - z * sinA * cosA);
		matrix.m11 = 1 - 2 * (z2 + x2) * sinA2;
		matrix.m12 = 2 * (y * z * sinA2 + x * sinA * cosA);
		matrix.m20 = 2 * (z * x * sinA2 + y * sinA * cosA);
		matrix.m21 = 2 * (z * y * sinA2 - x * sinA * cosA);
		matrix.m22 = 1 - 2 * (x2 + y2) * sinA2;
		matrix.m03 = matrix.m13 = matrix.m23 = 0;
		matrix.m30 = matrix.m31 = matrix.m32 = 0;
		matrix.m33 = 1;
	}	
	
	im4MultiplyOnLeft3x3(m, &matrix);
}

void im4Translate(Isgl3dMatrix4 * m, float x, float y, float z) {
	Isgl3dVector3 v = iv3(x, y, z);
	Isgl3dVector3 tv = im4MultVector3x3(m, &v);

	m->m30 += tv.x;
	m->m31 += tv.y;
	m->m32 += tv.z;
}

void im4TranslateByVector(Isgl3dMatrix4 * m, Isgl3dVector3 * v) {
	Isgl3dVector3 tv = im4MultVector3x3(m, v);

	m->m30 += tv.x;
	m->m31 += tv.y;
	m->m32 += tv.z;
}

void im4Scale(Isgl3dMatrix4 * m, float x, float y, float z) {
		
	Isgl3dVector3 currentScale = im4ToScaleValues(m);
		
		
	m->m00 *= x / currentScale.x;
	m->m01 *= x / currentScale.x;
	m->m02 *= x / currentScale.x;
	m->m10 *= y / currentScale.y;
	m->m11 *= y / currentScale.y;
	m->m12 *= y / currentScale.y;
	m->m20 *= z / currentScale.z;
	m->m21 *= z / currentScale.z;
	m->m22 *= z / currentScale.z;	
}

void im4Transpose(Isgl3dMatrix4 * m) {
	float tmp = m->m10;
    m->m10 = m->m01;
    m->m01 = tmp;
    
    tmp = m->m20;
    m->m20 = m->m02;
    m->m02 = tmp;
    
    tmp = m->m30;
    m->m30 = m->m03;
    m->m03 = tmp;
    
    tmp = m->m21;
    m->m21 = m->m12;
    m->m12 = tmp;
    
    tmp = m->m31;
    m->m31 = m->m13;
    m->m13 = tmp;
    
    tmp = m->m32;
    m->m32 = m->m23;
    m->m23 = tmp;
	
}

void im4SetRotation(Isgl3dMatrix4 * m, float angle, float x, float y, float z) {

	Isgl3dMatrix4 matrix = im4Identity();
	im4Rotate(&matrix, angle, x, y, z);
	
	m->m00 = matrix.m00;
	m->m10 = matrix.m10;
	m->m20 = matrix.m20;
	m->m01 = matrix.m01;
	m->m11 = matrix.m11;
	m->m21 = matrix.m21;
	m->m02 = matrix.m02;
	m->m12 = matrix.m12;
	m->m22 = matrix.m22;
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
	
	m->m00 = 1 - 2 * (zz + ww);
	m->m10 =     2 * (yz - xw);
	m->m20 =     2 * (xz + yw);
	m->m01 =     2 * (yz + xw);
	m->m11 = 1 - 2 * (yy + ww);
	m->m21 =     2 * (zw - xy);
	m->m02 =     2 * (yw - xz);
	m->m12 =     2 * (xy + zw);
	m->m22 = 1 - 2 * (yy + zz);
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
	float m111 = a->m00;
	float m112 = a->m10;
	float m113 = a->m20;
	float m114 = a->m30;
	float m121 = a->m01;
	float m122 = a->m11;
	float m123 = a->m21;
	float m124 = a->m31;
	float m131 = a->m02;
	float m132 = a->m12;
	float m133 = a->m22;
	float m134 = a->m32;
	float m141 = a->m03;
	float m142 = a->m13;
	float m143 = a->m23;
	float m144 = a->m33;
	
	float m211 = b->m00;
	float m212 = b->m10;
	float m213 = b->m20;
	float m214 = b->m30;
	float m221 = b->m01;
	float m222 = b->m11;
	float m223 = b->m21;
	float m224 = b->m31;
	float m231 = b->m02;
	float m232 = b->m12;
	float m233 = b->m22;
	float m234 = b->m32;
	float m241 = b->m03;
	float m242 = b->m13;
	float m243 = b->m23;
	float m244 = b->m33;
	
	a->m00 = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	a->m10 = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	a->m20 = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	a->m30  = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	a->m01 = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	a->m11 = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	a->m21 = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	a->m31  = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	a->m02 = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	a->m12 = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	a->m22 = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	a->m32  = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	a->m03 = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	a->m13 = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	a->m23 = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	a->m33  = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
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
	float m111 = b->m00;
	float m112 = b->m10;
	float m113 = b->m20;
	float m114 = b->m30;
	float m121 = b->m01;
	float m122 = b->m11;
	float m123 = b->m21;
	float m124 = b->m31;
	float m131 = b->m02;
	float m132 = b->m12;
	float m133 = b->m22;
	float m134 = b->m32;
	float m141 = b->m03;
	float m142 = b->m13;
	float m143 = b->m23;
	float m144 = b->m33;
	
	float m211 = a->m00;
	float m212 = a->m10;
	float m213 = a->m20;
	float m214 = a->m30;
	float m221 = a->m01;
	float m222 = a->m11;
	float m223 = a->m21;
	float m224 = a->m31;
	float m231 = a->m02;
	float m232 = a->m12;
	float m233 = a->m22;
	float m234 = a->m32;
	float m241 = a->m03;
	float m242 = a->m13;
	float m243 = a->m23;
	float m244 = a->m33;
	
	a->m00 = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	a->m10 = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	a->m20 = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	a->m30  = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	a->m01 = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	a->m11 = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	a->m21 = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	a->m31  = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	a->m02 = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	a->m12 = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	a->m22 = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	a->m32  = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	a->m03 = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	a->m13 = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	a->m23 = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	a->m33  = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
#endif
}

void im4MultiplyOnLeft3x3(Isgl3dMatrix4 * a, Isgl3dMatrix4 * b) {
	float m111 = b->m00;
	float m112 = b->m10;
	float m113 = b->m20;
	float m121 = b->m01;
	float m122 = b->m11;
	float m123 = b->m21;
	float m131 = b->m02;
	float m132 = b->m12;
	float m133 = b->m22;

	float m211 = a->m00;
	float m212 = a->m10;
	float m213 = a->m20;
	float m221 = a->m01;
	float m222 = a->m11;
	float m223 = a->m21;
	float m231 = a->m02;
	float m232 = a->m12;
	float m233 = a->m22;
	
	a->m00 = m111 * m211 + m112 * m221 + m113 * m231;
	a->m10 = m111 * m212 + m112 * m222 + m113 * m232;
	a->m20 = m111 * m213 + m112 * m223 + m113 * m233;
	a->m01 = m121 * m211 + m122 * m221 + m123 * m231;
	a->m11 = m121 * m212 + m122 * m222 + m123 * m232;
	a->m21 = m121 * m213 + m122 * m223 + m123 * m233;
	a->m02 = m131 * m211 + m132 * m221 + m133 * m231;
	a->m12 = m131 * m212 + m132 * m222 + m133 * m232;
	a->m22 = m131 * m213 + m132 * m223 + m133 * m233;
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
	
	float vx = m->m00 * ax + m->m10 * ay + m->m20 * az + m->m30 * aw;
	float vy = m->m01 * ax + m->m11 * ay + m->m21 * az + m->m31 * aw;
	float vz = m->m02 * ax + m->m12 * ay + m->m22 * az + m->m32 * aw;
	float vw = m->m03 * ax + m->m13 * ay + m->m23 * az + m->m33 * aw;
	
	iv4Fill(&result, vx, vy, vz, vw);
#endif
	return result;
}


Isgl3dVector3 im4MultVector(Isgl3dMatrix4 * m, Isgl3dVector3 * vector) {
	float ax = vector->x;
	float ay = vector->y;
	float az = vector->z;
	
	float vx = m->m00 * ax + m->m10 * ay + m->m20 * az + m->m30;
	float vy = m->m01 * ax + m->m11 * ay + m->m21 * az + m->m31;
	float vz = m->m02 * ax + m->m12 * ay + m->m22 * az + m->m32;

	return iv3(vx, vy, vz);	
} 


Isgl3dVector3 im4MultVector3x3(Isgl3dMatrix4 * m, Isgl3dVector3 * vector) {
	float ax = vector->x;
	float ay = vector->y;
	float az = vector->z;
	
	float vx = m->m00 * ax + m->m10 * ay + m->m20 * az;
	float vy = m->m01 * ax + m->m11 * ay + m->m21 * az;
	float vz = m->m02 * ax + m->m12 * ay + m->m22 * az;

	return iv3(vx, vy, vz);		
} 

void im4MultArray4(Isgl3dMatrix4 * m, float * array) {
	float ax = array[0];
	float ay = array[1];
	float az = array[2];
	float aw = array[3];
	
	float vx = m->m00 * ax + m->m10 * ay + m->m20 * az + m->m30 * aw;
	float vy = m->m01 * ax + m->m11 * ay + m->m21 * az + m->m31 * aw;
	float vz = m->m02 * ax + m->m12 * ay + m->m22 * az + m->m32 * aw;
	float vw = m->m03 * ax + m->m13 * ay + m->m23 * az + m->m33 * aw;

	array[0] = vx;
	array[1] = vy;
	array[2] = vz;
	array[3] = vw;
}


Isgl3dVector3 im4ToEulerAngles(Isgl3dMatrix4 * m) {

	// Get rotation about X
	float rotX = -atan2(m->m12, m->m22);
	
	// Create rotation matrix around X
	Isgl3dMatrix4 matrix = im4Identity();
	im4Rotate(&matrix, rotX * 180.0 / M_PI, 1, 0, 0);

	// left-multipy rotation matrix with self to remove X rotation from transformation
	im4MultiplyOnLeft(&matrix, m);
	
	// Get rotation about Y
	float cosRotY = sqrt(matrix.m00 * matrix.m00 + matrix.m01 * matrix.m01);
	float rotY = atan2(-matrix.m02, cosRotY);
	
	// get rotation about Z
	float rotZ = atan2(-matrix.m10, matrix.m11);
	
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

	float scaleX = sqrt(m->m00*m->m00 + m->m01*m->m01 + m->m02*m->m02);
	float scaleY = sqrt(m->m10*m->m10 + m->m11*m->m11 + m->m12*m->m12);
	float scaleZ = sqrt(m->m20*m->m20 + m->m21*m->m21 + m->m22*m->m22);

	return iv3(scaleX, scaleY, scaleZ);

}
