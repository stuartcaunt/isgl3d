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

#import "Isgl3dVector.h"

static float DEG_TO_RAD = M_PI / 180.0f;

#pragma mark Isgl3dVector3

Isgl3dVector3 Isgl3dVector3Forward = {0, 0, -1};
Isgl3dVector3 Isgl3dVector3Backward = {0, 0, 1};
Isgl3dVector3 Isgl3dVector3Left = {-1, 0, 0};
Isgl3dVector3 Isgl3dVector3Right = {1, 0, 0};
Isgl3dVector3 Isgl3dVector3Up = {0, 1, 0};
Isgl3dVector3 Isgl3dVector3Down = {0, -1, 0};

float iv3DistanceBetween(Isgl3dVector3 * a, Isgl3dVector3 * b) {
	float lx = b->x - a->x;
	float ly = b->y - a->y;
	float lz = b->z - a->z;
	
	return sqrt(lx * lx + ly * ly + lz * lz);
}

Isgl3dVector3 iv3Cross(Isgl3dVector3 * a, Isgl3dVector3 * b) {
	Isgl3dVector3 result;
	
	result.x = 	  a->y * b->z - a->z * b->y;
	result.y = 	  a->z * b->x - a->x * b->z;
	result.z = 	  a->x * b->y - a->y * b->x;
	
	return result;	
}

void iv3Normalize(Isgl3dVector3 * a) {
	float length = iv3Length(a);
	
	if (length != 0.0 && length != 1.0) {
		length = 1.0 / length; // Save some CPU
		a->x *= length;
		a->y *= length;
		a->z *= length;
	}
}

float iv3AngleBetween(Isgl3dVector3 * a, Isgl3dVector3 * b) {
	Isgl3dVector3 aCopy = iv3(a->x, a->y, a->z);
	Isgl3dVector3 bCopy = iv3(b->x, b->y, b->z);
	
	iv3Normalize(&aCopy);
	iv3Normalize(&bCopy);

	float dotProduct = iv3Dot(&aCopy, &bCopy);

	if (dotProduct > 1) {
		dotProduct = 1;
	}
	
	float angle = acos(dotProduct) * 180 / M_PI;
	
	return angle;	
	
}

void iv3RotateX(Isgl3dVector3 * a, float angle, float centerY, float centerZ) {

	angle *= DEG_TO_RAD;
	float cosRY = cos(angle);
	float sinRY = sin(angle);
	
	float tempY = a->y - centerY;
	float tempZ = a->z - centerZ;
	
	a->y = (tempY * cosRY) - (tempZ * sinRY) + centerY;
	a->z = (tempY * sinRY) + (tempZ * cosRY) + centerZ;
}	

void iv3RotateY(Isgl3dVector3 * a, float angle, float centerX, float centerZ) {
	
	angle *= DEG_TO_RAD;
	float cosRY = cos(angle);
	float sinRY = sin(angle);
	
	float tempX = a->x - centerX;
	float tempZ = a->z - centerZ;
	
	a->x = (tempX * cosRY) +  (tempZ * sinRY) + centerX;
	a->z = (tempX * -sinRY) + (tempZ * cosRY) + centerZ;
}	
	
void iv3RotateZ(Isgl3dVector3 * a, float angle, float centerX, float centerY) {

	angle *= DEG_TO_RAD;
	float cosRY = cos(angle);
	float sinRY = sin(angle);
	
	float tempX = a->x - centerX;
	float tempY = a->y - centerY;
		
	a->x = (tempX * cosRY ) - (tempY * sinRY);
	a->y = (tempX * sinRY ) + (tempY * cosRY);
}


#pragma mark Isgl3dVector4


void iv4Normalize(Isgl3dVector4 * a) {
	float length = iv4Length(a);
	
	if (length != 0.0 && length != 1.0) {
		length = 1.0 / length; // Save some CPU
		a->x *= length;
		a->y *= length;
		a->z *= length;
		a->w *= length;
	}	
}

