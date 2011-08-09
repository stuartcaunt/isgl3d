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

#import "DemoShader.h"
#import "Isgl3dGLProgram.h"
#import "Isgl3dGLVBOData.h"


@implementation DemoShader


+ (id) shaderWithKey:(NSString *)key {
	return [[[self alloc] initWithKey:key] autorelease];
}

- (id) initWithKey:(NSString *)key {
	if ((self = [super initWithVertexShaderFile:@"demoShader.vsh" fragmentShaderFile:@"demoShader.fsh" key:key])) {
		//[self setUniform1f:@"u_minHeight" value:-1.0f];
		//[self setUniform1f:@"u_maxHeight" value:1.0f];
	    [self setUniform1f:_minHeightUniformLocation value:-1.0f];
	    [self setUniform1f:_maxHeightUniformLocation value:1.0f];
	}
	return self;
}

- (void) dealloc {

	[super dealloc];
}


- (void) getAttributeAndUniformLocations {
	_vertexAttributeLocation = [_glProgram getAttributeLocation:@"a_vertex"];
    _mvpMatrixUniformLocation = [_glProgram getUniformLocation:@"u_mvpMatrix"];
    _minHeightUniformLocation = [_glProgram getUniformLocation:@"u_minHeight"];
    _maxHeightUniformLocation = [_glProgram getUniformLocation:@"u_maxHeight"];
}

- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix {
	[self setUniformMatrix4:_mvpMatrixUniformLocation matrix:modelViewProjectionMatrix];
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	[self setVertexAttribute:GL_FLOAT attributeLocation:_vertexAttributeLocation size:VBO_POSITION_SIZE strideBytes:vboData.stride offset:vboData.positionOffset];
}

@end
