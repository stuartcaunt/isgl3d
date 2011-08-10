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

#import "Isgl3dParticleNode.h"
#import "Isgl3dMaterial.h"
#import "Isgl3dGLParticle.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dObject3DGrabber.h"

@implementation Isgl3dParticleNode

+ (id) nodeWithParticle:(Isgl3dGLParticle *)particle andMaterial:(Isgl3dMaterial *)material {
	return [[[self alloc] initWithParticle:particle andMaterial:material] autorelease];
}

- (id) initWithParticle:(Isgl3dGLParticle *)particle andMaterial:(Isgl3dMaterial *)material {
	 if ((self = [super init])) {

		_particle = [particle retain];
		_material = [material retain];
	 }
	
	 return self;
}

- (void) dealloc {
	[_particle release];
	[_material release];
	
	[super dealloc];
}

- (id) copyWithZone:(NSZone *)zone {
	Isgl3dParticleNode * copy = [super copyWithZone:zone];
	
	copy->_particle = [_particle retain];
	copy->_material = [_material retain];
	
	return copy;
}

- (void) render:(Isgl3dGLRenderer *)renderer opaque:(BOOL)opaque {

	if (_material) {
		if (_transparent != opaque) {
			[_particle update];
	
			if (_particle.dirty) {
				[_particle buildArrays];
				_particle.dirty = NO;
			}

			// Set the renderer requirements
			unsigned int rendererRequirements = PARTICLES_ON;
			rendererRequirements |= _alphaCulling ? ALPHA_CULLING_ON : 0;

			// Prepare the material to be rendered
			[_material prepareRenderer:renderer requirements:rendererRequirements alpha:_alpha node:self];
				
			[renderer setVBOData:[_particle vboData]];
		
			[renderer setElementBufferData:[_particle indicesBufferId]];
		
			// Set alpha culling value
			[renderer setAlphaCullingValue:_alphaCullValue];
			
			[renderer setPointAttenuation:[_particle attenuation]];
		
			// Set the model matrix
			[renderer setModelMatrix:&_worldTransformation];

			// Renderer the particle
			[renderer onModelRenderReady];
			[renderer render:Points withNumberOfElements:[_particle numberOfPoints] atOffset:0];
			[renderer onModelRenderEnds];
		}
	}
	
	// Recurse over children
	[super render:renderer opaque:opaque];
}

- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer {

	if (_material && self.interactive) {

		// Set the renderer requirements (ES 2.0 uses the same shader for normal render)
		unsigned int rendererRequirements = PARTICLES_ON;
		[renderer setRendererRequirements:rendererRequirements];

		// Cannot render point sprites because texture color will interfere with capture color
		// Texture would only make a difference with alpha culling enabled: don't enable for capture, too costly

		// Get capture color
		float captureColor[4];
		[[Isgl3dObject3DGrabber sharedInstance] getCaptureColor:captureColor forObject:self];

		// Set the capture color in particle(s): !!! bad performance for particle systems !!!
		[_particle prepareForEventCapture:captureColor[0] g:captureColor[1] b:captureColor[2]];

		// Send the vertex data to the renderer
		[renderer setVBOData:[_particle vboData]];

		// Bind element index buffer
		[renderer setElementBufferData:[_particle indicesBufferId]];

		// Set alpha culling value
		[renderer setAlphaCullingValue:_alphaCullValue];

		[renderer setPointAttenuation:[_particle attenuation]];
		// Set the model matrix
		[renderer setModelMatrix:&_worldTransformation];

		// Renderer the particle
		[renderer onModelRenderReady];
		[renderer render:Points withNumberOfElements:[_particle numberOfPoints] atOffset:0];
		[renderer onModelRenderEnds];

		// Restore original particle color: !!! bad performance for particle systems !!!
		[_particle restoreRenderColor];
	}

	// Recurse over children
	[super renderForEventCapture:renderer];
}

- (void) collectAlphaObjects:(NSMutableArray *)alphaObjects {
	if (_transparent) {
		[alphaObjects addObject:self];
	}
}

@end
