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

#define MAX_LIGHTS 4

#define TEXTURE0_INDEX 0
#define SHADOWMAP_INDEX 1


@class Isgl3dShaderState;

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dGenericShader : Isgl3dInternalShader {

@private

	Isgl3dShaderState * _currentState;
	Isgl3dShaderState * _previousState;
	
	Isgl3dMatrix4 _biasMatrix;
	Isgl3dMatrix4 _shadowMapTransformMatrix;

	BOOL _planarShadowsActive;
	float _shadowAlpha;

	// Attributes
	GLint _vertexAttributeLocation;
	GLint _texCoordAttributeLocation;
	GLint _normalAttributeLocation;

	// Uniforms
	
	// Matrices	
    GLint _mvMatrixUniformLocation;
    GLint _mvpMatrixUniformLocation;
	GLint _normalMatrixUniformLocation;
	
	// light characteristics
	GLint _includeSpecularUniformLocation;
	GLint _lightingEnabledUniformLocation;
	GLint _lightPositionLocation[MAX_LIGHTS];
	GLint _lightAmbientLocation[MAX_LIGHTS];
	GLint _lightDiffuseLocation[MAX_LIGHTS];
	GLint _lightSpecularLocation[MAX_LIGHTS];
	GLint _lightAttenuationLocation[MAX_LIGHTS];
	GLint _lightSpotDirectionLocation[MAX_LIGHTS];
	GLint _lightSpotCutoffAngleLocation[MAX_LIGHTS];
	GLint _lightSpotFalloffExponentLocation[MAX_LIGHTS];
	GLint _lightEnabledLocation[MAX_LIGHTS];
	GLint _sceneAmbientUniformLocation;
	GLfloat _attenuation[3];
	GLfloat _sceneAmbient[4];
	int _lightCount;
	NSString * _sceneAmbientString;

	// material characteristics
	GLint _materialAmbientLocation;
	GLint _materialDiffuseLocation;
	GLint _materialSpecularLocation;
	GLint _materialShininessLocation;
	
	// alpha test
	GLint _alphaTestValueUniformLocation;
	
	// Texture
	GLint _samplerLocation;

	// Shadows
	GLint _mcToLightMatrixUniformLocation;
	GLint _shadowMapSamplerLocation;
	GLint _shadowCastingLightPositionLocation;
	
	// Skinning
	GLint _boneIndexAttributeLocation;
	GLint _boneWeightsAttributeLocation;
	GLint _boneCountUniformLocation;
	GLint _boneMatrixArrayUniformLocation;
	GLint _boneMatrixArrayITUniformLocation;
	
}

- (id) initWithVsPreProcHeader:(NSString *)vsPreProcHeader fsPreProcHeader:(NSString *)fsPreProcHeader;

@end
