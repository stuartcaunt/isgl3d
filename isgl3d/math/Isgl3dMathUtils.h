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


#include <math.h>
#include <stdbool.h>

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#endif


/*
 * Use GLKit definitions for iOS >= 5.0 and if no strict ANSI compilation is set (C/C++ language dialect)
 * GLKit linkage required in this case
 */
#if !(defined(__STRICT_ANSI__)) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0)

#import <GLKit/GLKMath.h>

#define Isgl3dMathDegreesToRadians GLKMathDegreesToRadians
#define Isgl3dMathRadiansToDegrees GLKMathRadiansToDegrees
#define Isgl3dMathProject GLKMathProject
#define Isgl3dMathUnproject GLKMathUnproject
#define NSStringFromIsgl3dMatrix2 NSStringFromGLKMatrix2
#define NSStringFromIsgl3dMatrix3 NSStringFromGLKMatrix3
#define NSStringFromIsgl3dMatrix4 NSStringFromGLKMatrix4
#define NSStringFromIsgl3dVector2 NSStringFromGLKVector2
#define NSStringFromIsgl3dVector3 NSStringFromGLKVector3
#define NSStringFromIsgl3dVector4 NSStringFromGLKVector4
//#define NSStringFromIsgl3dQuaternion NSStringFromGLKQuaternion

#else


#include <math.h>
#include <stdbool.h>

#include "Isgl3dMathTypes.h"

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#endif


#ifdef __cplusplus
extern "C" {
#endif

static inline float Isgl3dMathDegreesToRadians(float degrees) { return degrees * (M_PI / 180); };
static inline float Isgl3dMathRadiansToDegrees(float radians) { return radians * (180 / M_PI); };

Isgl3dVector3 Isgl3dMathProject(Isgl3dVector3 object, Isgl3dMatrix4 model, Isgl3dMatrix4 projection, int *viewport);
Isgl3dVector3 Isgl3dMathUnproject(Isgl3dVector3 window, Isgl3dMatrix4 model, Isgl3dMatrix4 projection, int *viewport, bool *success);

#ifdef __OBJC__
NSString * NSStringFromIsgl3dMatrix2(Isgl3dMatrix2 matrix);
NSString * NSStringFromIsgl3dMatrix3(Isgl3dMatrix3 matrix);
NSString * NSStringFromIsgl3dMatrix4(Isgl3dMatrix4 matrix);

NSString * NSStringFromIsgl3dVector2(Isgl3dVector2 vector);
NSString * NSStringFromIsgl3dVector3(Isgl3dVector3 vector);
NSString * NSStringFromIsgl3dVector4(Isgl3dVector4 vector);

//NSString * NSStringFromIsgl3dQuaternion(Isgl3dQuaternion quaternion);
#endif

#ifdef __cplusplus
}
#endif

#endif
