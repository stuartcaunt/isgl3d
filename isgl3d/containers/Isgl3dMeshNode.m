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

#import "Isgl3dNode.h"
#import "Isgl3dMeshNode.h"
#import "Isgl3dGLMesh.h"
#import "Isgl3dMaterial.h"
#import "Isgl3dColorMaterial.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dObject3DGrabber.h"

@interface Isgl3dMeshNode (PrivateMethods)
- (void) renderMesh:(Isgl3dGLRenderer *)renderer;
@end


@implementation Isgl3dMeshNode

@synthesize doubleSided = _doubleSided;

+ (id) nodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material {
	return [[[self alloc] initWithMesh:mesh andMaterial:material] autorelease];
}

- (id) initWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material {
    if ((self = [super init])) {

    	_occlusionAlpha = 1.0;

		_doubleSided = NO;
		_skinningEnabled = NO;

		if (mesh) {
			_mesh = [mesh retain];
		}
		if (material) {
			_material = [material retain];
		} else {
			_material = [[Isgl3dColorMaterial alloc] init];
		}
		
    }
	
    return self;
}

- (void) dealloc {
	[_mesh release];
	[_material release];
	
	[super dealloc];
}

- (id) copyWithZone:(NSZone *)zone {
	Isgl3dMeshNode * copy = [super copyWithZone:zone];
	
	copy.mesh = _mesh;
	copy.material = _material;
	copy->_doubleSided = _doubleSided;
	copy->_occlusionAlpha = _occlusionAlpha;
	
	return copy;
}


- (Isgl3dGLMesh *) mesh {
	return _mesh;
}

- (void) setMesh:(Isgl3dGLMesh *)mesh {
	if (mesh != _mesh) {
		if (_mesh) {
			[_mesh release];
			_mesh = nil;
		}
		
		if (mesh) {
			_mesh = [mesh retain];
		}
	}
}

- (Isgl3dMaterial *) material {
	return _material;
}

- (void) setMaterial:(Isgl3dMaterial *)material {
	if (material != _material) {
		if (_material) {
			[_material release];
			_material = nil;
		}
		
		if (material) {
			_material = [material retain];
		}
	}
}

- (void) occlusionTest:(Isgl3dVector3 *)eye normal:(Isgl3dVector3 *)normal targetDistance:(float)targetDistance maxAngle:(float)maxAngle {
	// Test for occlusion
	
	Isgl3dVector3 eyeToModel;
	Isgl3dVector3 eyeToModelNormal;

	iv3Fill(&eyeToModel, _worldTransformation.tx, _worldTransformation.ty, _worldTransformation.tz);
	iv3Sub(&eyeToModel, eye);

	iv3Copy(&eyeToModelNormal, &eyeToModel);
	iv3Normalize(&eyeToModelNormal);
	
	float dot = iv3Dot(normal, &eyeToModelNormal);
	float angle = acos(dot) * 180 / M_PI;
	
	
	// Calculate occlusion distance factor: 
	//    0 < f < 1 => object between target and eye
	//            0 => at camera
	//            1 => at target
	//        f > 1 => object behind target		
	//        f < 0 => object behind camera		
	float occlusionDistanceFactor = iv3Dot(normal, &eyeToModel) / targetDistance;
	
	// Calculate occlusion angle factor: 
	//    0 < f < 1 => object between target and max angle
	//            1 => at max angle
	//            0 => at target
	//        f > 1 => object outside max angle		
	float occlusionAngleFactor = angle / maxAngle;
		
		
	if (occlusionAngleFactor < 1 && occlusionAngleFactor >= 0 && occlusionDistanceFactor < 0.999 && occlusionDistanceFactor > 0.0001) {
		float occlusionEffect = 0.0;
		
		if ([Isgl3dNode occlusionMode] == Isgl3dOcclusionQuadDistanceAndAngle) {
			occlusionEffect = (1.0 - occlusionDistanceFactor * occlusionDistanceFactor) * (1.0 - occlusionAngleFactor);
			
		} else if ([Isgl3dNode occlusionMode] == Isgl3dOcclusionDistanceAndAngle) {
			occlusionEffect = (1.0 - occlusionDistanceFactor) * (1.0 - occlusionAngleFactor);
			
		} else if ([Isgl3dNode occlusionMode] == Isgl3dOcclusionQuadDistance) {
			occlusionEffect = 1.0 - occlusionDistanceFactor * occlusionDistanceFactor;
			
		} else if ([Isgl3dNode occlusionMode] == Isgl3dOcclusionDistance) {
			occlusionEffect = 1.0 - occlusionDistanceFactor;
			
		} else if ([Isgl3dNode occlusionMode] == Isgl3dOcclusionAngle) {
			occlusionEffect = 1.0 - occlusionAngleFactor;
		} 

		_occlusionAlpha = (1.0 - occlusionEffect);

	} else {
		_occlusionAlpha = 1.0;
	}
	
	// Recurse over children
	[super occlusionTest:eye normal:normal targetDistance:targetDistance maxAngle:maxAngle];
}

- (void) renderMesh:(Isgl3dGLRenderer *)renderer {
	[renderer onModelRenderReady];
	[renderer render:Triangles withNumberOfElements:[_mesh numberOfElements] atOffset:0];
	[renderer onModelRenderEnds];
}

- (void) render:(Isgl3dGLRenderer *)renderer opaque:(BOOL)opaque {
	
	BOOL goOn = YES;
	if (opaque) {
		if (_transparent || _occlusionAlpha < 1.0 || _alpha < 1.0) {
			goOn = NO;
		}
	} else {
		if (!_transparent && _occlusionAlpha == 1.0 && _alpha == 1.0) {
			goOn = NO;
		}
	}
	
	if (goOn && _mesh && _material) {
		// calculate transparency
		float alpha = _alpha * _occlusionAlpha;

		// Set the renderer requirements
		unsigned int rendererRequirements = _alphaCulling ? ALPHA_CULLING_ON : 0;
		if (_enableShadowRendering && renderer.shadowMapActive) {
			rendererRequirements |= SHADOW_MAPPING_ON;
		}
		if (_skinningEnabled) {
			rendererRequirements |= SKINNING_ON;
		}
		
		// Prepare the material to be rendered
		[_material prepareRenderer:renderer requirements:rendererRequirements alpha:alpha node:self];
	
		// Send the vertex data to the renderer
		[renderer setVBOData:[_mesh vboData]];
	
		// Bind element index buffer
		[renderer setElementBufferData:[_mesh indicesBufferId]];
	
		// Enable/disable lighting
		[renderer enableLighting:self.lightingEnabled];
	
		// Enable/disable normalization of normal vectors
		[renderer enableNormalization:_mesh.normalizationEnabled];
	
		// Enable/disable culling
		[renderer enableCulling:!_doubleSided backFace:YES];
	
		// Set alpha culling value
		[renderer setAlphaCullingValue:_alphaCullValue];
		
		if (_isPlanarShadowsNode) {
			[renderer enableShadowStencil:YES];
		}
		
		// Set the model matrix
		[renderer setModelMatrix:&_worldTransformation];
		
		// Renderer the mesh
		[self renderMesh:renderer];
		
		if (_isPlanarShadowsNode) {
			[renderer enableShadowStencil:NO];
		}
	}
	
	// Recurse over children
	[super render:renderer opaque:opaque];
}

- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer {

	if (_mesh && _material && self.interactive) {
		// Set the renderer requirements
		unsigned int rendererRequirements = CAPTURE_ON;
		if (_skinningEnabled) {
			rendererRequirements |= SKINNING_ON;
		}
		[renderer setRendererRequirements:rendererRequirements];
	
		float color[4];
		[[Isgl3dObject3DGrabber sharedInstance] getCaptureColor:color forObject:self];
		
		[renderer setCaptureColor:color];
		
		// Send the vertex data to the renderer
		[renderer setVBOData:[_mesh vboData]];
	
		// Bind element index buffer
		[renderer setElementBufferData:[_mesh indicesBufferId]];
	
		// Disable lighting
		[renderer enableLighting:NO];
	
		// Enable/disable culling
		[renderer enableCulling:YES backFace:YES];
		
		// Set the model matrix
		[renderer setModelMatrix:&_worldTransformation];
	
		// Renderer the mesh
		[self renderMesh:renderer];
		
		[renderer resetCaptureColor];
	}
	
	// Recurse over children
	[super renderForEventCapture:renderer];
}

- (void) renderForShadowMap:(Isgl3dGLRenderer *)renderer {

	if (_enableShadowCasting && _mesh && _material) {
		
		// Set the renderer requirements
		unsigned int rendererRequirements = SHADOW_MAP_CREATION_ON;
		rendererRequirements |= _alphaCulling ? ALPHA_CULLING_ON : 0;
		if (_skinningEnabled) {
			rendererRequirements |= SKINNING_ON;
		}
		[renderer setRendererRequirements:rendererRequirements];
		
		// Send the vertex data to the renderer
		[renderer setVBOData:[_mesh vboData]];
	
		// Bind element index buffer
		[renderer setElementBufferData:[_mesh indicesBufferId]];
	
		// Disable lighting
		[renderer enableLighting:NO];
	
		// Enable/disable culling
		[renderer enableCulling:YES backFace:NO];
		
		// Set the model matrix
		[renderer setModelMatrix:&_worldTransformation];

		// Set alpha culling value
		[renderer setAlphaCullingValue:_alphaCullValue];
		
		// Renderer the mesh
		[self renderMesh:renderer];
	}

	// Recurse over children
	[super renderForShadowMap:renderer];
}

- (void) renderForPlanarShadows:(Isgl3dGLRenderer *)renderer {

	if (_enableShadowCasting && _mesh && _material) {
		// calculate transparency
		float alpha = _alpha * _occlusionAlpha;

		// Set the renderer requirements
		unsigned int rendererRequirements = _alphaCulling ? ALPHA_CULLING_ON : 0;
		if (_skinningEnabled) {
			rendererRequirements |= SKINNING_ON;
		}
		
		// Prepare the material to be rendered
		[_material prepareRenderer:renderer requirements:rendererRequirements alpha:alpha node:self];

		// Send the vertex data to the renderer
		[renderer setVBOData:[_mesh vboData]];
	
		// Bind element index buffer
		[renderer setElementBufferData:[_mesh indicesBufferId]];
	
		// Disable lighting
		[renderer enableLighting:NO];
	
		// Enable/disable culling
		[renderer enableCulling:!_doubleSided backFace:YES];

		// Set alpha culling value
		[renderer setAlphaCullingValue:_alphaCullValue];
		
		// Set the model matrix
		[renderer setModelMatrix:&_worldTransformation];
		
		// Renderer the mesh
		[self renderMesh:renderer];
	}

	// Recurse over children
	[super renderForPlanarShadows:renderer];
}

- (void) collectAlphaObjects:(NSMutableArray *)alphaObjects {
	if (_transparent || _occlusionAlpha < 1.0 || _alpha < 1.0) {
		[alphaObjects addObject:self];
	}
	
	// Recurse over children
	[super collectAlphaObjects:alphaObjects];
}

@end
