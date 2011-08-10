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

#import "Isgl3dParticleShader.h"
#import "Isgl3dShaderState.h"
#import "Isgl3dGLProgram.h"
#import "Isgl3dGLVBOData.h"

@interface Isgl3dParticleShader (PrivateMethods)
- (void) handleStates;
@end

@implementation Isgl3dParticleShader

- (id) initWithVsPreProcHeader:(NSString *)vsPreProcHeader fsPreProcHeader:(NSString *)fsPreProcHeader {
	
	if ((self = [super initWithVertexShaderName:@"particle.vsh" fragmentShaderName:@"particle.fsh" vsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader])) {

		_currentState = [[Isgl3dShaderState alloc] init];
		_previousState = [[Isgl3dShaderState alloc] init];


		// Initialise point characteristics
		[self setUniform1f:_pointMinSize value:1.0];
		[self setUniform1f:_pointMaxSize value:64.0];
		[self setUniform1f:_pointConstantAttenuation value:1.0];
		[self setUniform1f:_pointLinearAttenuation value:0.0];
		[self setUniform1f:_pointQuadraticAttenuation value:0.0];
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
	_pointSizeAttributeLocation = [_glProgram getAttributeLocation:@"a_pointSize"];
	_vertexColorAttributeLocation = [_glProgram getAttributeLocation:@"a_vertexColor"];
	
	// Uniforms
	
	// Matrices
    _mvMatrixUniformLocation = [_glProgram getUniformLocation:@"u_mvMatrix"];
    _mvpMatrixUniformLocation = [_glProgram getUniformLocation:@"u_mvpMatrix"];

	// Texture
	_samplerLocation = [_glProgram getUniformLocation:@"s_texture"];
	
	// Point sprites
	_pointSpriteEnabledUniformLocation = [_glProgram getUniformLocation:@"u_pointSpriteEnabled"];
	_pointCoordEnabledUniformLocation = [_glProgram getUniformLocation:@"u_pointCoordEnabled"];
	_pointMinSize = [_glProgram getUniformLocation:@"u_point.minSize"];
	_pointMaxSize = [_glProgram getUniformLocation:@"u_point.maxSize"];
	_pointConstantAttenuation = [_glProgram getUniformLocation:@"u_point.constantAttenuation"];
	_pointLinearAttenuation = [_glProgram getUniformLocation:@"u_point.linearAttenuation"];
	_pointQuadraticAttenuation = [_glProgram getUniformLocation:@"u_point.quadraticAttenuation"];

	// Alpha testing
	_alphaTestValueUniformLocation = [_glProgram getUniformLocation:@"u_alphaTestValue"];
}

- (void) setModelViewMatrix:(Isgl3dMatrix4 *)modelViewMatrix {
	[self setUniformMatrix4:_mvMatrixUniformLocation matrix:modelViewMatrix];
}

- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix {
	[self setUniformMatrix4:_mvpMatrixUniformLocation matrix:modelViewProjectionMatrix];
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	[self setVertexAttribute:GL_FLOAT attributeLocation:_vertexAttributeLocation size:VBO_POSITION_SIZE strideBytes:vboData.stride offset:vboData.positionOffset];
	[self setVertexAttribute:GL_FLOAT attributeLocation:_vertexColorAttributeLocation size:VBO_COLOR_SIZE strideBytes:vboData.stride offset:vboData.colorOffset];
	[self setVertexAttribute:GL_FLOAT attributeLocation:_pointSizeAttributeLocation size:VBO_SIZE_SIZE strideBytes:vboData.stride offset:vboData.sizeOffset];
}

- (void) setTexture:(Isgl3dGLTexture *)texture {
	// Bind the texture
	if (_samplerLocation != -1) {
		[self bindTexture:texture textureUnit:0];
		[self setUniformSampler:_samplerLocation forTextureUnit:0];
	}
	
	_currentState.textureEnabled = YES;
}


- (void) setAlphaCullingValue:(float)cullValue {
	if (_alphaTestValueUniformLocation != -1) {
		[self setUniform1f:_alphaTestValueUniformLocation value:cullValue];
	}
}

- (void) setPointAttenuation:(float *)attenuation {
	[self setUniform1f:_pointConstantAttenuation value:attenuation[0]];
	[self setUniform1f:_pointLinearAttenuation value:attenuation[1]];
	[self setUniform1f:_pointQuadraticAttenuation value:attenuation[2]];
}

- (void) render:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset {
	[self handleStates];
	
	// render elements
	glDrawElements(GL_POINTS, numberOfElements, GL_UNSIGNED_SHORT, &((unsigned short*)0)[elementOffset]);
	
	// save client states
	[_previousState copyFrom:_currentState];
	[_currentState reset];
}

- (void) handleStates {

	if (!_currentState.textureEnabled && _previousState.textureEnabled) {
	
	} else if (_currentState.textureEnabled && !_previousState.textureEnabled) {
	
		// for transparency
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA ,GL_ONE_MINUS_SRC_ALPHA); 
	}


}

- (void) clean {

	[self setActive];

	[super clean];
	
	// Initialise point characteristics
	[self setUniform1f:_pointMinSize value:1.0];
	[self setUniform1f:_pointMaxSize value:64.0];
	[self setUniform1f:_pointConstantAttenuation value:1.0];
	[self setUniform1f:_pointLinearAttenuation value:0.0];
	[self setUniform1f:_pointQuadraticAttenuation value:0.0];
}


@end
