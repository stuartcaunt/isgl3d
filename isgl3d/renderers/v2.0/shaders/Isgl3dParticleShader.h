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

#import "Isgl3dInternalShader.h"

@class Isgl3dShaderState;

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dParticleShader : Isgl3dInternalShader {

@private

	Isgl3dShaderState * _currentState;
	Isgl3dShaderState * _previousState;

	// Attributes
	GLint _vertexAttributeLocation;
	GLint _pointSizeAttributeLocation;
	GLint _vertexColorAttributeLocation;

	// Uniforms
	
	// Matrices	
    GLint _mvMatrixUniformLocation;
    GLint _mvpMatrixUniformLocation;

	// point sprite characteristics
	GLint _pointSpriteEnabledUniformLocation;
	GLint _pointCoordEnabledUniformLocation;
	GLint _pointMinSize;
	GLint _pointMaxSize;
	GLint _pointConstantAttenuation;
	GLint _pointLinearAttenuation;
	GLint _pointQuadraticAttenuation;
	
	// alpha test
	GLint _alphaTestValueUniformLocation;
	
	// Texture
	GLint _samplerLocation;
}

- (id) initWithVsPreProcHeader:(NSString *)vsPreProcHeader fsPreProcHeader:(NSString *)fsPreProcHeader;


@end
