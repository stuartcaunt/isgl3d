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

#define iqn(X, Y, Z, W) iqnCreate(X, Y, Z, W)

/**
 * Simple structure to hold the components of a quaternion
 */
typedef struct {
	float x; // Note: removed __attribute__ ((aligned) to compile with LLVM GCC, crashes at run-time otherwise
	float y;
	float z;
	float w;
} Isgl3dQuaternion;


/**
 * Creates a quaternion with the given components.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 * @param w The w component.
 */
static inline Isgl3dQuaternion iqnCreate(float x, float y, float z, float w) {
	Isgl3dQuaternion q = {x, y, z, w};
	return q;
}


/**
 * Returns the magnitude of a quaternion.
 * @param a The quaternion.
 * @result The length from the origin.
 */
static inline float iqnMagnitude(Isgl3dQuaternion * a) {
	return sqrt(a->x * a->x + a->y * a->y + a->z * a->z);
}

/**
 * Multiplies two quaternions. Result is stored in first quaternion.
 * @param a the first quaternion 
 * @param b the second quaternion
 */
void iqnMultiply(Isgl3dQuaternion * a, Isgl3dQuaternion * b);
 
/*
 * Converts euler rotation angles into a quaternion
 * @param q The quaternion that will hold the equivalent rotation
 * @param ax Rotation in degrees about the x axis 
 * @param ay Rotation in degrees about the y axis 
 * @param az Rotation in degrees about the z axis 
 */
void iqnQuaternionFromEuler(Isgl3dQuaternion * q, float ax, float ay, float az);

/*
 * Creates a quaternion from euler rotation angles
 * @param ax Rotation in degrees about the x axis 
 * @param ay Rotation in degrees about the y axis 
 * @param az Rotation in degrees about the z axis 
 * @result The quaternion that will hold the equivalent rotation
 */
static inline Isgl3dQuaternion iqnCreateFromEuler(float ax, float ay, float az) {
	Isgl3dQuaternion q;
	iqnQuaternionFromEuler(&q, ax, ay, az);
	return q;
}
