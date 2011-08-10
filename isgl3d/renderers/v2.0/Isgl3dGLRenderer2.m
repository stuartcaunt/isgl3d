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
- (void) handleStates;
- (Isgl3dInternalShader *) shaderForRendererRequirements:(unsigned int)rendererRequirements;
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

		//[self buildAllShaders];
		_internalShaders = [[NSMutableDictionary alloc] init];
		_customShaders = [[NSMutableDictionary alloc] init];

		Isgl3dLog(Info, @"Isgl3dGLRenderer2 : created renderer for OpenGL ES 2.0");
	}
	
	return self;
}

- (void) dealloc {
	[_currentState release];
	[_previousState release];

	[_internalShaders release];
	[_customShaders release];
	
	[super dealloc];
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


- (Isgl3dInternalShader *) shaderForRendererRequirements:(unsigned int)rendererRequirements {
	Isgl3dInternalShader * shader;
	
	NSNumber * shaderId = [NSNumber numberWithUnsignedInt:rendererRequirements];
	shader = [_internalShaders objectForKey:shaderId];

	if (shader) {
		return shader;
	
	} else {
		NSString * vsPreProcHeader = @"";
		NSString * fsPreProcHeader = @"";
		
		if (rendererRequirements & TEXTURE_MAPPING_ON) {
			vsPreProcHeader = [vsPreProcHeader stringByAppendingString:@"#define TEXTURE_MAPPING_ENABLED\n"];
			fsPreProcHeader = [fsPreProcHeader stringByAppendingString:@"#define TEXTURE_MAPPING_ENABLED\n"];
		}
		if (rendererRequirements & ALPHA_CULLING_ON) {
			fsPreProcHeader = [fsPreProcHeader stringByAppendingString:@"#define ALPHA_TEST_ENABLED\n"];
		}
		if (rendererRequirements & SHADOW_MAPPING_ON) {
			vsPreProcHeader = [vsPreProcHeader stringByAppendingString:@"#define SHADOW_MAPPING_ENABLED\n"];
			fsPreProcHeader = [fsPreProcHeader stringByAppendingString:@"#define SHADOW_MAPPING_ENABLED\n"];
		}
		if (rendererRequirements & SKINNING_ON) {
			vsPreProcHeader = [vsPreProcHeader stringByAppendingString:@"#define SKINNING_ENABLED\n"];
		}
		
		if (rendererRequirements & SHADOW_MAP_CREATION_ON) {
			shader = [[Isgl3dShadowMapShader alloc] initWithVsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		
		} else if (rendererRequirements & CAPTURE_ON) {
			shader = [[Isgl3dCaptureShader alloc] initWithVsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		
		} else if (rendererRequirements & PARTICLES_ON) {
			shader = [[Isgl3dParticleShader alloc] initWithVsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		
		} else {
			shader = [[Isgl3dGenericShader alloc] initWithVsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader];
		}
        
        if (shader) {
            Isgl3dLog(Info, @"Created internal shader for renderer requirements %i", rendererRequirements);
			[_internalShaders setObject:shader forKey:[NSNumber numberWithUnsignedInt:rendererRequirements]];
			[shader release];
        } else {
            Isgl3dLog(Error, @"Isgl3dGLRenderer2 : Failed to add shader for renderer requirements %i", rendererRequirements);
        }

	}
	
	return shader;
}

- (void) setRendererRequirements:(unsigned int)rendererRequirements {

	// Determine which shader to use depending on requirements - create new one if needed
	Isgl3dShader * shader = [self shaderForRendererRequirements:rendererRequirements];
	
	if (shader != nil) {
		//Isgl3dLog(Info, @"Using shader: 0x%04X", rendererRequirements);
		
		[self setShaderActive:shader];
	
	} else {
		Isgl3dLog(Error, @"Isgl3dGLRenderer2 : Error in getting shader for requirements 0x%04X", rendererRequirements);
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

- (void) setShaderActive:(Isgl3dShader *)shader {
	_activeShader = shader;
	[_activeShader setActive];		
}

- (void) setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix {
	[super setProjectionMatrix:projectionMatrix];
	
	// Pass projection matrix to all custom shaders
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
		[shader setProjectionMatrix:projectionMatrix];
	}
}

- (void) setViewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	[super setViewMatrix:viewMatrix];
	
	// Pass view matrix to all custom shaders
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
		[shader setViewMatrix:viewMatrix];
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

	// Pass model matrix (and combinations only to active shader)
	[_activeShader setModelMatrix:&_modelMatrix];
	[_activeShader setModelViewMatrix:&_mvMatrix];
	[_activeShader setModelViewProjectionMatrix:&_mvpMatrix];

	// Send light model-view-projection matrix to generic renderer (for shadows)
	im4Copy(&_lightModelViewProjectionMatrix, &_lightViewProjectionMatrix);
	im4Multiply(&_lightModelViewProjectionMatrix, &_modelMatrix);

	if ([_activeShader isKindOfClass:[Isgl3dInternalShader class]]) {
		[(Isgl3dInternalShader *)_activeShader setShadowCastingMVPMatrix:&_lightModelViewProjectionMatrix];
	}
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

// Called only by Isgl3dTextureMaterial
- (void) setTexture:(Isgl3dGLTexture *)texture {
	if ([_activeShader isKindOfClass:[Isgl3dInternalShader class]]) {
		[(Isgl3dInternalShader *)_activeShader setTexture:texture];
		_currentState.alphaBlendEnabled = YES;
	}
}

// Called only by Isgl3dColorMaterial
- (void) setMaterialData:(GLfloat *)ambientColor diffuseColor:(GLfloat *)diffuseColor specularColor:(GLfloat *)specularColor withShininess:(GLfloat)shininess {
	if ([_activeShader isKindOfClass:[Isgl3dInternalShader class]]) {
		[(Isgl3dInternalShader *)_activeShader setMaterialData:ambientColor diffuseColor:diffuseColor specularColor:specularColor withShininess:shininess];
		_currentState.alphaBlendEnabled = YES;
	}
}

- (void) addLight:(Isgl3dLight *)light {
	NSEnumerator *enumerator = [_internalShaders objectEnumerator];
	Isgl3dInternalShader * shader;
	while ((shader = [enumerator nextObject])) {
		[self setShaderActive:shader];
		[shader addLight:light viewMatrix:&_viewMatrix];
	}
	
	// Add lighting to custom shaders
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
		[self setShaderActive:shader];
		[shader addLight:light viewMatrix:&_viewMatrix];
	}
}

- (void) setSceneAmbient:(NSString *)ambient {
	NSEnumerator *enumerator = [_internalShaders objectEnumerator];
	Isgl3dInternalShader * shader;
	while ((shader = [enumerator nextObject])) {
		[self setShaderActive:shader];
		[shader setSceneAmbient:ambient];
	}

	// Add scene ambient custom shaders
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
		[self setShaderActive:shader];
		[shader setSceneAmbient:ambient];
	}
}


- (void) enableLighting:(BOOL)lightingEnabled {
	if ([_activeShader isKindOfClass:[Isgl3dInternalShader class]]) {
		[(Isgl3dInternalShader *)_activeShader enableLighting:lightingEnabled];
	}
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
	if ([_activeShader isKindOfClass:[Isgl3dInternalShader class]]) {
		[(Isgl3dInternalShader *)_activeShader setCaptureColor:color];
	}
}

- (void) onRenderPhaseBeginsWithDeltaTime:(float)dt {
	// Clean up of custom shaders (remove any that are no longer retained)
	NSMutableArray * unretainedShaders = [NSMutableArray arrayWithCapacity:1];
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
		if ([shader retainCount] == 1) {
			[unretainedShaders addObject:key];
		}
	} 

	for (NSString * key in unretainedShaders) {
		Isgl3dLog(Info, @"Isgl3dGLRenderer2 : custom shader with key \"%@\" no longer retained: deleting.", key);
		[_customShaders removeObjectForKey:key];
	}	
	
	// custom handling of phase event
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
		[self setShaderActive:shader];
		[shader onRenderPhaseBeginsWithDeltaTime:dt];
	} 
}

- (void) onSceneRenderReady {
	// custom handling of phase event
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
		[self setShaderActive:shader];
		[shader onSceneRenderReady];
	} 
}

- (void) onModelRenderReady {
	// handle client states
	[self handleStates];
	
	[_activeShader onModelRenderReady];
}

- (void) onModelRenderEnds {
	// save client states
	[_previousState copyFrom:_currentState];
	[_currentState reset];

	[_activeShader onModelRenderEnds];
}

- (void) onSceneRenderEnds {
	// custom handling of phase event
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
		[self setShaderActive:shader];
		[shader onSceneRenderEnds];
	} 
}

- (void) onRenderPhaseEnds {
	// custom handling of phase event
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
		[self setShaderActive:shader];
		[shader onRenderPhaseEnds];
	} 
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
	NSEnumerator *enumerator = [_internalShaders objectEnumerator];
	Isgl3dInternalShader * shader;
	while ((shader = [enumerator nextObject])) {
		[self setShaderActive:shader];
		[shader setShadowCastingLightPosition:position viewMatrix:&_viewMatrix];
	}
}


- (void) setShadowMap:(Isgl3dGLTexture *)texture {
	NSEnumerator *enumerator = [_internalShaders objectEnumerator];
	Isgl3dInternalShader * shader;
	while ((shader = [enumerator nextObject])) {
		[self setShaderActive:shader];
		[shader setShadowMap:texture];
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
	
	NSEnumerator *enumerator = [_internalShaders objectEnumerator];
	Isgl3dInternalShader * shader;
	while ((shader = [enumerator nextObject])) {
		[self setShaderActive:shader];
		[shader setPlanarShadowsActive:planarShadowsActive shadowAlpha:_shadowAlpha];
	}	
}

- (void) clean {
//	Isgl3dLog(Info, @"Last number of rendered objects = %i", _renderedObjects);
	for (NSNumber * key in _internalShaders) {
		Isgl3dInternalShader * shader = [_internalShaders objectForKey:key];
		[self setShaderActive:shader];
		[shader clean];
	}
	
	for (NSString * key in _customShaders) {
		Isgl3dCustomShader * shader = [_customShaders objectForKey:key];
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
