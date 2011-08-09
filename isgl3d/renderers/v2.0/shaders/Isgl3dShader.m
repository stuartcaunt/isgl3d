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

#import "Isgl3dShader.h"
#import "Isgl3dGLProgram.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dArray.h"
#import "Isgl3dLog.h"

@interface Isgl3dShader (PrivateMethods)
- (void) getAttributeAndUniformLocations;
- (GLint) attributeIndexForName:(NSString *)name;
- (GLint) uniformIndexForName:(NSString *)name;
@end

//static GLuint _currentVBOIndex = -1;

@implementation Isgl3dShader

- (id) initWithVertexShaderName:(NSString *)vertexShaderName fragmentShaderName:(NSString *)fragmentShaderName vsPreProcHeader:(NSString *)vsPreProcHeader fsPreProcHeader:(NSString *)fsPreProcHeader {
	
	if ((self = [super init])) {
		_glProgram = [[Isgl3dGLProgram alloc] init];
		
		NSString * vertexExtension = [vertexShaderName pathExtension];
		NSString * vertexName = [vertexShaderName stringByDeletingPathExtension];
		NSString * fragmentExtension = [fragmentShaderName pathExtension];
		NSString * fragmentName = [fragmentShaderName stringByDeletingPathExtension];
		
       	
   		NSString * vertexShaderFileName = [[NSBundle mainBundle] pathForResource:vertexName ofType:vertexExtension];
   		if (!vertexShaderFileName) {
			Isgl3dLog(Error, @"Isgl3dShader: cannot create vertex shader: %@ does not exist in resources.", vertexShaderName);
			return nil;
   		}
   		
		NSString * fragmentShaderFileName = [[NSBundle mainBundle] pathForResource:fragmentName ofType:fragmentExtension];
   		if (!fragmentShaderFileName) {
			Isgl3dLog(Error, @"Isgl3dShader: cannot create fragment shader: %@ does not exist in resources.", fragmentShaderName);
			return nil;
   		}
	
   		if (![_glProgram loadShaderFile:GL_VERTEX_SHADER file:vertexShaderFileName withPreProcessorHeader:vsPreProcHeader]) {
   			[self release];
			return nil;
		}
		if (![_glProgram loadShaderFile:GL_FRAGMENT_SHADER file:fragmentShaderFileName withPreProcessorHeader:fsPreProcHeader]) {
   			[self release];
			return nil;
		}

		[_glProgram linkProgram];
		// Validation slows down app startup : uncomment for validation results during testing
//        if (![_glProgram validateProgram]) {
//            [self release];
//            return nil;
//        }
        
        _uniformNameIndices = [[NSMutableDictionary alloc] init];
        _attributeNameIndices = [[NSMutableDictionary alloc] init];
        
        
		[self getAttributeAndUniformLocations];
	
		_whiteAndAlpha[0] = 1.0;	
		_whiteAndAlpha[1] = 1.0;	
		_whiteAndAlpha[2] = 1.0;	
		_whiteAndAlpha[3] = 1.0;
		_blackAndAlpha[0] = 0.0;	
		_blackAndAlpha[1] = 0.0;	
		_blackAndAlpha[2] = 0.0;	
		_blackAndAlpha[3] = 1.0;

	}
	
	return self;
}


- (void) dealloc {

	[_uniformNameIndices release];
	[_attributeNameIndices release];
	[_glProgram release];
		
	[super dealloc];
}

- (void) initShader {
}


- (void) getAttributeAndUniformLocations {
}


- (GLint) uniformIndexForName:(NSString *)name {

	NSNumber * index = [_uniformNameIndices objectForKey:name];
	if (index) {
		return (GLint)[index intValue];
	
	} else {
		GLint location = [_glProgram getUniformLocation:name];
		if (location >= 0) {
			[_uniformNameIndices setObject:[NSNumber numberWithInt:location] forKey:name];
		} else {
			Isgl3dLog(Error, @"Isgl3dShader: cannot find uniform with name %@.", name);
		}
		return location;
	}
}

- (GLint) attributeIndexForName:(NSString *)name {

	NSNumber * index = [_attributeNameIndices objectForKey:name];
	if (index) {
		return (GLint)[index intValue];
	
	} else {
		GLint location = [_glProgram getAttributeLocation:name];
		if (location >= 0) {
			[_attributeNameIndices setObject:[NSNumber numberWithInt:location] forKey:name];
		} else {
			Isgl3dLog(Error, @"Isgl3dShader: cannot find attribute with name %@.", name);
		}
		return location;
	}
}

- (void) bindVertexBuffer:(GLuint)bufferIndex {
	glBindBuffer(GL_ARRAY_BUFFER, bufferIndex);
}

- (void) setVertexAttribute:(GLenum)type attributeLocation:(GLuint)attributeLocation size:(GLint)size strideBytes:(GLsizei)strideBytes offset:(unsigned int)offset {
	// Enable attribute array and bind to buffer data 
	glEnableVertexAttribArray(attributeLocation);
	glVertexAttribPointer(attributeLocation, size, type, GL_FALSE, strideBytes, (const void *)offset);
}

- (void) setVertexAttribute:(GLenum)type attributeName:(NSString *)attributeName size:(GLint)size strideBytes:(GLsizei)strideBytes offset:(unsigned int)offset {
	// Enable attribute array and bind to buffer data 
	GLint attributeLocation = [self attributeIndexForName:attributeName];
	glEnableVertexAttribArray(attributeLocation);
	glVertexAttribPointer(attributeLocation, size, type, GL_FALSE, strideBytes, (const void *)offset);
}

- (void) setUniformMatrix3:(GLint)uniformLocation matrix:(Isgl3dMatrix4 *)matrix {
	float matrixArray[9];
	im4ConvertTo3x3ColumnMajorFloatArray(matrix, matrixArray);
	glUniformMatrix3fv(uniformLocation, 1, GL_FALSE, matrixArray);
}

- (void) setUniformMatrix4:(GLint)uniformLocation matrix:(Isgl3dMatrix4 *)matrix {
	float *matrixArray = im4ColumnMajorFloatArrayFromMatrix(matrix);
	glUniformMatrix4fv(uniformLocation, 1, GL_FALSE, matrixArray);
}

- (void) setUniformMatrix3:(GLint)uniformLocation matrix:(Isgl3dArray *)matrices size:(unsigned int)size {
	float matrixArray[size * 9];
	int offset = 0;
	IA_FOREACH_PTR(Isgl3dMatrix4 *, matrix, matrices) {

		im4ConvertTo3x3ColumnMajorFloatArray(matrix, &(matrixArray[offset]));
		offset += 9;
	}
	glUniformMatrix3fv(uniformLocation, size, GL_FALSE, matrixArray);
}

- (void) setUniformMatrix4:(GLint)uniformLocation matrix:(Isgl3dArray *)matrices size:(unsigned int)size {
	Isgl3dMatrix4 * firstMatrix = IA_GET_PTR(Isgl3dMatrix4 *, matrices, 0);
	float *matrixArray = im4ColumnMajorFloatArrayFromMatrix(firstMatrix);
	
	glUniformMatrix4fv(uniformLocation, size, GL_FALSE, matrixArray);
}

- (void) setUniform1f:(GLint)uniformIndex value:(GLfloat)value {
	glUniform1f(uniformIndex, value);
}

- (void) setUniform2f:(GLint)uniformIndex values:(GLfloat *)values {
	glUniform2f(uniformIndex, values[0], values[1]);
}

- (void) setUniform3f:(GLint)uniformIndex values:(GLfloat *)values {
	glUniform3f(uniformIndex, values[0], values[1], values[2]);
}

- (void) setUniform4f:(GLint)uniformIndex values:(GLfloat *)values {
	glUniform4f(uniformIndex, values[0], values[1], values[2], values[3]);
}

- (void) setUniform1i:(GLint)uniformIndex value:(GLint)value {
	glUniform1i(uniformIndex, value);
}

- (void) setUniform2i:(GLint)uniformIndex values:(GLint *)values {
	glUniform2i(uniformIndex, values[0], values[1]);
}

- (void) setUniform3i:(GLint)uniformIndex values:(GLint *)values {
	glUniform3i(uniformIndex, values[0], values[1], values[2]);
}

- (void) setUniform4i:(GLint)uniformIndex values:(GLint *)values {
	glUniform4i(uniformIndex, values[0], values[1], values[2], values[3]);
}

- (void) setUniform2fv:(GLint)uniformIndex values:(GLfloat *)values {
	glUniform2fv(uniformIndex, 1, values);
}

- (void) setUniform3fv:(GLint)uniformIndex values:(GLfloat *)values {
	glUniform3fv(uniformIndex, 1, values);
}

- (void) setUniform4fv:(GLint)uniformIndex values:(GLfloat *)values {
	glUniform4fv(uniformIndex, 1, values);
}

- (void) setUniform2iv:(GLint)uniformIndex values:(GLint *)values {
	glUniform2iv(uniformIndex, 1, values);
}

- (void) setUniform3iv:(GLint)uniformIndex values:(GLint *)values {
	glUniform3iv(uniformIndex, 1, values);
}

- (void) setUniform4iv:(GLint)uniformIndex values:(GLint *)values {
	glUniform4iv(uniformIndex, 1, values);
}

- (void) setUniformSampler:(GLint)samplerIndex forTextureIndex:(GLuint)textureIndex {
	glUniform1i(samplerIndex, textureIndex);
}

- (void) setUniformMatrix3WithName:(NSString *)uniformName matrix:(Isgl3dMatrix4 *)matrix {
	GLint uniformLocation = [self uniformIndexForName:uniformName];
	[self setUniformMatrix3:uniformLocation matrix:matrix];
}

- (void) setUniformMatrix4WithName:(NSString *)uniformName matrix:(Isgl3dMatrix4 *)matrix {
	GLint uniformLocation = [self uniformIndexForName:uniformName];
	[self setUniformMatrix4:uniformLocation matrix:matrix];
}

- (void) setUniformMatrix3WithName:(NSString *)uniformName matrix:(Isgl3dArray *)matrices size:(unsigned int)size {
	GLint uniformLocation = [self uniformIndexForName:uniformName];
	[self setUniformMatrix3:uniformLocation matrix:matrices size:size];
}

- (void) setUniformMatrix4WithName:(NSString *)uniformName matrix:(Isgl3dArray *)matrices size:(unsigned int)size {
	GLint uniformLocation = [self uniformIndexForName:uniformName];
	[self setUniformMatrix4:uniformLocation matrix:matrices size:size];
}

- (void) setUniform1fWithName:(NSString *)uniformName value:(GLfloat)value {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform1f(uniformIndex, value);
}

- (void) setUniform2fWithName:(NSString *)uniformName values:(GLfloat *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform2f(uniformIndex, values[0], values[1]);
}

- (void) setUniform3fWithName:(NSString *)uniformName values:(GLfloat *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform3f(uniformIndex, values[0], values[1], values[2]);
}

- (void) setUniform4fWithName:(NSString *)uniformName values:(GLfloat *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform4f(uniformIndex, values[0], values[1], values[2], values[3]);
}

- (void) setUniform1iWithName:(NSString *)uniformName value:(GLint)value {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform1i(uniformIndex, value);
}

- (void) setUniform2iWithName:(NSString *)uniformName values:(GLint *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform2i(uniformIndex, values[0], values[1]);
}

- (void) setUniform3iWithName:(NSString *)uniformName values:(GLint *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform3i(uniformIndex, values[0], values[1], values[2]);
}

- (void) setUniform4iWithName:(NSString *)uniformName values:(GLint *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform4i(uniformIndex, values[0], values[1], values[2], values[3]);
}

- (void) setUniform2fvWithName:(NSString *)uniformName values:(GLfloat *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform2fv(uniformIndex, 1, values);
}

- (void) setUniform3fvWithName:(NSString *)uniformName values:(GLfloat *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform3fv(uniformIndex, 1, values);
}

- (void) setUniform4fvWithName:(NSString *)uniformName values:(GLfloat *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform4fv(uniformIndex, 1, values);
}

- (void) setUniform2ivWithName:(NSString *)uniformName values:(GLint *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform2iv(uniformIndex, 1, values);
}

- (void) setUniform3ivWithName:(NSString *)uniformName values:(GLint *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform3iv(uniformIndex, 1, values);
}

- (void) setUniform4ivWithName:(NSString *)uniformName values:(GLint *)values {
	GLint uniformIndex = [self uniformIndexForName:uniformName];
	glUniform4iv(uniformIndex, 1, values);
}

- (void) setUniformSamplerWithName:(NSString *)samplerName forTextureIndex:(GLuint)textureIndex {
	GLint samplerIndex = [self uniformIndexForName:samplerName];
	glUniform1i(samplerIndex, textureIndex);
}


- (void) bindTexture:(GLuint)textureIndex index:(GLuint)index {
	if (index == 0) {
		glActiveTexture(GL_TEXTURE0);
	} else if (index == 1) {
		glActiveTexture(GL_TEXTURE1);
	}
	glBindTexture(GL_TEXTURE_2D, textureIndex);
}

- (void) setModelMatrix:(Isgl3dMatrix4 *)modelMatrix {
	
}

- (void) setViewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	
}

- (void) setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix {
	
}

- (void) setModelViewMatrix:(Isgl3dMatrix4 *)modelViewMatrix {
}

- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix {
}

- (void) setActive {
	// Set program to be used
	glUseProgram([_glProgram glProgram]);
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
}

- (void) setTexture:(GLuint)textureId {
}

- (void) setMaterialData:(float *)ambientColor diffuseColor:(float *)diffuseColor specularColor:(float *)specularColor withShininess:(float)shininess {
}


- (void) enableLighting:(BOOL)lightingEnabled {
}

- (void) setAlphaCullingValue:(float)cullValue {
}

- (void) preRender {
}

- (void) postRender {
}

- (void) render:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset {
}

- (void) setPointAttenuation:(float *)attenuation {
}

- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations {
}

- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex {
}

- (void) addLight:(Isgl3dLight *)light viewMatrix:(Isgl3dMatrix4 *)viewMatrix {
}

- (void) setSceneAmbient:(NSString *)ambient {
}

- (void) setShadowCastingMVPMatrix:(Isgl3dMatrix4 *)mvpMatrix {
}

- (void) setShadowCastingLightPosition:(Isgl3dVector3 *)position viewMatrix:(Isgl3dMatrix4 *)viewMatrix {
}

- (void) setShadowMap:(unsigned int)textureId {
}

- (void) setPlanarShadowsActive:(BOOL)planarShadowsActive shadowAlpha:(float)shadowAlpha {
}

- (void) setCaptureColor:(float *)color {
}

- (void) clean {
}



@end
