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

#import "Isgl3dMatrix3.h"


#if !(defined(__STRICT_ANSI__)) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0)

#else

const Isgl3dMatrix3 Isgl3dMatrix3Identity = 
{
    1.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, 1.0f
};


static inline float Isgl3dMatrix3Determinant(const Isgl3dMatrix3 m)
{
	return	  (m.m00 * m.m11 - m.m01 * m.m10) * m.m22 
            - (m.m00 * m.m12 - m.m02 * m.m10) * m.m21 
            + (m.m01 * m.m12 - m.m02 * m.m11) * m.m20;	
}

Isgl3dMatrix3 Isgl3dMatrix3Invert(Isgl3dMatrix3 matrix, bool *isInvertible)
{
    Isgl3dMatrix3 m = matrix;

	// If the determinant is zero then no inverse exists
	float det =  Isgl3dMatrix3Determinant(m);
	if (fabs(det) < 1e-8) {
        if (isInvertible)
            *isInvertible = false;
		return m;
	}
	
	float invDet = 1.0f / det;
    
    // Calculate inverse with Cramer's rule
    // TODO: this could be optimized, SIMD instructions are possible
    // ftp://download.intel.com/design/pentiumiii/sml/24504301.pdf
	m.m00 =  invDet * (matrix.m11 * matrix.m22 - matrix.m12 * matrix.m21);
	m.m10 = -invDet * (matrix.m10 * matrix.m22 - matrix.m12 * matrix.m20);
	m.m20 =  invDet * (matrix.m10 * matrix.m21 - matrix.m11 * matrix.m20);
	m.m01 = -invDet * (matrix.m01 * matrix.m22 - matrix.m02 * matrix.m21);
	m.m11 =  invDet * (matrix.m00 * matrix.m22 - matrix.m02 * matrix.m20);
	m.m21 = -invDet * (matrix.m00 * matrix.m21 - matrix.m01 * matrix.m20);
	m.m02 =  invDet * (matrix.m01 * matrix.m12 - matrix.m02 * matrix.m11);
	m.m12 = -invDet * (matrix.m00 * matrix.m12 - matrix.m02 * matrix.m10);
	m.m22 =  invDet * (matrix.m00 * matrix.m11 - matrix.m01 * matrix.m10);
    
    if (isInvertible != NULL)
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

#endif
