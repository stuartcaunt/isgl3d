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

#import "Isgl3dGLRenderer.h"
#import "Isgl3dPrimitive.h"

@implementation Isgl3dGLRenderer

@synthesize shadowAlpha = _shadowAlpha;
@synthesize stencilBufferAvailable = _stencilBufferAvailable;

- (id) init {
	
	if ((self = [super init])) {
		
       	_modelMatrix = im4Identity();
       	_viewMatrix = im4Identity();
       	_projectionMatrix = im4Identity();
       	
		_black[0] = 0.0;	
		_black[1] = 0.0;	
		_black[2] = 0.0;	
		_black[3] = 1.0;	
		_white[0] = 1.0;	
		_white[1] = 1.0;	
		_white[2] = 1.0;	
		_white[3] = 1.0;

		_blackAndAlpha[0] = 0.0;	
		_blackAndAlpha[1] = 0.0;	
		_blackAndAlpha[2] = 0.0;	
		_blackAndAlpha[3] = 1.0;	
		_whiteAndAlpha[0] = 1.0;	
		_whiteAndAlpha[1] = 1.0;	
		_whiteAndAlpha[2] = 1.0;	
		_whiteAndAlpha[3] = 1.0;

		_shadowRenderingMethod = Isgl3dShadowNone;
       	_planarShadowsMatrix = im4Identity();
		_planarShadowsActive = NO;
		_shadowAlpha = 1.0;
	}
	
	return self;
}

- (void) dealloc {

	[super dealloc];
}

- (void) reset {
}

- (void) clear:(unsigned int)bufferBits {
	// OpenGL version specific
}

- (void) clear:(unsigned int)bufferBits color:(float *)color {
	// OpenGL version specific
}

- (void) clear:(unsigned int)bufferBits viewport:(CGRect)viewport {
	// OpenGL version specific
}

- (void) clear:(unsigned int)bufferBits color:(float *)color viewport:(CGRect)viewport {
	// OpenGL version specific
}

- (void) setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix {
	im4Copy(&_projectionMatrix, projectionMatrix);
}

- (void) setViewMatrix:(Isgl3dMatrix4 *)viewMatrix {
	im4Copy(&_viewMatrix, viewMatrix);
}

- (void) setPlanarShadowsMatrix:(Isgl3dMatrix4 *)planarShadowsMatrix {
	im4Copy(&_planarShadowsMatrix, planarShadowsMatrix);
}

- (void) setModelMatrix:(Isgl3dMatrix4 *)modelMatrix {
	im4Copy(&_modelMatrix, modelMatrix);
	
	[self setupMatrices];
}

- (void) setupMatrices {
}

- (void) setVBOData:(Isgl3dGLVBOData *)vboData {
}

- (void) setVertexBufferData:(unsigned int)bufferId {
}

- (void) setColorBufferData:(unsigned int)bufferId {
}

- (void) setNormalBufferData:(unsigned int)bufferId {
}

- (void) setTexCoordBufferData:(unsigned int)bufferId {
}

- (void) setPointSizeBufferData:(unsigned int)bufferId {
}

- (void) setBoneIndexBufferData:(unsigned int)bufferId {
}

- (void) setBoneWeightBufferData:(unsigned int)bufferId {
}

- (void) setElementBufferData:(unsigned int)bufferId {
}

- (void) setTexture:(Isgl3dGLTexture *)texture {
}

- (void) setMaterialData:(float *)ambientColor diffuseColor:(float *)diffuseColor specularColor:(float *)specularColor withShininess:(float)shininess {
}


- (void) addLight:(Isgl3dLight *)light {
}

- (void) setSceneAmbient:(NSString *)ambient {
}

- (void) enableLighting:(BOOL)lightingEnabled {
}

- (void) setRendererRequirements:(unsigned int)rendererRequirements {
}


- (void) enableCulling:(BOOL)cullingEnabled backFace:(BOOL)backFace {
}

- (void) setAlphaCullingValue:(float)cullValue {
}

- (void) enablePointSprites:(BOOL)pointSpriteEnabled {
}

- (void) enableNormalization:(BOOL)nomalizationEnabled {
}

- (void) enableSkinning:(BOOL)skinningEnabled {
}

- (void) setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations {
}

- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex {
}

- (void) setPointAttenuation:(float *)attenuation {
}

- (void) setCaptureColor:(float *)color {
}

- (void) resetCaptureColor {
}

- (void) initRenderForShadowMap {
}

- (void) setShadowRenderingMethod:(isgl3dShadowType)shadowRenderingMethod {
}

- (isgl3dShadowType) shadowRenderingMethod {
	return _shadowRenderingMethod;
}

- (void) setShadowCastingLightViewMatrix:(Isgl3dMatrix4 *)viewMatrix {
}

- (void) setShadowCastingLightPosition:(Isgl3dVector3 *)position {
}

- (void) setShadowMap:(Isgl3dGLTexture *)texture {
}

- (BOOL) shadowMapActive {
	return NO;
}

- (void) enableShadowStencil:(BOOL)shadowStencilEnabled {
}

- (void) initRenderForPlanarShadows {
}

- (void) finishRenderForPlanarShadows {
}

- (void) initRenderForShadowMapRendering {
}

- (void) finishRenderForShadowMapRendering {
}

- (void) clean {
}

- (void) onRenderPhaseBeginsWithDeltaTime:(float)dt {
}

- (void) onSceneRenderReady {
}

- (void) onModelRenderReady {
}

- (void) onModelRenderEnds {
}

- (void) onSceneRenderEnds {
}

- (void) onRenderPhaseEnds {
}

- (void) render:(Isgl3dRenderType)renderType withNumberOfElements:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset {
}


- (BOOL) registerCustomShader:(Isgl3dCustomShader *)shader {
	return NO;
}


@end
