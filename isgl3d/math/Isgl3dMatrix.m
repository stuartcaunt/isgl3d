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

#import "Isgl3dMatrix.h"
#import "Isgl3dMatrix4.h"
#import "Isgl3dVector3.h"
#import "Isgl3dMathUtils.h"
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

void im4Translate(Isgl3dMatrix4 * m, float x, float y, float z) {
	Isgl3dVector3 v =  Isgl3dVector3Make(x, y, z);
    Isgl3dVector3 tv = Isgl3dMatrix4MultiplyVector3(*m, v);

	m->m30 += tv.x;
	m->m31 += tv.y;
	m->m32 += tv.z;
}

void im4TranslateByVector(Isgl3dMatrix4 * m, Isgl3dVector3 * v) {
	Isgl3dVector3 tv = Isgl3dMatrix4MultiplyVector3(*m, *v);

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

    Isgl3dMatrix4 matrix = Isgl3dMatrix4MakeRotation(Isgl3dMathDegreesToRadians(angle), x, y, z);
	
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

Isgl3dVector3 im4ToEulerAngles(Isgl3dMatrix4 * m) {

	// Get rotation about X
	float rotX = -atan2(m->m12, m->m22);
	
	// Create rotation matrix around X
    Isgl3dMatrix4 matrix = Isgl3dMatrix4MakeRotation(Isgl3dMathDegreesToRadians(rotX), 1.0f, 0.0f, 0.0f);

	// left-multipy rotation matrix with self to remove X rotation from transformation
    matrix = Isgl3dMatrix4Multiply(*m, matrix);
	
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

	return Isgl3dVector3Make(-rotX * 180.0 / M_PI, rotY * 180.0 / M_PI, rotZ * 180.0 / M_PI);
	
}

Isgl3dVector3 im4ToScaleValues(Isgl3dMatrix4 * m) {

	float scaleX = sqrt(m->m00*m->m00 + m->m01*m->m01 + m->m02*m->m02);
	float scaleY = sqrt(m->m10*m->m10 + m->m11*m->m11 + m->m12*m->m12);
	float scaleZ = sqrt(m->m20*m->m20 + m->m21*m->m21 + m->m22*m->m22);

	return Isgl3dVector3Make(scaleX, scaleY, scaleZ);

}
