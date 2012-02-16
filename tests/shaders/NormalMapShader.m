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

#import "NormalMapShader.h"
#import "Isgl3dGLVBOData.h"

#define MATERIAL_TEXTUREINDEX 0
#define NORMAL_TEXTUREINDEX 1

@implementation NormalMapShader


+ (id) shaderWithKey:(NSString *)key {
	return [[[self alloc] initWithKey:key] autorelease];
}

- (id) initWithKey:(NSString *)key {
	if ((self = [super initWithVertexShaderFile:@"NormalMapShader.vsh" fragmentShaderFile:@"NormalMapShader.fsh" key:key])) {
		[self setUniformSamplerWithName:@"colourMap" forTextureUnit:MATERIAL_TEXTUREINDEX];
		[self setUniformSamplerWithName:@"normalMap" forTextureUnit:NORMAL_TEXTUREINDEX];
	}
	return self;
}

- (void) SetTextures:(NSString*)colorMap NormalMapTexture:(NSString*)normalMap {
    _materialTexture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromFile:colorMap] retain];
    _normalTexture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromFile:normalMap] retain];
}

- (void) dealloc {
	[super dealloc];
}

- (void) onSceneRenderReady {
	// Update lighting (use only first light)
	if ([_lights count] > 0) {
		Isgl3dLight * light = [self.lights objectAtIndex:0]; 
        
		float lightPosition[4];
		[light copyWorldPositionToArray:lightPosition];
		[self setUniform3fWithName:@"vLightPosition" values:lightPosition];
        
        float lightcolor[4] = {0.1f, 0.1f, 0.1f, 1.0f};
		[self setUniform4fWithName:@"ambientColour" values:lightcolor];
        float lightcolor2[4] = {1.0f, 1.0f, 1.0f, 1.0f};
		[self setUniform4fWithName:@"diffuseColour" values:lightcolor2];
		[self setUniform4fWithName:@"specularColour" values:lightcolor2];
	}
}

- (void) onModelRenderReady {
	[self setVertexAttribute:GL_FLOAT attributeName:@"vVertex" size:VBO_POSITION_SIZE strideBytes:self.vboData.stride offset:self.vboData.positionOffset];
	[self setVertexAttribute:GL_FLOAT attributeName:@"vNormal" size:VBO_NORMAL_SIZE strideBytes:self.vboData.stride offset:self.vboData.normalOffset];
	[self setVertexAttribute:GL_FLOAT attributeName:@"vTexture" size:VBO_UV_SIZE strideBytes:self.vboData.stride offset:self.vboData.uvOffset];

	// Set the mvp matrix
	[self setUniformMatrix4WithName:@"mvpMatrix" matrix:self.modelViewProjectionMatrix];
	[self setUniformMatrix4WithName:@"mvMatrix" matrix:self.modelViewMatrix];
	[self setUniformMatrix3WithName:@"normalMatrix" matrix:self.modelViewMatrix];
	
	[self bindTexture:_materialTexture textureUnit:MATERIAL_TEXTUREINDEX];
	[self bindTexture:_normalTexture textureUnit:NORMAL_TEXTUREINDEX];
}

@end
