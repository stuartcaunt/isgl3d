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

#import "Isgl3dShadowCastingLight.h"
#import "Isgl3dNode.h"
#import "Isgl3dGLDepthRenderTexture.h"
#import "Isgl3dGLTextureFactory.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dGLU.h"
#import "Isgl3dMatrix4D.h"
#import "Isgl3dVector4D.h"

@interface Isgl3dShadowCastingLight (PrivateMethods)
- (void) calculateViewMatrix;
@end

@implementation Isgl3dShadowCastingLight

@synthesize planarShadowsNode = _planarShadowsNode;
@synthesize planarShadowsNodeNormal = _planarShadowsNodeNormal;

- (id) initWithHexColor:(NSString *)ambientColor diffuseColor:(NSString *)diffuseColor specularColor:(NSString *)specularColor attenuation:(float)attenuation {
	
	if (self = [super initWithHexColor:ambientColor diffuseColor:diffuseColor specularColor:specularColor attenuation:attenuation]) {

		_planarShadowsNodeNormal = [[Isgl3dVector4D alloc] init:0 y:0 z:1 w:0];
	}
	
	return self;
}

- (void) dealloc {
	if (_shadowRenderTexture) {
		[_shadowRenderTexture release];
	}

	if (_planarShadowsNode) {
		[_planarShadowsNode release];
	}

	[_viewMatrix release];
	[_planarShadowsNodeNormal release];

	[super dealloc];
}


- (void) renderLights:(Isgl3dGLRenderer *)renderer {
	[super renderLights:renderer];
	
	if (renderer.shadowRenderingMethod == GLRENDERER_SHADOW_RENDERING_MAPS) {
		
		[renderer setShadowMap:_shadowRenderTexture.textureId];
		
		[renderer setShadowCastingLightViewMatrix:_viewMatrix];
		
		[renderer setShadowCastingLightPosition:[self position]];
	}
}


- (void) createShadowMaps:(Isgl3dGLRenderer *)renderer forScene:(Isgl3dNode *)scene {

	if (!_shadowRenderTexture) {
		_shadowRenderTexture = [[[Isgl3dGLTextureFactory sharedInstance] createDepthRenderTexture:SHADOW_MAP_WIDTH height:SHADOW_MAP_HEIGHT] retain];
	}

	[_shadowRenderTexture initializeRender];

	[_shadowRenderTexture clear];
	
	// Set view and projection matrices from light position
	[renderer setViewMatrix:_viewMatrix];
		
	[renderer initRenderForShadowMap];
	
	[scene renderForShadowMap:renderer];
	
	[_shadowRenderTexture finalizeRender];
}

- (void) createPlanarShadows:(Isgl3dGLRenderer *)renderer forScene:(Isgl3dNode *)scene {

	Isgl3dVector4D * plane;
	if (_planarShadowsNode != nil) {
		plane = [_planarShadowsNode asPlaneWithNormal:_planarShadowsNodeNormal];
	} else {
		plane = [Isgl3dVector4D vectorWithX:0 y:1 z:0 w:0];
	}

	// Create projection matrix
	Isgl3dMatrix4D * planarShadowsMatrix;
	if (self.lightType == DirectionalLight) {
		planarShadowsMatrix = [Isgl3dMatrix4D planarProjectionMatrix:plane fromDirection:[self position]];
	} else {
		planarShadowsMatrix = [Isgl3dMatrix4D planarProjectionMatrix:plane fromPosition:[self position]];
	}
		
	// set shadow projection matrix
	[renderer setPlanarShadowsMatrix:planarShadowsMatrix];

	// Render the scene
	[scene renderForPlanarShadows:renderer];

}

- (void) setPlanarShadowsNode:(Isgl3dNode *)node {
	if (_planarShadowsNode != nil) {
		_planarShadowsNode.isPlanarShadowsNode = NO;
		[_planarShadowsNode release];
	}
	
	_planarShadowsNode = [node retain];
	_planarShadowsNode.isPlanarShadowsNode = YES;
}


- (void) translate:(float)x y:(float)y z:(float)z {
	[super translate:x y:y z:z];
	
	[self calculateViewMatrix];
}

- (void) setTranslation:(float)x y:(float)y z:(float)z {
	[super setTranslation:x y:y z:z];
	
	[self calculateViewMatrix];
}

- (void) resetTransformation {
	[super resetTransformation];

	[self setTranslation:0 y:0 z:10];
}

- (void) udpateGlobalTransformation:(Isgl3dMatrix4D *)parentTransformation {
	
	BOOL calculateViewMatrix = _transformationDirty;
	[super udpateGlobalTransformation:parentTransformation];

	if (calculateViewMatrix) {
		[self calculateViewMatrix];
	}
}

- (void) calculateViewMatrix {
	if (_viewMatrix) {
		[_viewMatrix release];
	}
	
	float lightPosition[4];
	[self copyPositionTo:lightPosition];
	
	_viewMatrix = [Isgl3dGLU lookAt:lightPosition[0] eyey:lightPosition[1] eyez:lightPosition[2] centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	[_viewMatrix retain];
}


@end
