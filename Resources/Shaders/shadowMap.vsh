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

#define MAX_BONES 4

attribute vec4 a_vertex;

uniform mat4 u_mvpMatrix;

varying mediump vec4 v_position;

#ifdef SKINNING_ENABLED
attribute mediump vec4 a_boneIndex;
attribute mediump vec4 a_boneWeights;
uniform mediump	int u_boneCount;
uniform highp mat4 u_boneMatrixArray[8];
#endif

void main(void) {

#ifdef SKINNING_ENABLED
	mediump ivec4 boneIndex = ivec4(a_boneIndex);
	mediump vec4 boneWeights = a_boneWeights;
	
	if (u_boneCount > 0) {
		highp mat4 boneMatrix = u_boneMatrixArray[boneIndex.x];
        int j;
	
		vec4 vertexPosition = boneMatrix * a_vertex * boneWeights.x;
		j = 1;
		
		for (int i=1; i<MAX_BONES; i++) {
			if (j >= u_boneCount)
                break;

			// "rotate" the vector components
			boneIndex = boneIndex.yzwx;
			boneWeights = boneWeights.yzwx;
		
			boneMatrix = u_boneMatrixArray[boneIndex.x];

			vertexPosition += boneMatrix * a_vertex * boneWeights.x;

            j++;
		}	
		v_position = u_mvpMatrix * vertexPosition;
		gl_Position = v_position;

	} else {
		v_position = u_mvpMatrix * a_vertex;
		gl_Position = v_position;
	}

#else
	v_position = u_mvpMatrix * a_vertex;
	gl_Position = v_position;
#endif

}
