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

@class Isgl3dNode;

typedef enum {
	Isgl3dCustomShaderTrianglesType = 0,
	Isgl3dCustomShaderPointsType
} Isgl3dCustomShaderType;

/**
 * The Isgl3dCustomShader is intended to be extended for user-defined shaders. It is created with a vertex and fragment shader (with optional pre-processor directive)
 * that are used to create and OpenGL program. Calls during the scene rendering and object rendering ensure that all iSGL3D characteristics are sent to the
 * shader before rendering a given object.
 * 
 * By default the custom shader is used for rendering meshes but by changing the shader type it can be used to render points.
 * 
 * A key is is also given to the shader to allow for one shader to ensure unicity of a particular shader and allow reuse.
 */
@interface Isgl3dCustomShader : Isgl3dShader {
	NSString * _key;
	Isgl3dCustomShaderType _shaderType;
	
	Isgl3dMatrix4 * _modelMatrix;
	Isgl3dMatrix4 * _viewMatrix;
	Isgl3dMatrix4 * _projectionMatrix;
	Isgl3dMatrix4 * _modelViewMatrix;
	Isgl3dMatrix4 * _modelViewProjectionMatrix;
	
	Isgl3dGLVBOData * _vboData;
	
	NSMutableArray * _lights;
	NSString * _sceneAmbient;
	
	float _alphaCullingValue;
	float * _pointAttenuation;
	
	Isgl3dArray * _boneTransformations;
	Isgl3dArray * _boneInverseTransformations;
	unsigned int _numberOfBonesPerVertex;
	
	Isgl3dNode * _activeNode;
}

/**
 * The unique key of the shader
 */
@property (nonatomic, readonly) NSString * key;

/**
 * Specifies the shader type. Values can be Isgl3dCustomShaderTrianglesType (the default value) or Isgl3dCustomShaderPointsType.
 */
@property (nonatomic) Isgl3dCustomShaderType shaderType;

/**
 * Returns the current model transformation matrix for the shader
 */
@property (nonatomic, readonly) Isgl3dMatrix4 * modelMatrix;

/**
 * Returns the current view transformation matrix for the shader
 */
@property (nonatomic, readonly) Isgl3dMatrix4 * viewMatrix;

/**
 * Returns the current projections transformation matrix for the shader
 */
@property (nonatomic, readonly) Isgl3dMatrix4 * projectionMatrix;

/**
 * Returns the current model-view transformation matrix for the shader
 */
@property (nonatomic, readonly) Isgl3dMatrix4 * modelViewMatrix;

/**
 * Returns the current model-view-projection transformation matrix for the shader
 */
@property (nonatomic, readonly) Isgl3dMatrix4 * modelViewProjectionMatrix;

/**
 * Returns the current VBO data bound to the shader
 */
@property (nonatomic, readonly) Isgl3dGLVBOData * vboData;

/**
 * Returns the array of lights available in the scene
 */
@property (nonatomic, readonly) NSArray * lights;

/**
 * Returns the scene ambient light as a hex value
 */
@property (nonatomic, readonly) NSString * sceneAmbient;

/**
 * Returns the alpha culling value for the current object
 */
@property (nonatomic, readonly) float alphaCullingValue;

/**
 * Returns the array of point attenuation values.
 */
@property (nonatomic, readonly) float * pointAttenuation;

/**
 * Returns an array of 8 bone transformation matrices.
 */
@property (nonatomic, readonly) Isgl3dArray * boneTransformations;

/**
 * Returns an array of 8 bone inverse transformation matrices.
 */
@property (nonatomic, readonly) Isgl3dArray * boneInverseTransformations;

/**
 * Returns the number of bones per vertex for the current model to be shaded.
 */
@property (nonatomic, readonly) unsigned int numberOfBonesPerVertex;

/**
 * Specifies the active node being rendered.
 */
@property (nonatomic, assign) Isgl3dNode * activeNode;

/**
 * Allocates and initialises (autorelease) an Isgl3dCustomShader with given vertex and fragment shader filenames and a key for uniqueness.
 * @param vertexShaderFile The vertex shader filename
 * @param fragmentShaderFile The fragment shader filename
 * @param key The key for the shader
 */
+ (id) shaderWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			key:(NSString *)key;

/**
 * Allocates and initialises (autorelease) an Isgl3dCustomShader with given vertex and fragment shader filenames, pre-processor directives and a key for uniqueness.
 * @param vertexShaderFile The vertex shader filename
 * @param fragmentShaderFile The fragment shader filename
 * @param vertexShaderPreProcessorHeader The vertex shader pre-processor directives (can be nil).
 * @param fragmentShaderPreProcessorHeader The fragment shader pre-processor directives (can be nil).
 * @param key The key for the shader
 */
+ (id) shaderWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			vertexShaderPreProcessorHeader:(NSString *)vertexShaderPreProcessorHeader 
			fragmentShaderPreProcessorHeader:(NSString *)fragmentShaderPreProcessorHeader 
			key:(NSString *)key;

/**
 * Initialises an Isgl3dCustomShader with given vertex and fragment shader filenames and a key for uniqueness.
 * @param vertexShaderFile The vertex shader filename
 * @param fragmentShaderFile The fragment shader filename
 * @param key The key for the shader
 */
- (id) initWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			key:(NSString *)key;

/**
 * Initialises an Isgl3dCustomShader with given vertex and fragment shader filenames, pre-processor directives and a key for uniqueness.
 * @param vertexShaderFile The vertex shader filename
 * @param fragmentShaderFile The fragment shader filename
 * @param vertexShaderPreProcessorHeader The vertex shader pre-processor directives (can be nil).
 * @param fragmentShaderPreProcessorHeader The fragment shader pre-processor directives (can be nil).
 * @param key The key for the shader
 */
- (id) initWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			vertexShaderPreProcessorHeader:(NSString *)vertexShaderPreProcessorHeader 
			fragmentShaderPreProcessorHeader:(NSString *)fragmentShaderPreProcessorHeader 
			key:(NSString *)key;

/**
 * Called at the very beginning of the render phase with the delta time since the last render.
 * @param dt The delta time since the last render.
 */
- (void) onRenderPhaseBeginsWithDeltaTime:(float)dt;

/**
 * Called immediately after all scene-related attributes have been handed to the shader and
 * before individual models are rendered.
 * This can be used for example to handling lighting, view matrices, etc
 */
- (void) onSceneRenderReady;

/**
 * Called immediately before rendering the object to perform any pre-render operations.
 * This can be used for example to bind textures to samplers, handle shader states, etc
 */
- (void) onModelRenderReady;

/**
 * Called immediately after rendering the object to perform any post-render operations.
 * This can be used for example to handle shader states, perform clean up, etc
 */
- (void) onModelRenderEnds;

/**
 * Called immediately after all objects on a scene have been rendered.
 * This can be used for example to clear up lighting before the next scene render.
 */
- (void) onSceneRenderEnds;

/**
 * Called right at the end of the render cycle.
 * This can be used to perform any remaining clean up for example.
 */
- (void) onRenderPhaseEnds;

@end
