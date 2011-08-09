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

#import "Isgl3dCaptureShader.h"
#import "Isgl3dGLProgram.h"
#import "Isgl3dGLVBOData.h"

@implementation Isgl3dCaptureShader

- (id) initWithVsPreProcHeader:(NSString *)vsPreProcHeader fsPreProcHeader:(NSString *)fsPreProcHeader {
	
	if ((self = [super initWithVertexShaderName:@"capture.vsh" fragmentShaderName:@"capture.fsh" vsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader])) {
	}
	
	return self;
}

- (void) dealloc {

	[super dealloc];
}


- (void) getAttributeAndUniformLocations {

	// Get attribute locations
	_vertexAttributeLocation = [_glProgram getAttributeLocation:@"a_vertex"];

	// Get uniform locations	
    _colorUniformLocation = [_glProgram getUniformLocation:@"u_color"];
    _mvpMatrixUniformLocation = [_glProgram getUniformLocation:@"u_mvpMatrix"];

	// Skinning
	_boneIndexAttributeLocation = [_glProgram getAttributeLocation:@"a_boneIndex"];
	_boneWeightsAttributeLocation = [_glProgram getAttributeLocation:@"a_boneWeights"];
	_boneCountUniformLocation = [_glProgram getUniformLocation:@"u_boneCount"];
	_boneMatrixArrayUniformLocation = [_glProgram getUniformLocation:@"u_boneMatrixArray[0]"];
}

- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix {
	[self setUniformMatrix4:_mvpMatrixUniformLocation matrix:modelViewProjectionMatrix];
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	[self setVertexAttribute:GL_FLOAT attributeLocation:_vertexAttributeLocation size:VBO_POSITION_SIZE strideBytes:vboData.stride offset:vboData.positionOffset];
	if (vboData.boneIndexOffset != -1) {
		[self setVertexAttribute:GL_UNSIGNED_BYTE attributeLocation:_boneIndexAttributeLocation size:vboData.boneIndexSize strideBytes:vboData.stride offset:vboData.boneIndexOffset];
		[self setVertexAttribute:GL_FLOAT attributeLocation:_boneWeightsAttributeLocation size:vboData.boneWeightSize strideBytes:vboData.stride offset:vboData.boneWeightOffset];
	}
}

- (void) setCaptureColor:(float *)color {
	[self setUniform4f:_colorUniformLocation values:color];
}

- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations {
	[self setUniformMatrix4:_boneMatrixArrayUniformLocation matrix:transformations size:8];
}

- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex {
	[self setUniform1i:_boneCountUniformLocation value:numberOfBonesPerVertex];
}

- (void) render:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset {
	// render elements
	glDrawElements(GL_TRIANGLES, numberOfElements, GL_UNSIGNED_SHORT, &((unsigned short*)0)[elementOffset]);
}


@end
