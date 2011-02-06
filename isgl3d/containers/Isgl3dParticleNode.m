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

@implementation Isgl3dParticleNode

- (id) initWithParticle:(Isgl3dGLParticle *)particle andMaterial:(Isgl3dMaterial *)material {
    if (self = [super init]) {

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

- (void) render:(Isgl3dGLRenderer *)renderer opaque:(BOOL)opaque {

	if (_material) {
		if (_transparent != opaque) {
			[_particle update];
	
			if (_particle.dirty) {
				[_particle buildArrays];
				_particle.dirty = NO;
			}
	

			// Set the renderer requirements
			unsigned int rendererRequirements = [_material getRendererRequirements] | PARTICLES_ON;
			rendererRequirements |= _alphaCulling ? ALPHA_CULLING_ON : 0;
			[renderer setRendererRequirements:rendererRequirements];

			// Enable point sprites if necessary
			if (rendererRequirements & TEXTURE_MAPPING_ON) {
				[renderer enablePointSprites:YES];
			}
		
			// Prepare the particle to be rendered
			[_material prepareRenderer:renderer alpha:_alpha];
				
			[renderer setVBOData:[_particle vboData]];
		
			[renderer setElementBufferData:[_particle indicesBufferId]];
		
			// Set alpha culling value
			[renderer setAlphaCullingValue:_alphaCullValue];
			
			[renderer setPointAttenuation:[_particle attenuation]];
		
			// Set the model matrix
			[renderer setModelMatrix:_transformation];

			// Renderer the particle
			[renderer preRender];
			[renderer render:Points withNumberOfElements:[_particle numberOfPoints] atOffset:0];
			[renderer postRender];
		}
	}
}


- (void) collectAlphaObjects:(NSMutableArray *)alphaObjects {
	if (_transparent) {
		[alphaObjects addObject:self];
	}
}

@end
