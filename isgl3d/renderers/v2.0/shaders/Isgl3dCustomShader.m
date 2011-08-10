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
@synthesize modelMatrix = _modelMatrix;
@synthesize viewMatrix = _viewMatrix;
@synthesize projectionMatrix = _projectionMatrix;
@synthesize modelViewMatrix = _modelViewMatrix;
@synthesize modelViewProjectionMatrix = _modelViewProjectionMatrix;
@synthesize vboData = _vboData;
@synthesize lights = _lights;
@synthesize sceneAmbient = _sceneAmbient;
@synthesize alphaCullingValue = _alphaCullingValue;
@synthesize pointAttenuation = _pointAttenuation;
@synthesize boneTransformations = _boneTransformations;
@synthesize boneInverseTransformations = _boneInverseTransformations;
@synthesize numberOfBonesPerVertex = _numberOfBonesPerVertex;
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

		_lights = [[NSMutableArray alloc] init];

        Isgl3dLog(Info, @"Created custom shader for key %@", key);

	}
	return self;
}


- (void) dealloc {
	[_lights release];

	[super dealloc];
}


- (void) clean {
	[_lights removeAllObjects];
}

- (void) setModelMatrix:(Isgl3dMatrix4 *)modelMatrix {
	_modelMatrix = modelMatrix;
}

- (void) setViewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	_viewMatrix = viewMatrix;
}

- (void) setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix {
	_projectionMatrix = projectionMatrix;
}

- (void) setModelViewMatrix:(Isgl3dMatrix4 *)modelViewMatrix {
	_modelViewMatrix = modelViewMatrix;
}

- (void) setModelViewProjectionMatrix:(Isgl3dMatrix4 *)modelViewProjectionMatrix {
	_modelViewProjectionMatrix = modelViewProjectionMatrix;
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	_vboData = vboData;
}

- (void) addLight:(Isgl3dLight *)light viewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	[_lights addObject:light];
}

- (void) setSceneAmbient:(NSString *)ambient {
	_sceneAmbient = ambient;
}

- (void) setAlphaCullingValue:(float)cullValue {
	_alphaCullingValue = cullValue;
}

- (void) setPointAttenuation:(float *)attenuation {
	_pointAttenuation = attenuation;
}

- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations {
	_boneTransformations = transformations;
	_boneInverseTransformations = inverseTransformations;
}

- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex {
	_numberOfBonesPerVertex = numberOfBonesPerVertex;
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


- (void) onSceneRenderReady {
	// to be over-ridden if needed
	
}

- (void) onModelRenderReady {
	// to be over-ridden if needed
	
}

- (void) onModelRenderEnds {
	// to be over-ridden if needed
	
}

- (void) onSceneRenderEnds {
	// to be over-ridden if needed
	
}

- (void) onRenderPhaseEnds {
	// to be over-ridden if needed
	
}


@end
