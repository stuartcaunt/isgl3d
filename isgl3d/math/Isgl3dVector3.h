/*
 * iSGL3D: http:isgl3d.com
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

#import "math.h"
#import "Isgl3dMathTypes.h"


/*
 * Use GLKit definitions for iOS >= 5.0 and if no strict ANSI compilation is set (C/C++ language dialect)
 * GLKit linkage required in this case
 */
#if !(defined(__STRICT_ANSI__)) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0)

#import <GLKit/GLKMath.h>


#define Isgl3dVector3Make GLKVector3Make
#define Isgl3dVector3MakeWithArray GLKVector3MakeWithArray
#define Isgl3dVector3Negate GLKVector3Negate
#define Isgl3dVector3Add GLKVector3Add
#define Isgl3dVector3Subtract GLKVector3Subtract
#define Isgl3dVector3Multiply GLKVector3Multiply
#define Isgl3dVector3Divide GLKVector3Divide
#define Isgl3dVector3AddScalar GLKVector3AddScalar
#define Isgl3dVector3SubtractScalar GLKVector3SubtractScalar
#define Isgl3dVector3MultiplyScalar GLKVector3MultiplyScalar
#define Isgl3dVector3DivideScalar GLKVector3DivideScalar

#define Isgl3dVector3Maximum GLKVector3Maximum
#define Isgl3dVector3Minimum GLKVector3Minimum
#define Isgl3dVector3AllEqualToVector3 GLKVector3AllEqualToVector3
#define Isgl3dVector3AllEqualToScalar GLKVector3AllEqualToScalar
#define Isgl3dVector3AllGreaterThanVector3 GLKVector3AllGreaterThanVector3
#define Isgl3dVector3AllGreaterThanScalar GLKVector3AllGreaterThanScalar
#define Isgl3dVector3AllGreaterThanOrEqualToVector3 GLKVector3AllGreaterThanOrEqualToVector3
#define Isgl3dVector3AllGreaterThanOrEqualToScalar GLKVector3AllGreaterThanOrEqualToScalar
#define Isgl3dVector3Normalize GLKVector3Normalize
#define Isgl3dVector3DotProduct GLKVector3DotProduct
#define Isgl3dVector3Length GLKVector3Length
#define Isgl3dVector3Distance GLKVector3Distance
#define Isgl3dVector3Lerp GLKVector3Lerp
#define Isgl3dVector3CrossProduct GLKVector3CrossProduct
#define Isgl3dVector3Project GLKVector3Project


#else


#include <stdbool.h>
#include <math.h>


#ifdef __cplusplus
extern "C" {
#endif

#pragma mark -
#pragma mark GLKit compatible Prototypes
#pragma mark -
static inline Isgl3dVector3 Isgl3dVector3Make(float x, float y, float z);
static inline Isgl3dVector3 Isgl3dVector3MakeWithArray(float values[3]);
static inline Isgl3dVector3 Isgl3dVector3Negate(Isgl3dVector3 vector);
static inline Isgl3dVector3 Isgl3dVector3Add(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline Isgl3dVector3 Isgl3dVector3Subtract(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline Isgl3dVector3 Isgl3dVector3Multiply(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline Isgl3dVector3 Isgl3dVector3Divide(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline Isgl3dVector3 Isgl3dVector3AddScalar(Isgl3dVector3 vector, float value);
static inline Isgl3dVector3 Isgl3dVector3MultiplyScalar(Isgl3dVector3 vector, float value);
static inline Isgl3dVector3 Isgl3dVector3DivideScalar(Isgl3dVector3 vector, float value);
static inline Isgl3dVector3 Isgl3dVector3Maximum(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline Isgl3dVector3 Isgl3dVector3Minimum(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline bool Isgl3dVector3AllEqualToVector3(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline bool Isgl3dVector3AllEqualToScalar(Isgl3dVector3 vector, float value);
static inline bool Isgl3dVector3AllGreaterThanVector3(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline bool Isgl3dVector3AllGreaterThanScalar(Isgl3dVector3 vector, float value);
static inline bool Isgl3dVector3AllGreaterThanOrEqualToVector3(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline bool Isgl3dVector3AllGreaterThanOrEqualToScalar(Isgl3dVector3 vector, float value);
static inline Isgl3dVector3 Isgl3dVector3Normalize(Isgl3dVector3 vector);
static inline float Isgl3dVector3DotProduct(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline float Isgl3dVector3Length(Isgl3dVector3 vector);
static inline float Isgl3dVector3Distance(Isgl3dVector3 vectorStart, Isgl3dVector3 vectorEnd);
static inline Isgl3dVector3 Isgl3dVector3Lerp(Isgl3dVector3 vectorStart, Isgl3dVector3 vectorEnd, float t);
static inline Isgl3dVector3 Isgl3dVector3CrossProduct(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight);
static inline Isgl3dVector3 Isgl3dVector3Project(Isgl3dVector3 vectorToProject, Isgl3dVector3 projectionVector);


#pragma mark -
#pragma mark GLKit compatible Implementations
#pragma mark -
static inline Isgl3dVector3 Isgl3dVector3Make(float x, float y, float z)
{
    Isgl3dVector3 v = { x, y, z };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3MakeWithArray(float values[3])
{
    Isgl3dVector3 v = { values[0], values[1], values[2] };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3Negate(Isgl3dVector3 vector)
{
    Isgl3dVector3 v = { -vector.v[0], -vector.v[1], -vector.v[2] };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3Add(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector3 v = { vectorLeft.v[0] + vectorRight.v[0],
                        vectorLeft.v[1] + vectorRight.v[1],
                        vectorLeft.v[2] + vectorRight.v[2] };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3Subtract(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector3 v = { vectorLeft.v[0] - vectorRight.v[0],
                        vectorLeft.v[1] - vectorRight.v[1],
                        vectorLeft.v[2] - vectorRight.v[2] };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3Multiply(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector3 v = { vectorLeft.v[0] * vectorRight.v[0],
                        vectorLeft.v[1] * vectorRight.v[1],
                        vectorLeft.v[2] * vectorRight.v[2] };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3Divide(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector3 v = { vectorLeft.v[0] / vectorRight.v[0],
                        vectorLeft.v[1] / vectorRight.v[1],
                        vectorLeft.v[2] / vectorRight.v[2] };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3AddScalar(Isgl3dVector3 vector, float value)
{
    Isgl3dVector3 v = { vector.v[0] + value,
                        vector.v[1] + value,
                        vector.v[2] + value };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3SubtractScalar(Isgl3dVector3 vector, float value)
{
    Isgl3dVector3 v = { vector.v[0] - value,
                        vector.v[1] - value,
                        vector.v[2] - value };
    return v;    
}

static inline Isgl3dVector3 Isgl3dVector3MultiplyScalar(Isgl3dVector3 vector, float value)
{
    Isgl3dVector3 v = { vector.v[0] * value,
                        vector.v[1] * value,
                        vector.v[2] * value };
    return v;   
}

static inline Isgl3dVector3 Isgl3dVector3DivideScalar(Isgl3dVector3 vector, float value)
{
    Isgl3dVector3 v = { vector.v[0] / value,
                        vector.v[1] / value,
                        vector.v[2] / value };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3Maximum(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector3 max = vectorLeft;
    if (vectorRight.v[0] > vectorLeft.v[0])
        max.v[0] = vectorRight.v[0];
    if (vectorRight.v[1] > vectorLeft.v[1])
        max.v[1] = vectorRight.v[1];
    if (vectorRight.v[2] > vectorLeft.v[2])
        max.v[2] = vectorRight.v[2];
    return max;
}

static inline Isgl3dVector3 Isgl3dVector3Minimum(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector3 min = vectorLeft;
    if (vectorRight.v[0] < vectorLeft.v[0])
        min.v[0] = vectorRight.v[0];
    if (vectorRight.v[1] < vectorLeft.v[1])
        min.v[1] = vectorRight.v[1];
    if (vectorRight.v[2] < vectorLeft.v[2])
        min.v[2] = vectorRight.v[2];
    return min;
}

static inline bool Isgl3dVector3AllEqualToVector3(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    bool compare = false;
    if (vectorLeft.v[0] == vectorRight.v[0] &&
        vectorLeft.v[1] == vectorRight.v[1] &&
        vectorLeft.v[2] == vectorRight.v[2])
        compare = true;
    return compare;
}

static inline bool Isgl3dVector3AllEqualToScalar(Isgl3dVector3 vector, float value)
{
    bool compare = false;
    if (vector.v[0] == value &&
        vector.v[1] == value &&
        vector.v[2] == value)
        compare = true;
    return compare;
}

static inline bool Isgl3dVector3AllGreaterThanVector3(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    bool compare = false;
    if (vectorLeft.v[0] > vectorRight.v[0] &&
        vectorLeft.v[1] > vectorRight.v[1] &&
        vectorLeft.v[2] > vectorRight.v[2])
        compare = true;
    return compare;
}

static inline bool Isgl3dVector3AllGreaterThanScalar(Isgl3dVector3 vector, float value)
{
    bool compare = false;
    if (vector.v[0] > value &&
        vector.v[1] > value &&
        vector.v[2] > value)
        compare = true;
    return compare;
}

static inline bool Isgl3dVector3AllGreaterThanOrEqualToVector3(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    bool compare = false;
    if (vectorLeft.v[0] >= vectorRight.v[0] &&
        vectorLeft.v[1] >= vectorRight.v[1] &&
        vectorLeft.v[2] >= vectorRight.v[2])
        compare = true;
    return compare;
}

static inline bool Isgl3dVector3AllGreaterThanOrEqualToScalar(Isgl3dVector3 vector, float value)
{
    bool compare = false;
    if (vector.v[0] >= value &&
        vector.v[1] >= value &&
        vector.v[2] >= value)
        compare = true;
    return compare;
}

static inline Isgl3dVector3 Isgl3dVector3Normalize(Isgl3dVector3 vector)
{
    float scale = 1.0f / Isgl3dVector3Length(vector);
    Isgl3dVector3 v = { vector.v[0] * scale, vector.v[1] * scale, vector.v[2] * scale };
    return v;
}

static inline float Isgl3dVector3DotProduct(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    return vectorLeft.v[0] * vectorRight.v[0] + vectorLeft.v[1] * vectorRight.v[1] + vectorLeft.v[2] * vectorRight.v[2];
}

static inline float Isgl3dVector3Length(Isgl3dVector3 vector)
{
    return sqrt(vector.v[0] * vector.v[0] + vector.v[1] * vector.v[1] + vector.v[2] * vector.v[2]);
}

static inline float Isgl3dVector3Distance(Isgl3dVector3 vectorStart, Isgl3dVector3 vectorEnd)
{
    return Isgl3dVector3Length(Isgl3dVector3Subtract(vectorEnd, vectorStart));
}

static inline Isgl3dVector3 Isgl3dVector3Lerp(Isgl3dVector3 vectorStart, Isgl3dVector3 vectorEnd, float t)
{
    Isgl3dVector3 v = { vectorStart.v[0] + ((vectorEnd.v[0] - vectorStart.v[0]) * t),
                        vectorStart.v[1] + ((vectorEnd.v[1] - vectorStart.v[1]) * t),
                        vectorStart.v[2] + ((vectorEnd.v[2] - vectorStart.v[2]) * t) };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3CrossProduct(Isgl3dVector3 vectorLeft, Isgl3dVector3 vectorRight)
{
    Isgl3dVector3 v = { vectorLeft.v[1] * vectorRight.v[2] - vectorLeft.v[2] * vectorRight.v[1],
                        vectorLeft.v[2] * vectorRight.v[0] - vectorLeft.v[0] * vectorRight.v[2],
                        vectorLeft.v[0] * vectorRight.v[1] - vectorLeft.v[1] * vectorRight.v[0] };
    return v;
}

static inline Isgl3dVector3 Isgl3dVector3Project(Isgl3dVector3 vectorToProject, Isgl3dVector3 projectionVector)
{
    float scale = Isgl3dVector3DotProduct(projectionVector, vectorToProject) / Isgl3dVector3DotProduct(projectionVector, projectionVector);
    Isgl3dVector3 v = Isgl3dVector3MultiplyScalar(projectionVector, scale);
    return v;
}

#ifdef __cplusplus
}
#endif

#endif
