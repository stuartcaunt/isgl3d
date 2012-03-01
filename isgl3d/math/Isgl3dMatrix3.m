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

#import "Isgl3dMatrix3.h"


const Isgl3dMatrix3 Isgl3dMatrix3Identity = 
{
    1.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, 1.0f
};


Isgl3dMatrix3 Isgl3dMatrix3Invert(Isgl3dMatrix3 matrix, bool *isInvertible)
{
	// If the determinant is zero then no inverse exists
    Isgl3dMatrix3 m = matrix;
	float det =   (m.m00 * m.m11 - m.m01 * m.m10) * m.m22 
                - (m.m00 * m.m12 - m.m02 * m.m10) * m.m21 
                + (m.m01 * m.m12 - m.m02 * m.m11) * m.m20;	
    
    
	if (fabs(det) < 1e-8) {
        if (isInvertible)
            *isInvertible = false;
		return m;
	}
	
	float invDet = 1 / det;
    
	float m11 = m.m00;
	float m12 = m.m10;
	float m13 = m.m20;
	float m21 = m.m01;
	float m22 = m.m11;
	float m23 = m.m21;
	float m31 = m.m02;
	float m32 = m.m12;
	float m33 = m.m22;
    
	m.m00 =  invDet * (m22 * m33 - m32 * m23);
	m.m10 = -invDet * (m12 * m33 - m32 * m13);
	m.m20 =  invDet * (m12 * m23 - m22 * m13);
	m.m01 = -invDet * (m21 * m33 - m31 * m23);
	m.m11 =  invDet * (m11 * m33 - m31 * m13);
	m.m21 = -invDet * (m11 * m23 - m21 * m13);
	m.m02 =  invDet * (m21 * m32 - m31 * m22);
	m.m12 = -invDet * (m11 * m32 - m31 * m12);
	m.m22 =  invDet * (m11 * m22 - m21 * m12);
    
    if (*isInvertible)
        *isInvertible = true;
    
    return m;
}

Isgl3dMatrix3 Isgl3dMatrix3InvertAndTranspose(Isgl3dMatrix3 matrix, bool *isInvertible)
{
    bool _isInvertible;
    Isgl3dMatrix3 invTransposeMatrix = matrix;
    
    invTransposeMatrix = Isgl3dMatrix3Invert(invTransposeMatrix, &_isInvertible);
    if (_isInvertible)
        invTransposeMatrix = Isgl3dMatrix3Transpose(invTransposeMatrix);
    
    if (isInvertible != NULL)
        *isInvertible = _isInvertible;
    return invTransposeMatrix;
}
