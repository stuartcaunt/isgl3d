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

#include "Isgl3dMiniMat.h"
#include "math.h"

Isgl3dMiniMat4D mm4DCreateFromArray16(float * a) {
	Isgl3dMiniMat4D miniMat4D = {
		a[0], a[1], a[2], a[3], 
		a[4], a[5], a[6], a[7], 
		a[8], a[9], a[10], a[11], 
		a[12], a[13], a[14], a[15]};
		
	return miniMat4D;
}

void mm4DMakeIdentity(Isgl3dMiniMat4D * m) {
	m->sxx = 1;
	m->sxy = 0;
	m->sxz = 0;
	m->tx  = 0;
	m->syx = 0;
	m->syy = 1;
	m->syz = 0;
	m->ty  = 0;
	m->szx = 0;
	m->szy = 0;
	m->szz = 1;
	m->tz  = 0;
	m->swx = 0;
	m->swy = 0;
	m->swz = 0;
	m->tw  = 1;
}

void mm4DMultiply(Isgl3dMiniMat4D * a, Isgl3dMiniMat4D * b) {
	
	float m111 = a->sxx;
	float m112 = a->sxy;
	float m113 = a->sxz;
	float m114 = a->tx;
	float m121 = a->syx;
	float m122 = a->syy;
	float m123 = a->syz;
	float m124 = a->ty;
	float m131 = a->szx;
	float m132 = a->szy;
	float m133 = a->szz;
	float m134 = a->tz;
	float m141 = a->swx;
	float m142 = a->swy;
	float m143 = a->swz;
	float m144 = a->tw;
	
	float m211 = b->sxx;
	float m212 = b->sxy;
	float m213 = b->sxz;
	float m214 = b->tx;
	float m221 = b->syx;
	float m222 = b->syy;
	float m223 = b->syz;
	float m224 = b->ty;
	float m231 = b->szx;
	float m232 = b->szy;
	float m233 = b->szz;
	float m234 = b->tz;
	float m241 = b->swx;
	float m242 = b->swy;
	float m243 = b->swz;
	float m244 = b->tw;
	
	a->sxx = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	a->sxy = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	a->sxz = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	a->tx  = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	a->syx = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	a->syy = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	a->syz = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	a->ty  = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	a->szx = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	a->szy = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	a->szz = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	a->tz  = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	a->swx = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	a->swy = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	a->swz = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	a->tw  = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
}
	