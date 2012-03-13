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
 */

#import "Isgl3dVector.h"
#import "Isgl3dMathUtils.h"
#import "Isgl3dVector3.h"


#pragma mark Isgl3dVector3

const Isgl3dVector3 Isgl3dVector3Forward    = {  0.0f,  0.0f, -1.0f };
const Isgl3dVector3 Isgl3dVector3Backward   = {  0.0f,  0.0f,  1.0f };
const Isgl3dVector3 Isgl3dVector3Left       = { -1.0f,  0.0f,  0.0f };
const Isgl3dVector3 Isgl3dVector3Right      = {  1.0f,  0.0f,  0.0f };
const Isgl3dVector3 Isgl3dVector3Up         = {  0.0f,  1.0f,  0.0f };
const Isgl3dVector3 Isgl3dVector3Down       = {  0.0f, -1.0f,  0.0f };


float iv3AngleBetween(Isgl3dVector3 * a, Isgl3dVector3 * b) {
    
    Isgl3dVector3 aCopy = Isgl3dVector3Normalize(*a);
    Isgl3dVector3 bCopy = Isgl3dVector3Normalize(*b);

	float dotProduct = Isgl3dVector3DotProduct(aCopy, bCopy);

	if (dotProduct > 1.0f) {
		dotProduct = 1.0f;
	}
	
	float angle = acos(dotProduct) * 180 / M_PI;
	return angle;	
}

void iv3RotateX(Isgl3dVector3 * a, float angle, float centerY, float centerZ) {

	angle = Isgl3dMathDegreesToRadians(angle);
	float cosRY = cos(angle);
	float sinRY = sin(angle);
	
	float tempY = a->y - centerY;
	float tempZ = a->z - centerZ;
	
	a->y = (tempY * cosRY) - (tempZ * sinRY) + centerY;
	a->z = (tempY * sinRY) + (tempZ * cosRY) + centerZ;
}	

void iv3RotateY(Isgl3dVector3 * a, float angle, float centerX, float centerZ) {
	
	angle = Isgl3dMathDegreesToRadians(angle);
	float cosRY = cos(angle);
	float sinRY = sin(angle);
	
	float tempX = a->x - centerX;
	float tempZ = a->z - centerZ;
	
	a->x = (tempX * cosRY) +  (tempZ * sinRY) + centerX;
	a->z = (tempX * -sinRY) + (tempZ * cosRY) + centerZ;
}	
	
void iv3RotateZ(Isgl3dVector3 * a, float angle, float centerX, float centerY) {

	angle = Isgl3dMathDegreesToRadians(angle);
	float cosRY = cos(angle);
	float sinRY = sin(angle);
	
	float tempX = a->x - centerX;
	float tempY = a->y - centerY;
		
	a->x = (tempX * cosRY ) - (tempY * sinRY);
	a->y = (tempX * sinRY ) + (tempY * cosRY);
}

