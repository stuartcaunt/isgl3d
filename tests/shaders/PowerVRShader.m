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
		
		// Create textures
		_materialTexture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromFile:@"red_checker.png"] retain];
		_noiseTexture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromFile:@"Noise.pvr"] retain];

		// Set the texture units to use
		[self setUniformSamplerWithName:@"sampler2d" forTextureUnit:MATERIAL_TEXTUREINDEX];
		[self setUniformSamplerWithName:@"Noise" forTextureUnit:NOISE_TEXTUREINDEX];
	}
	return self;
}

- (void) dealloc {
	[_materialTexture release];
	[_noiseTexture release];

	[super dealloc];
}

- (void) onRenderPhaseBeginsWithDeltaTime:(float)dt {
	// Update the animation factor with a new render phase
	_fAnim += dt * 0.05;
	if (_fAnim > 0.5f) {
		_fAnim = 0.0f;
	}
	[self setUniform1fWithName:@"fAnim" value:_fAnim];
}

- (void) onSceneRenderReady {
	// Update lighting (use only first light)
	if ([_lights count] > 0) {
		Isgl3dLight * light = [self.lights objectAtIndex:0]; 

		float lightPosition[4];
		[light copyWorldPositionToArray:lightPosition];
		im4MultArray4(self.viewMatrix, lightPosition);
		[self setUniform3fWithName:@"myLightDirection" values:lightPosition];
	}
}

- (void) onModelRenderReady {
	
	// bind the vertex data to the attributes
	[self setVertexAttribute:GL_FLOAT attributeName:@"myVertex" size:VBO_POSITION_SIZE strideBytes:self.vboData.stride offset:self.vboData.positionOffset];
	[self setVertexAttribute:GL_FLOAT attributeName:@"myNormal" size:VBO_NORMAL_SIZE strideBytes:self.vboData.stride offset:self.vboData.normalOffset];
	[self setVertexAttribute:GL_FLOAT attributeName:@"myUV" size:VBO_UV_SIZE strideBytes:self.vboData.stride offset:self.vboData.uvOffset];

	// Set the mvp matrix
	[self setUniformMatrix4WithName:@"myMVPMatrix" matrix:self.modelViewProjectionMatrix];

	// Set the modelview matrix
	[self setUniformMatrix3WithName:@"myModelViewIT" matrix:self.modelViewMatrix];
	
	// Bind the textures to the texture unit	
	[self bindTexture:_materialTexture textureUnit:MATERIAL_TEXTUREINDEX];
	[self bindTexture:_noiseTexture textureUnit:NOISE_TEXTUREINDEX];
}


@end
