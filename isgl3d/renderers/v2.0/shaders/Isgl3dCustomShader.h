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

typedef enum {
	Isgl3dCustomShaderTrianglesType = 0,
	Isgl3dCustomShaderPointsType
} Isgl3dCustomShaderType;

@interface Isgl3dCustomShader : Isgl3dShader {
	NSString * _key;
	Isgl3dCustomShaderType _shaderType;
}


@property (nonatomic, readonly) NSString * key;
@property (nonatomic) Isgl3dCustomShaderType shaderType;

+ (id) shaderWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			key:(NSString *)key;

+ (id) shaderWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			vertexShaderPreProcessorHeader:(NSString *)vertexShaderPreProcessorHeader 
			fragmentShaderPreProcessorHeader:(NSString *)fragmentShaderPreProcessorHeader 
			key:(NSString *)key;

- (id) initWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			key:(NSString *)key;

- (id) initWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			vertexShaderPreProcessorHeader:(NSString *)vertexShaderPreProcessorHeader 
			fragmentShaderPreProcessorHeader:(NSString *)fragmentShaderPreProcessorHeader 
			key:(NSString *)key;

- (void) initShader;
- (void) clean;

- (void) getAttributeAndUniformLocations;

- (void) setModelMatrix:(Isgl3dMatrix4 *)modelMatrix;
- (void) setViewMatrix:(Isgl3dMatrix4 *)viewMatrix;
- (void) setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix;
- (void) setModelViewMatrix:(Isgl3dMatrix4 *)modelViewMatrix;
- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix;

- (void) setVBOData:(Isgl3dGLVBOData *)vboData;

- (void) setAlphaCullingValue:(float)cullValue;
- (void) setPointAttenuation:(float *)attenuation;
- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations;
- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex;

- (void) enableLighting:(BOOL)lightingEnabled;
- (void) addLight:(Isgl3dLight *)light viewMatrix:(Isgl3dMatrix4 *)viewMatrix;
- (void) setSceneAmbient:(NSString *)ambient;

- (void) preRender;
- (void) postRender;
- (void) render:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset;

@end
