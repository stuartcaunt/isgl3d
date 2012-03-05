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

#import <Foundation/Foundation.h>
#import "Isgl3dMathTypes.h"
#import "Isgl3dVector.h"
#import "Isgl3dVector3.h"
#import "Isgl3dQuaternion.h"


#pragma mark - iSGL3D specific math
#

#if (TARGET_IPHONE_SIMULATOR == 0) && (TARGET_OS_IPHONE == 1)
#define USE_ACC_MATH

#ifdef _ARM_ARCH_7
#define ISGL3D_MATRIX_MATH_ACCEL @"neon"
#else
#define ISGL3D_MATRIX_MATH_ACCEL @"vfp"
#endif

#endif

#define im4(sxx, sxy, sxz, tx, syx, syy, syz, ty, szx, szy, szz, tz, swx, swy, swz, tw) im4Create(sxx, sxy, sxz, tx, syx, syy, syz, ty, szx, szy, szz, tz, swx, swy, swz, tw)
#define im4Identity() im4CreateIdentity()


#pragma mark -


/**
 * Creates an Isgl3dMatrix4 structure with all values set to 0.
 * @result An empty matrix.
 */
static inline Isgl3dMatrix4 im4CreateEmpty()
{
	Isgl3dMatrix4 matrix = {
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0 };
	return matrix;	
}

/**
 * Creates a matrix structure from a row-major array of 9 values.
 * @param a The row-major array of 9 values.
 * @result A matrix created from the 16 value row-major array.
 */
static inline Isgl3dMatrix4 im4CreateFromArray9(float * a)
{
	Isgl3dMatrix4 matrix = {
		a[0], a[3], a[6], 0,
		a[1], a[4], a[7], 0,
		a[2], a[5], a[8], 0,
		0,    0,    0,    1 };
	return matrix;	
}

/**
 * Creates a matrix structure from a row-major array of 16 values.
 * @param a The row-major array of 16 values.
 * @result A matrix created from the 16 value row-major array.
 */
static inline Isgl3dMatrix4 im4CreateFromArray16(float * a)
{
	Isgl3dMatrix4 matrix = {
		a[0], a[4], a[8],  a[12],
		a[1], a[5], a[9],  a[13],
		a[2], a[6], a[10], a[14],
		a[3], a[7], a[11], a[15] };
	return matrix;	
}

/**
 * Constructs a matrix with values from a column-major float array.
 * The array must contain 16 values.
 * @param a The array of column-major matrix values.
 * @result A matrix created from given OpenGL (column-major) array.
 */
static inline Isgl3dMatrix4 im4CreateFromOpenGL(float * a)
{
	Isgl3dMatrix4 matrix = {
		a[0],  a[1],  a[2],  a[3],
		a[4],  a[5],  a[6],  a[7],
		a[8],  a[9],  a[10], a[11],
		a[12], a[13], a[14], a[15] };
	return matrix;	
}

/**
 * Constructs a matrix used to scale vertices.
 * @param scaleX The scaling along the x-axis.
 * @param scaleY The scaling along the y-axis.
 * @param scaleZ The scaling along the z-axis.
 * @result A new matrix with scale factors.
 */
static inline Isgl3dMatrix4 im4CreateFromScales(float scaleX, float scaleY, float scaleZ)
{
	Isgl3dMatrix4 matrix = {
		scaleX, 0,      0,      0,
		0,      scaleY, 0,      0,
		0,      0,      scaleZ, 0,
		0,      0,      0,      1 };
	return matrix;	
}

/**
 * Constructs a matrix to project all vertices onto a plane from a given position.
 * @param plane Vector representation of the plane.
 * @param position Vector position from which the projection occurs.
 * @result A matrix to flatten vertices onto a plane as projected from a position.
 */
Isgl3dMatrix4 im4PlanarProjectionMatrixFromPosition(Isgl3dVector4 * plane, Isgl3dVector3 * position);

/**
 * Constructs a matrix to project all vertices onto a plane along a given direction.
 * @param plane Vector representation of the plane.
 * @param direction Vector direction along which the projection occurs.
 * @result A matrix to flatten vertices onto a plane as projected along a direction.
 */
Isgl3dMatrix4 im4PlanarProjectionMatrixFromDirection(Isgl3dVector4 * plane, Isgl3dVector3 * direction);

static inline NSString * im4ToString(Isgl3dMatrix4 * m)
{
	return [NSString stringWithFormat:@"\n[%f, %f, %f, %f]\n[%f, %f, %f, %f]\n[%f, %f, %f, %f]\n[%f, %f, %f, %f]",
					m->m00, m->m10, m->m20, m->m30,
					m->m01, m->m11, m->m21, m->m31,
					m->m02, m->m12, m->m22, m->m32,
					m->m03, m->m13, m->m23, m->m33];	
}

/**
 * Returns the determinant of the full matrix.
 * @param m The matrix.
 * @return The determinant of the full matrix.
 */
static inline float im4Determinant(Isgl3dMatrix4 * m)
{
	return	  (m->m00 * m->m11 - m->m01 * m->m10) * (m->m22 * m->m33 - m->m23 * m->m32) 
			- (m->m00 * m->m12 - m->m02 * m->m10) * (m->m21 * m->m33 - m->m23 * m->m31) 
			+ (m->m00 * m->m13 - m->m03 * m->m10) * (m->m21 * m->m32 - m->m22 * m->m31) 
			+ (m->m01 * m->m12 - m->m02 * m->m11) * (m->m20 * m->m33 - m->m23 * m->m30) 
			- (m->m01 * m->m13 - m->m03 * m->m11) * (m->m20 * m->m32 - m->m22 * m->m30) 
			+ (m->m02 * m->m13 - m->m03 * m->m12) * (m->m20 * m->m31 - m->m21 * m->m30);
}

/**
 * Returns the determinant of the 3x3 part of the matrix.
 * @param m The matrix.
 * @return The determinant of the 3x3 part of the matrix.
 */
static inline float im4Determinant3x3(Isgl3dMatrix4 * m)
{
	return	  (m->m00 * m->m11 - m->m01 * m->m10) * m->m22 
			- (m->m00 * m->m12 - m->m02 * m->m10) * m->m21 
			+ (m->m01 * m->m12 - m->m02 * m->m11) * m->m20;	
}

/**
 * Performs a translation on a matrix by a given distance.
 * @param m The matrix.
 * @param x The distance along the x-axis of the translation.
 * @param y The distance along the y-axis of the translation.
 * @param z The distance along the z-axis of the translation.
 */
void im4Translate(Isgl3dMatrix4 * m, float x, float y, float z);

/**
 * Performs a translation on a matrix by a given vector.
 * @param m The matrix.
 * @param v The vector translation.
 */
void im4TranslateByVector(Isgl3dMatrix4 * m, Isgl3dVector3 * v);

/**
 * Performs a scaling on a matrix.
 * @param m The matrix.
 * @param x The amount of scaling in the x-direction.
 * @param y The amount of scaling in the y-direction.
 * @param z The amount of scaling in the z-direction.
 */
void im4Scale(Isgl3dMatrix4 * m, float x, float y, float z);

/**
 * Trasposes the matrix.
 * @param m The matrix.
 */
void im4Transpose(Isgl3dMatrix4 * m);

/**
 * Sets the rotation of a matrix to a specific angle about a specified axis.
 * The translation components of the matrix are not affected.
 * @param m The matrix.
 * @param angle The angle of rotation in degrees.
 * @param x The x component of the axis of rotation.
 * @param y The y component of the axis of rotation.
 * @param z The z component of the axis of rotation.
 */
void im4SetRotation(Isgl3dMatrix4 * m, float angle, float x, float y, float z);

/**
 * Calculates the rotational component of the matrix from euler angles.
 * The translation components of the matrix are not affected.
 * @param m The matrix.
 * @param ax The rotation about the x axis.
 * @param ay The rotation about the y axis.
 * @param az The rotation about the z axis.
 */
void im4SetRotationFromEuler(Isgl3dMatrix4 * m, float ax, float ay, float az);

/**
 * Calculates the rotational component of the matrix from a quaternion.
 * The translation components of the matrix are not affected.
 * @param m The matrix.
 * @param q The quaternion.
 */
void im4SetRotationFromQuaternion(Isgl3dMatrix4 * m, Isgl3dQuaternion * q);

/**
 * Sets the translation components of a matrix. The rotational components
 * are not affected.
 * @param m The matrix.
 * @param x The distance along the x-axis of the translation.
 * @param y The distance along the y-axis of the translation.
 * @param z The distance along the z-axis of the translation.
 */
static inline void im4SetTranslation(Isgl3dMatrix4 * m, float x, float y, float z)
{
	m->m30 = x;
	m->m31 = y;
	m->m32 = z;	
}

/**
 * Sets the translation components of a matrix stored in a vector. The rotational components
 * are not affected.
 * @param m The matrix.
 * @param translation The translation.
 */
static inline void im4SetTranslationByVector(Isgl3dMatrix4 * m, Isgl3dVector3 * translation)
{
	m->m30 = translation->x;
	m->m31 = translation->y;
	m->m32 = translation->z;	
}

/**
 * Returns the length of the translation of a matrix.
 * @param m The matrix.
 * @return The length of the translation of a matrix.
 */
static inline float im4TranslationLength(Isgl3dMatrix4 * m)
{
	return sqrt(m->m30 * m->m30 + m->m31 * m->m31 + m->m32 * m->m32);	
}

/**
 * Returns the 3x3 part of a matrix as a column-major float array.
 * @param m The matrix. 
 * @param array The float array into which the column-major representation of the matrix is set.
 */
static inline void im4ConvertTo3x3ColumnMajorFloatArray(Isgl3dMatrix4 * m, float * array)
{
	array[0] = m->m00; array[1] = m->m01; array[2] = m->m02;
	array[3] = m->m10; array[4] = m->m11; array[5] = m->m12;
	array[6] = m->m20; array[7] = m->m21; array[8] = m->m22;
}

/**
 * Returns the full matrix as a column-major float array.
 * @param m The matrix. 
 * @param array The float array into which the column-major representation of the matrix is set.
 */
static inline void im4ConvertToColumnMajorFloatArray(Isgl3dMatrix4 * m, float * array)
{
	array[0]  = m->m00; array[1]  = m->m01; array[2]  = m->m02; array[3]  = m->m03;
	array[4]  = m->m10; array[5]  = m->m11; array[6]  = m->m12; array[7]  = m->m13;
	array[8]  = m->m20; array[9]  = m->m21; array[10] = m->m22; array[11] = m->m23;
	array[12] = m->m30;  array[13] = m->m31;  array[14] = m->m32;  array[15] = m->m33;
}


/**
 * Returns the full matrix as a column-major float array.
 * @param m The matrix. 
 */
static inline float* im4ColumnMajorFloatArrayFromMatrix(Isgl3dMatrix4 * m)
{
	return (&m->m00);
}


/**
 * Copies data from a column-major (OpenGL standard) transformation in to a matrix.
 * @param m The matrix. 
 * @param t The column-major transformation as a 16 value float array to be copied.
 */
static inline void im4SetTransformationFromOpenGLMatrix(Isgl3dMatrix4 * m, float * t)
{
	m->m00 = t[ 0]; m->m01 = t[ 1]; m->m02 = t[ 2]; m->m03 = t[ 3];
	m->m10 = t[ 4]; m->m11 = t[ 5]; m->m12 = t[ 6]; m->m13 = t[ 7];
	m->m20 = t[ 8]; m->m21 = t[ 9]; m->m22 = t[10]; m->m23 = t[11];
	m->m30  = t[12]; m->m31  = t[13]; m->m32  = t[14]; m->m33  = t[15];
}

/**
 * Copies a matrix into a column-major (OpenGL standard) float array.
 * @param m The matrix. 
 * @param t The column-major transformation as a 16 value float array that will hold the values of this matrix after the call.
 */
static inline void im4GetTransformationAsOpenGLMatrix(Isgl3dMatrix4 * m, float * t)
{
	t[ 0] = m->m00; t[ 1] = m->m01; t[ 2] = m->m02; t[ 3] = m->m03;
	t[ 4] = m->m10; t[ 5] = m->m11; t[ 6] = m->m12; t[ 7] = m->m13;
	t[ 8] = m->m20; t[ 9] = m->m21; t[10] = m->m22; t[11] = m->m23;
	t[12] = m->m30;  t[13] = m->m31;  t[14] = m->m32;  t[15] = m->m33;
}

/**
 * Returns the equivalent Euler angles of the rotational components of a matrix.
 * @param m The matrix. 
 * @result Vector containing the rotations about x, y and z (in degrees)
 */
Isgl3dVector3 im4ToEulerAngles(Isgl3dMatrix4 * m);

/**
 * Returns the equivalent scaling values of a matrix.
 * @param m The matrix. 
 * @result Vector containing the scalex in x, y and z
 */
Isgl3dVector3 im4ToScaleValues(Isgl3dMatrix4 * m);


/**
 * Returns the equivalent scaling values of a matrix.
 * @param m The matrix. 
 * @result Vector containing the scalex in x, y and z
 */
static inline Isgl3dVector3 im4ToPosition(Isgl3dMatrix4 * m) 
{
	return Isgl3dVector3Make(m->m30, m->m31, m->m32);
}

