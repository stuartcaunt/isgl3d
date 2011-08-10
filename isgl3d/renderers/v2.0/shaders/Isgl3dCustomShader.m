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

#import "Isgl3dCustomShader.h"
#import "Isgl3dLog.h"


@implementation Isgl3dCustomShader

@synthesize key = _key;
@synthesize shaderType = _shaderType;
@synthesize activeNode = _activeNode;

+ (id) shaderWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			key:(NSString *)key {
				
	return [[[self alloc] initWithVertexShaderFile:vertexShaderFile
							fragmentShaderFile:fragmentShaderFile 
							key:key] autorelease];
				
}

+ (id) shaderWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			vertexShaderPreProcessorHeader:(NSString *)vertexShaderPreProcessorHeader 
			fragmentShaderPreProcessorHeader:(NSString *)fragmentShaderPreProcessorHeader 
			key:(NSString *)key {
				
	return [[[self alloc] initWithVertexShaderFile:vertexShaderFile
							fragmentShaderFile:fragmentShaderFile 
							vertexShaderPreProcessorHeader:vertexShaderPreProcessorHeader 
							fragmentShaderPreProcessorHeader:fragmentShaderPreProcessorHeader 
							key:key] autorelease];
				
}

- (id) initWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			key:(NSString *)key {
				
	return [self initWithVertexShaderFile:vertexShaderFile 
							fragmentShaderFile:fragmentShaderFile 
							vertexShaderPreProcessorHeader:nil 
							fragmentShaderPreProcessorHeader:nil
							key:key];
}

- (id) initWithVertexShaderFile:(NSString *)vertexShaderFile 
			fragmentShaderFile:(NSString *)fragmentShaderFile 
			vertexShaderPreProcessorHeader:(NSString *)vertexShaderPreProcessorHeader 
			fragmentShaderPreProcessorHeader:(NSString *)fragmentShaderPreProcessorHeader 
			key:(NSString *)key {
				
	if ((self = [super initWithVertexShaderName:vertexShaderFile 
							fragmentShaderName:fragmentShaderFile 
							vsPreProcHeader:vertexShaderPreProcessorHeader 
							fsPreProcHeader:fragmentShaderPreProcessorHeader])) {
		
		_shaderType = Isgl3dCustomShaderTrianglesType;
		_key = key;

        Isgl3dLog(Info, @"Created custom shader for key %@", key);

	}
	return self;
}


- (void) dealloc {

	[super dealloc];
}


- (void) clean {
	// to be over-ridden if needed
}

- (void) setModelMatrix:(Isgl3dMatrix4 *)modelMatrix {
	// to be over-ridden if needed
}

- (void) setViewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	// to be over-ridden if needed
}

- (void) setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix {
	// to be over-ridden if needed
}

- (void) setModelViewMatrix:(Isgl3dMatrix4 *)modelViewMatrix {
	// to be over-ridden if needed
}

- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix {
	// to be over-ridden if needed
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	// to be over-ridden if needed
}

- (void) addLight:(Isgl3dLight *)light viewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	// to be over-ridden if needed
}

- (void) setSceneAmbient:(NSString *)ambient {
	// to be over-ridden if needed
}

- (void) setAlphaCullingValue:(float)cullValue {
	// to be over-ridden if needed
}

- (void) setPointAttenuation:(float *)attenuation {
	// to be over-ridden if needed
}

- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations {
	// to be over-ridden if needed
}

- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex {
	// to be over-ridden if needed
}

- (void) preRender {
	// to be over-ridden if needed
}

- (void) postRender {
	// to be over-ridden if needed
}

- (void) render:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset {
	if (_shaderType == Isgl3dCustomShaderTrianglesType) {
		glDrawElements(GL_TRIANGLES, numberOfElements, GL_UNSIGNED_SHORT, &((unsigned short *)0)[elementOffset]);
	} else {
		glDrawElements(GL_POINTS, numberOfElements, GL_UNSIGNED_SHORT, &((unsigned short*)0)[elementOffset]);
	}
}

- (void) onRenderPhaseBeginsWithDeltaTime:(float)dt {
	// to be over-ridden if needed
}


@end
