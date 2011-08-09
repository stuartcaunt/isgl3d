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
#import "Isgl3dCustomShader.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dLog.h"


@interface Isgl3dGLRenderer2 (PrivateMethods)
- (void) initRendererState;
- (void) initShader:(Isgl3dShader *)shader;
- (void) handleStates;
- (void) buildAllShaders;
- (void) setPlanarShadowsActive:(BOOL)planarShadowActive;
@end

@implementation Isgl3dGLRenderer2

- (id) init {
	
	if ((self = [super init])) {
       	_mvMatrix = im4Identity();
       	_mvpMatrix = im4Identity();
       	
		_lightViewProjectionMatrix = im4Identity();
		_lightModelViewProjectionMatrix = im4Identity();
       	
		_currentState = [[Isgl3dGLRenderer2State alloc] init];
		_previousState = [[Isgl3dGLRenderer2State alloc] init];
		
		_shadowMapActive = NO;
		_currentVBOIndex = 0;
		_renderedObjects = 0;

		_currentElementBufferId = 0;

		[self buildAllShaders];
		_customShaders = [[NSMutableDictionary alloc] init];

		Isgl3dLog(Info, @"Isgl3dGLRenderer2 : created renderer for OpenGL ES 2.0");
	}
	
	return self;
}

- (void) dealloc {
	[_currentState release];
	[_previousState release];

	[_shaders release];
	[_customShaders release];
	
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
			shader = [[Isgl3dShadowMapShader alloc] initWithVsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		
		} else if (rendererType & CAPTURE_ON) {
			shader = [[Isgl3dCaptureShader alloc] initWithVsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		
		} else if (rendererType & PARTICLES_ON) {
			shader = [[Isgl3dParticleShader alloc] initWithVsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		
		} else {
			shader = [[Isgl3dGenericShader alloc] initWithVsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		}
        
        if (!shader) {
            Isgl3dLog(Error, @"Isgl3dGLRenderer2 failed to add shader for renderer type %i", rendererType);
            continue;
        }

		[_shaders setObject:shader forKey:[NSNumber numberWithUnsignedInt:rendererType]];
		
		[self initShader:shader];
		[shader release];
	}
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
	
	// save client states
	[_previousState copyFrom:_currentState];
	_currentState.cullingEnabled = NO;
	_currentState.alphaBlendEnabled = NO;

	glDisable(GL_CULL_FACE);
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
	im4Copy(&_mvMatrix, &_viewMatrix);
	if (_planarShadowsActive) {
		im4Multiply(&_mvMatrix, &_planarShadowsMatrix);
	}
	im4Multiply(&_mvMatrix, &_modelMatrix);
	
	
	// calculate model-view-projection
	im4Copy(&_mvpMatrix, &_projectionMatrix);
	im4Multiply(&_mvpMatrix, &_mvMatrix);

	[_activeShader setModelMatrix:&_modelMatrix];
	[_activeShader setViewMatrix:&_viewMatrix];
	[_activeShader setProjectionMatrix:&_projectionMatrix];
	[_activeShader setModelViewMatrix:&_mvMatrix];
	[_activeShader setModelViewMatrix:&_mvMatrix];
	[_activeShader setModelViewProjectionMatrix:&_mvpMatrix];


	// Send light model-view-projection matrix to generic renderer (for shadows)
	im4Copy(&_lightModelViewProjectionMatrix, &_lightViewProjectionMatrix);
	im4Multiply(&_lightModelViewProjectionMatrix, &_modelMatrix);

	[_activeShader setShadowCastingMVPMatrix:&_lightModelViewProjectionMatrix];
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
	if (_currentVBOIndex != vboData.vboIndex) {
		[_activeShader bindVertexBuffer:vboData.vboIndex];
		[_activeShader setVBOData:vboData];
		_currentVBOIndex = vboData.vboIndex;
	}
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
		[genericShader addLight:light viewMatrix:&_viewMatrix];
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

- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations {
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

- (void) setShadowCastingLightViewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	im4Copy(&_lightViewProjectionMatrix, &_projectionMatrix);
	im4Multiply(&_lightViewProjectionMatrix, viewMatrix);
}

- (void) setShadowCastingLightPosition:(Isgl3dVector3 *)position {
	NSEnumerator *enumerator = [_shaders objectEnumerator];
	Isgl3dGenericShader * genericShader;
	while ((genericShader = [enumerator nextObject])) {
		[self setShaderActive:genericShader];
		[genericShader setShadowCastingLightPosition:position viewMatrix:&_viewMatrix];
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

- (void) setShadowRenderingMethod:(isgl3dShadowType)shadowRenderingMethod {
	if (!_stencilBufferAvailable && shadowRenderingMethod != Isgl3dShadowNone) {
		_shadowRenderingMethod = Isgl3dShadowNone;
		Isgl3dLog(Warn, @"Isgl3dGLRenderer2 : Request for shadow rendering refused: not available on this device");

	} else {
		if (shadowRenderingMethod == Isgl3dShadowMaps) {
			Isgl3dLog(Info, @"Isgl3dGLRenderer2 : Shadow mapping activated.");
		} else {
			Isgl3dLog(Info, @"Isgl3dGLRenderer2 : Planar shadows activated.");
		}
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

- (BOOL) registerCustomShader:(Isgl3dCustomShader *)shader {
	if ([_customShaders objectForKey:shader.key]) {
		Isgl3dLog(Warn, @"Isgl3dGLRenderer2 : custom shader with key %@ already exists.", shader.key);
		return NO;
	}
	
	[_customShaders setObject:shader forKey:shader.key];
	
	return YES;
}


@end
