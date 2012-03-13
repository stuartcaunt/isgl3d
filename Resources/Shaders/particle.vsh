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

struct Point {
	float minSize;
	float maxSize;

	float constantAttenuation;
	float linearAttenuation;
	float quadraticAttenuation;
};

attribute vec4 a_vertex;
attribute vec4 a_vertexColor;
attribute float a_pointSize;

uniform mat4 u_mvpMatrix;
uniform mat4 u_mvMatrix;

uniform Point u_point;

varying lowp vec4 v_color;

const float	c_zero = 0.0;
const float	c_one = 1.0;


void main(void) {
	vec4 ecPosition3 = u_mvMatrix * a_vertex;

	v_color = a_vertexColor;
	
	float dist = distance(ecPosition3, vec4(c_zero, c_zero, c_zero, c_one));
	float att = sqrt(c_one / (u_point.constantAttenuation +
							(u_point.linearAttenuation +
							u_point.quadraticAttenuation * dist) * dist));
	float size = clamp(a_pointSize * att, u_point.minSize, u_point.maxSize);
	gl_PointSize = size;
		
	gl_Position = u_mvpMatrix * a_vertex;
}
