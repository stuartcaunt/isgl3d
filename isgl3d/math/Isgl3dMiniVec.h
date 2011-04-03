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

#ifndef ISGL3DMINIVEC_H_
#define ISGL3DMINIVEC_H_

/**
 * Simple structure to hold the components of a 3 dimensional vector.
 * This structure and the associated methods provide better performance than
 * the Objective-C class Isgl3dVector3D and should be used whenever possible.
 * 
 * WARNING: This is deprecated and will be removed in v1.2
 * The functionality of this class can be performed using the Isgl3dVector3 with c utilities.
 * 
 * @deprecated Will be removed in v1.2
 */
typedef struct {
	float x;
	float y;
	float z;
} Isgl3dMiniVec3D;

/**
 * Creates a vector with the given components.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 */
Isgl3dMiniVec3D mv3DCreate(float x, float y, float z);

/**
 * Resets all the vector components to 0.
 * @param a The vector to be modified.
 */
void mv3DReset(Isgl3dMiniVec3D * a);

/**
 * Copies the vector components of one vector into another.
 * @param a The destination vector.
 * @param b The source vector.
 */
void mv3DCopy(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b);

/**
 * Copies values into a vector.
 * @param a The destination vector.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 */
void mv3DFill(Isgl3dMiniVec3D * a, float x, float y, float z);

/**
 * Performs addition of two vectors. Produces a = a + b.
 * @param a The first vector.
 * @param b The second vector.
 */
void mv3DAdd(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b);

/**
 * Performs subtraction of two vectors. Produces a = a - b.
 * @param a The first vector.
 * @param b The second vector.
 */
void mv3DSub(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b);

/**
 * Performs dot product of two vectors. Produces a = a . b.
 * @param a The first vector.
 * @param b The second vector.
 */
float mv3DDot(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b);

/**
 * Performs cross product of two vectors. Produces a = a x b.
 * @param a The first vector.
 * @param b The second vector.
 */
Isgl3dMiniVec3D mv3DCross(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b);

/**
 * Translates a vector by a given amount.
 * @param a The vector.
 * @param x The x translation.
 * @param y The y translation.
 * @param z The z translation.
 */
void mv3DTranslate(Isgl3dMiniVec3D * a, float x, float y, float z);

/**
 * Scales a vector by a given amount.
 * @param a The vector.
 * @param s The scale factor.
 */
void mv3DScale(Isgl3dMiniVec3D * a, float scale);

/**
 * Returns the length of a vector.
 * @param a The vector.
 * @result The length from the origin.
 */
float mv3DLength(Isgl3dMiniVec3D * a);

/**
 * Returns the distance between two vector positions.
 * @param a The first vector.
 * @param b The second vector.
 * @result The distance between the two points.
 */
float mv3DDistanceBetween(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b);

/**
 * Normalizes the vector.
 * @param a The vector.
 */
void mv3DNormalize(Isgl3dMiniVec3D * a);

/**
 * Determines if two vectors are equivalent to a given precision.
 * @param a The first vector.
 * @param b The second vector.
 * @param precision The distances between each component must be less than this for the vectors to be considered equal.
 * @result 1 if the vectors are equal.
 */
int mv3DEquals(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b, float precision);

/**
 * Returns the angle in degrees between two vectors.
 * @param a The first vector.
 * @param b The second vector.
 * @result The angle between the vectors in degrees.
 */
float mv3DAngleBetween(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b);

/**
 * Rotates a given position around the x-axis by a specified angle centered on a given point in the y-z plane.
 * @param a The vector position.
 * @param angle The amount of rotation in degrees.
 * @param centerY The center of the rotation in the y-z plane along the y-axis. 
 * @param centerZ The center of the rotation in the y-z plane along the z-axis. 
 */
void mv3DRotateX(Isgl3dMiniVec3D * a, float angle, float centerY, float centerZ);

/**
 * Rotates a given position around the y-axis by a specified angle centered on a given point in the x-z plane.
 * @param a The vector position.
 * @param angle The amount of rotation in degrees.
 * @param centerX The center of the rotation in the x-z plane along the x-axis. 
 * @param centerZ The center of the rotation in the x-z plane along the z-axis. 
 */
void mv3DRotateY(Isgl3dMiniVec3D * a, float angle, float centerX, float centerZ);

/**
 * Rotates a given position around the z-axis by a specified angle centered on a given point in the x-y plane.
 * @param a The vector position.
 * @param angle The amount of rotation in degrees.
 * @param centerX The center of the rotation in the x-y plane along the x-axis. 
 * @param centerY The center of the rotation in the x-y plane along the y-axis. 
 */
void mv3DRotateZ(Isgl3dMiniVec3D * a, float angle, float centerX, float centerY);


#endif /*ISGL3DMINIVEC_H_*/
