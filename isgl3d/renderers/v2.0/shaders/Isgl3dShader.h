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
@class Isgl3dGLTexture;


/**
 * The Isgl3dShader encapsulates an OpenGL ES2 shader program (containing vertex and fragment shaders).
 * 
 * It provides an API to simplify accessing attributes and uniforms in the shaders as well as binding buffers and textures.
 * 
 * During the rendering cycle different methods are automatically called internally by iSGL3D to set the model matrices, add
 * lights, specify bone transformations, etc.
 * 
 * The sub-class, Isgl3dCustomShader, is provided as a class to be extended for user-defined shaders. The sub-class, Isgl3dInternalShader,
 * is used internally by iSGL3D and is not intended to be extended for user purposes.
 */
@interface Isgl3dShader : NSObject {

@protected
	Isgl3dGLProgram * _glProgram;
	
	NSMutableDictionary * _attributeNameIndices;
	NSMutableDictionary * _uniformNameIndices;
}

/**
 * Initialises the shader with vertex and fragment shader files and optional preprocessor directives for both of these.
 * @param vertexShaderName The filename of the vertex shader
 * @param fragmentShaderName The filename of the fragment shader
 * @param vsPreProcHeader The vertex shader pre-processor directives (can be nil).
 * @param fsPreProcHeader The fragment shader pre-processor directives (can be nil).
 */
- (id) initWithVertexShaderName:(NSString *)vertexShaderName fragmentShaderName:(NSString *)fragmentShaderName vsPreProcHeader:(NSString *)vsPreProcHeader fsPreProcHeader:(NSString *)fsPreProcHeader;

#pragma mark opengl related operations

/**
 * Sets the shader, and its associated glProgram, active. Only one shader is active at a time.
 */
- (void) setActive;

/**
 * Binds a vertex buffer in OpenGL, typically from an Isgl3dGLVBOData object.
 * @param bufferIndex The index of the buffer to be bound. 
 */
- (void) bindVertexBuffer:(GLuint)bufferIndex;

/**
 * Sets an attribute in the shader by its attribute location to the bound vertex buffer with a given data type, siwe, stride and offset.
 * @param type The data type to be set to the attribute.
 * @param attributeLocation The location of the attribute.
 * @param size The number of elements to be set.
 * @param strideBytes The stride of the data structure in the buffer in bytes.
 * @param offset The offset in the VBO object in bytes to the desired data
 */
- (void) setVertexAttribute:(GLenum)type attributeLocation:(GLuint)attributeLocation size:(GLint)size strideBytes:(GLsizei)strideBytes offset:(unsigned int)offset;

/**
 * Sets an attribute in the shader by its name to the bound vertex buffer with a given data type, siwe, stride and offset.
 * @param type The data type to be set to the attribute.
 * @param attributeName The name of the attribute.
 * @param size The number of elements to be set.
 * @param strideBytes The stride of the data structure in the buffer in bytes.
 * @param offset The offset in the VBO object in bytes to the desired data
 */
- (void) setVertexAttribute:(GLenum)type attributeName:(NSString *)attributeName size:(GLint)size strideBytes:(GLsizei)strideBytes offset:(unsigned int)offset;

/**
 * Copies data from an Isgl3dMatrix4 matrix to a 3x3 matrix uniform in the shader.
 * @param uniformLocation The location of the 3x3 matrix uniform
 * @param matrix The matrix to be copied to the shader
 */
- (void) setUniformMatrix3:(GLint)uniformLocation matrix:(Isgl3dMatrix4 *)matrix;

/**
 * Copies data from an Isgl3dMatrix4 matrix to a 4x4 matrix uniform in the shader.
 * @param uniformLocation The location of the 4x4 matrix uniform
 * @param matrix The matrix to be copied to the shader
 */
- (void) setUniformMatrix4:(GLint)uniformLocation matrix:(Isgl3dMatrix4 *)matrix;

/**
 * Copies data from a number of Isgl3dMatrix4 matrices to a 3x3 matrix uniform array in the shader.
 * @param uniformLocation The location of the 3x3 matrix array uniform
 * @param matrices An array of Isgl3dMatrix4x4 matrices to be copied to the shader
 * @param size The number of arrays to be copied
 */
- (void) setUniformMatrix3:(GLint)uniformLocation matrix:(Isgl3dArray *)matrices size:(unsigned int)size;

/**
 * Copies data from a number of Isgl3dMatrix4 matrices to a 4x4 matrix uniform array in the shader.
 * @param uniformLocation The location of the 4x4 matrix array uniform
 * @param matrices An array of Isgl3dMatrix4x4 matrices to be copied to the shader
 * @param size The number of arrays to be copied
 */
- (void) setUniformMatrix4:(GLint)uniformLocation matrix:(Isgl3dArray *)matrices size:(unsigned int)size;

/**
 * Sets a float value to a float uniform in the shader
 * @param uniformLocation The location of the float uniform
 * @param value The value to be set in the shader.
 */
- (void) setUniform1f:(GLint)uniformLocation value:(GLfloat)value;

/**
 * Sets an array of 2 float values to a float vector uniform in the shader
 * @param uniformLocation The location of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform2f:(GLint)uniformLocation values:(GLfloat *)values;

/**
 * Sets an array of 3 float values to a float vector uniform in the shader
 * @param uniformLocation The location of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform3f:(GLint)uniformLocation values:(GLfloat *)values;

/**
 * Sets an array of 4 float values to a float vector uniform in the shader
 * @param uniformLocation The location of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform4f:(GLint)uniformLocation values:(GLfloat *)values;

/**
 * Sets an integer value to a integer uniform in the shader
 * @param uniformLocation The location of the integer uniform
 * @param value The value to be set in the shader.
 */
- (void) setUniform1i:(GLint)uniformLocation value:(GLint)value;

/**
 * Sets an array of 2 integer values to an integer vector uniform in the shader
 * @param uniformLocation The location of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform2i:(GLint)uniformLocation values:(GLint *)values;

/**
 * Sets an array of 3 integer values to an integer vector uniform in the shader
 * @param uniformLocation The location of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform3i:(GLint)uniformLocation values:(GLint *)values;

/**
 * Sets an array of 4 integer values to an integer vector uniform in the shader
 * @param uniformLocation The location of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform4i:(GLint)uniformLocation values:(GLint *)values;

/**
 * Sets an array of 2 float values to a float vector uniform in the shader
 * @param uniformLocation The location of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform2fv:(GLint)uniformLocation values:(GLfloat *)values;

/**
 * Sets an array of 3 float values to a float vector uniform in the shader
 * @param uniformLocation The location of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform3fv:(GLint)uniformLocation values:(GLfloat *)values;

/**
 * Sets an array of 4 float values to a float vector uniform in the shader
 * @param uniformLocation The location of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform4fv:(GLint)uniformLocation values:(GLfloat *)values;

/**
 * Sets an array of 2 integer values to an integer vector uniform in the shader
 * @param uniformLocation The location of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform2iv:(GLint)uniformLocation values:(GLint *)values;

/**
 * Sets an array of 3 integer values to an integer vector uniform in the shader
 * @param uniformLocation The location of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform3iv:(GLint)uniformLocation values:(GLint *)values;

/**
 * Sets an array of 4 integer values to an integer vector uniform in the shader
 * @param uniformLocation The location of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform4iv:(GLint)uniformLocation values:(GLint *)values;

/**
 * Associates a texture unit index to a uniform sampler location.
 * @param samplerLocation The location of the sampler
 * @param textureUnit The index of the texture unit, specified with <em>bindTexture</em> (between 0 and 31)
 */
- (void) setUniformSampler:(GLint)samplerLocation forTextureUnit:(GLuint)textureUnit;

/**
 * Copies data from an Isgl3dMatrix4 matrix to a 3x3 matrix uniform in the shader.
 * @param uniformName The name of the 3x3 matrix uniform
 * @param matrix The matrix to be copied to the shader
 */
- (void) setUniformMatrix3WithName:(NSString *)uniformName matrix:(Isgl3dMatrix4 *)matrix;

/**
 * Copies data from an Isgl3dMatrix4 matrix to a 4x4 matrix uniform in the shader.
 * @param uniformName The name of the 4x4 matrix uniform
 * @param matrix The matrix to be copied to the shader
 */
- (void) setUniformMatrix4WithName:(NSString *)uniformName matrix:(Isgl3dMatrix4 *)matrix;

/**
 * Copies data from a number of Isgl3dMatrix4 matrices to a 3x3 matrix uniform array in the shader.
 * @param uniformName The name of the 3x3 matrix array uniform
 * @param matrices An array of Isgl3dMatrix4x4 matrices to be copied to the shader
 * @param size The number of arrays to be copied
 */
- (void) setUniformMatrix3WithName:(NSString *)uniformName matrix:(Isgl3dArray *)matrices size:(unsigned int)size;

/**
 * Copies data from a number of Isgl3dMatrix4 matrices to a 4x4 matrix uniform array in the shader.
 * @param uniformName The name of the 4x4 matrix array uniform
 * @param matrices An array of Isgl3dMatrix4x4 matrices to be copied to the shader
 * @param size The number of arrays to be copied
 */
- (void) setUniformMatrix4WithName:(NSString *)uniformName matrix:(Isgl3dArray *)matrices size:(unsigned int)size;

/**
 * Sets a float value to a float uniform in the shader
 * @param uniformName The name of the float uniform
 * @param value The value to be set in the shader.
 */
- (void) setUniform1fWithName:(NSString *)uniformName value:(GLfloat)value;

/**
 * Sets an array of 2 float values to a float vector uniform in the shader
 * @param uniformName The name of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform2fWithName:(NSString *)uniformName values:(GLfloat *)values;

/**
 * Sets an array of 3 float values to a float vector uniform in the shader
 * @param uniformName The name of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform3fWithName:(NSString *)uniformName values:(GLfloat *)values;

/**
 * Sets an array of 4 float values to a float vector uniform in the shader
 * @param uniformName The name of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform4fWithName:(NSString *)uniformName values:(GLfloat *)values;

/**
 * Sets an integer value to a integer uniform in the shader
 * @param uniformName The name of the integer uniform
 * @param value The value to be set in the shader.
 */
- (void) setUniform1iWithName:(NSString *)uniformName value:(GLint)value;

/**
 * Sets an array of 2 integer values to an integer vector uniform in the shader
 * @param uniformName The name of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform2iWithName:(NSString *)uniformName values:(GLint *)values;

/**
 * Sets an array of 3 integer values to an integer vector uniform in the shader
 * @param uniformName The name of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform3iWithName:(NSString *)uniformName values:(GLint *)values;

/**
 * Sets an array of 4 integer values to an integer vector uniform in the shader
 * @param uniformName The name of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform4iWithName:(NSString *)uniformName values:(GLint *)values;

/**
 * Sets an array of 2 float values to a float vector uniform in the shader
 * @param uniformName The name of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform2fvWithName:(NSString *)uniformName values:(GLfloat *)values;

/**
 * Sets an array of 3 float values to a float vector uniform in the shader
 * @param uniformName The name of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform3fvWithName:(NSString *)uniformName values:(GLfloat *)values;

/**
 * Sets an array of 4 float values to a float vector uniform in the shader
 * @param uniformName The name of the float vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform4fvWithName:(NSString *)uniformName values:(GLfloat *)values;

/**
 * Sets an array of 2 integer values to an integer vector uniform in the shader
 * @param uniformName The name of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform2ivWithName:(NSString *)uniformName values:(GLint *)values;

/**
 * Sets an array of 3 integer values to an integer vector uniform in the shader
 * @param uniformName The name of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform3ivWithName:(NSString *)uniformName values:(GLint *)values;

/**
 * Sets an array of 4 integer values to an integer vector uniform in the shader
 * @param uniformName The name of the integer vector uniform
 * @param values The values to be set in the shader.
 */
- (void) setUniform4ivWithName:(NSString *)uniformName values:(GLint *)values;

/**
 * Associates a texture unit index to a uniform sampler location.
 * @param samplerName The name of the sampler
 * @param textureUnit The index of the texture unit, specified with <em>bindTexture</em> (between 0 and 31)
 */
- (void) setUniformSamplerWithName:(NSString *)samplerName forTextureUnit:(GLuint)textureUnit;

/**
 * Binds an Isgl3dGLTexture texture to a particular texture unit in the shader. A shader can have up to 
 * 32 different textures associated to different texture units. See also <em>setUniformSampler</em> and
 * <em>setUniformSamplerWithName</em> on how to link these texture units to samplers.
 * @param texture The texture to be associated with a texture unit.
 * @param textureUnit The index of the texture unit (between 0 and 31)
 */
- (void) bindTexture:(Isgl3dGLTexture *)texture textureUnit:(GLuint)textureUnit;

/**
 * Used by the different sub-classed shaders to render the currently active vertex buffer data with shader.
 * @param numberOfElements the number of elements to be rendered
 * @param elementOffset The offset in the elements array to start rendering
 */
- (void) render:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset;

#pragma mark isgl3d internal calls (can be over-ridden for custom shaders)

/**
 * Called at the beginning of the render cycle for an Isgl3dView after the buffers have been initialised. All shader-specific operations needed 
 * to initialise the shader for a view should be performed here (for example remove all lighting that was added for the previous view). 
 */
- (void) clean;

/**
 * Passes the model transformation of the object to be rendered. 
 * Called before rendering a specific object using the shader.
 * @param modelMatrix The model transformation
 */
- (void) setModelMatrix:(Isgl3dMatrix4 *)modelMatrix;

/**
 * Passes the view transformation for the active camera rendering the scene
 * Called before rendering a specific object using the shader.
 * @param viewMatrix The view transformation
 */
- (void) setViewMatrix:(Isgl3dMatrix4 *)viewMatrix;

/**
 * Passes the projection matrix (perspective or ortho) used by the active camera.
 * Called before rendering a specific object using the shader.
 * @param projectionMatrix The projection matrix
 */
- (void) setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix;

/**
 * Passes the combined model-view transformation of the object to be rendered with the active camera.
 * Called before rendering a specific object using the shader.
 * @param modelViewMatrix The model-view transformation
 */
- (void) setModelViewMatrix:(Isgl3dMatrix4 *)modelViewMatrix;

/**
 * Passes the combined model-view-projection transformation of the object to be rendered with the active camera.
 * Called before rendering a specific object using the shader.
 * @param modelViewProjectionMatrix The model-view-projection transformation
 */
- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix;

/**
 * Passes the VBO data (an Isgl3dVBOData object) to the shader for the object to be rendered.
 * This allows for calls to <em>setVertexAttribute:attributeLocation:size:strideBytes:offset:</em> be made to associate elements of the VBO
 * data with the shader.
 * Called before rendering a specific object using the shader.
 * @param vboData The VBO of the object to be rendered.
 */
- (void) setVBOData:(Isgl3dGLVBOData *)vboData;

/**
 * Adds a light to the shader if any are required along with the view matrix to transform the light world position correctly.
 * Called during the scene intialisation in the render phase before rendering all objects.
 * @param light The light to be added to the scene
 * @param viewMatrix The view transformation 
 */
- (void) addLight:(Isgl3dLight *)light viewMatrix:(Isgl3dMatrix4 *)viewMatrix;

/**
 * Sets the scene ambient color (as a hex value)
 * Called during the scene intialisation in the render phase before rendering all objects.
 * @param ambient The ambient color of the scene.
 */
- (void) setSceneAmbient:(NSString *)ambient;

/**
 * Specifies the alpha culling value for the next object to be rendered.
 * Called before rendering a specific object using the shader.
 * @param cullValue The alpha value below which pixels should be culled.
 */
- (void) setAlphaCullingValue:(float)cullValue;

/**
 * Sets the point attenuation for particles as three float value (constant, linear and quadratic attenuation values).
 * Called before rendering a specific object using the shader.
 * @param attenuation Three value float array of attenuation values.
 */
- (void) setPointAttenuation:(float *)attenuation;

/**
 * Sets and array of 8 bone transformations  and inverse transformations used for vertex skinning.
 * Called before rendering a specific object using the shader.
 * @param transformations An array of 8 bone transformations
 * @param inverseTransformations An array of 8 bone inverse transformations
 */
- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations;

/**
 * Sets the number of bones per vertex.
 * Called before rendering a specific object using the shader.
 * @param numberOfBonesPerVertex The number of bones per vertex
 */
- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex;

#pragma mark methods intended to be over-ridden

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


@end
