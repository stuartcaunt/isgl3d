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
#include "Isgl3dMiniMat.h"

/**
 * The Isgl3dMatrix4D is used to contain data for a 4x4 matrix used for all transformations in iSGL3D.
 * 
 * Matrices in iSGL3D are row-major and are constructed as follows:
 * 
 * | sxx, sxy, sxz,  tx |
 * 
 * | syx, syy, syz,  ty |
 * 
 * | szx, szy, szz,  tz |
 * 
 * | swx, swy, swz,  tw |
 * 
 * 
 * WARNING: This class is deprecated and will be removed in v1.2
 * The functionality of this class can be performed using the Isgl3dMatrix4 with c utilities. This can produce a significant performance gain.
 * 
 * @deprecated Will be removed in v1.2
 */
@interface Isgl3dMatrix4D : NSObject {
	    
	
@private
	float _sxx;
	float _sxy;
	float _sxz;
	float _tx;
	float _syx;
	float _syy;
	float _syz;
	float _ty;
	float _szx;
	float _szy;
	float _szz;
	float _tz;
	float _swx;
	float _swy;
	float _swz;
	float _tw;

	Isgl3dMatrix4D * _tmpMatrix;

}

/**
 * The sxx component of the matrix
 */
@property float sxx;

/**
 * The sxy component of the matrix
 */
@property float sxy;

/**
 * The sxz component of the matrix
 */
@property float sxz;

/**
 * The tx component of the matrix
 */
@property float tx;

/**
 * The syx component of the matrix
 */
@property float syx;

/**
 * The syy component of the matrix
 */
@property float syy;

/**
 * The syz component of the matrix
 */
@property float syz;

/**
 * The ty component of the matrix
 */
@property float ty;

/**
 * The szx component of the matrix
 */
@property float szx;

/**
 * The szy component of the matrix
 */
@property float szy;

/**
 * The szz component of the matrix
 */
@property float szz;

/**
 * The tz component of the matrix
 */
@property float tz;

/**
 * The swx component of the matrix
 */
@property float swx;

/**
 * The swy component of the matrix
 */
@property float swy;

/**
 * The swz component of the matrix
 */
@property float swz;

/**
 * The tw component of the matrix
 */
@property float tw;


/**
 * Constructs a matrix with no initialisation of the components
 * @result (autorelease) A new matrix with no initialisations of values.
 */
+ (Isgl3dMatrix4D *) matrix;

/**
 * Constructs an identity matrix
 * @result (autorelease) A new identity matrix.
 */
+ (Isgl3dMatrix4D *) identityMatrix;

/**
 * Constructs a matrix with values copied from another.
 * @param matrix The original matrix to be copied.
 * @result (autorelease) A matrix copied from given matrix.
 */
+ (Isgl3dMatrix4D *) matrixFromMatrix:(Isgl3dMatrix4D*)matrix;

/**
 * Constructs a matrix with values from a row-major float array.
 * The values must be row-major (sxx, sxy, sxz...) and the size must either be 9 or 16. If the
 * size is 9 the tx = ty = tz = 0 and tw = 1;
 * @param array The array of row-major matrix values.
 * @param size The size of the array.
 * @result (autorelease) A matrix created from given array values.
 */
+ (Isgl3dMatrix4D *) matrixFromFloatArray:(float *)array size:(int)size;

/**
 * Constructs a matrix with values from a column-major float array.
 * The array must contain 16 values.
 * @param The array of column-major matrix values.
 * @result (autorelease) A matrix created from given OpenGL (column-major) array.
 */
+ (Isgl3dMatrix4D *) matrixFromOpenGLMatrix:(float *)array;

/**
 * Constructs a matrix to project all vertices onto a plane from a given position.
 * @param plane Vector representation of the plane.
 * @param position Vector position from which the projection occurs.
 * @result (autorelease) A matrix to flatten vertices onto a plane as projected from a position.
 */
+ (Isgl3dMatrix4D *) planarProjectionMatrix:(Isgl3dVector4)plane fromPosition:(Isgl3dVector3)position;

/**
 * Constructs a matrix to project all vertices onto a plane along a given direction.
 * @param plane Vector representation of the plane.
 * @param position Vector direction along which the projection occurs.
 * @result (autorelease) A matrix to flatten vertices onto a plane as projected along a direction.
 */
+ (Isgl3dMatrix4D *) planarProjectionMatrix:(Isgl3dVector4)plane fromDirection:(Isgl3dVector3)direction;

/**
 * Constructs a matrix used to scale vertices.
 * @param scaleX The scaling along the x-axis.
 * @param scaleY The scaling along the y-axis.
 * @param scaleZ The scaling along the z-axis.
 * @result (autorelease) A new identity matrix.
 */
+ (Isgl3dMatrix4D *) scaleMatrix:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ;


/**
 * Initialises the matrix with no initialisation of the components.
 */
- (id) init;

/**
 * Initialises the matrix as an identity matrix
 */
- (id) initWithIdentity;

/**
 * Initialises the matrix with values copied from another.
 * @param matrix The original matrix to be copied.
 */
- (id) initFromMatrix:(Isgl3dMatrix4D*)matrix;

/**
 * Initialises the matrix with values from a row-major float array.
 * The values must be row-major (sxx, sxy, sxz...) and the size must either be 9 or 16. If the
 * size is 9 the tx = ty = tz = 0 and tw = 1;
 * @param array The array of row-major matrix values.
 * @param size The size of the array.
 */
- (id) initFromFloatArray:(float *)array size:(int)size;

/**
 * Initialises the matrix with values from a column-major float array.
 * The array must contain 16 values.
 * @param The array of column-major matrix values.
 */
- (id) initFromOpenGLMatrix:(float *)array;

/**
 * Initialises the matrix to scale vertices.
 * @param scaleX The scaling along the x-axis.
 * @param scaleY The scaling along the y-axis.
 * @param scaleZ The scaling along the z-axis.
 */
- (id) initWithScale:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ;

/**
 * Returns the matrix components as a string (used for debugging).
 * @return The NSString representation of the matrix.
 */
//- (NSString *) toString;

/**
 * Resets the matrix as an identity matrix.
 */
- (void) makeIdentity;

/**
 * Returns the determinant of the full matrix.
 * @return The determinant of the full matrix.
 */
- (float) determinant;

/**
 * Returns the determinant of the 3x3 part of the matrix.
 * @return The determinant of the 3x3 part of the matrix.
 */
- (float) determinant3x3;

/**
 * Inverts the matrix.
 */
- (void) invert;

/**
 * Inverts the 3x3 part of the matrix.
 */
- (void) invert3x3;

/**
 * Copies the matrix values of another matrix into this one.
 * @param matrix The original matrix to be copied.
 */
- (void) copyFrom:(Isgl3dMatrix4D *)matrix;

/**
 * Copies the matrix values of an Isgl3dMiniMat4D structure into this one.
 * @param matrix The Isgl3dMiniMat4D matrix to be copied.
 */
- (void) copyFromMiniMat4D:(Isgl3dMiniMat4D *)matrix;

/**
 * Performs a rotation on the matrix around a given axis.
 * @param angle The angle of rotation in degrees.
 * @param x The x component of the axis of rotation.
 * @param y The y component of the axis of rotation.
 * @param z The z component of the axis of rotation.
 */
- (void) rotate:(float)angle x:(float)x y:(float)y z:(float)z;

/**
 * Performs a translation on the matrix by a given distance.
 * @param x The distance along the x-axis of the translation.
 * @param y The distance along the y-axis of the translation.
 * @param z The distance along the z-axis of the translation.
 */
- (void) translate:(float)x y:(float)y z:(float)z;

/**
 * Performs a scaling on the matrix.
 * @param x The amount of scaling in the x-direction.
 * @param y The amount of scaling in the y-direction.
 * @param z The amount of scaling in the z-direction.
 */
- (void) scale:(float)x y:(float)y z:(float)z;

/**
 * Trasposes the matrix.
 */
- (void) transpose;

/**
 * Sets the rotation of the matrix to a specific angle about a specified axis.
 * The translation components of the matrix are not affected.
 * @param angle The angle of rotation in degrees.
 * @param x The x component of the axis of rotation.
 * @param y The y component of the axis of rotation.
 * @param z The z component of the axis of rotation.
 */
- (void) setRotation:(float)angle x:(float)x y:(float)y z:(float)z;

/**
 * Sets the translation components of the matrix. The rotational components
 * are not affected.
 * @param x The distance along the x-axis of the translation.
 * @param y The distance along the y-axis of the translation.
 * @param z The distance along the z-axis of the translation.
 */
- (void) setTranslation:(float)x y:(float)y z:(float)z;

/**
 * Sets the translation components of the matrix stored in a vector. The rotational components
 * are not affected.
 * @param translation The translation.
 */
- (void) setTranslationVector:(Isgl3dVector3)translation;

/**
 * Returns the length of the current translation.
 * @return The length of the current translation.
 */
- (float) translationLength;

/**
 * Performs a multiplication on the given matrix.
 * The resulting matrix is "this x matrix".
 * @param matrix The matrix to be multiplied. 
 */
- (void) multiply:(Isgl3dMatrix4D *)matrix;

/**
 * Performs a multiplication on the given matrix with it being on the left.
 * The resulting matrix is "matrix x this".
 * @param matrix The matrix to be multiplied. 
 */
- (void) multiplyOnLeft:(Isgl3dMatrix4D *)matrix;

/**
 * Performs a multiplication on the given matrix with it being on the left, using only the 3x3 part of the matrix.
 * The resulting matrix is "matrix x this".
 * The translation components of the matrix are not affected.
 * @param matrix The matrix to be multiplied. 
 */
- (void) multiplyOnLeft3x3:(Isgl3dMatrix4D *)matrix;
- (void) multVec3:(float *)vector;
- (void) multVec4:(float *)vector;

/**
 * Performs a multiplication on the given 4-component vector.
 * @param vector The vector to be multiplied.
 * @result The result of the multiplication on given vector
 */
- (Isgl3dVector4) multVector4D:(Isgl3dVector4)vector;

/**
 * Performs a multiplication on the given 3-component vector with the translational components of the matrix included.
 * @param vector The vector to be multiplied.
 * @result The result of the multiplication on given vector
 */
- (Isgl3dVector3) multVector:(Isgl3dVector3)vector;

/**
 * Performs a multiplication on the given 3-component vector with the only the 3x3 part of the matrix.
 * @param vector The vector to be multiplied.
 * @result The result of the multiplication on given vector
 */
- (Isgl3dVector3) multVector3x3:(Isgl3dVector3)vector;

/**
 * Returns the 3x3 part of the matrix as a column-major float array.
 * @param array The float array into which the column-major representation of the matrix is set.
 */
- (void) convertTo3x3ColumnMajorFloatArray:(float *)array;

/**
 * Returns the full matrix as a column-major float array.
 * @param array The float array into which the column-major representation of the matrix is set.
 */
- (void) convertToColumnMajorFloatArray:(float *)array;

/**
 * Copies data from a column-major (OpenGL standard) transformation in to the matrix.
 * @param transformation The column-major transformation as a 16 value float array to be copied.
 */
- (void) setTransformationFromOpenGLMatrix:(float *)transformation;

/**
 * Copies this matrix into a column-major (OpenGL standard) float array.
 * @param transformation The column-major transformation as a 16 value float array that will hold the values of this matrix after the call.
 */
- (void) getTransformationAsOpenGLMatrix:(float *)transformation;

/**
 * Returns the equivalent Euler angles of the current rotational components of the matrix.
 * @result Vector containing the rotations about x, y and z (in degrees)
 */
- (Isgl3dVector3) toEulerAngles;

/**
 * Returns the equivalet scaling values of the matrix.
 * @result Vector containing the scalex in x, y and z
 */
- (Isgl3dVector3) toScaleValues;


@end
