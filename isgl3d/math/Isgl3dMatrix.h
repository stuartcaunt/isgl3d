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

#import <Foundation/Foundation.h>
#import "Isgl3dVector.h"
#import "Isgl3dQuaternion.h"

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

/**
 * Simple structure to hold the values of a 4x4 matrix.
 * stored in column-major order
 */
typedef struct {
	float sxx; // 11 Note: removed __attribute__ ((aligned) to compile with LLVM GCC, crashes at run-time otherwise
	float syx; // 21
	float szx; // 31
	float swx; // 41
	float sxy; // 12
	float syy; // 22
	float szy; // 32
	float swy; // 42
	float sxz; // 13
	float syz; // 23
	float szz; // 33
	float swz; // 43
	float tx;  // 14
	float ty;  // 24
	float tz;  // 34
	float tw;  // 44
} Isgl3dMatrix4;


/**
 * Creates an Isgl3dMatrix4 structure from given values.
 * @result A specified matrix.
 */
static inline Isgl3dMatrix4 im4Create(float sxx, float sxy, float sxz, float tx, float syx, float syy, float syz, float ty, float szx, float szy, float szz, float tz, float swx, float swy, float swz, float tw)
{
	Isgl3dMatrix4 matrix = {
		sxx, syx, szx, swx,
		sxy, syy, szy, swy,
		sxz, syz, szz, swz,
		tx,  ty,  tz,  tw };
	return matrix;	
}

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
 * Creates an identity matrix.
 * @result An identity matrix.
 */
static inline Isgl3dMatrix4 im4CreateIdentity()
{
	Isgl3dMatrix4 matrix = {
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1 };
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
					m->sxx, m->sxy, m->sxz, m->tx,
					m->syx, m->syy, m->syz, m->ty,
					m->szx, m->szy, m->szz, m->tz,
					m->swx, m->swy, m->swz, m->tw];	
}

/**
 * Returns the determinant of the full matrix.
 * @param m The matrix.
 * @return The determinant of the full matrix.
 */
static inline float im4Determinant(Isgl3dMatrix4 * m)
{
	return	  (m->sxx * m->syy - m->syx * m->sxy) * (m->szz * m->tw - m->swz * m->tz) 
			- (m->sxx * m->szy - m->szx * m->sxy) * (m->syz * m->tw - m->swz * m->ty) 
			+ (m->sxx * m->swy - m->swx * m->sxy) * (m->syz * m->tz - m->szz * m->ty) 
			+ (m->syx * m->szy - m->szx * m->syy) * (m->sxz * m->tw - m->swz * m->tx) 
			- (m->syx * m->swy - m->swx * m->syy) * (m->sxz * m->tz - m->szz * m->tx) 
			+ (m->szx * m->swy - m->swx * m->szy) * (m->sxz * m->ty - m->syz * m->tx);
}

/**
 * Returns the determinant of the 3x3 part of the matrix.
 * @param m The matrix.
 * @return The determinant of the 3x3 part of the matrix.
 */
static inline float im4Determinant3x3(Isgl3dMatrix4 * m)
{
	return	  (m->sxx * m->syy - m->syx * m->sxy) * m->szz 
			- (m->sxx * m->szy - m->szx * m->sxy) * m->syz 
			+ (m->syx * m->szy - m->szx * m->syy) * m->sxz;	
}

/**
 * Inverts the matrix.
 */
void im4Invert(Isgl3dMatrix4 * m);

/**
 * Inverts the 3x3 part of the matrix.
 */
void im4Invert3x3(Isgl3dMatrix4 * m);

/**
 * Copies the matrix components of one matrix into another.
 * @param a The destination matrix.
 * @param b The source matrix.
 */
static inline void im4Copy(Isgl3dMatrix4 * a, Isgl3dMatrix4 * b)
{
	a->sxx = b->sxx;	a->sxy = b->sxy;	a->sxz = b->sxz;	a->tx  = b->tx;
	a->syx = b->syx;	a->syy = b->syy;	a->syz = b->syz;	a->ty  = b->ty;
	a->szx = b->szx;	a->szy = b->szy;	a->szz = b->szz;	a->tz  = b->tz;
	a->swx = b->swx;	a->swy = b->swy;	a->swz = b->swz;	a->tw  = b->tw;
}

/**
 * Performs a rotation on a matrix around a given axis.
 * @param m The matrix.
 * @param angle The angle of rotation in degrees.
 * @param x The x component of the axis of rotation.
 * @param y The y component of the axis of rotation.
 * @param z The z component of the axis of rotation.
 */
void im4Rotate(Isgl3dMatrix4 * m, float angle, float x, float y, float z);

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
	m->tx = x;
	m->ty = y;
	m->tz = z;	
}

/**
 * Sets the translation components of a matrix stored in a vector. The rotational components
 * are not affected.
 * @param m The matrix.
 * @param translation The translation.
 */
static inline void im4SetTranslationByVector(Isgl3dMatrix4 * m, Isgl3dVector3 * translation)
{
	m->tx = translation->x;
	m->ty = translation->y;
	m->tz = translation->z;	
}

/**
 * Returns the length of the translation of a matrix.
 * @param m The matrix.
 * @return The length of the translation of a matrix.
 */
static inline float im4TranslationLength(Isgl3dMatrix4 * m)
{
	return sqrt(m->tx * m->tx + m->ty * m->ty + m->tz * m->tz);	
}

/**
 * Multiplies two matrices. The result is a = a x b.
 * @param a The left-hand matrix, stores result after calculation.
 * @param b The right-hand matrix.
 */
void im4Multiply(Isgl3dMatrix4 * a, Isgl3dMatrix4 * b);

/**
 * Multiplies two matrices. The result is a = b x a.
 * @param a The right-hand matrix, stores result after calculation.
 * @param b The left-hand matrix.
 */
void im4MultiplyOnLeft(Isgl3dMatrix4 * a, Isgl3dMatrix4 * b);

/**
 * Performs a multiplication on a given matrix with it being on the left, using only the 3x3 part of the matrix.
 * The resulting matrix is stored in "a".
 * The translation components of the matrix are not affected.
 * @param a The matrix to be multiplied on the left, result stored in this matrix. 
 * @param b The matrix to be multiplied on the right. 
 */
void im4MultiplyOnLeft3x3(Isgl3dMatrix4 * a, Isgl3dMatrix4 * b);

/**
 * Performs a multiplication by the matrix on the given 4-component vector.
 * @param m The matrix multiplier. 
 * @param vector The vector to be multiplied.
 * @result The result of the multiplication on given vector
 */
Isgl3dVector4 im4MultVector4(Isgl3dMatrix4 * m, Isgl3dVector4 * vector); 

/**
 * Performs a multiplication by the matrix on the given 3-component vector with the translational components of the matrix included.
 * @param m The matrix multiplier. 
 * @param vector The vector to be multiplied.
 * @result The result of the multiplication on given vector
 */
Isgl3dVector3 im4MultVector(Isgl3dMatrix4 * m, Isgl3dVector3 * vector); 

/**
 * Performs a multiplication on the given 3-component vector with the only the 3x3 part of the matrix.
 * @param m The matrix multiplier. 
 * @param vector The vector to be multiplied.
 * @result The result of the multiplication on given vector
 */
Isgl3dVector3 im4MultVector3x3(Isgl3dMatrix4 * m, Isgl3dVector3 * vector); 

/**
 * Performs a multiplication by the matrix on the array equivalent of a 4-component vector.
 * @param m The matrix multiplier. 
 * @param array The array to be multiplied. Result is stored in the same array.
 */
void im4MultArray4(Isgl3dMatrix4 * m, float * array); 


/**
 * Returns the 3x3 part of a matrix as a column-major float array.
 * @param m The matrix. 
 * @param array The float array into which the column-major representation of the matrix is set.
 */
static inline void im4ConvertTo3x3ColumnMajorFloatArray(Isgl3dMatrix4 * m, float * array)
{
	array[0] = m->sxx; array[1] = m->syx; array[2] = m->szx;
	array[3] = m->sxy; array[4] = m->syy; array[5] = m->szy;
	array[6] = m->sxz; array[7] = m->syz; array[8] = m->szz;
}

/**
 * Returns the full matrix as a column-major float array.
 * @param m The matrix. 
 * @param array The float array into which the column-major representation of the matrix is set.
 */
static inline void im4ConvertToColumnMajorFloatArray(Isgl3dMatrix4 * m, float * array)
{
	array[0]  = m->sxx; array[1]  = m->syx; array[2]  = m->szx; array[3]  = m->swx;
	array[4]  = m->sxy; array[5]  = m->syy; array[6]  = m->szy; array[7]  = m->swy;
	array[8]  = m->sxz; array[9]  = m->syz; array[10] = m->szz; array[11] = m->swz;
	array[12] = m->tx;  array[13] = m->ty;  array[14] = m->tz;  array[15] = m->tw;
}


/**
 * Returns the full matrix as a column-major float array.
 * @param m The matrix. 
 */
static inline float* im4ColumnMajorFloatArrayFromMatrix(Isgl3dMatrix4 * m)
{
	return (&m->sxx);
}


/**
 * Copies data from a column-major (OpenGL standard) transformation in to a matrix.
 * @param m The matrix. 
 * @param t The column-major transformation as a 16 value float array to be copied.
 */
static inline void im4SetTransformationFromOpenGLMatrix(Isgl3dMatrix4 * m, float * t)
{
	m->sxx = t[ 0]; m->syx = t[ 1]; m->szx = t[ 2]; m->swx = t[ 3];
	m->sxy = t[ 4]; m->syy = t[ 5]; m->szy = t[ 6]; m->swy = t[ 7];
	m->sxz = t[ 8]; m->syz = t[ 9]; m->szz = t[10]; m->swz = t[11];
	m->tx  = t[12]; m->ty  = t[13]; m->tz  = t[14]; m->tw  = t[15];
}

/**
 * Copies a matrix into a column-major (OpenGL standard) float array.
 * @param m The matrix. 
 * @param t The column-major transformation as a 16 value float array that will hold the values of this matrix after the call.
 */
static inline void im4GetTransformationAsOpenGLMatrix(Isgl3dMatrix4 * m, float * t)
{
	t[ 0] = m->sxx; t[ 1] = m->syx; t[ 2] = m->szx; t[ 3] = m->swx;
	t[ 4] = m->sxy; t[ 5] = m->syy; t[ 6] = m->szy; t[ 7] = m->swy;
	t[ 8] = m->sxz; t[ 9] = m->syz; t[10] = m->szz; t[11] = m->swz;
	t[12] = m->tx;  t[13] = m->ty;  t[14] = m->tz;  t[15] = m->tw;
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
	return iv3(m->tx, m->ty, m->tz);
}
