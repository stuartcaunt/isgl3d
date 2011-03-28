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
#import "Isgl3dMatrix4D.h"
#import "Isgl3dVector3D.h"

@interface Isgl3dMeshNode (PrivateMethods)
- (void) renderMesh:(Isgl3dGLRenderer *)renderer;
@end


@implementation Isgl3dMeshNode

@synthesize doubleSided = _doubleSided;

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

- (void) occlusionTest:(Isgl3dMiniVec3D *)eye normal:(Isgl3dMiniVec3D *)normal targetDistance:(float)targetDistance maxAngle:(float)maxAngle {
	// Test for occlusion
	mv3DFill(&_eyeToModel, _transformation.tx, _transformation.ty, _transformation.tz);
	mv3DSub(&_eyeToModel, eye);

	mv3DCopy(&_eyeToModelNormal, &_eyeToModel);
	mv3DNormalize(&_eyeToModelNormal);
	
	float dot = mv3DDot(normal, &_eyeToModelNormal);
	float angle = acos(dot) * 180 / M_PI;
	
	
	// Calculate occlusion distance factor: 
	//    0 < f < 1 => object between target and eye
	//            0 => at camera
	//            1 => at target
	//        f > 1 => object behind target		
	//        f < 0 => object behind camera		
	float occlusionDistanceFactor = mv3DDot(normal, &_eyeToModel) / targetDistance;
	
	// Calculate occlusion angle factor: 
	//    0 < f < 1 => object between target and max angle
	//            1 => at max angle
	//            0 => at target
	//        f > 1 => object outside max angle		
	float occlusionAngleFactor = angle / maxAngle;
		
		
	if (occlusionAngleFactor < 1 && occlusionAngleFactor >= 0 && occlusionDistanceFactor < 0.999 && occlusionDistanceFactor > 0.0001) {
		float occlusionEffect = 0.0;
		
		if ([Isgl3dNode occlusionMode] == OCCLUSION_MODE_QUAD_DISTANCE_AND_ANGLE) {
			occlusionEffect = (1.0 - occlusionDistanceFactor * occlusionDistanceFactor) * (1.0 - occlusionAngleFactor);
			
		} else if ([Isgl3dNode occlusionMode] == OCCLUSION_MODE_DISTANCE_AND_ANGLE) {
			occlusionEffect = (1.0 - occlusionDistanceFactor) * (1.0 - occlusionAngleFactor);
			
		} else if ([Isgl3dNode occlusionMode] == OCCLUSION_MODE_QUAD_DISTANCE) {
			occlusionEffect = 1.0 - occlusionDistanceFactor * occlusionDistanceFactor;
			
		} else if ([Isgl3dNode occlusionMode] == OCCLUSION_MODE_DISTANCE) {
			occlusionEffect = 1.0 - occlusionDistanceFactor;
			
		} else if ([Isgl3dNode occlusionMode] == OCCLUSION_MODE_ANGLE) {
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
	[renderer preRender];
	[renderer render:Triangles withNumberOfElements:[_mesh numberOfElements] atOffset:0];
	[renderer postRender];
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
		// Set the renderer requirements
		unsigned int rendererRequirements = [_material getRendererRequirements];
		rendererRequirements |= _alphaCulling ? ALPHA_CULLING_ON : 0;
		if (_enableShadowRendering && renderer.shadowMapActive) {
			rendererRequirements |= SHADOW_MAPPING_ON;
		}
		if (_skinningEnabled) {
			rendererRequirements |= SKINNING_ON;
		}
		[renderer setRendererRequirements:rendererRequirements];
		
		// Prepare the material to be rendered
		float alpha = _alpha * _occlusionAlpha;
		[_material prepareRenderer:renderer alpha:alpha];
	
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
		[renderer setModelMatrix:_transformation];
		
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
		[renderer setModelMatrix:_transformation];
	
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
		[renderer setModelMatrix:_transformation];

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
		
		// Set the renderer requirements
		unsigned int rendererRequirements = [_material getRendererRequirements];
		rendererRequirements |= _alphaCulling ? ALPHA_CULLING_ON : 0;
		if (_skinningEnabled) {
			rendererRequirements |= SKINNING_ON;
		}
		[renderer setRendererRequirements:rendererRequirements];

		// Prepare the material to be rendered
		float alpha = _alpha * _occlusionAlpha;
		[_material prepareRenderer:renderer alpha:alpha];
		
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
		[renderer setModelMatrix:_transformation];
		
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
