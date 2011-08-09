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

#import "Isgl3dGLProgram.h"
#import "Isgl3dLog.h"

@implementation Isgl3dGLProgram

- (id) init {    

    if ((self = [super init])) {
    	_program = glCreateProgram();
		if (!_program) {
			Isgl3dLog(Error, @"Could not create gl program");
            [self release];
            return nil;
		}
		
    }
    return self;
}

- (void) dealloc {
	if (_program) {
		glDeleteProgram(_program);
		_program = 0;
	}
   	if (_vertexShader) {
    	glDeleteShader(_vertexShader);
    	_vertexShader = 0;
	}
	if (_fragmentShader) {
    	glDeleteShader(_fragmentShader);
    	_fragmentShader = 0;
	}
 	
    [super dealloc];
}

- (GLuint)glProgram {
	return _program;
}

- (BOOL)loadShaderFile:(GLenum)shaderType file:(NSString *)file withPreProcessorHeader:(NSString *)preProcessorHeader {
	
	// Get the contents of the file
	NSString * shaderSource = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];

	if (!shaderSource) {
		Isgl3dLog(Error, @"Failed to load shader file %s", file);
		return FALSE;
	}

	return [self loadShaderSource:shaderType shaderSource:shaderSource withPreProcessorHeader:preProcessorHeader];

}
	
- (BOOL)loadShaderSource:(GLenum)shaderType shaderSource:(NSString *)shaderSource withPreProcessorHeader:(NSString *)preProcessorHeader {
	GLint status;

	// Add pre-processor header if necessary
	NSString * fullShaderSource;
	if (preProcessorHeader != nil) {
		fullShaderSource = [preProcessorHeader stringByAppendingString:shaderSource];
	} else {
		fullShaderSource = shaderSource;
	}
	
	const GLchar * source = (GLchar *)[fullShaderSource UTF8String];
	
	// Create a shader
    GLuint shader = glCreateShader(shaderType);
	if (!shader) {
		Isgl3dLog(Error, @"Unable to create %s shader", ((shaderType == GL_VERTEX_SHADER) ? "vertex" : "fragment"));	   
		return FALSE;
	}
    
    // load the shader source 
    glShaderSource(shader, 1, &source, NULL);
    
    // compiler the shader
    glCompileShader(shader);
	
	// Check that the compilation worked
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
		// Something went wrong during compilation; get the error
		GLint logLength;
	    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
	    if (logLength > 0) {
	        GLchar *error = (GLchar *)malloc(logLength);
	        glGetShaderInfoLog(shader, logLength, &logLength, error);
	        Isgl3dLog(Info, @"Error compiling %s shader:\n%s", ((shaderType == GL_VERTEX_SHADER) ? "vertex" : "fragment"), error);
	        free(error);
	    }

		glDeleteShader(shader);
		return FALSE;
	}
	
	if (shaderType == GL_VERTEX_SHADER) {
		_vertexShader = shader;
	} else {
		_fragmentShader = shader;
	}
	
	glAttachShader(_program, shader);
	return TRUE;
}

- (BOOL)linkProgram {
	GLint status;
	
	// Link the program
	glLinkProgram(_program);
	
	// Check for errors
    glGetProgramiv(_program, GL_LINK_STATUS, &status);
    if (status == 0) {
    	// Error occurred: get error log
		GLint logLength;
	    glGetProgramiv(_program, GL_INFO_LOG_LENGTH, &logLength);
	    
	    if (logLength > 0) {
	        GLchar *error = (GLchar *)malloc(logLength);
	        glGetProgramInfoLog(_program, logLength, &logLength, error);
	        Isgl3dLog(Error, @"Error in program linking:\n%s", error);
	        free(error);
	    }
    	
    	// clean up
    	glDeleteProgram(_program);
		_program = 0;
    	if (_vertexShader) {
	    	glDeleteShader(_vertexShader);
	    	_vertexShader = 0;
    	}
    	if (_fragmentShader) {
	    	glDeleteShader(_fragmentShader);
	    	_fragmentShader = 0;
    	}
    	return FALSE;
    }
	return TRUE;
}

- (BOOL)validateProgram {
    glValidateProgram(_program);
    
    GLint logLength;
    glGetProgramiv(_program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *error = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(_program, logLength, &logLength, error);
        Isgl3dLog(Error, @"Error in program validation:\n%s", error);
        free(error);

    	// clean up
    	glDeleteProgram(_program);
		_program = 0;
    	if (_vertexShader) {
	    	glDeleteShader(_vertexShader);
	    	_vertexShader = 0;
    	}
    	if (_fragmentShader) {
	    	glDeleteShader(_fragmentShader);
	    	_fragmentShader = 0;
    	}
    	return FALSE;
    }
    
    return TRUE;
}

- (GLint)getAttributeLocation:(NSString*)attributeName {
	return glGetAttribLocation(_program, [attributeName UTF8String]);
}

- (GLint)getUniformLocation:(NSString*)uniformName {
    return glGetUniformLocation(_program, [uniformName UTF8String]);
}

- (void)bindAttributeLocation:(NSString*)attributeName location:(GLint)location {
	glBindAttribLocation(_program, location, [attributeName UTF8String]);
}

@end
