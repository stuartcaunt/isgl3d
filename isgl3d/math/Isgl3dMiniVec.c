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

#include "Isgl3dMiniVec.h"
#include "math.h"

static float DEG_TO_RAD = M_PI / 180.0f;

Isgl3dMiniVec3D mv3DCreate(float x, float y, float z) {
	Isgl3dMiniVec3D miniVec3D = {x, y, z};
	
	return miniVec3D;
}

void mv3DReset(Isgl3dMiniVec3D * a) {
	a->x = 0;
	a->y = 0;
	a->z = 0;
}

void mv3DCopy(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b) {
	a->x = b->x;
	a->y = b->y;
	a->z = b->z;
}

void mv3DFill(Isgl3dMiniVec3D * a, float x, float y, float z) {
	a->x = x;
	a->y = y;
	a->z = z;
}

void mv3DAdd(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b) {
	a->x += b->x;
	a->y += b->y;
	a->z += b->z;
}

void mv3DTranslate(Isgl3dMiniVec3D * a, float x, float y, float z) {
	a->x += x;
	a->y += y;
	a->z += z;
}

void mv3DSub(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b) {
	a->x -= b->x;
	a->y -= b->y;
	a->z -= b->z;
}

void mv3DScale(Isgl3dMiniVec3D * a, float scale) {
	a->x *= scale;
	a->y *= scale;
	a->z *= scale;
}

float mv3DLength(Isgl3dMiniVec3D * a) {
	return sqrt(a->x * a->x + a->y * a->y + a->z * a->z);
}

float mv3DDistanceBetween(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b) {
	float lx = b->x - a->x;
	float ly = b->y - a->y;
	float lz = b->z - a->z;
	
	return sqrt(lx * lx + ly * ly + lz * lz);
}


float mv3DDot(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b) {
	return a->x * b->x + a->y * b->y + a->z * b->z;
}

Isgl3dMiniVec3D mv3DCross(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b) {
	Isgl3dMiniVec3D result;
	
	result.x = 	  a->y * b->z - a->z * b->y;
	result.y = 	  a->z * b->x - a->x * b->z;
	result.z = 	  a->x * b->y - a->y * b->x;
	
	return result;	
}

void mv3DNormalize(Isgl3dMiniVec3D * a) {
	float length = mv3DLength(a);
	
	if (length != 0.0 && length != 1.0) {
		length = 1.0 / length; // Save some CPU
		a->x *= length;
		a->y *= length;
		a->z *= length;
	}
}

int mv3DEquals(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b, float precision) {
	return (fabs(a->x - b->x) < precision) && (fabs(a->y - b->y) < precision) && (fabs(a->z - b->z) < precision);
}

float mv3DAngleBetween(Isgl3dMiniVec3D * a, Isgl3dMiniVec3D * b) {
	Isgl3dMiniVec3D aCopy = mv3DCreate(a->x, a->y, a->z);
	Isgl3dMiniVec3D bCopy = mv3DCreate(b->x, b->y, b->z);
	
	mv3DNormalize(&aCopy);
	mv3DNormalize(&bCopy);

	float dotProduct = mv3DDot(&aCopy, &bCopy);

	if (dotProduct > 1) {
		dotProduct = 1;
	}
	
	float angle = acos(dotProduct) * 180 / M_PI;
	
	return angle;	
	
}

void mv3DRotateX(Isgl3dMiniVec3D * a, float angle, float centerY, float centerZ) {

	angle *= DEG_TO_RAD;
	float cosRY = cos(angle);
	float sinRY = sin(angle);
	
	float tempY = a->y - centerY;
	float tempZ = a->z - centerZ;
	
	a->y = (tempY * cosRY) - (tempZ * sinRY) + centerY;
	a->z = (tempY * sinRY) + (tempZ * cosRY) + centerZ;
}	

void mv3DRotateY(Isgl3dMiniVec3D * a, float angle, float centerX, float centerZ) {
	
	angle *= DEG_TO_RAD;
	float cosRY = cos(angle);
	float sinRY = sin(angle);
	
	float tempX = a->x - centerX;
	float tempZ = a->z - centerZ;
	
	a->x = (tempX * cosRY) +  (tempZ * sinRY) + centerX;
	a->z = (tempX * -sinRY) + (tempZ * cosRY) + centerZ;
}	
	
void mv3DRotateZ(Isgl3dMiniVec3D * a, float angle, float centerX, float centerY) {

	angle *= DEG_TO_RAD;
	float cosRY = cos(angle);
	float sinRY = sin(angle);
	
	float tempX = a->x - centerX;
	float tempY = a->y - centerY;
		
	a->x = (tempX * cosRY ) - (tempY * sinRY);
	a->y = (tempX * sinRY ) + (tempY * cosRY);
}

