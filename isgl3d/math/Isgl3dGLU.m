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

#import "Isgl3dGLU.h"
#import "Isgl3dMatrix4D.h"
#import "Isgl3dMiniMat.h"

@implementation Isgl3dGLU

- (id) init {    
    if ((self = [super init])) {
    }
	
    return self;
}

+ (Isgl3dMatrix4D *) lookAt:(float)eyex eyey:(float)eyey eyez:(float)eyez centerx:(float)centerx centery:(float)centery centerz:(float)centerz upx:(float)upx upy:(float)upy upz:(float)upz {
	Isgl3dMatrix4D * matrix = [Isgl3dMatrix4D matrix];
	
	[Isgl3dGLU lookAt:eyex eyey:eyey eyez:eyez centerx:centerx centery:centery centerz:centerz upx:upx upy:upy upz:upz inToMatrix:matrix];

	return matrix;	
}

+ (void) lookAt:(float)eyex eyey:(float)eyey eyez:(float)eyez centerx:(float)centerx centery:(float)centery centerz:(float)centerz upx:(float)upx upy:(float)upy upz:(float)upz inToMatrix:(Isgl3dMatrix4D *)matrix {
	
	// remember: z out of screen
	float zx = eyex - centerx;
	float zy = eyey - centery;
	float zz = eyez - centerz;
	
	// normalise z
	float zlen = sqrt(zx * zx + zy * zy + zz * zz);
	zx /= zlen;
	zy /= zlen;
	zz /= zlen;
	
	// Calculate cross product of up and z to get x 
	// (x coming out of plane containing up and z: up not necessarily perpendicular to z)
	float xx =  upy * zz - upz * zy;
	float xy = -upx * zz + upz * zx;
	float xz =  upx * zy - upy * zx;
	
	// up not necessarily a unit vector so normalise x
	float xlen = sqrt(xx * xx + xy * xy + xz * xz);
	xx /= xlen;
	xy /= xlen;
	xz /= xlen;
	
	// calculate y: cross product of z and x (x and z unit vector so no need to normalise after)
	float yx =  zy * xz - zz * xy;
	float yy = -zx * xz + zz * xx;
	float yz =  zx * xy - zy * xx;

	// Create rotation matrix from new coorinate system
	Isgl3dMiniMat4D lookat = {xx, xy, xz, 0, yx, yy, yz, 0, zx, zy, zz, 0, 0, 0, 0, 1}; 
	
	// create translation matrix
	Isgl3dMiniMat4D translation = {1, 0, 0, -eyex, 0, 1, 0, -eyey, 0, 0, 1, -eyez, 0, 0, 0, 1}; 
	
	// calculate final lookat (projection) matrix from combination of both rotation and translation
	mm4DMultiply(&lookat, &translation);
	
	[matrix copyFromMiniMat4D:&lookat];
}

+ (Isgl3dMatrix4D *) perspective:(float)fovy aspect:(float)aspect near:(float)near far:(float)far zoom:(float)zoom landscape:(BOOL)landscape {
	return [Isgl3dGLU perspective:fovy aspect:aspect near:near far:far zoom:zoom orientation:landscape ? Isgl3dOrientation90CounterClockwise : Isgl3dOrientation0];
}

+ (Isgl3dMatrix4D *) perspective:(float)fovy aspect:(float)aspect near:(float)near far:(float)far zoom:(float)zoom orientation:(isgl3dOrientation)orientation {
	
	if (orientation == Isgl3dOrientation90Clockwise || orientation == Isgl3dOrientation90CounterClockwise) {
		aspect = 1. / aspect;
	}

	float top = tan(fovy * M_PI / 360) * near / zoom;
	float bottom = -top;
	float left = aspect * bottom;
	float right = aspect * top;

	float A = (right + left) / (right - left);
	float B = (top + bottom) / (top - bottom);
	float C = -(far + near) / (far - near);
	float D = -(2 * far * near) / (far - near);
	
	Isgl3dMatrix4D* matrix = [Isgl3dMatrix4D matrix];
	matrix.sxx = (2 * near) / (right - left);
	matrix.syx = 0;
	matrix.szx = 0;
	matrix.swx = 0;
	
	matrix.sxy = 0;
	matrix.syy = 2 * near / (top - bottom);
	matrix.szy = 0;
	matrix.swy = 0;
	
	matrix.sxz = A;
	matrix.syz = B;
	matrix.szz = C;
	matrix.swz = -1;
	
	matrix.tx = 0;
	matrix.ty = 0;
	matrix.tz = D;
	matrix.tw = 0;
	
	if (orientation == Isgl3dOrientation90Clockwise) {
		float landscapeArray[9] = {0, -1, 0, 1, 0, 0, 0, 0, 1}; 
		Isgl3dMatrix4D * landscapeMatrix = [Isgl3dMatrix4D matrixFromFloatArray:landscapeArray size:9];
		
		[matrix multiplyOnLeft3x3:landscapeMatrix];
		
	} else if (orientation == Isgl3dOrientation180) {
		float landscapeArray[9] = {-1, 0, 0, 0, -1, 0, 0, 0, 1}; 
		Isgl3dMatrix4D * landscapeMatrix = [Isgl3dMatrix4D matrixFromFloatArray:landscapeArray size:9];
		
		[matrix multiplyOnLeft3x3:landscapeMatrix];
		
	} else if (orientation == Isgl3dOrientation90CounterClockwise) {
		float landscapeArray[9] = {0, 1, 0, -1, 0, 0, 0, 0, 1}; 
		Isgl3dMatrix4D * landscapeMatrix = [Isgl3dMatrix4D matrixFromFloatArray:landscapeArray size:9];
		
		[matrix multiplyOnLeft3x3:landscapeMatrix];
	} 
	
	return matrix;	
}

+ (Isgl3dMatrix4D *) ortho:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far zoom:(float)zoom landscape:(BOOL)landscape {
	return [Isgl3dGLU ortho:left right:right bottom:bottom top:top near:near far:far zoom:zoom orientation:landscape ? Isgl3dOrientation90CounterClockwise : Isgl3dOrientation0];
}

+ (Isgl3dMatrix4D *) ortho:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far zoom:(float)zoom orientation:(isgl3dOrientation)orientation {
	float tx = (left + right) / ((right - left) * zoom);
	float ty = (top + bottom) / ((top - bottom) * zoom);
	float tz = (far + near) / (far - near);
	
	Isgl3dMatrix4D* matrix = [Isgl3dMatrix4D matrix];


	if (orientation == Isgl3dOrientation0) {
		matrix.sxx = 2 / (right - left);
		matrix.sxy = 0;
		matrix.sxz = 0;
		matrix.tx  = -tx;
		matrix.syx = 0;
		matrix.syy = 2 / (top - bottom);
		matrix.syz = 0;
		matrix.ty  = -ty;
		matrix.szx = 0;
		matrix.szy = 0;
		matrix.szz = -2 / (far - near);
		matrix.tz  = -tz;
		matrix.swx = 0;
		matrix.swy = 0;
		matrix.swz = 0;
		matrix.tw  = 1;
		
	} else if (orientation == Isgl3dOrientation90Clockwise) {
		matrix.sxx = 0;
		matrix.sxy = -2 / (right - left);
		matrix.sxz = 0;
		matrix.tx  = tx;
		matrix.syx = 2 / (top - bottom);
		matrix.syy = 0;
		matrix.syz = 0;
		matrix.ty  = -ty;
		matrix.szx = 0;
		matrix.szy = 0;
		matrix.szz = -2 / (far - near);
		matrix.tz  = -tz;
		matrix.swx = 0;
		matrix.swy = 0;
		matrix.swz = 0;
		matrix.tw  = 1;
		
	} else if (orientation == Isgl3dOrientation180) {
		matrix.sxx = -2 / (right - left);
		matrix.sxy = 0;
		matrix.sxz = 0;
		matrix.tx  = tx;
		matrix.syx = 0;
		matrix.syy = -2 / (top - bottom);
		matrix.syz = 0;
		matrix.ty  = ty;
		matrix.szx = 0;
		matrix.szy = 0;
		matrix.szz = -2 / (far - near);
		matrix.tz  = -tz;
		matrix.swx = 0;
		matrix.swy = 0;
		matrix.swz = 0;
		matrix.tw  = 1;

	} else if (orientation == Isgl3dOrientation90CounterClockwise) {
		matrix.sxx = 0;
		matrix.sxy = 2 / (right - left);
		matrix.sxz = 0;
		matrix.tx  = -tx;
		matrix.syx = -2 / (top - bottom);
		matrix.syy = 0;
		matrix.syz = 0;
		matrix.ty  = ty;
		matrix.szx = 0;
		matrix.szy = 0;
		matrix.szz = -2 / (far - near);
		matrix.tz  = -tz;
		matrix.swx = 0;
		matrix.swy = 0;
		matrix.swz = 0;
		matrix.tw  = 1;
	} 		
	return matrix;
}

@end
