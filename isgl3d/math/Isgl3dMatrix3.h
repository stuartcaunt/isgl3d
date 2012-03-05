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
#import "Isgl3dVector3.h"
#import "Isgl3dVector4.h"


/*
 * Use GLKit definitions for iOS >= 5.0 and if no strict ANSI compilation is set (C/C++ language dialect)
 * GLKit linkage required in this case
 */
#if !(defined(__STRICT_ANSI__)) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0)

#import <GLKit/GLKMath.h>


#define Isgl3dMatrix3Identity GLKMatrix3Identity

#define Isgl3dMatrix3Make GLKMatrix3Make
#define Isgl3dMatrix3MakeAndTranspose GLKMatrix3MakeAndTranspose
#define Isgl3dMatrix3MakeWithArray GLKMatrix3MakeWithArray
#define Isgl3dMatrix3MakeWithArrayAndTranspose GLKMatrix3MakeWithArrayAndTranspose
#define Isgl3dMatrix3MakeWithRows GLKMatrix3MakeWithRows
#define Isgl3dMatrix3MakeWithColumns GLKMatrix3MakeWithColumns
#define Isgl3dMatrix3MakeWithQuaternion GLKMatrix3MakeWithQuaternion
#define Isgl3dMatrix3MakeScale GLKMatrix3MakeScale
#define Isgl3dMatrix3MakeRotation GLKMatrix3MakeRotation
#define Isgl3dMatrix3MakeXRotation GLKMatrix3MakeXRotation
#define Isgl3dMatrix3MakeYRotation GLKMatrix3MakeYRotation
#define Isgl3dMatrix3MakeZRotation GLKMatrix3MakeZRotation
#define Isgl3dMatrix3GetMatrix2 GLKMatrix3GetMatrix2
#define Isgl3dMatrix3GetRow GLKMatrix3GetRow
#define Isgl3dMatrix3GetColumn GLKMatrix3GetColumn
#define Isgl3dMatrix3SetRow GLKMatrix3SetRow
#define Isgl3dMatrix3SetColumn GLKMatrix3SetColumn
#define Isgl3dMatrix3Transpose GLKMatrix3Transpose
#define Isgl3dMatrix3Invert GLKMatrix3Invert
#define Isgl3dMatrix3InvertAndTranspose GLKMatrix3InvertAndTranspose
#define Isgl3dMatrix3Multiply GLKMatrix3Multiply
#define Isgl3dMatrix3Add GLKMatrix3Add
#define Isgl3dMatrix3Subtract GLKMatrix3Subtract
#define Isgl3dMatrix3Scale GLKMatrix3Scale
#define Isgl3dMatrix3ScaleWithVector3 GLKMatrix3ScaleWithVector3
#define Isgl3dMatrix3ScaleWithVector4 GLKMatrix3ScaleWithVector4
#define Isgl3dMatrix3Rotate GLKMatrix3Rotate
#define Isgl3dMatrix3RotateWithVector3 GLKMatrix3RotateWithVector3
#define Isgl3dMatrix3RotateWithVector4 GLKMatrix3RotateWithVector4
#define Isgl3dMatrix3RotateX GLKMatrix3RotateX
#define Isgl3dMatrix3RotateY GLKMatrix3RotateY
#define Isgl3dMatrix3RotateZ GLKMatrix3RotateZ
#define Isgl3dMatrix3MultiplyVector3 GLKMatrix3MultiplyVector3
#define Isgl3dMatrix3MultiplyVector3Array GLKMatrix3MultiplyVector3Array


#else


#include <stddef.h>
#include <stdbool.h>
#include <math.h>

#if defined(__ARM_NEON__)
#include <arm_neon.h>
#endif


#ifdef __cplusplus
extern "C" {
#endif

#pragma mark -
#pragma mark GLKit compatible Prototypes
#pragma mark -

    
extern const Isgl3dMatrix3 Isgl3dMatrix3Identity;


static inline Isgl3dMatrix3 Isgl3dMatrix3Make(float m00, float m01, float m02,
                                              float m10, float m11, float m12,
                                              float m20, float m21, float m22);
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeAndTranspose(float m00, float m01, float m02,
                                                          float m10, float m11, float m12,
                                                          float m20, float m21, float m22);
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithArray(float values[9]);
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithArrayAndTranspose(float values[9]);
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithRows(Isgl3dVector3 row0,
                                                      Isgl3dVector3 row1, 
                                                      Isgl3dVector3 row2);
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithColumns(Isgl3dVector3 column0,
                                                         Isgl3dVector3 column1, 
                                                         Isgl3dVector3 column2);
//static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithQuaternion(Isgl3dQuaternion quaternion);
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeScale(float sx, float sy, float sz);	
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeRotation(float radians, float x, float y, float z);
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeXRotation(float radians);
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeYRotation(float radians);
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeZRotation(float radians);
static inline Isgl3dMatrix2 Isgl3dMatrix3GetMatrix2(Isgl3dMatrix3 matrix);
static inline Isgl3dVector3 Isgl3dMatrix3GetRow(Isgl3dMatrix3 matrix, int row);
static inline Isgl3dVector3 Isgl3dMatrix3GetColumn(Isgl3dMatrix3 matrix, int column);
static inline Isgl3dMatrix3 Isgl3dMatrix3SetRow(Isgl3dMatrix3 matrix, int row, Isgl3dVector3 vector);
static inline Isgl3dMatrix3 Isgl3dMatrix3SetColumn(Isgl3dMatrix3 matrix, int column, Isgl3dVector3 vector);
static inline Isgl3dMatrix3 Isgl3dMatrix3Transpose(Isgl3dMatrix3 matrix);
Isgl3dMatrix3 Isgl3dMatrix3Invert(Isgl3dMatrix3 matrix, bool *isInvertible);
Isgl3dMatrix3 Isgl3dMatrix3InvertAndTranspose(Isgl3dMatrix3 matrix, bool *isInvertible);
static inline Isgl3dMatrix3 Isgl3dMatrix3Multiply(Isgl3dMatrix3 matrixLeft, Isgl3dMatrix3 matrixRight);
static inline Isgl3dMatrix3 Isgl3dMatrix3Add(Isgl3dMatrix3 matrixLeft, Isgl3dMatrix3 matrixRight);
static inline Isgl3dMatrix3 Isgl3dMatrix3Subtract(Isgl3dMatrix3 matrixLeft, Isgl3dMatrix3 matrixRight);
static inline Isgl3dMatrix3 Isgl3dMatrix3Scale(Isgl3dMatrix3 matrix, float sx, float sy, float sz);
static inline Isgl3dMatrix3 Isgl3dMatrix3ScaleWithVector3(Isgl3dMatrix3 matrix, Isgl3dVector3 scaleVector);
static inline Isgl3dMatrix3 Isgl3dMatrix3ScaleWithVector4(Isgl3dMatrix3 matrix, Isgl3dVector4 scaleVector);
static inline Isgl3dMatrix3 Isgl3dMatrix3Rotate(Isgl3dMatrix3 matrix, float radians, float x, float y, float z);
static inline Isgl3dMatrix3 Isgl3dMatrix3RotateWithVector3(Isgl3dMatrix3 matrix, float radians, Isgl3dVector3 axisVector);
static inline Isgl3dMatrix3 Isgl3dMatrix3RotateWithVector4(Isgl3dMatrix3 matrix, float radians, Isgl3dVector4 axisVector);
static inline Isgl3dMatrix3 Isgl3dMatrix3RotateX(Isgl3dMatrix3 matrix, float radians);
static inline Isgl3dMatrix3 Isgl3dMatrix3RotateY(Isgl3dMatrix3 matrix, float radians);
static inline Isgl3dMatrix3 Isgl3dMatrix3RotateZ(Isgl3dMatrix3 matrix, float radians);
static inline Isgl3dVector3 Isgl3dMatrix3MultiplyVector3(Isgl3dMatrix3 matrixLeft, Isgl3dVector3 vectorRight);
static inline void Isgl3dMatrix3MultiplyVector3Array(Isgl3dMatrix3 matrix, Isgl3dVector3 *vectors, size_t vectorCount);


#pragma mark -
#pragma mark GLKit compatible Implementations
#pragma mark -

static inline Isgl3dMatrix3 Isgl3dMatrix3Make(float m00, float m01, float m02,
                                              float m10, float m11, float m12,
                                              float m20, float m21, float m22)
{
    Isgl3dMatrix3 m = { m00, m01, m02,
                        m10, m11, m12,
                        m20, m21, m22 };
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeAndTranspose(float m00, float m01, float m02,
                                                          float m10, float m11, float m12,
                                                          float m20, float m21, float m22)
{
    Isgl3dMatrix3 m = { m00, m10, m20,
                        m01, m11, m21,
                        m02, m12, m22};
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithArray(float values[9])
{
    Isgl3dMatrix3 m = { values[0], values[1], values[2],
                        values[3], values[4], values[5],
                        values[6], values[7], values[8] };
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithArrayAndTranspose(float values[9])
{
    Isgl3dMatrix3 m = { values[0], values[3], values[6],
                        values[1], values[4], values[7],
                        values[2], values[5], values[8] };
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithRows(Isgl3dVector3 row0,
                                                      Isgl3dVector3 row1, 
                                                      Isgl3dVector3 row2)
{
    Isgl3dMatrix3 m = { row0.v[0], row1.v[0], row2.v[0],
                        row0.v[1], row1.v[1], row2.v[1],
                        row0.v[2], row1.v[2], row2.v[2] };
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithColumns(Isgl3dVector3 column0,
                                                         Isgl3dVector3 column1, 
                                                         Isgl3dVector3 column2)
{
    Isgl3dMatrix3 m = { column0.v[0], column0.v[1], column0.v[2],
                        column1.v[0], column1.v[1], column1.v[2],
                        column2.v[0], column2.v[1], column2.v[2] };
    return m;
}

/*
static inline Isgl3dMatrix3 Isgl3dMatrix3MakeWithQuaternion(Isgl3dQuaternion quaternion)
{
    quaternion = Isgl3dQuaternionNormalize(quaternion);
    
    float x = quaternion.q[0];
    float y = quaternion.q[1];
    float z = quaternion.q[2];
    float w = quaternion.q[3];
    
    float _2x = x + x;
    float _2y = y + y;
    float _2z = z + z;
    float _2w = w + w;
    
    Isgl3dMatrix3 m = { 1.0f - _2y * y - _2z * z,
        _2x * y + _2w * z,
        _2x * z - _2w * y,
        
        _2x * y - _2w * z,
        1.0f - _2x * x - _2z * z,
        _2y * z + _2w * x,
        
        _2x * z + _2w * y,
        _2y * z - _2w * x,
        1.0f - _2x * x - _2y * y };
    
    return m;
}
*/

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeScale(float sx, float sy, float sz)
{
    Isgl3dMatrix3 m = Isgl3dMatrix3Identity;
    m.m[0] = sx;
    m.m[4] = sy;
    m.m[8] = sz;
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeRotation(float radians, float x, float y, float z)
{
    Isgl3dVector3 v = Isgl3dVector3Normalize(Isgl3dVector3Make(x, y, z));
    float cos = cosf(radians);
    float cosp = 1.0f - cos;
    float sin = sinf(radians);
    
    Isgl3dMatrix3 m = { cos + cosp * v.v[0] * v.v[0],
                        cosp * v.v[0] * v.v[1] + v.v[2] * sin,
                        cosp * v.v[0] * v.v[2] - v.v[1] * sin,
                        
                        cosp * v.v[0] * v.v[1] - v.v[2] * sin,
                        cos + cosp * v.v[1] * v.v[1],
                        cosp * v.v[1] * v.v[2] + v.v[0] * sin,
                        
                        cosp * v.v[0] * v.v[2] + v.v[1] * sin,
                        cosp * v.v[1] * v.v[2] - v.v[0] * sin,
                        cos + cosp * v.v[2] * v.v[2] };
    
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeXRotation(float radians)
{
    float cos = cosf(radians);
    float sin = sinf(radians);
    
    Isgl3dMatrix3 m = { 1.0f, 0.0f, 0.0f,
                        0.0f, cos, sin,
                        0.0f, -sin, cos };
    
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeYRotation(float radians)
{
    float cos = cosf(radians);
    float sin = sinf(radians);
    
    Isgl3dMatrix3 m = { cos, 0.0f, -sin,
                        0.0f, 1.0f, 0.0f,
                        sin, 0.0f, cos };
    
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3MakeZRotation(float radians)
{
    float cos = cosf(radians);
    float sin = sinf(radians);
    
    Isgl3dMatrix3 m = { cos, sin, 0.0f,
                        -sin, cos, 0.0f,
                        0.0f, 0.0f, 1.0f };
    
    return m;
}

static inline Isgl3dMatrix2 Isgl3dMatrix3GetMatrix2(Isgl3dMatrix3 matrix)
{
    Isgl3dMatrix2 m = { matrix.m[0], matrix.m[1],
                        matrix.m[3], matrix.m[4] };
    return m;
}

static inline Isgl3dVector3 Isgl3dMatrix3GetRow(Isgl3dMatrix3 matrix, int row)
{
    Isgl3dVector3 v = { matrix.m[row], matrix.m[3 + row], matrix.m[6 + row] };
    return v;
}

static inline Isgl3dVector3 Isgl3dMatrix3GetColumn(Isgl3dMatrix3 matrix, int column)
{
#if defined(__ARM_NEON__)
    Isgl3dVector3 v;
    *((float32x2_t *)&v) = vld1_f32(&(matrix.m[column * 3]));
    v.v[2] = matrix.m[column * 3 + 2];
    return v;
#else
    Isgl3dVector3 v = { matrix.m[column * 3 + 0], matrix.m[column * 3 + 1], matrix.m[column * 3 + 2] };
    return v;
#endif
}

static inline Isgl3dMatrix3 Isgl3dMatrix3SetRow(Isgl3dMatrix3 matrix, int row, Isgl3dVector3 vector)
{
    matrix.m[row] = vector.v[0];
    matrix.m[row + 3] = vector.v[1];
    matrix.m[row + 6] = vector.v[2];
    
    return matrix;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3SetColumn(Isgl3dMatrix3 matrix, int column, Isgl3dVector3 vector)
{
#if defined(__ARM_NEON__)
    float *dst = &(matrix.m[column * 3]);
    vst1_f32(dst, vld1_f32(vector.v));
    dst[2] = vector.v[2];
    return matrix;
#else
    matrix.m[column * 3 + 0] = vector.v[0];
    matrix.m[column * 3 + 1] = vector.v[1];
    matrix.m[column * 3 + 2] = vector.v[2];
    
    return matrix;
#endif
}

static inline Isgl3dMatrix3 Isgl3dMatrix3Transpose(Isgl3dMatrix3 matrix)
{
    Isgl3dMatrix3 m = { matrix.m[0], matrix.m[3], matrix.m[6],
                        matrix.m[1], matrix.m[4], matrix.m[7],
                        matrix.m[2], matrix.m[5], matrix.m[8] };
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3Multiply(Isgl3dMatrix3 matrixLeft, Isgl3dMatrix3 matrixRight)
{
#if defined(__ARM_NEON__)
    Isgl3dMatrix3 m;
    float32x4x3_t iMatrixLeft;
    float32x4x3_t iMatrixRight;
    float32x4x3_t mm;
    
    iMatrixLeft.val[0] = *(float32x4_t *)&matrixLeft.m[0]; // 0 1 2 3
    iMatrixLeft.val[1] = *(float32x4_t *)&matrixLeft.m[3]; // 3 4 5 6
    iMatrixLeft.val[2] = *(float32x4_t *)&matrixLeft.m[5]; // 5 6 7 8
    
    iMatrixRight.val[0] = *(float32x4_t *)&matrixRight.m[0];
    iMatrixRight.val[1] = *(float32x4_t *)&matrixRight.m[3];
    iMatrixRight.val[2] = *(float32x4_t *)&matrixRight.m[5];
    
    iMatrixLeft.val[2] = vextq_f32(iMatrixLeft.val[2], iMatrixLeft.val[2], 1); // 6 7 8 x
    
    mm.val[0] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[0], 0));
    mm.val[1] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[0], 3));
    mm.val[2] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[1], 3));
    
    mm.val[0] = vmlaq_n_f32(mm.val[0], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[0], 1));
    mm.val[1] = vmlaq_n_f32(mm.val[1], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[1], 1));
    mm.val[2] = vmlaq_n_f32(mm.val[2], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[2], 2));
    
    mm.val[0] = vmlaq_n_f32(mm.val[0], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[0], 2));
    mm.val[1] = vmlaq_n_f32(mm.val[1], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[1], 2));
    mm.val[2] = vmlaq_n_f32(mm.val[2], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[2], 3));
    
    *(float32x4_t *)&m.m[0] = mm.val[0];
    *(float32x4_t *)&m.m[3] = mm.val[1];
    *(float32x2_t *)&m.m[6] = vget_low_f32(mm.val[2]);
    m.m[8] = vgetq_lane_f32(mm.val[2], 2);
    
    return m;
#else
    Isgl3dMatrix3 m;
    
    m.m[0] = matrixLeft.m[0] * matrixRight.m[0] + matrixLeft.m[3] * matrixRight.m[1] + matrixLeft.m[6] * matrixRight.m[2];
    m.m[3] = matrixLeft.m[0] * matrixRight.m[3] + matrixLeft.m[3] * matrixRight.m[4] + matrixLeft.m[6] * matrixRight.m[5];
    m.m[6] = matrixLeft.m[0] * matrixRight.m[6] + matrixLeft.m[3] * matrixRight.m[7] + matrixLeft.m[6] * matrixRight.m[8];
    
    m.m[1] = matrixLeft.m[1] * matrixRight.m[0] + matrixLeft.m[4] * matrixRight.m[1] + matrixLeft.m[7] * matrixRight.m[2];
    m.m[4] = matrixLeft.m[1] * matrixRight.m[3] + matrixLeft.m[4] * matrixRight.m[4] + matrixLeft.m[7] * matrixRight.m[5];
    m.m[7] = matrixLeft.m[1] * matrixRight.m[6] + matrixLeft.m[4] * matrixRight.m[7] + matrixLeft.m[7] * matrixRight.m[8];
    
    m.m[2] = matrixLeft.m[2] * matrixRight.m[0] + matrixLeft.m[5] * matrixRight.m[1] + matrixLeft.m[8] * matrixRight.m[2];
    m.m[5] = matrixLeft.m[2] * matrixRight.m[3] + matrixLeft.m[5] * matrixRight.m[4] + matrixLeft.m[8] * matrixRight.m[5];
    m.m[8] = matrixLeft.m[2] * matrixRight.m[6] + matrixLeft.m[5] * matrixRight.m[7] + matrixLeft.m[8] * matrixRight.m[8];
    
    return m;
#endif
}

static inline Isgl3dMatrix3 Isgl3dMatrix3Add(Isgl3dMatrix3 matrixLeft, Isgl3dMatrix3 matrixRight)
{
#if defined(__ARM_NEON__)
    Isgl3dMatrix3 m;
    
    *(float32x4_t *)&(m.m[0]) = vaddq_f32(*(float32x4_t *)&(matrixLeft.m[0]), *(float32x4_t *)&(matrixRight.m[0]));
    *(float32x4_t *)&(m.m[4]) = vaddq_f32(*(float32x4_t *)&(matrixLeft.m[4]), *(float32x4_t *)&(matrixRight.m[4]));
    m.m[8] = matrixLeft.m[8] + matrixRight.m[8];
    
    return m;
#else
    Isgl3dMatrix3 m;
    
    m.m[0] = matrixLeft.m[0] + matrixRight.m[0];
    m.m[1] = matrixLeft.m[1] + matrixRight.m[1];
    m.m[2] = matrixLeft.m[2] + matrixRight.m[2];
    
    m.m[3] = matrixLeft.m[3] + matrixRight.m[3];
    m.m[4] = matrixLeft.m[4] + matrixRight.m[4];
    m.m[5] = matrixLeft.m[5] + matrixRight.m[5];
    
    m.m[6] = matrixLeft.m[6] + matrixRight.m[6];
    m.m[7] = matrixLeft.m[7] + matrixRight.m[7];
    m.m[8] = matrixLeft.m[8] + matrixRight.m[8];
    
    return m;
#endif
}

static inline Isgl3dMatrix3 Isgl3dMatrix3Subtract(Isgl3dMatrix3 matrixLeft, Isgl3dMatrix3 matrixRight)
{
#if defined(__ARM_NEON__)
    Isgl3dMatrix3 m;
    
    *(float32x4_t *)&(m.m[0]) = vsubq_f32(*(float32x4_t *)&(matrixLeft.m[0]), *(float32x4_t *)&(matrixRight.m[0]));
    *(float32x4_t *)&(m.m[4]) = vsubq_f32(*(float32x4_t *)&(matrixLeft.m[4]), *(float32x4_t *)&(matrixRight.m[4]));
    m.m[8] = matrixLeft.m[8] - matrixRight.m[8];
    
    return m;
#else
    Isgl3dMatrix3 m;
    
    m.m[0] = matrixLeft.m[0] - matrixRight.m[0];
    m.m[1] = matrixLeft.m[1] - matrixRight.m[1];
    m.m[2] = matrixLeft.m[2] - matrixRight.m[2];
    
    m.m[3] = matrixLeft.m[3] - matrixRight.m[3];
    m.m[4] = matrixLeft.m[4] - matrixRight.m[4];
    m.m[5] = matrixLeft.m[5] - matrixRight.m[5];
    
    m.m[6] = matrixLeft.m[6] - matrixRight.m[6];
    m.m[7] = matrixLeft.m[7] - matrixRight.m[7];
    m.m[8] = matrixLeft.m[8] - matrixRight.m[8];
    
    return m;
#endif
}

static inline Isgl3dMatrix3 Isgl3dMatrix3Scale(Isgl3dMatrix3 matrix, float sx, float sy, float sz)
{
    Isgl3dMatrix3 m = { matrix.m[0] * sx, matrix.m[1] * sx, matrix.m[2] * sx,
                        matrix.m[3] * sy, matrix.m[4] * sy, matrix.m[5] * sy,
                        matrix.m[6] * sz, matrix.m[7] * sz, matrix.m[8] * sz };
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3ScaleWithVector3(Isgl3dMatrix3 matrix, Isgl3dVector3 scaleVector)
{
    Isgl3dMatrix3 m = { matrix.m[0] * scaleVector.v[0], matrix.m[1] * scaleVector.v[0], matrix.m[2] * scaleVector.v[0],
                        matrix.m[3] * scaleVector.v[1], matrix.m[4] * scaleVector.v[1], matrix.m[5] * scaleVector.v[1],
                        matrix.m[6] * scaleVector.v[2], matrix.m[7] * scaleVector.v[2], matrix.m[8] * scaleVector.v[2] };
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3ScaleWithVector4(Isgl3dMatrix3 matrix, Isgl3dVector4 scaleVector)
{
    Isgl3dMatrix3 m = { matrix.m[0] * scaleVector.v[0], matrix.m[1] * scaleVector.v[0], matrix.m[2] * scaleVector.v[0],
                        matrix.m[3] * scaleVector.v[1], matrix.m[4] * scaleVector.v[1], matrix.m[5] * scaleVector.v[1],
                        matrix.m[6] * scaleVector.v[2], matrix.m[7] * scaleVector.v[2], matrix.m[8] * scaleVector.v[2] };
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix3Rotate(Isgl3dMatrix3 matrix, float radians, float x, float y, float z)
{
    Isgl3dMatrix3 rm = Isgl3dMatrix3MakeRotation(radians, x, y, z);
    return Isgl3dMatrix3Multiply(matrix, rm);
}

static inline Isgl3dMatrix3 Isgl3dMatrix3RotateWithVector3(Isgl3dMatrix3 matrix, float radians, Isgl3dVector3 axisVector)
{
    Isgl3dMatrix3 rm = Isgl3dMatrix3MakeRotation(radians, axisVector.v[0], axisVector.v[1], axisVector.v[2]);
    return Isgl3dMatrix3Multiply(matrix, rm);
}

static inline Isgl3dMatrix3 Isgl3dMatrix3RotateWithVector4(Isgl3dMatrix3 matrix, float radians, Isgl3dVector4 axisVector)
{
    Isgl3dMatrix3 rm = Isgl3dMatrix3MakeRotation(radians, axisVector.v[0], axisVector.v[1], axisVector.v[2]);
    return Isgl3dMatrix3Multiply(matrix, rm);
}

static inline Isgl3dMatrix3 Isgl3dMatrix3RotateX(Isgl3dMatrix3 matrix, float radians)
{
    Isgl3dMatrix3 rm = Isgl3dMatrix3MakeXRotation(radians);
    return Isgl3dMatrix3Multiply(matrix, rm);
}

static inline Isgl3dMatrix3 Isgl3dMatrix3RotateY(Isgl3dMatrix3 matrix, float radians)
{
    Isgl3dMatrix3 rm = Isgl3dMatrix3MakeYRotation(radians);
    return Isgl3dMatrix3Multiply(matrix, rm);
}

static inline Isgl3dMatrix3 Isgl3dMatrix3RotateZ(Isgl3dMatrix3 matrix, float radians)
{
    Isgl3dMatrix3 rm = Isgl3dMatrix3MakeZRotation(radians);
    return Isgl3dMatrix3Multiply(matrix, rm);
}

static inline Isgl3dVector3 Isgl3dMatrix3MultiplyVector3(Isgl3dMatrix3 matrixLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector3 v = { matrixLeft.m[0] * vectorRight.v[0] + matrixLeft.m[3] * vectorRight.v[1] + matrixLeft.m[6] * vectorRight.v[2],
                        matrixLeft.m[1] * vectorRight.v[0] + matrixLeft.m[4] * vectorRight.v[1] + matrixLeft.m[7] * vectorRight.v[2],
                        matrixLeft.m[2] * vectorRight.v[0] + matrixLeft.m[5] * vectorRight.v[1] + matrixLeft.m[8] * vectorRight.v[2] };
    return v;
}

static inline void Isgl3dMatrix3MultiplyVector3Array(Isgl3dMatrix3 matrix, Isgl3dVector3 *vectors, size_t vectorCount)
{
    int i;
    for (i=0; i < vectorCount; i++)
        vectors[i] = Isgl3dMatrix3MultiplyVector3(matrix, vectors[i]);
}
    
#ifdef __cplusplus
}
#endif

#endif
