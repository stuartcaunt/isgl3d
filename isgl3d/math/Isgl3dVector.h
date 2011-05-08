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

#import "math.h"

#define iv3(X, Y, Z) iv3Create(X, Y, Z)
#define iv4(X, Y, Z, W) iv4Create(X, Y, Z, W)


/**
 * Simple structure to hold the components of a 3 dimensional vector.
 */
typedef struct {
	float x; // Note: removed __attribute__ ((aligned) to compile with LLVM GCC, crashes at run-time otherwise
	float y;
	float z;
} Isgl3dVector3;

/**
 * Simple structure to hold the components of a 4 dimensional vector.
 */
typedef struct {
	float x; // Note: removed __attribute__ ((aligned) to compile with LLVM GCC, crashes at run-time otherwise
	float y;
	float z;
	float w;
} Isgl3dVector4;


#pragma mark Isgl3dVector3

extern Isgl3dVector3 Isgl3dVector3Forward;
extern Isgl3dVector3 Isgl3dVector3Backward;
extern Isgl3dVector3 Isgl3dVector3Left;
extern Isgl3dVector3 Isgl3dVector3Right;
extern Isgl3dVector3 Isgl3dVector3Up;
extern Isgl3dVector3 Isgl3dVector3Down;


/**
 * Creates a vector with the given components.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 */
static inline Isgl3dVector3 iv3Create(float x, float y, float z)
{
	Isgl3dVector3 v = {x, y, z};
	return v;
}


/**
 * Resets all the vector components to 0.
 * @param a The vector to be modified.
 */
static inline void iv3Reset(Isgl3dVector3 * a)
{
	a->x = 0;
	a->y = 0;
	a->z = 0;
}

/**
 * Copies the vector components of one vector into another.
 * @param a The destination vector.
 * @param b The source vector.
 */
static inline void iv3Copy(Isgl3dVector3 * a, Isgl3dVector3 * b)
{
	a->x = b->x;
	a->y = b->y;
	a->z = b->z;
}

/**
 * Copies values into a vector.
 * @param a The destination vector.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 */
static inline void iv3Fill(Isgl3dVector3 * a, float x, float y, float z)
{
	a->x = x;
	a->y = y;
	a->z = z;
}

/**
 * Performs addition of two vectors. Produces a = a + b.
 * @param a The first vector.
 * @param b The second vector.
 */
static inline void iv3Add(Isgl3dVector3 * a, Isgl3dVector3 * b)
{
	a->x += b->x;
	a->y += b->y;
	a->z += b->z;
}

/**
 * Performs addition of vector components to a vector. 
 * @param a The first vector.
 * @param x The x component to be added.
 * @param y The y component to be added.
 * @param z The z component to be added.
 */
static inline void iv3AddComponents(Isgl3dVector3 * a, float x, float y, float z)
{
	a->x += x;
	a->y += y;
	a->z += z;
}

/**
 * Performs subtraction of two vectors. Produces a = a - b.
 * @param a The first vector.
 * @param b The second vector.
 */
static inline void iv3Sub(Isgl3dVector3 * a, Isgl3dVector3 * b)
{
	a->x -= b->x;
	a->y -= b->y;
	a->z -= b->z;
}

/**
 * Translates a vector by a given amount.
 * @param a The vector.
 * @param x The x translation.
 * @param y The y translation.
 * @param z The z translation.
 */
static inline void iv3Translate(Isgl3dVector3 * a, float x, float y, float z)
{
	a->x += x;
	a->y += y;
	a->z += z;
}

/**
 * Scales a vector by a given amount.
 * @param a The vector.
 * @param scale The scale factor.
 */
static inline void iv3Scale(Isgl3dVector3 * a, float scale) 
{
	a->x *= scale;
	a->y *= scale;
	a->z *= scale;
}

/**
 * Performs dot product of two vectors. Produces a = a . b.
 * @param a The first vector.
 * @param b The second vector.
 * @result the dot product of the two vectors.
 */
static inline float iv3Dot(Isgl3dVector3 * a, Isgl3dVector3 * b)
{
	return a->x * b->x + a->y * b->y + a->z * b->z;
}

/**
 * Performs cross product of two vectors. Produces a = a x b.
 * @param a The first vector.
 * @param b The second vector.
 * @result The cross product of the two vectors.
 */
Isgl3dVector3 iv3Cross(Isgl3dVector3 * a, Isgl3dVector3 * b);

/**
 * Returns the length of a vector.
 * @param a The vector.
 * @result The length from the origin.
 */
static inline float iv3Length(Isgl3dVector3 * a)
{
	return sqrt(a->x * a->x + a->y * a->y + a->z * a->z);
}

/**
 * Returns the distance between two vector positions.
 * @param a The first vector.
 * @param b The second vector.
 * @result The distance between the two points.
 */
float iv3DistanceBetween(Isgl3dVector3 * a, Isgl3dVector3 * b);

/**
 * Normalizes the vector.
 * @param a The vector.
 */
void iv3Normalize(Isgl3dVector3 * a);

/**
 * Determines if two vectors are equivalent to a given precision.
 * @param a The first vector.
 * @param b The second vector.
 * @param precision The distances between each component must be less than this for the vectors to be considered equal.
 * @result 1 if the vectors are equal.
 */
static inline int iv3Equals(Isgl3dVector3 * a, Isgl3dVector3 * b, float precision)
{
	return (fabs(a->x - b->x) < precision) && (fabs(a->y - b->y) < precision) && (fabs(a->z - b->z) < precision);
}

/**
 * Returns the angle in degrees between two vectors.
 * @param a The first vector.
 * @param b The second vector.
 * @result The angle between the vectors in degrees.
 */
float iv3AngleBetween(Isgl3dVector3 * a, Isgl3dVector3 * b);

/**
 * Rotates a given position around the x-axis by a specified angle centered on a given point in the y-z plane.
 * @param a The vector position.
 * @param angle The amount of rotation in degrees.
 * @param centerY The center of the rotation in the y-z plane along the y-axis. 
 * @param centerZ The center of the rotation in the y-z plane along the z-axis. 
 */
void iv3RotateX(Isgl3dVector3 * a, float angle, float centerY, float centerZ);

/**
 * Rotates a given position around the y-axis by a specified angle centered on a given point in the x-z plane.
 * @param a The vector position.
 * @param angle The amount of rotation in degrees.
 * @param centerX The center of the rotation in the x-z plane along the x-axis. 
 * @param centerZ The center of the rotation in the x-z plane along the z-axis. 
 */
void iv3RotateY(Isgl3dVector3 * a, float angle, float centerX, float centerZ);

/**
 * Rotates a given position around the z-axis by a specified angle centered on a given point in the x-y plane.
 * @param a The vector position.
 * @param angle The amount of rotation in degrees.
 * @param centerX The center of the rotation in the x-y plane along the x-axis. 
 * @param centerY The center of the rotation in the x-y plane along the y-axis. 
 */
void iv3RotateZ(Isgl3dVector3 * a, float angle, float centerX, float centerY);


#pragma mark Isgl3dVector4

/**
 * Creates a vector with the given components.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 * @param w The w component.
 */
static inline Isgl3dVector4 iv4Create(float x, float y, float z, float w)
{
	Isgl3dVector4 v = {x, y, z, w};
	return v;
}


/**
 * Resets all the vector components to 0.
 * @param a The vector to be modified.
 */
static inline void iv4Reset(Isgl3dVector4 * a)
{
	a->x = 0;
	a->y = 0;
	a->z = 0;
	a->w = 0;
}

/**
 * Copies the vector components of one vector into another.
 * @param a The destination vector.
 * @param b The source vector.
 */
static inline void iv4Copy(Isgl3dVector4 * a, Isgl3dVector4 * b)
{
	a->x = b->x;
	a->y = b->y;
	a->z = b->z;
	a->w = b->w;
}

/**
 * Copies values into a vector.
 * @param a The destination vector.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 * @param w The w component.
 */
static inline void iv4Fill(Isgl3dVector4 * a, float x, float y, float z, float w)
{
	a->x = x;
	a->y = y;
	a->z = z;
	a->w = w;
}

/**
 * Performs addition of two vectors. Produces a = a + b.
 * @param a The first vector.
 * @param b The second vector.
 */
static inline void iv4Add(Isgl3dVector4 * a, Isgl3dVector4 * b)
{
	a->x += b->x;
	a->y += b->y;
	a->z += b->z;
	a->w += b->w;
}

/**
 * Performs addition of vector components to a vector. 
 * @param a The first vector.
 * @param x The x component to be added.
 * @param y The y component to be added.
 * @param z The z component to be added.
 * @param w The w component to be added.
 */
static inline void iv4AddComponents(Isgl3dVector4 * a, float x, float y, float z, float w)
{
	a->x += x;
	a->y += y;
	a->z += z;
	a->w += w;
}

/**
 * Performs subtraction of two vectors. Produces a = a - b.
 * @param a The first vector.
 * @param b The second vector.
 */
static inline void iv4Sub(Isgl3dVector4 * a, Isgl3dVector4 * b)
{
	a->x -= b->x;
	a->y -= b->y;
	a->z -= b->z;
	a->w -= b->w;
}

/**
 * Scales a vector by a given amount.
 * @param a The vector.
 * @param scale The scale factor.
 */
static inline void iv4Scale(Isgl3dVector4 * a, float scale)
{
	a->x *= scale;
	a->y *= scale;
	a->z *= scale;
	a->w *= scale;
}

/**
 * Performs dot product of two vectors. Produces a = a . b.
 * @param a The first vector.
 * @param b The second vector.
 */
static inline float iv4Dot(Isgl3dVector4 * a, Isgl3dVector4 * b)
{
	return a->x * b->x + a->y * b->y + a->z * b->z + a->w * b->w;
}

/**
 * Returns the length of a vector.
 * @param a The vector.
 * @result The length from the origin.
 */
static inline float iv4Length(Isgl3dVector4 * a)
{
	return sqrt(a->x * a->x + a->y * a->y + a->z * a->z + a->w * a->w);
}

/**
 * Normalizes the vector.
 * @param a The vector.
 */
void iv4Normalize(Isgl3dVector4 * a);

/**
 * Determines if two vectors are equivalent to a given precision.
 * @param a The first vector.
 * @param b The second vector.
 * @param precision The distances between each component must be less than this for the vectors to be considered equal.
 * @result 1 if the vectors are equal.
 */
static inline int iv4Equals(Isgl3dVector4 * a, Isgl3dVector4 * b, float precision)
{
	return (fabs(a->x - b->x) < precision) && (fabs(a->y - b->y) < precision) && (fabs(a->z - b->z) < precision) && (fabs(a->w - b->w) < precision);
}


