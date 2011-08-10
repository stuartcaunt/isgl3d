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

#import "PowerVRShader.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dGLTextureFactory.h"
#import "Isgl3dGLTexture.h"
#import "Isgl3dLight.h"

#define MATERIAL_TEXTUREINDEX 0
#define NOISE_TEXTUREINDEX 1

@implementation PowerVRShader


+ (id) shaderWithKey:(NSString *)key {
	return [[[self alloc] initWithKey:key] autorelease];
}

- (id) initWithKey:(NSString *)key {
	if ((self = [super initWithVertexShaderFile:@"powervrShader.vsh" fragmentShaderFile:@"powervrShader.fsh" key:key])) {

		_fAnim = 0.0f;
		
		_materialTexture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromFile:@"red_checker.png"] retain];
		_noiseTexture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromFile:@"Noise.pvr"] retain];

		[self setUniformSamplerWithName:@"sampler2d" forTextureIndex:MATERIAL_TEXTUREINDEX];
		[self setUniformSamplerWithName:@"Noise" forTextureIndex:NOISE_TEXTUREINDEX];
		
	}
	return self;
}

- (void) dealloc {
	[_materialTexture release];
	[_noiseTexture release];


	[super dealloc];
}

- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix {
	[self setUniformMatrix4WithName:@"myMVPMatrix" matrix:modelViewProjectionMatrix];
}

- (void) setModelViewMatrix:(Isgl3dMatrix4 *)modelViewMatrix {
	[self setUniformMatrix3WithName:@"myModelViewIT" matrix:modelViewMatrix];
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	[self setVertexAttribute:GL_FLOAT attributeName:@"myVertex" size:VBO_POSITION_SIZE strideBytes:vboData.stride offset:vboData.positionOffset];
	[self setVertexAttribute:GL_FLOAT attributeName:@"myNormal" size:VBO_NORMAL_SIZE strideBytes:vboData.stride offset:vboData.normalOffset];
	[self setVertexAttribute:GL_FLOAT attributeName:@"myUV" size:VBO_UV_SIZE strideBytes:vboData.stride offset:vboData.uvOffset];
}

- (void) addLight:(Isgl3dLight *)light viewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	float lightPosition[4];
	[light copyWorldPositionToArray:lightPosition];
	im4MultArray4(viewMatrix, lightPosition);
	[self setUniform3fWithName:@"myLightDirection" values:lightPosition];
}

- (void) preRender {
	[self bindTexture:_materialTexture index:MATERIAL_TEXTUREINDEX];
	[self bindTexture:_noiseTexture index:NOISE_TEXTUREINDEX];
}

- (void) onRenderPhaseBeginsWithDeltaTime:(float)dt {
	_fAnim += dt * 0.05;
	if (_fAnim > 0.5f) {
		_fAnim = 0.0f;
	}
	[self setUniform1fWithName:@"fAnim" value:_fAnim];
}


@end
