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

#import <OpenGLES/ES2/gl.h>
#import <Foundation/Foundation.h>

/**
 * The Isgl3dGLProgram encapsulates an OpenGL ES2 glProgram. It contains OpenGL references to both vertex and fragment shaders as well as the associated program.
 * 
 * All shaders (Isgl3dShader) in iSGL3D contain an Isgl3dGLProgram and most of the functionality is internal. The Isgl3dShader contains an API to access specific
 * glProgram functionality although this is not often needed.
 * 
 * Note: This class is mainly intended for internal use by iSGL3D.
 */
@interface Isgl3dGLProgram : NSObject {
	
@private
	GLuint _program;
	GLuint _vertexShader;
	GLuint _fragmentShader;
}

/**
 * Returns the OpenGL glProgram object.
 */
- (GLuint)glProgram;

/**
 * Loads a shader from a file for a particular type (vertex or fragment) with optional pre-processor directives.
 * @param shaderType The type of shader. Can take values of GL_VERTEX_SHADER or GL_FRAGMENT_SHADER
 * @param file The file containing the shader source
 * @param preProcessorHeader The pre-processor directives
 * @return True if the shader was correctly loaded and compiled
 */
- (BOOL)loadShaderFile:(GLenum)shaderType file:(NSString *)file withPreProcessorHeader:(NSString *)preProcessorHeader;

/**
 * Loads a shader from NSString source for a particular type (vertex or fragment) with optional pre-processor directives.
 * @param shaderType The type of shader. Can take values of GL_VERTEX_SHADER or GL_FRAGMENT_SHADER
 * @param shaderSource String containing the shader source
 * @param preProcessorHeader The pre-processor directives
 * @return True if the shader was correctly loaded and compiled
 */
- (BOOL)loadShaderSource:(GLenum)shaderType shaderSource:(NSString *)shaderSource withPreProcessorHeader:(NSString *)preProcessorHeader;

/**
 * Links both vertex and frament shaders. Both vertex and fragment shaders must have already been loaded.
 * @return True if the program was correctly linked.
 */
- (BOOL)linkProgram;


/**
 * Validates the program to ensure that can function correctly.
 * Note that this has a preformance cost and should only be called during debugging.
 * @return True if the program was correctly validated.
 */
- (BOOL)validateProgram;

/**
 * Returns the OpenGL attribute location for a particular attribute name.
 * @param attributeName The attribute name
 * @return The attribute location
 */
- (GLint)getAttributeLocation:(NSString*)attributeName;

/**
 * Returns the OpenGL uniform location for a particular uniform name.
 * @param uniformName The uniform name
 * @return The uniform location
 */
- (GLint)getUniformLocation:(NSString*)uniformName;

/**
 * Binds a particular attribute name to a user-defined attribute location
 * @param attributeName The attribute name
 * @param location The attribute location
 */
- (void)bindAttributeLocation:(NSString*)attributeName location:(GLint)location;

@end
