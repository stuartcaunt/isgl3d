/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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

#define COLOR_RENDERING @"ColorRendering"
#define GENERIC_RENDERING @"GenericRendering"
#define PARTICLE_RENDERING @"ParticleRendering"

#define NOTHING_ON                    0
#define TEXTURE_MAPPING_ON      (1 << 0)
#define ALPHA_CULLING_ON        (1 << 1)
#define SHADOW_MAPPING_ON       (1 << 2)
#define SHADOW_MAPPING_DEPTH_ON (1 << 3)
#define PARTICLES_ON            (1 << 4)
#define SKINNING_ON             (1 << 5)
#define SHADOW_MAP_CREATION_ON  (1 << 6)
#define CAPTURE_ON              (1 << 7)
#define NORMAL_MAPPING_ON       (1 << 8)

#define ISGL3D_COLOR_BUFFER_BIT     1
#define ISGL3D_DEPTH_BUFFER_BIT     2
#define ISGL3D_STENCIL_BUFFER_BIT   4

typedef enum {
	Triangles = 0,
	Points
} Isgl3dRenderType;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Isgl3dTypes.h"
#import "Isgl3dVector.h"
#import "Isgl3dMatrix.h"

@class Isgl3dLight;
@class Isgl3dGLVBOData;
@class Isgl3dArray;
@class Isgl3dCustomShader;
@class Isgl3dGLTexture;

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dGLRenderer : NSObject {

@protected
	Isgl3dMatrix4 _viewMatrix;
	Isgl3dMatrix4 _modelMatrix;
	Isgl3dMatrix4 _projectionMatrix;
	
	float _black[4];
	float _white[4];
	
	float _blackAndAlpha[4];
	float _whiteAndAlpha[4];
	
	isgl3dShadowType _shadowRenderingMethod;
	Isgl3dMatrix4 _planarShadowsMatrix;
	BOOL _planarShadowsActive;
	float _shadowAlpha;
	
	BOOL _stencilBufferAvailable;
	
}

@property (readonly, getter=shadowMapActive) BOOL shadowMapActive;
@property (nonatomic) isgl3dShadowType shadowRenderingMethod;
@property (nonatomic) float shadowAlpha;
@property (nonatomic) BOOL stencilBufferAvailable;

- (id)init;
- (void)reset;

- (void)clear:(unsigned int)bufferBits;
- (void)clear:(unsigned int)bufferBits color:(float *)color;
- (void)clear:(unsigned int)bufferBits viewport:(CGRect)viewport;
- (void)clear:(unsigned int)bufferBits color:(float *)color viewport:(CGRect)viewport;

- (void)setProjectionMatrix:(Isgl3dMatrix4 *)projectionMatrix;
- (void)setViewMatrix:(Isgl3dMatrix4 *)viewMatrix;
- (void)setModelMatrix:(Isgl3dMatrix4 *)modelMatrix;
- (void)setPlanarShadowsMatrix:(Isgl3dMatrix4 *)planarShadowsMatrix;
- (void)setupMatrices;

- (void)setVBOData:(Isgl3dGLVBOData *)vboData;
- (void)setElementBufferData:(unsigned int)bufferId;

- (void)setTexture:(Isgl3dGLTexture *)texture;
- (void)setMaterialData:(float *)ambientColor diffuseColor:(float *)diffuseColor specularColor:(float *)specularColor withShininess:(float)shininess;
- (void)setNormalMap:(Isgl3dGLTexture *)texture;

- (void)addLight:(Isgl3dLight *)light;
- (void)setSceneAmbient:(NSString *)ambient;
- (void)enableLighting:(BOOL)lightingEnabled;


- (void)setRendererRequirements:(unsigned int)rendererRequirements;


- (void)enableCulling:(BOOL)cullingEnabled backFace:(BOOL)backFace;
- (void)setAlphaCullingValue:(float)cullValue;

- (void)enablePointSprites:(BOOL)pointSpriteEnabled;
- (void)setPointAttenuation:(float *)attenuation;

- (void)enableNormalization:(BOOL)nomalizationEnabled;

- (void)enableSkinning:(BOOL)skinningEnabled;
- (void)setBoneTransformations:(Isgl3dArray *)transformations andInverseTransformations:(Isgl3dArray *)inverseTransformations;
- (void)setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex;

- (void)setCaptureColor:(float *)color;
- (void)resetCaptureColor;

- (void)initRenderForShadowMap;
- (void)setShadowCastingLightProjectionViewMatrix:(Isgl3dMatrix4)viewProjectionMatrix;
- (void)setShadowCastingLightPosition:(Isgl3dVector3 *)position;
- (void)setShadowMap:(Isgl3dGLTexture *)texture;
- (BOOL)shadowMapActive;
- (void)enableShadowStencil:(BOOL)shadowStencilEnabled;

- (void)initRenderForPlanarShadows;
- (void)finishRenderForPlanarShadows;
- (void)initRenderForShadowMapRendering;
- (void)finishRenderForShadowMapRendering;

- (void)clean;

- (void)onRenderPhaseBeginsWithDeltaTime:(float)dt;
- (void)onSceneRenderReady;
- (void)onModelRenderReady;
- (void)onModelRenderEnds;
- (void)onSceneRenderEnds;
- (void)onRenderPhaseEnds;
- (void)render:(Isgl3dRenderType)renderType withNumberOfElements:(unsigned int)numberOfElements atOffset:(unsigned int)elementOffset;


- (BOOL) registerCustomShader:(Isgl3dCustomShader *)shader;


@end
