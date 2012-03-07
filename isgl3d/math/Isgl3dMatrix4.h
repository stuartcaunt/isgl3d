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


#define Isgl3dMatrix4Identity GLKMatrix4Identity

#define Isgl3dMatrix4Matrix GLKMatrix4Make
#define Isgl3dMatrix4MakeAndTranspose GLKMatrix4MakeAndTranspose
#define Isgl3dMatrix4MakeWithArray GLKMatrix4MakeWithArray
#define Isgl3dMatrix4MakeWithArrayAndTranspose GLKMatrix4MakeWithArrayAndTranspose
#define Isgl3dMatrix4MakeWithRows GLKMatrix4MakeWithRows
#define Isgl3dMatrix4MakeWithColumns GLKMatrix4MakeWithColumns

#define Isgl3dMatrix4MakeTranslation GLKMatrix4MakeTranslation
#define Isgl3dMatrix4MakeScale GLKMatrix4MakeScale
#define Isgl3dMatrix4MakeRotation GLKMatrix4MakeRotation
#define Isgl3dMatrix4MakeXRotation GLKMatrix4MakeXRotation
#define Isgl3dMatrix4MakeYRotation GLKMatrix4MakeYRotation
#define Isgl3dMatrix4MakeZRotation GLKMatrix4MakeZRotation
#define Isgl3dMatrix4MakePerspective GLKMatrix4MakePerspective
#define Isgl3dMatrix4MakeFrustum GLKMatrix4MakeFrustum
#define Isgl3dMatrix4MakeOrtho GLKMatrix4MakeOrtho
#define Isgl3dMatrix4MakeLookAt GLKMatrix4MakeLookAt
#define Isgl3dMatrix4GetMatrix3 GLKMatrix4GetMatrix3
#define Isgl3dMatrix4GetMatrix2 GLKMatrix4GetMatrix2
#define Isgl3dMatrix4GetRow GLKMatrix4GetRow
#define Isgl3dMatrix4GetColumn GLKMatrix4GetColumn
#define Isgl3dMatrix4SetRow GLKMatrix4SetRow
#define Isgl3dMatrix4SetColumn GLKMatrix4SetColumn
#define Isgl3dMatrix4Transpose GLKMatrix4Transpose
#define Isgl3dMatrix4Invert GLKMatrix4Invert
#define Isgl3dMatrix4InvertAndTranspose GLKMatrix4InvertAndTranspose
#define Isgl3dMatrix4Multiply GLKMatrix4Multiply
#define Isgl3dMatrix4Add GLKMatrix4Add
#define Isgl3dMatrix4Subtract GLKMatrix4Subtract
#define Isgl3dMatrix4Translate GLKMatrix4Translate
#define Isgl3dMatrix4TranslateWithVector3 GLKMatrix4TranslateWithVector3
#define Isgl3dMatrix4TranslateWithVector4 GLKMatrix4TranslateWithVector4
#define Isgl3dMatrix4Scale GLKMatrix4Scale
#define Isgl3dMatrix4ScaleWithVector3 GLKMatrix4ScaleWithVector3
#define Isgl3dMatrix4ScaleWithVector4 GLKMatrix4ScaleWithVector4
#define Isgl3dMatrix4Rotate GLKMatrix4Rotate
#define Isgl3dMatrix4RotateWithVector3 GLKMatrix4RotateWithVector3
#define Isgl3dMatrix4RotateWithVector4 GLKMatrix4RotateWithVector4
#define Isgl3dMatrix4RotateX GLKMatrix4RotateX
#define Isgl3dMatrix4RotateY GLKMatrix4RotateY
#define Isgl3dMatrix4RotateZ GLKMatrix4RotateZ
#define Isgl3dMatrix4MultiplyVector3 GLKMatrix4MultiplyVector3
#define Isgl3dMatrix4MultiplyVector3WithTranslation GLKMatrix4MultiplyVector3WithTranslation
#define Isgl3dMatrix4MultiplyAndProjectVector3 GLKMatrix4MultiplyAndProjectVector3
#define Isgl3dMatrix4MultiplyVector3Array GLKMatrix4MultiplyVector3Array
#define Isgl3dMatrix4MultiplyVector3ArrayWithTranslation GLKMatrix4MultiplyVector3ArrayWithTranslation
#define Isgl3dMatrix4MultiplyAndProjectVector3Array GLKMatrix4MultiplyAndProjectVector3Array
#define Isgl3dMatrix4MultiplyVector4 GLKMatrix4MultiplyVector4
#define Isgl3dMatrix4MultiplyVector4Array GLKMatrix4MultiplyVector4Array


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

extern const Isgl3dMatrix4 Isgl3dMatrix4Identity;


static inline Isgl3dMatrix4 Isgl3dMatrix4Matrix(float m00, float m01, float m02, float m03,
                                                     float m10, float m11, float m12, float m13,
                                                     float m20, float m21, float m22, float m23,
                                                     float m30, float m31, float m32, float m33);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeAndTranspose(float m00, float m01, float m02, float m03,
                                                          float m10, float m11, float m12, float m13,
                                                          float m20, float m21, float m22, float m23,
                                                          float m30, float m31, float m32, float m33);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeWithArray(float values[16]);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeWithArrayAndTranspose(float values[16]);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeWithRows(Isgl3dVector4 row0,
                                                      Isgl3dVector4 row1, 
                                                      Isgl3dVector4 row2,
                                                      Isgl3dVector4 row3);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeTranslation(float tx, float ty, float tz);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeScale(float sx, float sy, float sz);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeRotation(float radians, float x, float y, float z);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeXRotation(float radians);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeYRotation(float radians);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeZRotation(float radians);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakePerspective(float fovyRadians, float aspect, float nearZ, float farZ);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeFrustum(float left, float right,
                                                     float bottom, float top,
                                                     float nearZ, float farZ);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeOrtho(float left, float right,
                                                   float bottom, float top,
                                                   float nearZ, float farZ);
static inline Isgl3dMatrix4 Isgl3dMatrix4MakeLookAt(float eyeX, float eyeY, float eyeZ,
                                                    float centerX, float centerY, float centerZ,
                                                    float upX, float upY, float upZ);
static inline Isgl3dMatrix3 Isgl3dMatrix4GetMatrix3(Isgl3dMatrix4 matrix);
static inline Isgl3dMatrix2 Isgl3dMatrix4GetMatrix2(Isgl3dMatrix4 matrix);
static inline Isgl3dVector4 Isgl3dMatrix4GetRow(Isgl3dMatrix4 matrix, int row);
static inline Isgl3dVector4 Isgl3dMatrix4GetColumn(Isgl3dMatrix4 matrix, int column);
static inline Isgl3dMatrix4 Isgl3dMatrix4SetRow(Isgl3dMatrix4 matrix, int row, Isgl3dVector4 vector);
static inline Isgl3dMatrix4 Isgl3dMatrix4SetColumn(Isgl3dMatrix4 matrix, int column, Isgl3dVector4 vector);
static inline Isgl3dMatrix4 Isgl3dMatrix4Transpose(Isgl3dMatrix4 matrix);
Isgl3dMatrix4 Isgl3dMatrix4Invert(Isgl3dMatrix4 matrix, bool *isInvertible);
Isgl3dMatrix4 Isgl3dMatrix4InvertAndTranspose(Isgl3dMatrix4 matrix, bool *isInvertible);
#ifndef __clang__
static inline Isgl3dMatrix4 Isgl3dMatrix4Multiply(Isgl3dMatrix4 matrixLeft, Isgl3dMatrix4 matrixRight);
#else
static Isgl3dMatrix4 Isgl3dMatrix4Multiply(Isgl3dMatrix4 matrixLeft, Isgl3dMatrix4 matrixRight);
#endif
static inline Isgl3dMatrix4 Isgl3dMatrix4Add(Isgl3dMatrix4 matrixLeft, Isgl3dMatrix4 matrixRight);
static inline Isgl3dMatrix4 Isgl3dMatrix4Subtract(Isgl3dMatrix4 matrixLeft, Isgl3dMatrix4 matrixRight);
static inline Isgl3dMatrix4 Isgl3dMatrix4Translate(Isgl3dMatrix4 matrix, float tx, float ty, float tz);
static inline Isgl3dMatrix4 Isgl3dMatrix4TranslateWithVector3(Isgl3dMatrix4 matrix, Isgl3dVector3 translationVector);
static inline Isgl3dMatrix4 Isgl3dMatrix4TranslateWithVector4(Isgl3dMatrix4 matrix, Isgl3dVector4 translationVector);
static inline Isgl3dMatrix4 Isgl3dMatrix4Scale(Isgl3dMatrix4 matrix, float sx, float sy, float sz);
static inline Isgl3dMatrix4 Isgl3dMatrix4ScaleWithVector3(Isgl3dMatrix4 matrix, Isgl3dVector3 scaleVector);
static inline Isgl3dMatrix4 Isgl3dMatrix4ScaleWithVector4(Isgl3dMatrix4 matrix, Isgl3dVector4 scaleVector);
static inline Isgl3dMatrix4 Isgl3dMatrix4Rotate(Isgl3dMatrix4 matrix, float radians, float x, float y, float z);
static inline Isgl3dMatrix4 Isgl3dMatrix4RotateWithVector3(Isgl3dMatrix4 matrix, float radians, Isgl3dVector3 axisVector);
static inline Isgl3dMatrix4 Isgl3dMatrix4RotateWithVector4(Isgl3dMatrix4 matrix, float radians, Isgl3dVector4 axisVector);
static inline Isgl3dMatrix4 Isgl3dMatrix4RotateX(Isgl3dMatrix4 matrix, float radians);
static inline Isgl3dMatrix4 Isgl3dMatrix4RotateY(Isgl3dMatrix4 matrix, float radians);
static inline Isgl3dMatrix4 Isgl3dMatrix4RotateZ(Isgl3dMatrix4 matrix, float radians);
static inline Isgl3dVector3 Isgl3dMatrix4MultiplyVector3(Isgl3dMatrix4 matrixLeft, Isgl3dVector3 vectorRight);
static inline Isgl3dVector3 Isgl3dMatrix4MultiplyVector3WithTranslation(Isgl3dMatrix4 matrixLeft, Isgl3dVector3 vectorRight);
static inline Isgl3dVector3 Isgl3dMatrix4MultiplyAndProjectVector3(Isgl3dMatrix4 matrixLeft, Isgl3dVector3 vectorRight);
static inline void Isgl3dMatrix4MultiplyVector3Array(Isgl3dMatrix4 matrix, Isgl3dVector3 *vectors, size_t vectorCount);
static inline void Isgl3dMatrix4MultiplyAndProjectVector3Array(Isgl3dMatrix4 matrix, Isgl3dVector3 *vectors, size_t vectorCount);
static inline Isgl3dVector4 Isgl3dMatrix4MultiplyVector4(Isgl3dMatrix4 matrixLeft, Isgl3dVector4 vectorRight);
static inline void Isgl3dMatrix4MultiplyVector4Array(Isgl3dMatrix4 matrix, Isgl3dVector4 *vectors, size_t vectorCount);


#pragma mark -
#pragma mark GLKit compatible Implementations
#pragma mark -
static inline Isgl3dMatrix4 Isgl3dMatrix4Matrix(float m00, float m01, float m02, float m03,
                                                float m10, float m11, float m12, float m13,
                                                float m20, float m21, float m22, float m23,
                                                float m30, float m31, float m32, float m33)
{
    Isgl3dMatrix4 m = { m00, m01, m02, m03,
                        m10, m11, m12, m13,
                        m20, m21, m22, m23,
                        m30, m31, m32, m33 };
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeAndTranspose(float m00, float m01, float m02, float m03,
                                                          float m10, float m11, float m12, float m13,
                                                          float m20, float m21, float m22, float m23,
                                                          float m30, float m31, float m32, float m33)
{
    Isgl3dMatrix4 m = { m00, m10, m20, m30,
                        m01, m11, m21, m31,
                        m02, m12, m22, m32,
                        m03, m13, m23, m33 };
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeWithArray(float values[16])
{
    Isgl3dMatrix4 m = { values[0], values[1], values[2], values[3],
                        values[4], values[5], values[6], values[7],
                        values[8], values[9], values[10], values[11],
                        values[12], values[13], values[14], values[15] };
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeWithArrayAndTranspose(float values[16])
{
#if defined(__ARM_NEON__)
    float32x4x4_t m = vld4q_f32(values);
    return *(Isgl3dMatrix4 *)&m;
#else
    Isgl3dMatrix4 m = { values[0], values[4], values[8], values[12],
                        values[1], values[5], values[9], values[13],
                        values[2], values[6], values[10], values[14],
                        values[3], values[7], values[11], values[15] };
    return m;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeWithRows(Isgl3dVector4 row0,
                                                      Isgl3dVector4 row1, 
                                                      Isgl3dVector4 row2,
                                                      Isgl3dVector4 row3)
{
    Isgl3dMatrix4 m = { row0.v[0], row1.v[0], row2.v[0], row3.v[0],
                        row0.v[1], row1.v[1], row2.v[1], row3.v[1],
                        row0.v[2], row1.v[2], row2.v[2], row3.v[2],
                        row0.v[3], row1.v[3], row2.v[3], row3.v[3] };
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeWithColumns(Isgl3dVector4 column0,
                                                         Isgl3dVector4 column1, 
                                                         Isgl3dVector4 column2,
                                                         Isgl3dVector4 column3)
{
#if defined(__ARM_NEON__)
    float32x4x4_t m;
    m.val[0] = vld1q_f32(column0.v);
    m.val[1] = vld1q_f32(column1.v);
    m.val[2] = vld1q_f32(column2.v);
    m.val[3] = vld1q_f32(column3.v);
    return *(Isgl3dMatrix4 *)&m;
#else
    Isgl3dMatrix4 m = { column0.v[0], column0.v[1], column0.v[2], column0.v[3],
                        column1.v[0], column1.v[1], column1.v[2], column1.v[3],
                        column2.v[0], column2.v[1], column2.v[2], column2.v[3],
                        column3.v[0], column3.v[1], column3.v[2], column3.v[3] };
    return m;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeTranslation(float tx, float ty, float tz)
{
    Isgl3dMatrix4 m = Isgl3dMatrix4Identity;
    m.m[12] = tx;
    m.m[13] = ty;
    m.m[14] = tz;
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeScale(float sx, float sy, float sz)
{
    Isgl3dMatrix4 m = Isgl3dMatrix4Identity;
    m.m[0] = sx;
    m.m[5] = sy;
    m.m[10] = sz;
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeRotation(float radians, float x, float y, float z)
{
    Isgl3dVector3 v = Isgl3dVector3Normalize(Isgl3dVector3Make(x, y, z));
    float cos = cosf(radians);
    float cosp = 1.0f - cos;
    float sin = sinf(radians);
    
    Isgl3dMatrix4 m = { cos + cosp * v.v[0] * v.v[0],
                        cosp * v.v[0] * v.v[1] + v.v[2] * sin,
                        cosp * v.v[0] * v.v[2] - v.v[1] * sin,
                        0.0f,
                        cosp * v.v[0] * v.v[1] - v.v[2] * sin,
                        cos + cosp * v.v[1] * v.v[1],
                        cosp * v.v[1] * v.v[2] + v.v[0] * sin,
                        0.0f,
                        cosp * v.v[0] * v.v[2] + v.v[1] * sin,
                        cosp * v.v[1] * v.v[2] - v.v[0] * sin,
                        cos + cosp * v.v[2] * v.v[2],
                        0.0f,
                        0.0f,
                        0.0f,
                        0.0f,
                        1.0f };
    
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeXRotation(float radians)
{
    float cos = cosf(radians);
    float sin = sinf(radians);
    
    Isgl3dMatrix4 m = { 1.0f, 0.0f, 0.0f, 0.0f,
                        0.0f, cos, sin, 0.0f,
                        0.0f, -sin, cos, 0.0f,
                        0.0f, 0.0f, 0.0f, 1.0f };
    
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeYRotation(float radians)
{
    float cos = cosf(radians);
    float sin = sinf(radians);
    
    Isgl3dMatrix4 m = { cos, 0.0f, -sin, 0.0f,
                        0.0f, 1.0f, 0.0f, 0.0f,
                        sin, 0.0f, cos, 0.0f,
                        0.0f, 0.0f, 0.0f, 1.0f };
    
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeZRotation(float radians)
{
    float cos = cosf(radians);
    float sin = sinf(radians);
    
    Isgl3dMatrix4 m = { cos, sin, 0.0f, 0.0f,
                        -sin, cos, 0.0f, 0.0f,
                        0.0f, 0.0f, 1.0f, 0.0f,
                        0.0f, 0.0f, 0.0f, 1.0f };
    
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakePerspective(float fovyRadians, float aspect, float nearZ, float farZ)
{
    float cotan = 1.0f / tanf(fovyRadians / 2.0f);
    
    Isgl3dMatrix4 m = { cotan / aspect, 0.0f, 0.0f, 0.0f,
                        0.0f, cotan, 0.0f, 0.0f,
                        0.0f, 0.0f, (farZ + nearZ) / (nearZ - farZ), -1.0f,
                        0.0f, 0.0f, (2.0f * farZ * nearZ) / (nearZ - farZ), 0.0f };
    
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeFrustum(float left, float right,
                                                     float bottom, float top,
                                                     float nearZ, float farZ)
{
    float ral = right + left;
    float rsl = right - left;
    float tsb = top - bottom;
    float tab = top + bottom;
    float fan = farZ + nearZ;
    float fsn = farZ - nearZ;
    
    Isgl3dMatrix4 m = { 2.0f * nearZ / rsl, 0.0f, 0.0f, 0.0f,
                        0.0f, 2.0f * nearZ / tsb, 0.0f, 0.0f,
                        ral / rsl, tab / tsb, -fan / fsn, -1.0f,
                        0.0f, 0.0f, (-2.0f * farZ * nearZ) / fsn, 0.0f };
    
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeOrtho(float left, float right,
                                                   float bottom, float top,
                                                   float nearZ, float farZ)
{
    float ral = right + left;
    float rsl = right - left;
    float tab = top + bottom;
    float tsb = top - bottom;
    float fan = farZ + nearZ;
    float fsn = farZ - nearZ;
    
    Isgl3dMatrix4 m = { 2.0f / rsl, 0.0f, 0.0f, 0.0f,
                        0.0f, 2.0f / tsb, 0.0f, 0.0f,
                        0.0f, 0.0f, -2.0f / fsn, 0.0f,
                        -ral / rsl, -tab / tsb, -fan / fsn, 1.0f };
    
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4MakeLookAt(float eyeX, float eyeY, float eyeZ,
                                                    float centerX, float centerY, float centerZ,
                                                    float upX, float upY, float upZ)
{
    Isgl3dVector3 ev = { eyeX, eyeY, eyeZ };
    Isgl3dVector3 cv = { centerX, centerY, centerZ };
    Isgl3dVector3 uv = { upX, upY, upZ };
    Isgl3dVector3 n = Isgl3dVector3Normalize(Isgl3dVector3Add(ev, Isgl3dVector3Negate(cv)));
    Isgl3dVector3 u = Isgl3dVector3Normalize(Isgl3dVector3CrossProduct(uv, n));
    Isgl3dVector3 v = Isgl3dVector3CrossProduct(n, u);
    
    Isgl3dMatrix4 m = { u.v[0], v.v[0], n.v[0], 0.0f,
                        u.v[1], v.v[1], n.v[1], 0.0f,
                        u.v[2], v.v[2], n.v[2], 0.0f,
                        Isgl3dVector3DotProduct(Isgl3dVector3Negate(u), ev),
                        Isgl3dVector3DotProduct(Isgl3dVector3Negate(v), ev),
                        Isgl3dVector3DotProduct(Isgl3dVector3Negate(n), ev),
                        1.0f };
    
    return m;
}

static inline Isgl3dMatrix3 Isgl3dMatrix4GetMatrix3(Isgl3dMatrix4 matrix)
{
    Isgl3dMatrix3 m = { matrix.m[0], matrix.m[1], matrix.m[2],
                        matrix.m[4], matrix.m[5], matrix.m[6],
                        matrix.m[8], matrix.m[9], matrix.m[10] };
    return m;
}

static inline Isgl3dMatrix2 Isgl3dMatrix4GetMatrix2(Isgl3dMatrix4 matrix)
{
    Isgl3dMatrix2 m = { matrix.m[0], matrix.m[1],
                        matrix.m[4], matrix.m[5] };
    return m;
}

static inline Isgl3dVector4 Isgl3dMatrix4GetRow(Isgl3dMatrix4 matrix, int row)
{
    Isgl3dVector4 v = { matrix.m[row], matrix.m[4 + row], matrix.m[8 + row], matrix.m[12 + row] };
    return v;
}

static inline Isgl3dVector4 Isgl3dMatrix4GetColumn(Isgl3dMatrix4 matrix, int column)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vld1q_f32(&(matrix.m[column * 4]));
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { matrix.m[column * 4 + 0], matrix.m[column * 4 + 1], matrix.m[column * 4 + 2], matrix.m[column * 4 + 3] };
    return v;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4SetRow(Isgl3dMatrix4 matrix, int row, Isgl3dVector4 vector)
{
    matrix.m[row] = vector.v[0];
    matrix.m[row + 4] = vector.v[1];
    matrix.m[row + 8] = vector.v[2];
    matrix.m[row + 12] = vector.v[3];
    
    return matrix;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4SetColumn(Isgl3dMatrix4 matrix, int column, Isgl3dVector4 vector)
{
#if defined(__ARM_NEON__)
    float *dst = &(matrix.m[column * 4]);
    vst1q_f32(dst, vld1q_f32(vector.v));
    return matrix;
#else
    matrix.m[column * 4 + 0] = vector.v[0];
    matrix.m[column * 4 + 1] = vector.v[1];
    matrix.m[column * 4 + 2] = vector.v[2];
    matrix.m[column * 4 + 3] = vector.v[3];
    
    return matrix;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4Transpose(Isgl3dMatrix4 matrix)
{
#if defined(__ARM_NEON__)
    float32x4x4_t m = vld4q_f32(matrix.m);
    return *(Isgl3dMatrix4 *)&m;
#else
    Isgl3dMatrix4 m = { matrix.m[0], matrix.m[4], matrix.m[8], matrix.m[12],
        matrix.m[1], matrix.m[5], matrix.m[9], matrix.m[13],
        matrix.m[2], matrix.m[6], matrix.m[10], matrix.m[14],
        matrix.m[3], matrix.m[7], matrix.m[11], matrix.m[15] };
    return m;
#endif
}

#ifndef __clang__
static inline Isgl3dMatrix4 Isgl3dMatrix4Multiply(Isgl3dMatrix4 matrixLeft, Isgl3dMatrix4 matrixRight)
#else
static Isgl3dMatrix4 Isgl3dMatrix4Multiply(Isgl3dMatrix4 matrixLeft, Isgl3dMatrix4 matrixRight)
#endif
{
#if defined(__ARM_NEON__)
    float32x4x4_t iMatrixLeft = *(float32x4x4_t *)&matrixLeft;
    float32x4x4_t iMatrixRight = *(float32x4x4_t *)&matrixRight;
    float32x4x4_t m;
    
    m.val[0] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[0], 0));
    m.val[1] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[1], 0));
    m.val[2] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[2], 0));
    m.val[3] = vmulq_n_f32(iMatrixLeft.val[0], vgetq_lane_f32(iMatrixRight.val[3], 0));
    
    m.val[0] = vmlaq_n_f32(m.val[0], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[0], 1));
    m.val[1] = vmlaq_n_f32(m.val[1], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[1], 1));
    m.val[2] = vmlaq_n_f32(m.val[2], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[2], 1));
    m.val[3] = vmlaq_n_f32(m.val[3], iMatrixLeft.val[1], vgetq_lane_f32(iMatrixRight.val[3], 1));
    
    m.val[0] = vmlaq_n_f32(m.val[0], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[0], 2));
    m.val[1] = vmlaq_n_f32(m.val[1], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[1], 2));
    m.val[2] = vmlaq_n_f32(m.val[2], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[2], 2));
    m.val[3] = vmlaq_n_f32(m.val[3], iMatrixLeft.val[2], vgetq_lane_f32(iMatrixRight.val[3], 2));
    
    m.val[0] = vmlaq_n_f32(m.val[0], iMatrixLeft.val[3], vgetq_lane_f32(iMatrixRight.val[0], 3));
    m.val[1] = vmlaq_n_f32(m.val[1], iMatrixLeft.val[3], vgetq_lane_f32(iMatrixRight.val[1], 3));
    m.val[2] = vmlaq_n_f32(m.val[2], iMatrixLeft.val[3], vgetq_lane_f32(iMatrixRight.val[2], 3));
    m.val[3] = vmlaq_n_f32(m.val[3], iMatrixLeft.val[3], vgetq_lane_f32(iMatrixRight.val[3], 3));
    
    return *(Isgl3dMatrix4 *)&m;
#else
    Isgl3dMatrix4 m;
    
    m.m[0]  = matrixLeft.m[0] * matrixRight.m[0]  + matrixLeft.m[4] * matrixRight.m[1]  + matrixLeft.m[8] * matrixRight.m[2]   + matrixLeft.m[12] * matrixRight.m[3];
	m.m[4]  = matrixLeft.m[0] * matrixRight.m[4]  + matrixLeft.m[4] * matrixRight.m[5]  + matrixLeft.m[8] * matrixRight.m[6]   + matrixLeft.m[12] * matrixRight.m[7];
	m.m[8]  = matrixLeft.m[0] * matrixRight.m[8]  + matrixLeft.m[4] * matrixRight.m[9]  + matrixLeft.m[8] * matrixRight.m[10]  + matrixLeft.m[12] * matrixRight.m[11];
	m.m[12] = matrixLeft.m[0] * matrixRight.m[12] + matrixLeft.m[4] * matrixRight.m[13] + matrixLeft.m[8] * matrixRight.m[14]  + matrixLeft.m[12] * matrixRight.m[15];
    
	m.m[1]  = matrixLeft.m[1] * matrixRight.m[0]  + matrixLeft.m[5] * matrixRight.m[1]  + matrixLeft.m[9] * matrixRight.m[2]   + matrixLeft.m[13] * matrixRight.m[3];
	m.m[5]  = matrixLeft.m[1] * matrixRight.m[4]  + matrixLeft.m[5] * matrixRight.m[5]  + matrixLeft.m[9] * matrixRight.m[6]   + matrixLeft.m[13] * matrixRight.m[7];
	m.m[9]  = matrixLeft.m[1] * matrixRight.m[8]  + matrixLeft.m[5] * matrixRight.m[9]  + matrixLeft.m[9] * matrixRight.m[10]  + matrixLeft.m[13] * matrixRight.m[11];
	m.m[13] = matrixLeft.m[1] * matrixRight.m[12] + matrixLeft.m[5] * matrixRight.m[13] + matrixLeft.m[9] * matrixRight.m[14]  + matrixLeft.m[13] * matrixRight.m[15];
    
	m.m[2]  = matrixLeft.m[2] * matrixRight.m[0]  + matrixLeft.m[6] * matrixRight.m[1]  + matrixLeft.m[10] * matrixRight.m[2]  + matrixLeft.m[14] * matrixRight.m[3];
	m.m[6]  = matrixLeft.m[2] * matrixRight.m[4]  + matrixLeft.m[6] * matrixRight.m[5]  + matrixLeft.m[10] * matrixRight.m[6]  + matrixLeft.m[14] * matrixRight.m[7];
	m.m[10] = matrixLeft.m[2] * matrixRight.m[8]  + matrixLeft.m[6] * matrixRight.m[9]  + matrixLeft.m[10] * matrixRight.m[10] + matrixLeft.m[14] * matrixRight.m[11];
	m.m[14] = matrixLeft.m[2] * matrixRight.m[12] + matrixLeft.m[6] * matrixRight.m[13] + matrixLeft.m[10] * matrixRight.m[14] + matrixLeft.m[14] * matrixRight.m[15];
    
	m.m[3]  = matrixLeft.m[3] * matrixRight.m[0]  + matrixLeft.m[7] * matrixRight.m[1]  + matrixLeft.m[11] * matrixRight.m[2]  + matrixLeft.m[15] * matrixRight.m[3];
	m.m[7]  = matrixLeft.m[3] * matrixRight.m[4]  + matrixLeft.m[7] * matrixRight.m[5]  + matrixLeft.m[11] * matrixRight.m[6]  + matrixLeft.m[15] * matrixRight.m[7];
	m.m[11] = matrixLeft.m[3] * matrixRight.m[8]  + matrixLeft.m[7] * matrixRight.m[9]  + matrixLeft.m[11] * matrixRight.m[10] + matrixLeft.m[15] * matrixRight.m[11];
	m.m[15] = matrixLeft.m[3] * matrixRight.m[12] + matrixLeft.m[7] * matrixRight.m[13] + matrixLeft.m[11] * matrixRight.m[14] + matrixLeft.m[15] * matrixRight.m[15];
    
    return m;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4Add(Isgl3dMatrix4 matrixLeft, Isgl3dMatrix4 matrixRight)
{
#if defined(__ARM_NEON__)
    float32x4x4_t iMatrixLeft = *(float32x4x4_t *)&matrixLeft;
    float32x4x4_t iMatrixRight = *(float32x4x4_t *)&matrixRight;
    float32x4x4_t m;
    
    m.val[0] = vaddq_f32(iMatrixLeft.val[0], iMatrixRight.val[0]);
    m.val[1] = vaddq_f32(iMatrixLeft.val[1], iMatrixRight.val[1]);
    m.val[2] = vaddq_f32(iMatrixLeft.val[2], iMatrixRight.val[2]);
    m.val[3] = vaddq_f32(iMatrixLeft.val[3], iMatrixRight.val[3]);
    
    return *(Isgl3dMatrix4 *)&m;
#else
    Isgl3dMatrix4 m;
    
    m.m[0] = matrixLeft.m[0] + matrixRight.m[0];
    m.m[1] = matrixLeft.m[1] + matrixRight.m[1];
    m.m[2] = matrixLeft.m[2] + matrixRight.m[2];
    m.m[3] = matrixLeft.m[3] + matrixRight.m[3];
    
    m.m[4] = matrixLeft.m[4] + matrixRight.m[4];
    m.m[5] = matrixLeft.m[5] + matrixRight.m[5];
    m.m[6] = matrixLeft.m[6] + matrixRight.m[6];
    m.m[7] = matrixLeft.m[7] + matrixRight.m[7];
    
    m.m[8] = matrixLeft.m[8] + matrixRight.m[8];
    m.m[9] = matrixLeft.m[9] + matrixRight.m[9];
    m.m[10] = matrixLeft.m[10] + matrixRight.m[10];
    m.m[11] = matrixLeft.m[11] + matrixRight.m[11];
    
    m.m[12] = matrixLeft.m[12] + matrixRight.m[12];
    m.m[13] = matrixLeft.m[13] + matrixRight.m[13];
    m.m[14] = matrixLeft.m[14] + matrixRight.m[14];
    m.m[15] = matrixLeft.m[15] + matrixRight.m[15];
    
    return m;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4Subtract(Isgl3dMatrix4 matrixLeft, Isgl3dMatrix4 matrixRight)
{
#if defined(__ARM_NEON__)
    float32x4x4_t iMatrixLeft = *(float32x4x4_t *)&matrixLeft;
    float32x4x4_t iMatrixRight = *(float32x4x4_t *)&matrixRight;
    float32x4x4_t m;
    
    m.val[0] = vsubq_f32(iMatrixLeft.val[0], iMatrixRight.val[0]);
    m.val[1] = vsubq_f32(iMatrixLeft.val[1], iMatrixRight.val[1]);
    m.val[2] = vsubq_f32(iMatrixLeft.val[2], iMatrixRight.val[2]);
    m.val[3] = vsubq_f32(iMatrixLeft.val[3], iMatrixRight.val[3]);
    
    return *(Isgl3dMatrix4 *)&m;
#else
    Isgl3dMatrix4 m;
    
    m.m[0] = matrixLeft.m[0] - matrixRight.m[0];
    m.m[1] = matrixLeft.m[1] - matrixRight.m[1];
    m.m[2] = matrixLeft.m[2] - matrixRight.m[2];
    m.m[3] = matrixLeft.m[3] - matrixRight.m[3];
    
    m.m[4] = matrixLeft.m[4] - matrixRight.m[4];
    m.m[5] = matrixLeft.m[5] - matrixRight.m[5];
    m.m[6] = matrixLeft.m[6] - matrixRight.m[6];
    m.m[7] = matrixLeft.m[7] - matrixRight.m[7];
    
    m.m[8] = matrixLeft.m[8] - matrixRight.m[8];
    m.m[9] = matrixLeft.m[9] - matrixRight.m[9];
    m.m[10] = matrixLeft.m[10] - matrixRight.m[10];
    m.m[11] = matrixLeft.m[11] - matrixRight.m[11];
    
    m.m[12] = matrixLeft.m[12] - matrixRight.m[12];
    m.m[13] = matrixLeft.m[13] - matrixRight.m[13];
    m.m[14] = matrixLeft.m[14] - matrixRight.m[14];
    m.m[15] = matrixLeft.m[15] - matrixRight.m[15];
    
    return m;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4Translate(Isgl3dMatrix4 matrix, float tx, float ty, float tz)
{
    Isgl3dMatrix4 m = { matrix.m[0], matrix.m[1], matrix.m[2], matrix.m[3],
                        matrix.m[4], matrix.m[5], matrix.m[6], matrix.m[7],
                        matrix.m[8], matrix.m[9], matrix.m[10], matrix.m[11],
                        matrix.m[0] * tx + matrix.m[4] * ty + matrix.m[8] * tz + matrix.m[12],
                        matrix.m[1] * tx + matrix.m[5] * ty + matrix.m[9] * tz + matrix.m[13],
                        matrix.m[2] * tx + matrix.m[6] * ty + matrix.m[10] * tz + matrix.m[14],
                        matrix.m[15] };
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4TranslateWithVector3(Isgl3dMatrix4 matrix, Isgl3dVector3 translationVector)
{
    Isgl3dMatrix4 m = { matrix.m[0], matrix.m[1], matrix.m[2], matrix.m[3],
                        matrix.m[4], matrix.m[5], matrix.m[6], matrix.m[7],
                        matrix.m[8], matrix.m[9], matrix.m[10], matrix.m[11],
                        matrix.m[0] * translationVector.v[0] + matrix.m[4] * translationVector.v[1] + matrix.m[8] * translationVector.v[2] + matrix.m[12],
                        matrix.m[1] * translationVector.v[0] + matrix.m[5] * translationVector.v[1] + matrix.m[9] * translationVector.v[2] + matrix.m[13],
                        matrix.m[2] * translationVector.v[0] + matrix.m[6] * translationVector.v[1] + matrix.m[10] * translationVector.v[2] + matrix.m[14],
                        matrix.m[15] };
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4TranslateWithVector4(Isgl3dMatrix4 matrix, Isgl3dVector4 translationVector)
{
    Isgl3dMatrix4 m = { matrix.m[0], matrix.m[1], matrix.m[2], matrix.m[3],
                        matrix.m[4], matrix.m[5], matrix.m[6], matrix.m[7],
                        matrix.m[8], matrix.m[9], matrix.m[10], matrix.m[11],
                        matrix.m[0] * translationVector.v[0] + matrix.m[4] * translationVector.v[1] + matrix.m[8] * translationVector.v[2] + matrix.m[12],
                        matrix.m[1] * translationVector.v[0] + matrix.m[5] * translationVector.v[1] + matrix.m[9] * translationVector.v[2] + matrix.m[13],
                        matrix.m[2] * translationVector.v[0] + matrix.m[6] * translationVector.v[1] + matrix.m[10] * translationVector.v[2] + matrix.m[14],
                        matrix.m[15] };
    return m;
}

static inline Isgl3dMatrix4 Isgl3dMatrix4Scale(Isgl3dMatrix4 matrix, float sx, float sy, float sz)
{
#if defined(__ARM_NEON__)
    float32x4x4_t iMatrix = *(float32x4x4_t *)&matrix;
    float32x4x4_t m;
    
    m.val[0] = vmulq_n_f32(iMatrix.val[0], (float32_t)sx);
    m.val[1] = vmulq_n_f32(iMatrix.val[1], (float32_t)sy);
    m.val[2] = vmulq_n_f32(iMatrix.val[2], (float32_t)sz);
    m.val[3] = iMatrix.val[3];
    
    return *(Isgl3dMatrix4 *)&m;
#else
    Isgl3dMatrix4 m = { matrix.m[0] * sx, matrix.m[1] * sx, matrix.m[2] * sx, matrix.m[3] * sx,
                        matrix.m[4] * sy, matrix.m[5] * sy, matrix.m[6] * sy, matrix.m[7] * sy,
                        matrix.m[8] * sz, matrix.m[9] * sz, matrix.m[10] * sz, matrix.m[11] * sz,
                        matrix.m[12], matrix.m[13], matrix.m[14], matrix.m[15] };
    return m;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4ScaleWithVector3(Isgl3dMatrix4 matrix, Isgl3dVector3 scaleVector)
{
#if defined(__ARM_NEON__)
    float32x4x4_t iMatrix = *(float32x4x4_t *)&matrix;
    float32x4x4_t m;
    
    m.val[0] = vmulq_n_f32(iMatrix.val[0], (float32_t)scaleVector.v[0]);
    m.val[1] = vmulq_n_f32(iMatrix.val[1], (float32_t)scaleVector.v[1]);
    m.val[2] = vmulq_n_f32(iMatrix.val[2], (float32_t)scaleVector.v[2]);
    m.val[3] = iMatrix.val[3];
    
    return *(Isgl3dMatrix4 *)&m;
#else
    Isgl3dMatrix4 m = { matrix.m[0] * scaleVector.v[0], matrix.m[1] * scaleVector.v[0], matrix.m[2] * scaleVector.v[0], matrix.m[3] * scaleVector.v[0],
        matrix.m[4] * scaleVector.v[1], matrix.m[5] * scaleVector.v[1], matrix.m[6] * scaleVector.v[1], matrix.m[7] * scaleVector.v[1],
        matrix.m[8] * scaleVector.v[2], matrix.m[9] * scaleVector.v[2], matrix.m[10] * scaleVector.v[2], matrix.m[11] * scaleVector.v[2],
        matrix.m[12], matrix.m[13], matrix.m[14], matrix.m[15] };
    return m;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4ScaleWithVector4(Isgl3dMatrix4 matrix, Isgl3dVector4 scaleVector)
{
#if defined(__ARM_NEON__)
    float32x4x4_t iMatrix = *(float32x4x4_t *)&matrix;
    float32x4x4_t m;
    
    m.val[0] = vmulq_n_f32(iMatrix.val[0], (float32_t)scaleVector.v[0]);
    m.val[1] = vmulq_n_f32(iMatrix.val[1], (float32_t)scaleVector.v[1]);
    m.val[2] = vmulq_n_f32(iMatrix.val[2], (float32_t)scaleVector.v[2]);
    m.val[3] = iMatrix.val[3];
    
    return *(Isgl3dMatrix4 *)&m;
#else
    Isgl3dMatrix4 m = { matrix.m[0] * scaleVector.v[0], matrix.m[1] * scaleVector.v[0], matrix.m[2] * scaleVector.v[0], matrix.m[3] * scaleVector.v[0],
        matrix.m[4] * scaleVector.v[1], matrix.m[5] * scaleVector.v[1], matrix.m[6] * scaleVector.v[1], matrix.m[7] * scaleVector.v[1],
        matrix.m[8] * scaleVector.v[2], matrix.m[9] * scaleVector.v[2], matrix.m[10] * scaleVector.v[2], matrix.m[11] * scaleVector.v[2],
        matrix.m[12], matrix.m[13], matrix.m[14], matrix.m[15] };
    return m;
#endif
}

static inline Isgl3dMatrix4 Isgl3dMatrix4Rotate(Isgl3dMatrix4 matrix, float radians, float x, float y, float z)
{
    Isgl3dMatrix4 rm = Isgl3dMatrix4MakeRotation(radians, x, y, z);
    return Isgl3dMatrix4Multiply(matrix, rm);
}

static inline Isgl3dMatrix4 Isgl3dMatrix4RotateWithVector3(Isgl3dMatrix4 matrix, float radians, Isgl3dVector3 axisVector)
{
    Isgl3dMatrix4 rm = Isgl3dMatrix4MakeRotation(radians, axisVector.v[0], axisVector.v[1], axisVector.v[2]);
    return Isgl3dMatrix4Multiply(matrix, rm);
}

static inline Isgl3dMatrix4 Isgl3dMatrix4RotateWithVector4(Isgl3dMatrix4 matrix, float radians, Isgl3dVector4 axisVector)
{
    Isgl3dMatrix4 rm = Isgl3dMatrix4MakeRotation(radians, axisVector.v[0], axisVector.v[1], axisVector.v[2]);
    return Isgl3dMatrix4Multiply(matrix, rm);    
}

static inline Isgl3dMatrix4 Isgl3dMatrix4RotateX(Isgl3dMatrix4 matrix, float radians)
{
    Isgl3dMatrix4 rm = Isgl3dMatrix4MakeXRotation(radians);
    return Isgl3dMatrix4Multiply(matrix, rm);
}

static inline Isgl3dMatrix4 Isgl3dMatrix4RotateY(Isgl3dMatrix4 matrix, float radians)
{
    Isgl3dMatrix4 rm = Isgl3dMatrix4MakeYRotation(radians);
    return Isgl3dMatrix4Multiply(matrix, rm);
}

static inline Isgl3dMatrix4 Isgl3dMatrix4RotateZ(Isgl3dMatrix4 matrix, float radians)
{
    Isgl3dMatrix4 rm = Isgl3dMatrix4MakeZRotation(radians);
    return Isgl3dMatrix4Multiply(matrix, rm);
}

static inline Isgl3dVector3 Isgl3dMatrix4MultiplyVector3(Isgl3dMatrix4 matrixLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector4 v4 = Isgl3dMatrix4MultiplyVector4(matrixLeft, Isgl3dVector4Make(vectorRight.v[0], vectorRight.v[1], vectorRight.v[2], 0.0f));
    return Isgl3dVector3Make(v4.v[0], v4.v[1], v4.v[2]);
}

static inline Isgl3dVector3 Isgl3dMatrix4MultiplyVector3WithTranslation(Isgl3dMatrix4 matrixLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector4 v4 = Isgl3dMatrix4MultiplyVector4(matrixLeft, Isgl3dVector4Make(vectorRight.v[0], vectorRight.v[1], vectorRight.v[2], 1.0f));
    return Isgl3dVector3Make(v4.v[0], v4.v[1], v4.v[2]);
}

static inline Isgl3dVector3 Isgl3dMatrix4MultiplyAndProjectVector3(Isgl3dMatrix4 matrixLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector4 v4 = Isgl3dMatrix4MultiplyVector4(matrixLeft, Isgl3dVector4Make(vectorRight.v[0], vectorRight.v[1], vectorRight.v[2], 1.0f));
    return Isgl3dVector3MultiplyScalar(Isgl3dVector3Make(v4.v[0], v4.v[1], v4.v[2]), 1.0f / v4.v[3]);
}

static inline void Isgl3dMatrix4MultiplyVector3Array(Isgl3dMatrix4 matrix, Isgl3dVector3 *vectors, size_t vectorCount)
{
    int i;
    for (i=0; i < vectorCount; i++)
        vectors[i] = Isgl3dMatrix4MultiplyVector3(matrix, vectors[i]);
}

static inline void Isgl3dMatrix4MultiplyVector3ArrayWithTranslation(Isgl3dMatrix4 matrix, Isgl3dVector3 *vectors, size_t vectorCount)
{
    int i;
    for (i=0; i < vectorCount; i++)
        vectors[i] = Isgl3dMatrix4MultiplyVector3WithTranslation(matrix, vectors[i]);
}

static inline void Isgl3dMatrix4MultiplyAndProjectVector3Array(Isgl3dMatrix4 matrix, Isgl3dVector3 *vectors, size_t vectorCount)
{
    int i;
    for (i=0; i < vectorCount; i++)
        vectors[i] = Isgl3dMatrix4MultiplyAndProjectVector3(matrix, vectors[i]);
}

static inline Isgl3dVector4 Isgl3dMatrix4MultiplyVector4(Isgl3dMatrix4 matrixLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON__)
    float32x4x4_t iMatrix = *(float32x4x4_t *)&matrixLeft;
    float32x4_t v;
    
    iMatrix.val[0] = vmulq_n_f32(iMatrix.val[0], (float32_t)vectorRight.v[0]);
    iMatrix.val[1] = vmulq_n_f32(iMatrix.val[1], (float32_t)vectorRight.v[1]);
    iMatrix.val[2] = vmulq_n_f32(iMatrix.val[2], (float32_t)vectorRight.v[2]);
    iMatrix.val[3] = vmulq_n_f32(iMatrix.val[3], (float32_t)vectorRight.v[3]);
    
    iMatrix.val[0] = vaddq_f32(iMatrix.val[0], iMatrix.val[1]);
    iMatrix.val[2] = vaddq_f32(iMatrix.val[2], iMatrix.val[3]);
    
    v = vaddq_f32(iMatrix.val[0], iMatrix.val[2]);
    
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { matrixLeft.m[0] * vectorRight.v[0] + matrixLeft.m[4] * vectorRight.v[1] + matrixLeft.m[8] * vectorRight.v[2] + matrixLeft.m[12] * vectorRight.v[3],
        matrixLeft.m[1] * vectorRight.v[0] + matrixLeft.m[5] * vectorRight.v[1] + matrixLeft.m[9] * vectorRight.v[2] + matrixLeft.m[13] * vectorRight.v[3],
        matrixLeft.m[2] * vectorRight.v[0] + matrixLeft.m[6] * vectorRight.v[1] + matrixLeft.m[10] * vectorRight.v[2] + matrixLeft.m[14] * vectorRight.v[3],
        matrixLeft.m[3] * vectorRight.v[0] + matrixLeft.m[7] * vectorRight.v[1] + matrixLeft.m[11] * vectorRight.v[2] + matrixLeft.m[15] * vectorRight.v[3] };
    return v;
#endif
}

static inline void Isgl3dMatrix4MultiplyVector4Array(Isgl3dMatrix4 matrix, Isgl3dVector4 *vectors, size_t vectorCount)
{
    int i;
    for (i=0; i < vectorCount; i++)
        vectors[i] = Isgl3dMatrix4MultiplyVector4(matrix, vectors[i]);
}

#ifdef __cplusplus
}
#endif

#endif
