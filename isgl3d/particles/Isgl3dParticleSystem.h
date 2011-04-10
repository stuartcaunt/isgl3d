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

#import "Isgl3dGLParticle.h"

/**
 * The Isgl3dParticleSystem extends the Isgl3dGLParticle to allow for large numbers of particles to be rendered
 * quickly.
 * 
 * As mentioned in Isgl3dGLParticle, raw data for the particles is sent directly to the GPU, the data containing
 * position, size and color of each particle. This makes more sense for the particle system: several thousand 
 * particles can be rendered in a single call to the GPU with all the data associated with the particles in a single
 * array producing highly optimised results.
 * 
 * The Isgl3dParticleSystem contains an array of Isgl3dGLParticles. This means that each particle added to the system
 * can have its own position, color and size. These properties on the Isgl3dParticleSystem therefore make no difference 
 * to the rendered result.
 * 
 * The main objective of the Isgl3dParticleSystem is to optimise the construction of the vertex data arrays to be passed
 * to the GPU.
 */
@interface Isgl3dParticleSystem : Isgl3dGLParticle {
	
@private
	NSMutableArray * _particles;
	
}

@property (readonly) NSArray * particles;

/**
 * Allocates and initialises (autorelease) particle system.
 */
+ (id) particleSystem;

/**
 * Initialises the particle system.
 */
- (id) init;

/**
 * Creates and adds a particle to the particle system.
 * @return The newly created particle.
 */
- (Isgl3dGLParticle *) addParticle;

/**
 * Removes a particle from the particle system.
 * @param particle The particle to be removed.
 */
- (void) removeParticle:(Isgl3dGLParticle *)particle;

/**
 * Returns the number of particles in the system.
 * @return The number of particles.
 */
- (unsigned int)numberOfPoints;

/**
 * Sorts all the particles by decreasing distance from a given point in the same coordinate system as the particle system.
 * This is useful if the particles are transparent and need to be renedered correctly.
 * @param x The x coordinate of the point;
 * @param y The y coordinate of the point;
 * @param z The z coordinate of the point;
 */
- (void) sortDecreasingDistanceFromX:(float)x y:(float)y z:(float)z;

@end
