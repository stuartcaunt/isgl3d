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

#import "Isgl3dQuaternion.h"

static float DEG_TO_RAD = M_PI / 180.0f;

void iqnMultiply(Isgl3dQuaternion * a, Isgl3dQuaternion * b) {
	float x1 = a->x;
	float y1 = a->y;
	float z1 = a->z;
	float w1 = a->w;
	float x2 = b->x;
	float y2 = b->y;
	float z2 = b->z;
	float w2 = b->w;

	a->x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2;
	a->y = w1 * y2 + y1 * w2 + z1 * x2 - x1 * z2;
	a->z = w1 * z2 + z1 * w2 + x1 * y2 - y1 * x2;
	a->w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2;
}

void iqnQuaternionFromEuler(Isgl3dQuaternion * q, float ax, float ay, float az) {
	ax = 0.5 * DEG_TO_RAD * ax; 
	ay = 0.5 * DEG_TO_RAD * ay; 
	az = 0.5 * DEG_TO_RAD * az; 
	
	float sax = sin(ax);
	float cax = cos(ax);
	float say = sin(ay);
	float cay = cos(ay);
	float saz = sin(az);
	float caz = cos(az);

	q->x = cax * cay * caz + sax * say * saz;
	q->y = sax * cay * caz - cax * say * saz;
	q->z = cax * say * caz + sax * cay * saz;
	q->w = cax * cay * saz - sax * say * caz;
}
