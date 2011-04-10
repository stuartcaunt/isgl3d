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

@class Isgl3dMaterial;
@class Isgl3dGLParticle;

/**
 * The Isgl3dParticleNode is used to render a particle (or particle system) in the scene. A particle,
 * to be rendered, requires a material.
 */
@interface Isgl3dParticleNode : Isgl3dNode {

@private
	Isgl3dGLParticle * _particle;
	Isgl3dMaterial * _material;
}

/**
 * Allocates and initialises (autorelease) node with a particle and material.
 * @param particle The particle to be rendered.
 * @param material The material used to render the particle.
 */
+ (id) nodeWithParticle:(Isgl3dGLParticle *)particle andMaterial:(Isgl3dMaterial *)material;

/**
 * Initialises the node with a particle and material.
 * @param particle The particle to be rendered.
 * @param material The material used to render the particle.
 */
- (id) initWithParticle:(Isgl3dGLParticle *)particle andMaterial:(Isgl3dMaterial *)material;


@end
