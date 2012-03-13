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

precision highp float;


varying highp vec4 v_position;

const highp vec4 packFactors = vec4(256.0 * 256.0 * 256.0, 256.0 * 256.0, 256.0, 1.0);
const highp vec4 bitMask = vec4(1.0/256.0, 1.0/256.0, 1.0/256.0, 1.0/256.0);

void main(void) {
	
	highp float normalizedDistance  = v_position.z / v_position.w;
	normalizedDistance = (normalizedDistance + 1.0) / 2.0;

	highp vec4 packedValue = vec4(fract(packFactors * normalizedDistance));
	packedValue -= packedValue.xxyz * bitMask;

	gl_FragColor = packedValue;
}

			