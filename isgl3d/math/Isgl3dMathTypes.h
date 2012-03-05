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
 *
 * This file makes the GLKit math functions available for iSGL3D and iOS 4.x.
 * Some of the code is based on the Apple GLKit implementations.
 *
 */

#ifndef isgl3d_Isgl3dMathTypes_h
#define isgl3d_Isgl3dMathTypes_h


/*
 * Use GLKit definitions for iOS >= 5.0 and if no strict ANSI compilation is set (C/C++ language dialect)
 * GLKit linkage required in this case
 */
#if !(defined(__STRICT_ANSI__)) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0)

#import <GLKit/GLKit.h>

#define Isgl3dMatrix2 GLKMatrix2
#define Isgl3dMatrix3 GLKMatrix3
#define Isgl3dMatrix4 GLKMatrix4

#define Isgl3dVector2 GLKVector2
#define Isgl3dVector3 GLKVector3
#define Isgl3dVector4 GLKVector4
#define Isgl3dQuaternion GLKQuaternion


#else // __IPHONE_5_0


#ifdef __cplusplus
extern "C" {
#endif


/*
 * Matrix definitions (2x2, 3x3, 4x4)
 *   All structs are meant to be used in column major order
 */
union _Isgl3dMatrix2
{
    struct
    {
        float m00, m01;
        float m10, m11;
    };
    float m2[2][2];
    float m[4];
};
typedef union _Isgl3dMatrix2 Isgl3dMatrix2;
    
union _Isgl3dMatrix3
{
    struct
    {
        float m00, m01, m02;
        float m10, m11, m12;
        float m20, m21, m22;
    };
    float m[9];
};
typedef union _Isgl3dMatrix3 Isgl3dMatrix3;
    
union _Isgl3dMatrix4
{
    struct
    {
        float m00, m01, m02, m03;
        float m10, m11, m12, m13;
        float m20, m21, m22, m23;
        float m30, m31, m32, m33;
    };
    float m[16];
} __attribute__((aligned(16)));
typedef union _Isgl3dMatrix4 Isgl3dMatrix4;


/*
 * Vector definitions (2dim, 3dim, 4dim)
 */
union _Isgl3dVector2
{
    struct { float x, y; };
    struct { float s, t; };
    float v[2];
};
typedef union _Isgl3dVector2 Isgl3dVector2;

union _Isgl3dVector3
{
    struct { float x, y, z; };
    struct { float r, g, b; };
    struct { float s, t, p; };
    float v[3];
};
typedef union _Isgl3dVector3 Isgl3dVector3;

union _Isgl3dVector4
{
    struct { float x, y, z, w; };
    struct { float r, g, b, a; };
    struct { float s, t, p, q; };
    float v[4];
} __attribute__((aligned(16)));
typedef union _Isgl3dVector4 Isgl3dVector4;


/*
 * Quaternion
 */
union _Isgl3dQuaternion
{
    struct { Isgl3dVector3 v; float s; };
    struct { float x, y, z, w; };
    float q[4];
} __attribute__((aligned(16)));
typedef union _Isgl3dQuaternion Isgl3dQuaternion;    

    
#ifdef __cplusplus
}
#endif


#endif // __IPHONE_5_0


#endif // isgl3d_Isgl3dMathTypes_h
