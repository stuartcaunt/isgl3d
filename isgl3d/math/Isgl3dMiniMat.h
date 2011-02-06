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

#ifndef ISGL3DMINIMAT_H_
#define ISGL3DMINIMAT_H_

/**
 * Simple structure to hold the values of a 4x4 matrix.
 */
typedef struct {
	float sxx;
	float sxy;
	float sxz;
	float tx;
	float syx;
	float syy;
	float syz;
	float ty;
	float szx;
	float szy;
	float szz;
	float tz;
	float swx;
	float swy;
	float swz;
	float tw;
} Isgl3dMiniMat4D;

/**
 * Creates an Isgl3dMiniMat4D structure from a row-major array of 16 values.
 * @param array The row-major array of 16 values.
 */
Isgl3dMiniMat4D mm4DCreateFromArray16(float * array);

/**
 * Modifies the matrix so that it represents an identity matrix.
 * @param m The matrix to be modified.
 */
void mm4DMakeIdentity(Isgl3dMiniMat4D * m);

/**
 * Multiplies two matrices. The result is a = a x b.
 * @param a The left-hand matrix, stores result after calculation.
 * @param b The right-hand matrix.
 */
void mm4DMultiply(Isgl3dMiniMat4D * a, Isgl3dMiniMat4D * b);


#endif /*ISGL3DMINIMAT_H_*/
