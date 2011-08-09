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

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import "Isgl3dVector.h"
#import "Isgl3dMatrix.h"

@class Isgl3dGLProgram;
@class Isgl3dLight;
@class Isgl3dGLVBOData;
@class Isgl3dArray;

#define TEXTURE0_INDEX 0
#define SHADOWMAP_INDEX 1


/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dShader : NSObject {

@protected
	Isgl3dGLProgram * _glProgram;
	
	float _whiteAndAlpha[4];
	float _blackAndAlpha[4];
	
	NSMutableDictionary * _attributeNameIndices;
	NSMutableDictionary * _uniformNameIndices;
	
}

- (id) initWithVertexShaderName:(NSString *)vertexShaderName fragmentShaderName:(NSString *)fragmentShaderName vsPreProcHeader:(NSString *)vsPreProcHeader fsPreProcHeader:(NSString *)fsPreProcHeader;
- (void) initShader;

- (void) bindVertexBuffer:(GLuint)bufferIndex;
- (void) setVertexAttribute:(GLenum)type attributeLocation:(GLuint)attributeLocation size:(GLint)size strideBytes:(GLsizei)strideBytes offset:(unsigned int)offset;
- (void) setVertexAttribute:(GLenum)type attributeName:(NSString *)attributeName size:(GLint)size strideBytes:(GLsizei)strideBytes offset:(unsigned int)offset;

- (void) setUniformMatrix3:(GLint)uniformLocation matrix:(Isgl3dMatrix4 *)matrix;
- (void) setUniformMatrix4:(GLint)uniformLocation matrix:(Isgl3dMatrix4 *)matrix;
- (void) setUniformMatrix3:(GLint)uniformLocation matrix:(Isgl3dArray *)matrices size:(unsigned int)size;
- (void) setUniformMatrix4:(GLint)uniformLocation matrix:(Isgl3dArray *)matrices size:(unsigned int)size;
- (void) setUniform1f:(GLint)uniformIndex value:(GLfloat)value;
- (void) setUniform2f:(GLint)uniformIndex values:(GLfloat *)values;
- (void) setUniform3f:(GLint)uniformIndex values:(GLfloat *)values;
- (void) setUniform4f:(GLint)uniformIndex values:(GLfloat *)values;
- (void) setUniform1i:(GLint)uniformIndex value:(GLint)value;
- (void) setUniform2i:(GLint)uniformIndex values:(GLint *)value;
- (void) setUniform3i:(GLint)uniformIndex values:(GLint *)value;
- (void) setUniform4i:(GLint)uniformIndex values:(GLint *)value;
- (void) setUniform2fv:(GLint)uniformIndex values:(GLfloat *)values;
- (void) setUniform3fv:(GLint)uniformIndex values:(GLfloat *)values;
- (void) setUniform4fv:(GLint)uniformIndex values:(GLfloat *)values;
- (void) setUniform2iv:(GLint)uniformIndex values:(GLint *)values;
- (void) setUniform3iv:(GLint)uniformIndex values:(GLint *)values;
- (void) setUniform4iv:(GLint)uniformIndex values:(GLint *)values;
- (void) setUniformSampler:(GLint)samplerIndex forTextureIndex:(GLuint)textureIndex;

- (void) setUniformMatrix3WithName:(NSString *)uniformName matrix:(Isgl3dMatrix4 *)matrix;
- (void) setUniformMatrix4WithName:(NSString *)uniformName matrix:(Isgl3dMatrix4 *)matrix;
- (void) setUniformMatrix3WithName:(NSString *)uniformName matrix:(Isgl3dArray *)matrices size:(unsigned int)size;
- (void) setUniformMatrix4WithName:(NSString *)uniformName matrix:(Isgl3dArray *)matrices size:(unsigned int)size;
- (void) setUniform1fWithName:(NSString *)uniformName value:(GLfloat)value;
- (void) setUniform2fWithName:(NSString *)uniformName values:(GLfloat *)values;
- (void) setUniform3fWithName:(NSString *)uniformName values:(GLfloat *)values;
- (void) setUniform4fWithName:(NSString *)uniformName values:(GLfloat *)values;
- (void) setUniform1iWithName:(NSString *)uniformName value:(GLint)value;
- (void) setUniform2iWithName:(NSString *)uniformName values:(GLint *)value;
- (void) setUniform3iWithName:(NSString *)uniformName values:(GLint *)value;
- (void) setUniform4iWithName:(NSString *)uniformName values:(GLint *)value;
- (void) setUniform2fvWithName:(NSString *)uniformName values:(GLfloat *)values;
- (void) setUniform3fvWithName:(NSString *)uniformName values:(GLfloat *)values;
- (void) setUniform4fvWithName:(NSString *)uniformName values:(GLfloat *)values;
- (void) setUniform2ivWithName:(NSString *)uniformName values:(GLint *)values;
- (void) setUniform3ivWithName:(NSString *)uniformName values:(GLint *)values;
- (void) setUniform4ivWithName:(NSString *)uniformName values:(GLint *)values;
- (void) setUniformSamplerWithName:(NSString *)samplerName forTextureIndex:(GLuint)textureIndex;

- (void) bindTexture:(GLuint)textureIndex index:(GLuint)index;

- (void) setModelMatrix:(Isgl3dMatrix4 *)modelMatrix;
- (void) setViewMatrix:(Isgl3dMatrix4 *)viewMatrix;
- (void) setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix;
- (void) setModelViewMatrix:(Isgl3dMatrix4 *)modelViewMatrix;
- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix;

- (void) setActive;

- (void) setVBOData:(Isgl3dGLVBOData *)vboData;

- (void) setTexture:(GLuint)textureId;
- (void) setMaterialData:(float *)ambientColor diffuseColor:(float *)diffuseColor specularColor:(float *)specularColor withShininess:(float)shininess;

- (void) enableLighting:(BOOL)lightingEnabled;

- (void) setAlphaCullingValue:(float)cullValue;
- (void) setPointAttenuation:(float *)attenuation;

//- (void) setBoneTransformations:(NSArray *)transformations andInverseTransformations:(NSArray *)inverseTransformations;
- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations;
- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex;


- (void) preRender;
- (void) postRender;
- (void) render:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset;


- (void) addLight:(Isgl3dLight *)light viewMatrix:(Isgl3dMatrix4 *)viewMatrix;
- (void) setSceneAmbient:(NSString *)ambient;

- (void) setShadowCastingMVPMatrix:(Isgl3dMatrix4 *)mvpMatrix;
- (void) setShadowCastingLightPosition:(Isgl3dVector3 *)position viewMatrix:(Isgl3dMatrix4 *)viewMatrix;
- (void) setShadowMap:(unsigned int)textureId;
- (void) setPlanarShadowsActive:(BOOL)planarShadowsActive shadowAlpha:(float)shadowAlpha;

- (void) setCaptureColor:(float *)color;

- (void) clean;

@end
