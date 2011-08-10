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

#import "Isgl3dGenericShader.h"
#import "Isgl3dShaderState.h"
#import "Isgl3dGLProgram.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dLight.h"
#import "Isgl3dColorUtil.h"
#import "Isgl3dLog.h"


@interface Isgl3dGenericShader (PrivateMethods)
- (void) handleStates;
@end

//static GLVBOData * _currentVBOData = nil;

@implementation Isgl3dGenericShader

- (id) initWithVsPreProcHeader:(NSString *)vsPreProcHeader fsPreProcHeader:(NSString *)fsPreProcHeader {
	
	if ((self = [super initWithVertexShaderName:@"generic.vsh" fragmentShaderName:@"generic.fsh" vsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader])) {
		
		_currentState = [[Isgl3dShaderState alloc] init];
		_previousState = [[Isgl3dShaderState alloc] init];
	
		_biasMatrix = im4(0.5, 0, 0, 0.5, 0, 0.5, 0, 0.5, 0, 0, 0.5, 0.5, 0, 0, 0, 1);
		_shadowMapTransformMatrix = im4Identity();
		
		_sceneAmbient[0] = 0.0;
		_sceneAmbient[1] = 0.0;
		_sceneAmbient[2] = 0.0;
		_sceneAmbient[3] = 1.0;
		
		_sceneAmbientString = @"000000";
		
		_planarShadowsActive = NO,
		_shadowAlpha = 1.0;

		// Initialise lighting
		for (int i = 0; i < MAX_LIGHTS; i++) {
			[self setUniform1i:_lightEnabledLocation[i] value:0];
		}
		[self setUniform1i:_lightingEnabledUniformLocation value:0];
		[self setSceneAmbient:@"000000"];
		
		_lightCount = 0;
	
	}
	
	return self;
}

- (void) dealloc {

	[_currentState release];
	[_previousState release];

	[super dealloc];
}


- (void) getAttributeAndUniformLocations {

	// Attributes
	_vertexAttributeLocation = [_glProgram getAttributeLocation:@"a_vertex"];
	_normalAttributeLocation = [_glProgram getAttributeLocation:@"a_normal"];
	_texCoordAttributeLocation = [_glProgram getAttributeLocation:@"a_texCoord"];
	
	// Uniforms
	
	// Matrices
    _mvMatrixUniformLocation = [_glProgram getUniformLocation:@"u_mvMatrix"];
    _mvpMatrixUniformLocation = [_glProgram getUniformLocation:@"u_mvpMatrix"];
	_normalMatrixUniformLocation = [_glProgram getUniformLocation:@"u_normalMatrix"];

	// Lighting
	_sceneAmbientUniformLocation = [_glProgram getUniformLocation:@"u_sceneAmbientColor"];
	_includeSpecularUniformLocation = [_glProgram getUniformLocation:@"u_includeSpecular"];
	_lightingEnabledUniformLocation = [_glProgram getUniformLocation:@"u_lightingEnabled"];
	for (int i = 0; i < MAX_LIGHTS; i++) {
		NSString * lightStruct = [NSString stringWithFormat:@"u_light[%i].", i];
		NSString * lightEnabled = [NSString stringWithFormat:@"u_lightEnabled[%i]", i];

		_lightPositionLocation[i] = [_glProgram getUniformLocation:[NSString stringWithFormat:@"%@position", lightStruct]];
		_lightAmbientLocation[i] = [_glProgram getUniformLocation:[NSString stringWithFormat:@"%@ambientColor", lightStruct]];
		_lightDiffuseLocation[i] = [_glProgram getUniformLocation:[NSString stringWithFormat:@"%@diffuseColor", lightStruct]];
		_lightSpecularLocation[i] = [_glProgram getUniformLocation:[NSString stringWithFormat:@"%@specularColor", lightStruct]];
		_lightAttenuationLocation[i] = [_glProgram getUniformLocation:[NSString stringWithFormat:@"%@attenuation", lightStruct]];
		_lightSpotDirectionLocation[i] = [_glProgram getUniformLocation:[NSString stringWithFormat:@"%@spotDirection", lightStruct]];
		_lightSpotCutoffAngleLocation[i] = [_glProgram getUniformLocation:[NSString stringWithFormat:@"%@spotCutoffAngle", lightStruct]];
		_lightSpotFalloffExponentLocation[i] = [_glProgram getUniformLocation:[NSString stringWithFormat:@"%@spotFalloffExponent", lightStruct]];
		_lightEnabledLocation[i] = [_glProgram getUniformLocation:lightEnabled];
	}

	// Materials
	_materialAmbientLocation = [_glProgram getUniformLocation:@"u_material.ambientColor"];
	_materialDiffuseLocation = [_glProgram getUniformLocation:@"u_material.diffuseColor"];
	_materialSpecularLocation = [_glProgram getUniformLocation:@"u_material.specularColor"];
	_materialShininessLocation = [_glProgram getUniformLocation:@"u_material.shininess"];

	// Texture
	_samplerLocation = [_glProgram getUniformLocation:@"s_texture"];

	// Alpha testing
	_alphaTestValueUniformLocation = [_glProgram getUniformLocation:@"u_alphaTestValue"];
	
	// Shadows
    _mcToLightMatrixUniformLocation = [_glProgram getUniformLocation:@"u_mcToLightMatrix"];
    _shadowMapSamplerLocation = [_glProgram getUniformLocation:@"s_shadowMap"];
	_shadowCastingLightPositionLocation = [_glProgram getUniformLocation:@"u_shadowCastingLightPosition"];
	
	// Skinning
	_boneIndexAttributeLocation = [_glProgram getAttributeLocation:@"a_boneIndex"];
	_boneWeightsAttributeLocation = [_glProgram getAttributeLocation:@"a_boneWeights"];
	_boneCountUniformLocation = [_glProgram getUniformLocation:@"u_boneCount"];
	_boneMatrixArrayUniformLocation = [_glProgram getUniformLocation:@"u_boneMatrixArray[0]"];
	_boneMatrixArrayITUniformLocation = [_glProgram getUniformLocation:@"u_boneMatrixArrayIT[0]"];
	
}

- (void) setModelViewMatrix:(Isgl3dMatrix4 *)modelViewMatrix {
	[self setUniformMatrix4:_mvMatrixUniformLocation matrix:modelViewMatrix];
	[self setUniformMatrix3:_normalMatrixUniformLocation matrix:modelViewMatrix];
}

- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix {
	[self setUniformMatrix4:_mvpMatrixUniformLocation matrix:modelViewProjectionMatrix];
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	[self setVertexAttribute:GL_FLOAT attributeLocation:_vertexAttributeLocation size:VBO_POSITION_SIZE strideBytes:vboData.stride offset:vboData.positionOffset];
	[self setVertexAttribute:GL_FLOAT attributeLocation:_normalAttributeLocation size:VBO_NORMAL_SIZE strideBytes:vboData.stride offset:vboData.normalOffset];
	if (_texCoordAttributeLocation != -1 && vboData.uvOffset != -1) {
		[self setVertexAttribute:GL_FLOAT attributeLocation:_texCoordAttributeLocation size:VBO_UV_SIZE strideBytes:vboData.stride offset:vboData.uvOffset];
	}
	if (vboData.boneIndexOffset != -1) {
		[self setVertexAttribute:GL_UNSIGNED_BYTE attributeLocation:_boneIndexAttributeLocation size:vboData.boneIndexSize strideBytes:vboData.stride offset:vboData.boneIndexOffset];
		[self setVertexAttribute:GL_FLOAT attributeLocation:_boneWeightsAttributeLocation size:vboData.boneWeightSize strideBytes:vboData.stride offset:vboData.boneWeightOffset];
	}
}

- (void) setTexture:(Isgl3dGLTexture *)texture {
	if (_samplerLocation != -1) {
		// Bind the texture
		[self bindTexture:texture textureUnit:TEXTURE0_INDEX];
		[self setUniformSampler:_samplerLocation forTextureUnit:TEXTURE0_INDEX];
	}
	
	_currentState.textureEnabled = YES;
}

- (void) setMaterialData:(float *)ambientColor diffuseColor:(float *)diffuseColor specularColor:(float *)specularColor withShininess:(float)shininess {
	
	if (_planarShadowsActive) {
		_blackAndAlpha[3] = _shadowAlpha;
		[self setUniform4f:_materialAmbientLocation values:_blackAndAlpha];
		[self setUniform4f:_materialDiffuseLocation values:_blackAndAlpha];
		[self setUniform4f:_materialSpecularLocation values:_blackAndAlpha];
		[self setUniform1i:_includeSpecularUniformLocation value:0];

	} else {	
		[self setUniform4f:_materialAmbientLocation values:ambientColor];
		[self setUniform4f:_materialDiffuseLocation values:diffuseColor];
		[self setUniform4f:_materialSpecularLocation values:specularColor];
		[self setUniform1f:_materialShininessLocation value:shininess];
	
		if (shininess > 0.0) {
			[self setUniform1i:_includeSpecularUniformLocation value:1];
		} else {
			[self setUniform1i:_includeSpecularUniformLocation value:0];
		}
	}
	
	_currentState.textureEnabled = NO;
}

- (void) addLight:(Isgl3dLight *)light viewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	if (_lightCount >= MAX_LIGHTS) {
		Isgl3dLog(Warn, @"Number of lights exceeds %i", MAX_LIGHTS);
		return;
	}
	
	[self setActive];
	unsigned int lightIndex = _lightCount;
	
	_lightCount++;
	
	// enable light
	[self setUniform1i:_lightEnabledLocation[lightIndex] value:1];
	
	// set light colors
	[self setUniform4f:_lightAmbientLocation[lightIndex] values:[light ambientLight]];
	[self setUniform4f:_lightDiffuseLocation[lightIndex] values:[light diffuseLight]];
	[self setUniform4f:_lightSpecularLocation[lightIndex] values:[light specularLight]];
	
	// set light position, take into account translation from viewer's position
	float transformedLightPosition[4];
	[light copyWorldPositionToArray:transformedLightPosition];
	im4MultArray4(viewMatrix, transformedLightPosition);
	[self setUniform4f:_lightPositionLocation[lightIndex] values:transformedLightPosition];
	
	// set attenuation factors
	_attenuation[0] = light.constantAttenuation;
	_attenuation[1] = light.linearAttenuation;
	_attenuation[2] = light.quadraticAttenuation;
	[self setUniform3f:_lightAttenuationLocation[lightIndex] values:_attenuation];
	
	// Set spot factors
	if (light.lightType == SpotLight) {
		// set spot light direction, take into account translation from viewer's position
		float spotDirection[4];
		memcpy(spotDirection, [light spotDirection], sizeof(float) * 3);
		spotDirection[3] = 0.;
		
		im4MultArray4(viewMatrix, spotDirection);
		[self setUniform3f:_lightSpotDirectionLocation[lightIndex] values:spotDirection];

		[self setUniform1f:_lightSpotCutoffAngleLocation[lightIndex] value:light.spotCutoffAngle];
		[self setUniform1f:_lightSpotFalloffExponentLocation[lightIndex] value:light.spotFalloffExponent];
	} else {
		[self setUniform1f:_lightSpotCutoffAngleLocation[lightIndex] value:-1.0];
	}
	
	
}

- (void) setSceneAmbient:(NSString *)ambient {
	if (![_sceneAmbientString isEqualToString:ambient]) { 
		_sceneAmbientString = ambient;
		
		[self setActive];
		// Set scene ambient levels
		[Isgl3dColorUtil hexColorStringToFloatArray:ambient floatArray:_sceneAmbient];
		[self setUniform4f:_sceneAmbientUniformLocation values:_sceneAmbient];
	}
}

- (void) enableLighting:(BOOL)lightingEnabled {
	_currentState.lightingEnabled = lightingEnabled; 
}

- (void) setAlphaCullingValue:(float)cullValue {
	if (_alphaTestValueUniformLocation != -1) {
		[self setUniform1f:_alphaTestValueUniformLocation value:cullValue];
	}
}

- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations {
	[self setUniformMatrix4:_boneMatrixArrayUniformLocation matrix:transformations size:8];
	[self setUniformMatrix3:_boneMatrixArrayITUniformLocation matrix:inverseTransformations size:8];
}

- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex {
	[self setUniform1i:_boneCountUniformLocation value:numberOfBonesPerVertex];
}


- (void) setShadowCastingMVPMatrix:(Isgl3dMatrix4 *)mvpMatrix {
	if (_mcToLightMatrixUniformLocation != -1) {
		im4Copy(&_shadowMapTransformMatrix, &_biasMatrix);
		im4Multiply(&_shadowMapTransformMatrix, mvpMatrix);
		
		[self setUniformMatrix4:_mcToLightMatrixUniformLocation matrix:&_shadowMapTransformMatrix];
	}
}

- (void) setShadowCastingLightPosition:(Isgl3dVector3 *)position viewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	// set light position, take into account translation from viewer's position
	float transformedLightPosition[4] = {position->x, position->y, position->z, 1.0};
	im4MultArray4(viewMatrix, transformedLightPosition);
	[self setUniform4f:_shadowCastingLightPositionLocation values:transformedLightPosition];
}

- (void) setShadowMap:(Isgl3dGLTexture *)texture {
	if (_shadowMapSamplerLocation != -1) {
		[self bindTexture:texture textureUnit:SHADOWMAP_INDEX];
		[self setUniformSampler:_shadowMapSamplerLocation forTextureUnit:SHADOWMAP_INDEX];
	}
}

- (void) setPlanarShadowsActive:(BOOL)planarShadowsActive shadowAlpha:(float)shadowAlpha {
	_planarShadowsActive = planarShadowsActive;
	_shadowAlpha = shadowAlpha;
}

- (void) onModelRenderReady {
	[self handleStates];
}

- (void) onModelRenderEnds {
	// save client states
	[_previousState copyFrom:_currentState];
	[_currentState reset];
}

- (void) render:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset {
	// render elements
	glDrawElements(GL_TRIANGLES, numberOfElements, GL_UNSIGNED_SHORT, &((unsigned short *)0)[elementOffset]);
}

- (void) handleStates {

	if (!_currentState.textureEnabled && _previousState.textureEnabled) {
		//glDisable(GL_BLEND);
	
	} else if (_currentState.textureEnabled && !_previousState.textureEnabled) {
		glActiveTexture(GL_TEXTURE0);
	
		// for transparency
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA ,GL_ONE_MINUS_SRC_ALPHA); 
	}

	if (!_currentState.lightingEnabled && _previousState.lightingEnabled) {
		[self setUniform1i:_lightingEnabledUniformLocation value:0];

	} else if (_currentState.lightingEnabled && !_previousState.lightingEnabled) {
		if (_lightCount > 0) {
			[self setUniform1i:_lightingEnabledUniformLocation value:1];
		} else {
			_currentState.lightingEnabled = NO;
		}
	}
	
}

- (void) clean {
	for (int i = 0; i < MAX_LIGHTS; i++) {
		[self setUniform1i:_lightEnabledLocation[i] value:0];
	}
	
	//NSLog(@"_lightingEnabledUniformLocation = %d", _lightingEnabledUniformLocation);
	//[self setUniform1i:_lightingEnabledUniformLocation value:0];
	//[self setSceneAmbient:@"000000"];
	
	_lightCount = 0;
}


@end
