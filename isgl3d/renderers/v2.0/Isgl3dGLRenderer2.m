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

#import "Isgl3dGLRenderer2.h"
#import "Isgl3dGLRenderer2State.h"
#import "Isgl3dGenericShader.h"
#import "Isgl3dParticleShader.h"
#import "Isgl3dCaptureShader.h"
#import "Isgl3dShadowMapShader.h"
#import "Isgl3dGLContext2.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dMatrix4D.h"
#import "Isgl3dLog.h"


@interface Isgl3dGLRenderer2 (PrivateMethods)
- (void) initRendererState;
- (void) initShader:(Isgl3dShader *)shader;
- (void) setShaderActive:(Isgl3dShader *)shader;
- (void) handleStates;
- (void) buildAllShaders;
- (void) setPlanarShadowsActive:(BOOL)planarShadowActive;
@end

@implementation Isgl3dGLRenderer2

- (id) initWithContext:(Isgl3dGLContext2 *)context {
	
	if (self = [super init]) {
		_glContext = [context retain];
		
       	_mvMatrix = [[Isgl3dMatrix4D alloc] initWithIdentity];
       	_mvpMatrix = [[Isgl3dMatrix4D alloc] initWithIdentity];
       	
		_lightViewProjectionMatrix = [[Isgl3dMatrix4D alloc] initWithIdentity];
		_lightModelViewProjectionMatrix = [[Isgl3dMatrix4D alloc] initWithIdentity];
       	
		_currentState = [[Isgl3dGLRenderer2State alloc] init];
		_previousState = [[Isgl3dGLRenderer2State alloc] init];
		
		_shadowMapActive = NO;
		_currentVBOIndex = 0;
		_renderedObjects = 0;

		_currentElementBufferId = 0;

		[self buildAllShaders];
	}
	
	return self;
}

- (void) dealloc {
	[_glContext release];

	[_currentState release];
	[_previousState release];

	[_mvMatrix release];
	[_mvpMatrix release];
	[_lightViewProjectionMatrix release];
	[_lightModelViewProjectionMatrix release];

	[_shaders release];
	
	[super dealloc];
}

- (void) buildAllShaders {
		
	_shaders = [[NSMutableDictionary alloc] init];

	// define the different types of shaders
	unsigned int nRendererCombinations = 19;
	unsigned int rendererCombinations[] = {
		NOTHING_ON,
		SKINNING_ON,
		SHADOW_MAPPING_ON,
		SHADOW_MAP_CREATION_ON,
		CAPTURE_ON,
		TEXTURE_MAPPING_ON,
		TEXTURE_MAPPING_ON | ALPHA_CULLING_ON,
		TEXTURE_MAPPING_ON | SHADOW_MAPPING_ON,
		TEXTURE_MAPPING_ON | ALPHA_CULLING_ON | SHADOW_MAPPING_ON,
		SKINNING_ON | SHADOW_MAPPING_ON,
		SKINNING_ON | SHADOW_MAP_CREATION_ON,
		SKINNING_ON | TEXTURE_MAPPING_ON,
		SKINNING_ON | CAPTURE_ON,
		SKINNING_ON | TEXTURE_MAPPING_ON | ALPHA_CULLING_ON,
		SKINNING_ON | TEXTURE_MAPPING_ON | SHADOW_MAPPING_ON,
		SKINNING_ON | TEXTURE_MAPPING_ON | ALPHA_CULLING_ON | SHADOW_MAPPING_ON,
		PARTICLES_ON,
		PARTICLES_ON | TEXTURE_MAPPING_ON,
		PARTICLES_ON | TEXTURE_MAPPING_ON | ALPHA_CULLING_ON 
	};

	// Create the different shaders and add pre-processor directives to shaders
	for (unsigned int i = 0; i < nRendererCombinations; i++) {
		unsigned int rendererType = rendererCombinations[i];
		NSString * vsPreProcHeader = @"";
		NSString * fsPreProcHeader = @"";
		
		Isgl3dShader * shader;
		
		if (rendererType & TEXTURE_MAPPING_ON) {
			vsPreProcHeader = [vsPreProcHeader stringByAppendingString:@"#define TEXTURE_MAPPING_ENABLED\n"];
			fsPreProcHeader = [fsPreProcHeader stringByAppendingString:@"#define TEXTURE_MAPPING_ENABLED\n"];
		}
		if (rendererType & ALPHA_CULLING_ON) {
			fsPreProcHeader = [fsPreProcHeader stringByAppendingString:@"#define ALPHA_TEST_ENABLED\n"];
		}
		if (rendererType & SHADOW_MAPPING_ON) {
			vsPreProcHeader = [vsPreProcHeader stringByAppendingString:@"#define SHADOW_MAPPING_ENABLED\n"];
			fsPreProcHeader = [fsPreProcHeader stringByAppendingString:@"#define SHADOW_MAPPING_ENABLED\n"];
		}
		if (rendererType & SKINNING_ON) {
			vsPreProcHeader = [vsPreProcHeader stringByAppendingString:@"#define SKINNING_ENABLED\n"];
		}
		
		if (rendererType & SHADOW_MAP_CREATION_ON) {
			shader = [[Isgl3dShadowMapShader alloc] initWithContext:_glContext vsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		
		} else if (rendererType & CAPTURE_ON) {
			shader = [[Isgl3dCaptureShader alloc] initWithContext:_glContext vsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		
		} else if (rendererType & PARTICLES_ON) {
			shader = [[Isgl3dParticleShader alloc] initWithContext:_glContext vsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		
		} else {
			shader = [[Isgl3dGenericShader alloc] initWithContext:_glContext vsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		}

		[_shaders setObject:shader forKey:[NSNumber numberWithUnsignedInt:rendererType]];
		
		[self initShader:shader];
		[shader release];
	}
}


- (void) setRendererRequirements:(unsigned int)rendererRequirements {
	// Determine which shader to use depending on requirements
	
	Isgl3dShader * shader;
	
	NSNumber * shaderId = [NSNumber numberWithUnsignedInt:rendererRequirements];
	shader = [_shaders objectForKey:shaderId];

	if (shader != nil) {
		//Isgl3dLog(Info, @"Using shader: 0x%04X", rendererRequirements);
		
		[self setShaderActive:shader];
	
	} else {
		Isgl3dLog(Error, @"Error in getting shader for requirements 0x%04X", rendererRequirements);
	}
	
}
- (void) reset {
	
	glDisable(GL_CULL_FACE);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	
}

- (void) initShader:(Isgl3dShader *)shader {
	[self setShaderActive:shader];
	[shader initShader];
}


- (void) setShaderActive:(Isgl3dShader *)shader {
	if (_activeShader != shader) {
		_activeShader = shader;
		[_activeShader setActive];		
	}
}

- (void) setupMatrices {

	// calculate model-view matrix
	[_mvMatrix copyFrom:_viewMatrix];
	if (_planarShadowsActive) {
		[_mvMatrix multiply:_planarShadowsMatrix];
	}
	[_mvMatrix multiply:_modelMatrix];
	
	
	// calculate model-view-projection
	[_mvpMatrix copyFrom:_projectionMatrix];
	[_mvpMatrix multiply:_mvMatrix];

	[_activeShader setModelViewMatrix:_mvMatrix];
	[_activeShader setModelViewProjectionMatrix:_mvpMatrix];


	// Send light model-view-projection matrix to generic renderer (for shadows)
	[_lightModelViewProjectionMatrix copyFrom:_lightViewProjectionMatrix];
	[_lightModelViewProjectionMatrix multiply:_modelMatrix];

	[_activeShader setShadowCastingMVPMatrix:_lightModelViewProjectionMatrix];
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	if (_currentVBOIndex != vboData.vboIndex) {
		[_activeShader setVBOData:vboData];
		_currentVBOIndex = vboData.vboIndex;
	}
}

- (void) setVertexBufferData:(unsigned int)bufferId {
	[_activeShader setVertexBufferData:bufferId];
}

- (void) setNormalBufferData:(GLuint)bufferId {
	[_activeShader setNormalBufferData:bufferId];
}

- (void) setTexCoordBufferData:(GLuint)bufferId {
	[_activeShader setTexCoordBufferData:bufferId];
}

- (void) setColorBufferData:(GLuint)bufferId {
	[_activeShader setColorBufferData:bufferId];
}

- (void) setPointSizeBufferData:(GLuint)bufferId {
	[_activeShader setPointSizeBufferData:bufferId];
}

- (void) setElementBufferData:(unsigned int)bufferId {
	// Bind element index buffer
	if (_currentElementBufferId != bufferId) {
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, bufferId);
		_currentElementBufferId = bufferId;
	}
}

- (void) setTexture:(GLuint)textureId {
	[_activeShader setTexture:textureId];
	_currentState.alphaBlendEnabled = YES;
}

- (void) setMaterialData:(GLfloat *)ambientColor diffuseColor:(GLfloat *)diffuseColor specularColor:(GLfloat *)specularColor withShininess:(GLfloat)shininess {
	[_activeShader setMaterialData:ambientColor diffuseColor:diffuseColor specularColor:specularColor withShininess:shininess];
	_currentState.alphaBlendEnabled = YES;
}

- (void) addLight:(Isgl3dLight *)light {
	NSEnumerator *enumerator = [_shaders objectEnumerator];
	Isgl3dGenericShader * genericShader;
	while ((genericShader = [enumerator nextObject])) {
		[self setShaderActive:genericShader];
		[genericShader addLight:light viewMatrix:_viewMatrix];
	}
}

- (void) setSceneAmbient:(NSString *)ambient {
	NSEnumerator *enumerator = [_shaders objectEnumerator];
	Isgl3dGenericShader * genericShader;
	while ((genericShader = [enumerator nextObject])) {
		[self setShaderActive:genericShader];
		[genericShader setSceneAmbient:ambient];
	}
}


- (void) enableLighting:(BOOL)lightingEnabled {
	[_activeShader enableLighting:lightingEnabled];
}

- (void) enableCulling:(BOOL)cullingEnabled backFace:(BOOL)backFace {
	_currentState.cullingEnabled = cullingEnabled;
	_currentState.backFaceCulling = backFace;
}

- (void) setAlphaCullingValue:(float)cullValue {
	[_activeShader setAlphaCullingValue:cullValue];
}

- (void) enablePointSprites:(BOOL)pointSpriteEnabled {
}

- (void) setPointAttenuation:(float *)attenuation {
	[_activeShader setPointAttenuation:attenuation];
}

- (void) enableSkinning:(BOOL)skinningEnabled {
}

- (void) setBoneTransformations:(NSArray *)transformations andInverseTransformations:(NSArray *)inverseTransformations {
	[_activeShader setBoneTransformations:transformations andInverseTransformations:inverseTransformations];
}

- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex {
	[_activeShader setNumberOfBonesPerVertex:numberOfBonesPerVertex];
}


- (void) setCaptureColor:(float *)color {
	[_activeShader setCaptureColor:color];
}

- (void) preRender {
	// handle client states
	[self handleStates];
	
	[_activeShader preRender];
}

- (void) postRender {
	// save client states
	[_previousState copyFrom:_currentState];
	[_currentState reset];

	[_activeShader postRender];
}

- (void) render:(Isgl3dRenderType)renderType withNumberOfElements:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset {
	_renderedObjects++;
	[_activeShader render:numberOfElements atOffset:elementOffset];
		
}

- (void) handleStates {

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

	if (!_currentState.alphaBlendEnabled && _previousState.alphaBlendEnabled) {
		glDisable(GL_BLEND);
	} else if (_currentState.alphaBlendEnabled && !_previousState.alphaBlendEnabled) {
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA ,GL_ONE_MINUS_SRC_ALPHA); 
	}
	
}

- (void) initRenderForShadowMap {
	_currentState.alphaBlendEnabled = false;
}

- (void) setShadowCastingLightViewMatrix:(Isgl3dMatrix4D *)viewMatrix {
	[_lightViewProjectionMatrix copyFrom:_projectionMatrix];
	[_lightViewProjectionMatrix multiply:viewMatrix];
}

- (void) setShadowCastingLightPosition:(Isgl3dVector3D *)position {
	NSEnumerator *enumerator = [_shaders objectEnumerator];
	Isgl3dGenericShader * genericShader;
	while ((genericShader = [enumerator nextObject])) {
		[self setShaderActive:genericShader];
		[genericShader setShadowCastingLightPosition:position viewMatrix:_viewMatrix];
	}
}


- (void) setShadowMap:(unsigned int)textureId {
	NSEnumerator *enumerator = [_shaders objectEnumerator];
	Isgl3dGenericShader * genericShader;
	while ((genericShader = [enumerator nextObject])) {
		[self setShaderActive:genericShader];
		[genericShader setShadowMap:textureId];
	}
	_shadowMapActive = YES;
}

- (BOOL) shadowMapActive {
	return _shadowMapActive;
}

- (void) setShadowRenderingMethod:(unsigned int)shadowRenderingMethod {
	if (!_stencilBufferAvailable && shadowRenderingMethod != GLRENDERER_SHADOW_RENDERING_NONE) {
		_shadowRenderingMethod = GLRENDERER_SHADOW_RENDERING_NONE;
		Isgl3dLog(Warn, @"Request for shadow rendering refused: not available on this device");
		_shadowRenderingMethod = shadowRenderingMethod;
	} else {
		_shadowRenderingMethod = shadowRenderingMethod;
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
		
		[self setPlanarShadowsActive:YES];
	}
}

- (void) finishRenderForPlanarShadows {
	if (_stencilBufferAvailable) {
		glDisable(GL_POLYGON_OFFSET_FILL);
		glDisable(GL_STENCIL_TEST);
		[self setPlanarShadowsActive:NO];
	}	
}

- (void) setPlanarShadowsActive:(BOOL)planarShadowsActive {
	_planarShadowsActive = planarShadowsActive;
	
	NSEnumerator *enumerator = [_shaders objectEnumerator];
	Isgl3dGenericShader * genericShader;
	while ((genericShader = [enumerator nextObject])) {
		[self setShaderActive:genericShader];
		[genericShader setPlanarShadowsActive:planarShadowsActive shadowAlpha:_shadowAlpha];
	}	
}

- (void) clean {
//	Isgl3dLog(Info, @"Last number of rendered objects = %i", _renderedObjects);
	for (NSNumber * key in _shaders) {
		Isgl3dShader * shader = [_shaders objectForKey:key];
		[self setShaderActive:shader];
		[shader clean];
	}
	_renderedObjects = 0;
}

@end
