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

#import "Isgl3dGLRenderer1.h"
#import "Isgl3dGLRenderer1State.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dGLTexture.h"
#import "Isgl3dMaterial.h"
#import "Isgl3dLight.h"
#import "Isgl3dColorUtil.h"
#import "Isgl3dLog.h"
#import "Isgl3dArray.h"

@interface Isgl3dGLRenderer1 (PrivateMethods)
- (void) removeModelMatrix;
- (void) handleStates;
@end

@implementation Isgl3dGLRenderer1

- (id) init {
	
	if ((self = [super init])) {
		_lightCount = 0;
		
		_currentState = [[Isgl3dGLRenderer1State alloc] init];
		_previousState = [[Isgl3dGLRenderer1State alloc] init];

		_glLight[0] = GL_LIGHT0;
		_glLight[1] = GL_LIGHT1;
		_glLight[2] = GL_LIGHT2;
		_glLight[3] = GL_LIGHT3;
		_glLight[4] = GL_LIGHT4;
		_glLight[5] = GL_LIGHT5;
		_glLight[6] = GL_LIGHT6;
		_glLight[7] = GL_LIGHT7;

		_renderTypes[Triangles] = GL_TRIANGLES;
		_renderTypes[Points] = GL_POINTS;
		
		_currentVBOId = 0;
		_currentTextureId = 0;
		_currentElementBufferId = 0;
		
		Isgl3dLog(Info, @"Isgl3dGLRenderer1 : created renderer for OpenGL ES 1.1");
	}
	
	return self;
}

- (void) dealloc {
	[_currentState release];
	[_previousState release];

	[super dealloc];
}

- (void) reset {
	
	for (int i = 0; i < 8; i++) {
		glDisable(_glLight[i]);
	}
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_NORMAL_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
	glDisableClientState(GL_MATRIX_INDEX_ARRAY_OES);
	glDisableClientState(GL_WEIGHT_ARRAY_OES);

	glDisable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	glDisable(GL_CULL_FACE);
	glDisable(GL_ALPHA_TEST);
	glDisable(GL_LIGHTING);
	glDisable(GL_POINT_SPRITE_OES);
	glDisable(GL_MATRIX_PALETTE_OES);

	glBindBuffer(GL_ARRAY_BUFFER, 0);

	_currentVBOId = 0;
	_currentTextureId = 0;
	_currentElementBufferId = 0;

	[_previousState release];
	_previousState = [[Isgl3dGLRenderer1State alloc] init];
	[_currentState release];
	_currentState = [[Isgl3dGLRenderer1State alloc] init];

}

- (void) clear:(unsigned int)bufferBits {
	unsigned int glBufferBits = 0;
	glBufferBits |= (bufferBits & ISGL3D_COLOR_BUFFER_BIT) ? GL_COLOR_BUFFER_BIT : 0;
	glBufferBits |= (bufferBits & ISGL3D_DEPTH_BUFFER_BIT) ? GL_DEPTH_BUFFER_BIT : 0;
	glBufferBits |= (bufferBits & ISGL3D_STENCIL_BUFFER_BIT) ? GL_STENCIL_BUFFER_BIT : 0;

	glClear(glBufferBits);
}

- (void) clear:(unsigned int)bufferBits color:(float *)color {
	unsigned int glBufferBits = 0;
	glBufferBits |= (bufferBits & ISGL3D_COLOR_BUFFER_BIT) ? GL_COLOR_BUFFER_BIT : 0;
	glBufferBits |= (bufferBits & ISGL3D_DEPTH_BUFFER_BIT) ? GL_DEPTH_BUFFER_BIT : 0;
	glBufferBits |= (bufferBits & ISGL3D_STENCIL_BUFFER_BIT) ? GL_STENCIL_BUFFER_BIT : 0;

	glClearColor(color[0], color[1], color[2], color[3]);

	glClear(glBufferBits);
}

- (void) clear:(unsigned int)bufferBits viewport:(CGRect)viewport {
	unsigned int glBufferBits = 0;
	glBufferBits |= (bufferBits & ISGL3D_COLOR_BUFFER_BIT) ? GL_COLOR_BUFFER_BIT : 0;
	glBufferBits |= (bufferBits & ISGL3D_DEPTH_BUFFER_BIT) ? GL_DEPTH_BUFFER_BIT : 0;
	glBufferBits |= (bufferBits & ISGL3D_STENCIL_BUFFER_BIT) ? GL_STENCIL_BUFFER_BIT : 0;

	glEnable(GL_SCISSOR_TEST);	
	glViewport(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);
	glScissor(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);	
	glClear(glBufferBits);
	glDisable(GL_SCISSOR_TEST);	
}

- (void) clear:(unsigned int)bufferBits color:(float *)color viewport:(CGRect)viewport {
	unsigned int glBufferBits = 0;
	glBufferBits |= (bufferBits & ISGL3D_COLOR_BUFFER_BIT) ? GL_COLOR_BUFFER_BIT : 0;
	glBufferBits |= (bufferBits & ISGL3D_DEPTH_BUFFER_BIT) ? GL_DEPTH_BUFFER_BIT : 0;
	glBufferBits |= (bufferBits & ISGL3D_STENCIL_BUFFER_BIT) ? GL_STENCIL_BUFFER_BIT : 0;

	glEnable(GL_SCISSOR_TEST);	
	glViewport(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);
	glScissor(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);	
	glClearColor(color[0], color[1], color[2], color[3]);
	glClear(glBufferBits);
	glDisable(GL_SCISSOR_TEST);	
}


- (void) setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix {
	[super setProjectionMatrix:projectionMatrix];

    glMatrixMode(GL_PROJECTION);
	float *matrixArray = im4ColumnMajorFloatArrayFromMatrix(&_projectionMatrix);
    glLoadMatrixf(matrixArray);
}

- (void) setViewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	[super setViewMatrix:viewMatrix];

    glMatrixMode(GL_MODELVIEW);

	float *matrixArray = im4ColumnMajorFloatArrayFromMatrix(&_viewMatrix);
    glLoadMatrixf(matrixArray);
}

- (void) setModelMatrix:(Isgl3dMatrix4 *)modelMatrix {
	[super setModelMatrix:modelMatrix];
    glMatrixMode(GL_MODELVIEW);

	glPushMatrix();
	float *matrixArray;

	if (_planarShadowsActive) {
		matrixArray = im4ColumnMajorFloatArrayFromMatrix(&_planarShadowsMatrix);
    	glMultMatrixf(matrixArray);
	}

	matrixArray = im4ColumnMajorFloatArrayFromMatrix(&_modelMatrix);
    glMultMatrixf(matrixArray);
}

- (void) removeModelMatrix {
    glMatrixMode(GL_MODELVIEW);

	glPopMatrix();
}

- (void) setupMatrices {
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {

	// Bind buffer if necessary
	if (_currentVBOId != vboData.vboIndex) {
		glBindBuffer(GL_ARRAY_BUFFER, vboData.vboIndex);
		_currentVBOId = vboData.vboIndex;
	
		if (vboData.positionOffset != -1) {
			glVertexPointer(VBO_POSITION_SIZE, GL_FLOAT, vboData.stride, (const void *)vboData.positionOffset);
		}
		if (vboData.normalOffset != -1) {
			glNormalPointer(GL_FLOAT, vboData.stride, (const void *)vboData.normalOffset);
		}
		if (vboData.uvOffset != -1) {
			glTexCoordPointer(VBO_UV_SIZE, GL_FLOAT, vboData.stride, (const void *)vboData.uvOffset);
		}
		if (vboData.colorOffset != -1) {
			glColorPointer(VBO_COLOR_SIZE, GL_FLOAT, vboData.stride, (const void *)vboData.colorOffset);
		}
		if (vboData.sizeOffset != -1) {
			glPointSizePointerOES(GL_FLOAT, vboData.stride, (const void *)vboData.sizeOffset);
		}
		if (vboData.boneIndexOffset != -1) {
			glMatrixIndexPointerOES(vboData.boneIndexSize, GL_UNSIGNED_BYTE, vboData.stride, (const void *)vboData.boneIndexOffset);
		}
		if (vboData.boneWeightOffset != -1) {
			glWeightPointerOES(vboData.boneWeightSize, GL_FLOAT, vboData.stride, (const void *)vboData.boneWeightOffset);
		}
	}

	// Handle state
	if (vboData.positionOffset != -1) {
		_currentState.vertexEnabled = YES;
	}
	if (vboData.normalOffset != -1) {
		_currentState.normalEnabled = YES;
	}
	if (vboData.uvOffset != -1) {
		_currentState.texCoordEnabled = YES;
	}
	if (vboData.colorOffset != -1) {
		_currentState.colorEnabled = YES;
	}
	if (vboData.sizeOffset != -1) {
		_currentState.pointSizeEnabled = YES;
	}
	if (vboData.boneIndexOffset != -1) {
		_currentState.boneIndexEnabled = YES;
	}
	if (vboData.boneWeightOffset != -1) {
		_currentState.boneWeightEnabled = YES;
	}

}

- (void) setElementBufferData:(unsigned int)bufferId {
	if (_currentElementBufferId != bufferId) {
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, bufferId);
		_currentElementBufferId = bufferId;
	}
}

- (void) setTexture:(Isgl3dGLTexture *)texture {
	if (_currentTextureId != texture.textureId) {
		glBindTexture(GL_TEXTURE_2D, texture.textureId);
		_currentTextureId = texture.textureId;
	}
	
	_currentState.textureEnabled = YES;
	_currentState.alphaBlendEnabled = YES;
}


- (void) setMaterialData:(float *)ambientColor diffuseColor:(float *)diffuseColor specularColor:(float *)specularColor withShininess:(float)shininess {
	if (_lightCount > 0) {
		if (_planarShadowsActive) {
			_blackAndAlpha[3] = _shadowAlpha;
			glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, _blackAndAlpha);
			glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, _blackAndAlpha);
			glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, _blackAndAlpha);
			
		} else {
			glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, ambientColor);
			glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuseColor);
			glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specularColor);
		glColor4f(diffuseColor[0], diffuseColor[1], diffuseColor[2], diffuseColor[3]);
			
			// multiply shininess by 100 so that it is equivalent to ES 2.0 shaders
			glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, shininess * 100);
		}
	} else {
		glColor4f(diffuseColor[0], diffuseColor[1], diffuseColor[2], diffuseColor[3]);
	}
	_currentState.alphaBlendEnabled = YES;
	
}

- (void) addLight:(Isgl3dLight *)light {
	int lightIndex = _lightCount;
	
	_lightCount++;	
	
	if (_lightCount > MAX_LIGHTS) {
		Isgl3dLog(Warn, @"Number of lights exceeds %i", MAX_LIGHTS);
		return;
	}
	
	glEnable(_glLight[lightIndex]);
	
	glLightfv(_glLight[lightIndex], GL_AMBIENT, [light ambientLight]);
	glLightfv(_glLight[lightIndex], GL_DIFFUSE, [light diffuseLight]);
	glLightfv(_glLight[lightIndex], GL_SPECULAR, [light specularLight]);
	glLightf(_glLight[lightIndex], GL_CONSTANT_ATTENUATION, light.constantAttenuation);
	glLightf(_glLight[lightIndex], GL_LINEAR_ATTENUATION, light.linearAttenuation);
	glLightf(_glLight[lightIndex], GL_QUADRATIC_ATTENUATION, light.quadraticAttenuation);
	
	float lightPosition[4];
	[light copyWorldPositionToArray:lightPosition];
	glLightfv(_glLight[lightIndex], GL_POSITION, lightPosition);
	
	if (light.lightType == SpotLight) {
		glLightfv(_glLight[lightIndex], GL_SPOT_DIRECTION, [light spotDirection]);
		glLightf(_glLight[lightIndex], GL_SPOT_CUTOFF, light.spotCutoffAngle);
		glLightf(_glLight[lightIndex], GL_SPOT_EXPONENT, light.spotFalloffExponent);		
	}
}

- (void) setSceneAmbient:(NSString *)ambient {
	if (![_sceneAmbientString isEqualToString:ambient]) { 
		_sceneAmbientString = ambient;
		[Isgl3dColorUtil hexColorStringToFloatArray:ambient floatArray:_sceneAmbient];
		[Isgl3dColorUtil hexColorStringToFloatArray:ambient floatArray:_sceneAmbientAndAlpha];
		
		glLightModelfv(GL_LIGHT_MODEL_AMBIENT, _sceneAmbient);
	}
}

- (void) enableLighting:(BOOL)lightingEnabled {
	_currentState.lightingEnabled = lightingEnabled; 
}

- (void) setRendererRequirements:(unsigned int)rendererRequirements {
	_currentState.alphaCullingEnabled = rendererRequirements & ALPHA_CULLING_ON; 
}


- (void) enableCulling:(BOOL)cullingEnabled backFace:(BOOL)backFace {
	_currentState.cullingEnabled = cullingEnabled;
	_currentState.backFaceCulling = backFace;
}


- (void) setAlphaCullingValue:(float)cullValue {
	if (_currentState.alphaCullingEnabled) {
		glAlphaFunc(GL_GREATER, cullValue);
	}
}

- (void) enablePointSprites:(BOOL)pointSpriteEnabled {
	_currentState.pointSpriteEnabled = pointSpriteEnabled;
}

- (void) enableNormalization:(BOOL)nomalizationEnabled {
	_currentState.normalizationEnabled = nomalizationEnabled;
}

- (void) enableSkinning:(BOOL)skinningEnabled {
	_currentState.matrixPaletteEnabled = skinningEnabled;
}

- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations {
	glMatrixMode(GL_MATRIX_PALETTE_OES);
	unsigned int iMatrix = 0;
	IA_FOREACH_PTR(Isgl3dMatrix4 *, boneWorldTransformation, transformations) {
		
		glCurrentPaletteMatrixOES(iMatrix);
		
		iMatrix++;
		Isgl3dMatrix4 boneViewMatrix = _viewMatrix;
		if (_planarShadowsActive) {
			im4Multiply(&boneViewMatrix, &_planarShadowsMatrix);
		}

		im4Multiply(&boneViewMatrix, boneWorldTransformation);

		float *matrixArray = im4ColumnMajorFloatArrayFromMatrix(&boneViewMatrix);
	    glLoadMatrixf(matrixArray);
	}
	glMatrixMode(GL_MODELVIEW);
}

- (void) setPointAttenuation:(float *)attenuation {
	glPointParameterfv(GL_POINT_DISTANCE_ATTENUATION, attenuation);
}

- (void) onRenderPhaseBeginsWithDeltaTime:(float)dt {
	// Do nothing
}

- (void) onSceneRenderReady {
	// Do nothing
}

- (void) onModelRenderReady {
	// handle client states
	[self handleStates];
}

- (void) onModelRenderEnds {
	[self removeModelMatrix];
	
	// save client states
	[_previousState copyFrom:_currentState];
	[_currentState reset];
}

- (void) onSceneRenderEnds {
	// Do nothing
}

- (void) onRenderPhaseEnds {
	// Do nothing
}

- (void) render:(Isgl3dRenderType)renderType withNumberOfElements:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset {
	// render elements
	glDrawElements(_renderTypes[renderType], numberOfElements, GL_UNSIGNED_SHORT, &((unsigned short *)0)[elementOffset]);
}


- (void) handleStates {
	if (!_currentState.vertexEnabled && _previousState.vertexEnabled) {
		glDisableClientState(GL_VERTEX_ARRAY);
	} else if (_currentState.vertexEnabled && !_previousState.vertexEnabled) {
		glEnableClientState(GL_VERTEX_ARRAY);
	}
	
	if (!_currentState.colorEnabled && _previousState.colorEnabled) {
		glDisableClientState(GL_COLOR_ARRAY);
	} else if (_currentState.colorEnabled && !_previousState.colorEnabled) {
		glEnableClientState(GL_COLOR_ARRAY);
	}

	if (!_currentState.normalEnabled && _previousState.normalEnabled) {
		glDisableClientState(GL_NORMAL_ARRAY);
	} else if (_currentState.normalEnabled && !_previousState.normalEnabled) {
		glEnableClientState(GL_NORMAL_ARRAY);
	}

	if (!_currentState.texCoordEnabled && _previousState.texCoordEnabled) {
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	} else if (_currentState.texCoordEnabled && !_previousState.texCoordEnabled) {
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	}
	
	if (!_currentState.textureEnabled && _previousState.textureEnabled) {
		glDisable(GL_TEXTURE_2D);
	} else if (_currentState.textureEnabled && !_previousState.textureEnabled) {
		glEnable(GL_TEXTURE_2D);
	}
	
	if (!_currentState.lightingEnabled && _previousState.lightingEnabled) {
		glDisable(GL_LIGHTING);
	} else if (_currentState.lightingEnabled && !_previousState.lightingEnabled) {
		if (_lightCount > 0) {
			glEnable(GL_LIGHTING);
		} else {
			_currentState.lightingEnabled = NO;
		}
	}
	
	if (!_currentState.alphaBlendEnabled && _previousState.alphaBlendEnabled) {
		glDisable(GL_BLEND);
	} else if (_currentState.alphaBlendEnabled && !_previousState.alphaBlendEnabled) {
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA ,GL_ONE_MINUS_SRC_ALPHA); 
	}
	
	if (!_currentState.cullingEnabled && _previousState.cullingEnabled) {
		glDisable(GL_CULL_FACE);
	} else if (_currentState.cullingEnabled && !_previousState.cullingEnabled) {
		glEnable(GL_CULL_FACE);
	}

	if (!_currentState.backFaceCulling && _previousState.backFaceCulling) {
		glCullFace(GL_FRONT);
	} else if (_currentState.backFaceCulling && !_previousState.backFaceCulling) {
		glCullFace(GL_BACK);
	}
	
	if (!_currentState.alphaCullingEnabled && _previousState.alphaCullingEnabled) {
		glDisable(GL_ALPHA_TEST);
	} else if (_currentState.alphaCullingEnabled && !_previousState.alphaCullingEnabled) {
		glEnable(GL_ALPHA_TEST);
	}
	
	if (!_currentState.pointSpriteEnabled && _previousState.pointSpriteEnabled) {
		glDisable(GL_POINT_SPRITE_OES);
	} else if (_currentState.pointSpriteEnabled && !_previousState.pointSpriteEnabled) {
		glEnable(GL_POINT_SPRITE_OES);
		glTexEnvi(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
	}

	if (!_currentState.pointSizeEnabled && _previousState.pointSizeEnabled) {
		glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
	} else if (_currentState.pointSizeEnabled && !_previousState.pointSizeEnabled) {
		glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
	}

	if (!_currentState.normalizationEnabled && _previousState.normalizationEnabled) {
		glDisable(GL_NORMALIZE);
	} else if (_currentState.normalizationEnabled && !_previousState.normalizationEnabled) {
		glEnable(GL_NORMALIZE);
	}

	if (!_currentState.matrixPaletteEnabled && _previousState.matrixPaletteEnabled) {
		glDisable(GL_MATRIX_PALETTE_OES);
	} else if (_currentState.matrixPaletteEnabled && !_previousState.matrixPaletteEnabled) {
		glEnable(GL_MATRIX_PALETTE_OES);
	}
	
	if (!_currentState.boneIndexEnabled && _previousState.boneIndexEnabled) {
		glDisableClientState(GL_MATRIX_INDEX_ARRAY_OES);
	} else if (_currentState.boneIndexEnabled && !_previousState.boneIndexEnabled) {
		glEnableClientState(GL_MATRIX_INDEX_ARRAY_OES);
	}
	
	if (!_currentState.boneWeightEnabled && _previousState.boneWeightEnabled) {
		glDisableClientState(GL_WEIGHT_ARRAY_OES);
	} else if (_currentState.boneWeightEnabled && !_previousState.boneWeightEnabled) {
		glEnableClientState(GL_WEIGHT_ARRAY_OES);
	}
	
}

- (void) setCaptureColor:(float *)color {
	glColor4f(color[0], color[1], color[2], color[3]);
}

- (void) resetCaptureColor {
	glColor4f(_white[0], _white[1], _white[2], _white[3]);
}

- (void) setShadowRenderingMethod:(isgl3dShadowType)shadowRenderingMethod {
	if (!_stencilBufferAvailable && shadowRenderingMethod != Isgl3dShadowNone) {
		_shadowRenderingMethod = Isgl3dShadowNone;
		Isgl3dLog(Warn, @"Isgl3dGLRenderer1 : Request for shadow rendering refused: not available on this device");
	} else {
		if (shadowRenderingMethod == Isgl3dShadowMaps) {
			Isgl3dLog(Info, @"Isgl3dGLRenderer1 : Request for shadow mapping refused: not available with OpenGL ES 1.1. Using planar shadows.");
			_shadowRenderingMethod = Isgl3dShadowPlanar;
		} else {
			Isgl3dLog(Info, @"Isgl3dGLRenderer1 : Planar shadows activated.");
			_shadowRenderingMethod = shadowRenderingMethod;
		}
	}
}

- (void) enableShadowStencil:(BOOL)shadowStencilEnabled {
	if (_stencilBufferAvailable) {
		if (shadowStencilEnabled) {
			glEnable(GL_STENCIL_TEST);
			glStencilFunc(GL_ALWAYS, 3, 0xffffffff);
			glStencilOp(GL_KEEP, GL_KEEP, GL_REPLACE);
		} else {
			glDisable(GL_STENCIL_TEST);
		}
	}
}

- (void) initRenderForPlanarShadows {
	
	if (_stencilBufferAvailable) {
		_currentState.alphaBlendEnabled = YES;
	
		// Offset polygons to avoid z-fighting
		glEnable(GL_POLYGON_OFFSET_FILL);
		glPolygonOffset(-1.0, -2.5);
	
		// Enable stencil test to ensure we only render on planar shadow node
		glEnable(GL_STENCIL_TEST);
		glStencilFunc(GL_LESS, 2, 0xffffffff);
		glStencilOp(GL_REPLACE, GL_REPLACE, GL_REPLACE);
	
		glColor4f(0.0, 0.0, 0.0, _shadowAlpha);
		
		_planarShadowsActive = YES;
	}
}

- (void) finishRenderForPlanarShadows {
	if (_stencilBufferAvailable) {
		glDisable(GL_POLYGON_OFFSET_FILL);
		glDisable(GL_STENCIL_TEST);

		glColor4f(_white[0], _white[1], _white[2], _white[3]);
		_planarShadowsActive = NO;
	}
}


- (void) clean {
	_lightCount = 0;
	for (int i = 0; i < 8; i++) {
		glDisable(_glLight[i]);
	}
	
}

- (BOOL) registerCustomShader:(Isgl3dCustomShader *)shader {
	Isgl3dLog(Error, @"Isgl3dRenderer1 : Cannot user shader materials using OpenGL ES1");
	return NO;
}


@end
