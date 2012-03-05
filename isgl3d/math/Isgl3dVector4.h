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


#define Isgl3dVector4Make GLKVector4Make
#define Isgl3dVector4MakeWithArray GLKVector4MakeWithArray
#define Isgl3dVector4MakeWithVector3 GLKVector4MakeWithVector3
#define Isgl3dVector4Negate GLKVector4Negate
#define Isgl3dVector4Add GLKVector4Add
#define Isgl3dVector4Subtract GLKVector4Subtract
#define Isgl3dVector4Multiply GLKVector4Multiply
#define Isgl3dVector4Divide GLKVector4Divide
#define Isgl3dVector4AddScalar GLKVector4AddScalar
#define Isgl3dVector4SubtractScalar GLKVector4SubtractScalar
#define Isgl3dVector4MultiplyScalar GLKVector4MultiplyScalar
#define Isgl3dVector4DivideScalar GLKVector4DivideScalar
#define Isgl3dVector4Maximum GLKVector4Maximum
#define Isgl3dVector4Minimum GLKVector4Minimum
#define Isgl3dVector4AllEqualToVector4 GLKVector4AllEqualToVector4
#define Isgl3dVector4AllEqualToScalar GLKVector4AllEqualToScalar
#define Isgl3dVector4AllGreaterThanVector4 GLKVector4AllGreaterThanVector4
#define Isgl3dVector4AllGreaterThanScalar GLKVector4AllGreaterThanScalar
#define Isgl3dVector4AllGreaterThanOrEqualToVector4 GLKVector4AllGreaterThanOrEqualToVector4
#define Isgl3dVector4AllGreaterThanOrEqualToScalar GLKVector4AllGreaterThanOrEqualToScalar
#define Isgl3dVector4Normalize GLKVector4Normalize
#define Isgl3dVector4DotProduct GLKVector4DotProduct
#define Isgl3dVector4Length GLKVector4Length
#define Isgl3dVector4Distance GLKVector4Distance
#define Isgl3dVector4Lerp GLKVector4Lerp
#define Isgl3dVector4CrossProduct GLKVector4CrossProduct
#define Isgl3dVector4Project GLKVector4Project


#else


#include <stdbool.h>
#include <math.h>

#if defined(__ARM_NEON__)
#include <arm_neon.h>
#endif


#pragma mark -
#pragma mark GLKit compatible Prototypes
#pragma mark -

#ifdef __cplusplus
extern "C" {
#endif

static inline Isgl3dVector4 Isgl3dVector4Make(float x, float y, float z, float w);
static inline Isgl3dVector4 Isgl3dVector4MakeWithArray(float values[4]);
static inline Isgl3dVector4 Isgl3dVector4MakeWithVector3(Isgl3dVector3 vector, float w);
static inline Isgl3dVector4 Isgl3dVector4Negate(Isgl3dVector4 vector);
static inline Isgl3dVector4 Isgl3dVector4Add(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline Isgl3dVector4 Isgl3dVector4Subtract(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline Isgl3dVector4 Isgl3dVector4Multiply(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline Isgl3dVector4 Isgl3dVector4Divide(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline Isgl3dVector4 Isgl3dVector4AddScalar(Isgl3dVector4 vector, float value);
static inline Isgl3dVector4 Isgl3dVector4SubtractScalar(Isgl3dVector4 vector, float value);
static inline Isgl3dVector4 Isgl3dVector4MultiplyScalar(Isgl3dVector4 vector, float value);
static inline Isgl3dVector4 Isgl3dVector4DivideScalar(Isgl3dVector4 vector, float value);
static inline Isgl3dVector4 Isgl3dVector4Maximum(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline Isgl3dVector4 Isgl3dVector4Minimum(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline bool Isgl3dVector4AllEqualToVector4(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline bool Isgl3dVector4AllEqualToScalar(Isgl3dVector4 vector, float value);
static inline bool Isgl3dVector4AllGreaterThanVector4(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline bool Isgl3dVector4AllGreaterThanScalar(Isgl3dVector4 vector, float value);
static inline bool Isgl3dVector4AllGreaterThanOrEqualToVector4(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline bool Isgl3dVector4AllGreaterThanOrEqualToScalar(Isgl3dVector4 vector, float value);
static inline Isgl3dVector4 Isgl3dVector4Normalize(Isgl3dVector4 vector);
static inline float Isgl3dVector4DotProduct(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline float Isgl3dVector4Length(Isgl3dVector4 vector);
static inline float Isgl3dVector4Distance(Isgl3dVector4 vectorStart, Isgl3dVector4 vectorEnd);
static inline Isgl3dVector4 Isgl3dVector4Lerp(Isgl3dVector4 vectorStart, Isgl3dVector4 vectorEnd, float t);
static inline Isgl3dVector4 Isgl3dVector4CrossProduct(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight);
static inline Isgl3dVector4 Isgl3dVector4Project(Isgl3dVector4 vectorToProject, Isgl3dVector4 projectionVector);


#pragma mark -
#pragma mark GLKit compatible Implementations
#pragma mark -
static inline Isgl3dVector4 Isgl3dVector4Make(float x, float y, float z, float w)
{
    Isgl3dVector4 v = { x, y, z, w };
    return v;
}

static inline Isgl3dVector4 Isgl3dVector4MakeWithArray(float values[4])
{
#if defined(__ARM_NEON__)
    float32x4_t v = vld1q_f32(values);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { values[0], values[1], values[2], values[3] };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4MakeWithVector3(Isgl3dVector3 vector, float w)
{
    Isgl3dVector4 v = { vector.v[0], vector.v[1], vector.v[2], w };
    return v;
}

static inline Isgl3dVector4 Isgl3dVector4Negate(Isgl3dVector4 vector)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vnegq_f32(*(float32x4_t *)&vector);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { -vector.v[0], -vector.v[1], -vector.v[2], -vector.v[3] };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4Add(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vaddq_f32(*(float32x4_t *)&vectorLeft,
                              *(float32x4_t *)&vectorRight);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { vectorLeft.v[0] + vectorRight.v[0],
                        vectorLeft.v[1] + vectorRight.v[1],
                        vectorLeft.v[2] + vectorRight.v[2],
                        vectorLeft.v[3] + vectorRight.v[3] };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4Subtract(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vsubq_f32(*(float32x4_t *)&vectorLeft,
                              *(float32x4_t *)&vectorRight);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { vectorLeft.v[0] - vectorRight.v[0],
                        vectorLeft.v[1] - vectorRight.v[1],
                        vectorLeft.v[2] - vectorRight.v[2],
                        vectorLeft.v[3] - vectorRight.v[3] };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4Multiply(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vmulq_f32(*(float32x4_t *)&vectorLeft,
                              *(float32x4_t *)&vectorRight);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { vectorLeft.v[0] * vectorRight.v[0],
                        vectorLeft.v[1] * vectorRight.v[1],
                        vectorLeft.v[2] * vectorRight.v[2],
                        vectorLeft.v[3] * vectorRight.v[3] };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4Divide(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON__)
    float32x4_t *vLeft = (float32x4_t *)&vectorLeft;
    float32x4_t *vRight = (float32x4_t *)&vectorRight;
    float32x4_t estimate = vrecpeq_f32(*vRight);    
    estimate = vmulq_f32(vrecpsq_f32(*vRight, estimate), estimate);
    estimate = vmulq_f32(vrecpsq_f32(*vRight, estimate), estimate);
    float32x4_t v = vmulq_f32(*vLeft, estimate);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { vectorLeft.v[0] / vectorRight.v[0],
                        vectorLeft.v[1] / vectorRight.v[1],
                        vectorLeft.v[2] / vectorRight.v[2],
                        vectorLeft.v[3] / vectorRight.v[3] };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4AddScalar(Isgl3dVector4 vector, float value)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vaddq_f32(*(float32x4_t *)&vector,
                              vdupq_n_f32((float32_t)value));
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { vector.v[0] + value,
                        vector.v[1] + value,
                        vector.v[2] + value,
                        vector.v[3] + value };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4SubtractScalar(Isgl3dVector4 vector, float value)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vsubq_f32(*(float32x4_t *)&vector,
                              vdupq_n_f32((float32_t)value));
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { vector.v[0] - value,
                        vector.v[1] - value,
                        vector.v[2] - value,
                        vector.v[3] - value };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4MultiplyScalar(Isgl3dVector4 vector, float value)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vmulq_f32(*(float32x4_t *)&vector,
                              vdupq_n_f32((float32_t)value));
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { vector.v[0] * value,
                        vector.v[1] * value,
                        vector.v[2] * value,
                        vector.v[3] * value };
    return v;   
#endif
}

static inline Isgl3dVector4 Isgl3dVector4DivideScalar(Isgl3dVector4 vector, float value)
{
#if defined(__ARM_NEON__)
    float32x4_t values = vdupq_n_f32((float32_t)value);
    float32x4_t estimate = vrecpeq_f32(values);    
    estimate = vmulq_f32(vrecpsq_f32(values, estimate), estimate);
    estimate = vmulq_f32(vrecpsq_f32(values, estimate), estimate);
    float32x4_t v = vmulq_f32(*(float32x4_t *)&vector, estimate);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { vector.v[0] / value,
                        vector.v[1] / value,
                        vector.v[2] / value,
                        vector.v[3] / value };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4Maximum(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vmaxq_f32(*(float32x4_t *)&vectorLeft,
                              *(float32x4_t *)&vectorRight);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 max = vectorLeft;
    if (vectorRight.v[0] > vectorLeft.v[0])
        max.v[0] = vectorRight.v[0];
    if (vectorRight.v[1] > vectorLeft.v[1])
        max.v[1] = vectorRight.v[1];
    if (vectorRight.v[2] > vectorLeft.v[2])
        max.v[2] = vectorRight.v[2];
    if (vectorRight.v[3] > vectorLeft.v[3])
        max.v[3] = vectorRight.v[3];
    return max;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4Minimum(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vminq_f32(*(float32x4_t *)&vectorLeft,
                              *(float32x4_t *)&vectorRight);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 min = vectorLeft;
    if (vectorRight.v[0] < vectorLeft.v[0])
        min.v[0] = vectorRight.v[0];
    if (vectorRight.v[1] < vectorLeft.v[1])
        min.v[1] = vectorRight.v[1];
    if (vectorRight.v[2] < vectorLeft.v[2])
        min.v[2] = vectorRight.v[2];
    if (vectorRight.v[3] < vectorLeft.v[3])
        min.v[3] = vectorRight.v[3];
    return min;
#endif
}

static inline bool Isgl3dVector4AllEqualToVector4(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON_)
    float32x4_t v1 = *(float32x4_t *)&vectorLeft;
    float32x4_t v2 = *(float32x4_t *)&vectorRight;
    uint32x4_t vCmp = vceqq_f32(v1, v2);
    uint32x2_t vAnd = vand_u32(vget_low_u32(vCmp), vget_high_u32(vCmp));
    vAnd = vand_u32(vAnd, vext_u32(vAnd, vAnd, 1));
    vAnd = vand_u32(vAnd, vdup_n_u32(1));
    return (bool)vget_lane_u32(vAnd, 0);
#else
    bool compare = false;
    if (vectorLeft.v[0] == vectorRight.v[0] &&
        vectorLeft.v[1] == vectorRight.v[1] &&
        vectorLeft.v[2] == vectorRight.v[2] &&
        vectorLeft.v[3] == vectorRight.v[3])
        compare = true;
    return compare;
#endif
}

static inline bool Isgl3dVector4AllEqualToScalar(Isgl3dVector4 vector, float value)
{
#if defined(__ARM_NEON_)
    float32x4_t v1 = *(float32x4_t *)&vector;
    float32x4_t v2 = vdupq_n_f32(value);
    uint32x4_t vCmp = vceqq_f32(v1, v2);
    uint32x2_t vAnd = vand_u32(vget_low_u32(vCmp), vget_high_u32(vCmp));
    vAnd = vand_u32(vAnd, vext_u32(vAnd, vAnd, 1));
    vAnd = vand_u32(vAnd, vdup_n_u32(1));
    return (bool)vget_lane_u32(vAnd, 0);
#else
    bool compare = false;
    if (vector.v[0] == value &&
        vector.v[1] == value &&
        vector.v[2] == value &&
        vector.v[3] == value)
        compare = true;
    return compare;
#endif
}

static inline bool Isgl3dVector4AllGreaterThanVector4(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON_)
    float32x4_t v1 = *(float32x4_t *)&vectorLeft;
    float32x4_t v2 = *(float32x4_t *)&vectorRight;
    uint32x4_t vCmp = vcgtq_f32(v1, v2);
    uint32x2_t vAnd = vand_u32(vget_low_u32(vCmp), vget_high_u32(vCmp));
    vAnd = vand_u32(vAnd, vext_u32(vAnd, vAnd, 1));
    vAnd = vand_u32(vAnd, vdup_n_u32(1));
    return (bool)vget_lane_u32(vAnd, 0);
#else
    bool compare = false;
    if (vectorLeft.v[0] > vectorRight.v[0] &&
        vectorLeft.v[1] > vectorRight.v[1] &&
        vectorLeft.v[2] > vectorRight.v[2] &&
        vectorLeft.v[3] > vectorRight.v[3])
        compare = true;
    return compare;
#endif
}

static inline bool Isgl3dVector4AllGreaterThanScalar(Isgl3dVector4 vector, float value)
{
#if defined(__ARM_NEON_)
    float32x4_t v1 = *(float32x4_t *)&vector;
    float32x4_t v2 = vdupq_n_f32(value);
    uint32x4_t vCmp = vcgtq_f32(v1, v2);
    uint32x2_t vAnd = vand_u32(vget_low_u32(vCmp), vget_high_u32(vCmp));
    vAnd = vand_u32(vAnd, vext_u32(vAnd, vAnd, 1));
    vAnd = vand_u32(vAnd, vdup_n_u32(1));
    return (bool)vget_lane_u32(vAnd, 0);
#else
    bool compare = false;
    if (vector.v[0] > value &&
        vector.v[1] > value &&
        vector.v[2] > value &&
        vector.v[3] > value)
        compare = true;
    return compare;
#endif
}

static inline bool Isgl3dVector4AllGreaterThanOrEqualToVector4(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON_)
    float32x4_t v1 = *(float32x4_t *)&vectorLeft;
    float32x4_t v2 = *(float32x4_t *)&vectorRight;
    uint32x4_t vCmp = vcgeq_f32(v1, v2);
    uint32x2_t vAnd = vand_u32(vget_low_u32(vCmp), vget_high_u32(vCmp));
    vAnd = vand_u32(vAnd, vext_u32(vAnd, vAnd, 1));
    vAnd = vand_u32(vAnd, vdup_n_u32(1));
    return (bool)vget_lane_u32(vAnd, 0);
#else
    bool compare = false;
    if (vectorLeft.v[0] >= vectorRight.v[0] &&
        vectorLeft.v[1] >= vectorRight.v[1] &&
        vectorLeft.v[2] >= vectorRight.v[2] &&
        vectorLeft.v[3] >= vectorRight.v[3])
        compare = true;
    return compare;
#endif
}

static inline bool Isgl3dVector4AllGreaterThanOrEqualToScalar(Isgl3dVector4 vector, float value)
{
#if defined(__ARM_NEON_)
    float32x4_t v1 = *(float32x4_t *)&vector;
    float32x4_t v2 = vdupq_n_f32(value);
    uint32x4_t vCmp = vcgeq_f32(v1, v2);
    uint32x2_t vAnd = vand_u32(vget_low_u32(vCmp), vget_high_u32(vCmp));
    vAnd = vand_u32(vAnd, vext_u32(vAnd, vAnd, 1));
    vAnd = vand_u32(vAnd, vdup_n_u32(1));
    return (bool)vget_lane_u32(vAnd, 0);
#else
    bool compare = false;
    if (vector.v[0] >= value &&
        vector.v[1] >= value &&
        vector.v[2] >= value &&
        vector.v[3] >= value)
        compare = true;
    return compare;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4Normalize(Isgl3dVector4 vector)
{
    float scale = 1.0f / Isgl3dVector4Length(vector);
    Isgl3dVector4 v = Isgl3dVector4MultiplyScalar(vector, scale);
    return v;
}

static inline float Isgl3dVector4DotProduct(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vmulq_f32(*(float32x4_t *)&vectorLeft,
                              *(float32x4_t *)&vectorRight);
    float32x2_t v2 = vpadd_f32(vget_low_f32(v), vget_high_f32(v));
    v2 = vpadd_f32(v2, v2);
    return vget_lane_f32(v2, 0);
#else
    return vectorLeft.v[0] * vectorRight.v[0] +
    vectorLeft.v[1] * vectorRight.v[1] +
    vectorLeft.v[2] * vectorRight.v[2] +
    vectorLeft.v[3] * vectorRight.v[3];
#endif
}

static inline float Isgl3dVector4Length(Isgl3dVector4 vector)
{
#if defined(__ARM_NEON__)
    float32x4_t v = vmulq_f32(*(float32x4_t *)&vector,
                              *(float32x4_t *)&vector);
    float32x2_t v2 = vpadd_f32(vget_low_f32(v), vget_high_f32(v));
    v2 = vpadd_f32(v2, v2);
    return sqrt(vget_lane_f32(v2, 0));
#else
    return sqrt(vector.v[0] * vector.v[0] +
                vector.v[1] * vector.v[1] +
                vector.v[2] * vector.v[2] +
                vector.v[3] * vector.v[3]);
#endif
}

static inline float Isgl3dVector4Distance(Isgl3dVector4 vectorStart, Isgl3dVector4 vectorEnd)
{
    return Isgl3dVector4Length(Isgl3dVector4Subtract(vectorEnd, vectorStart));
}

static inline Isgl3dVector4 Isgl3dVector4Lerp(Isgl3dVector4 vectorStart, Isgl3dVector4 vectorEnd, float t)
{
#if defined(__ARM_NEON__)
    float32x4_t vDiff = vsubq_f32(*(float32x4_t *)&vectorEnd,
                                  *(float32x4_t *)&vectorStart);
    vDiff = vmulq_f32(vDiff, vdupq_n_f32((float32_t)t));
    float32x4_t v = vaddq_f32(*(float32x4_t *)&vectorStart, vDiff);
    return *(Isgl3dVector4 *)&v;
#else
    Isgl3dVector4 v = { vectorStart.v[0] + ((vectorEnd.v[0] - vectorStart.v[0]) * t),
                        vectorStart.v[1] + ((vectorEnd.v[1] - vectorStart.v[1]) * t),
                        vectorStart.v[2] + ((vectorEnd.v[2] - vectorStart.v[2]) * t),
                        vectorStart.v[3] + ((vectorEnd.v[3] - vectorStart.v[3]) * t) };
    return v;
#endif
}

static inline Isgl3dVector4 Isgl3dVector4CrossProduct(Isgl3dVector4 vectorLeft, Isgl3dVector4 vectorRight)
{
    Isgl3dVector4 v = { vectorLeft.v[1] * vectorRight.v[2] - vectorLeft.v[2] * vectorRight.v[1],
                        vectorLeft.v[2] * vectorRight.v[0] - vectorLeft.v[0] * vectorRight.v[2],
                        vectorLeft.v[0] * vectorRight.v[1] - vectorLeft.v[1] * vectorRight.v[0],
        0.0f };
    return v;
}

static inline Isgl3dVector4 Isgl3dVector4Project(Isgl3dVector4 vectorToProject, Isgl3dVector4 projectionVector)
{
    float scale = Isgl3dVector4DotProduct(projectionVector, vectorToProject) / Isgl3dVector4DotProduct(projectionVector, projectionVector);
    Isgl3dVector4 v = Isgl3dVector4MultiplyScalar(projectionVector, scale);
    return v;
}

#ifdef __cplusplus
}
#endif

#endif
