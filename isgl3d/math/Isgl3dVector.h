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


#pragma mark Isgl3dVector3

extern const Isgl3dVector3 Isgl3dVector3Forward;
extern const Isgl3dVector3 Isgl3dVector3Backward;
extern const Isgl3dVector3 Isgl3dVector3Left;
extern const Isgl3dVector3 Isgl3dVector3Right;
extern const Isgl3dVector3 Isgl3dVector3Up;
extern const Isgl3dVector3 Isgl3dVector3Down;


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


