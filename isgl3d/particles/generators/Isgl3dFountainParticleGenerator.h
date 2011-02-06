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

#import "Isgl3dParticleGenerator.h"

/*
 * The Isgl3dFountainParticleGenerator is a particle generator used to create a simple fountain effect
 * 
 * It is configurable with a scatter angle (the maximum angle from the y-axis to which particles move), a maximum
 * height for the particles and a time for the particle movement. 
 */
@interface Isgl3dFountainParticleGenerator : Isgl3dParticleGenerator {
	
@private
	float _scatterAngle;
	float _height;
	float _time;
}

/**
 * Maximum angle from the y-axis to which particles move to. Default is 90 degrees.
 */
@property (nonatomic) float scatterAngle;

/**
 * The maximum height in the y direction of the fountain. Default is 7.
 */
@property (nonatomic) float height;

/**
 * The time it takes the particles to move. Default is 2s.
 */
@property (nonatomic) float time;

/*
 * Initialises the generator with a particle system and a particle node.
 * @param particleSystem The particle system.
 * @param node The particle node.
 */
- (id) initWithParticleSystem:(Isgl3dParticleSystem *)particleSystem andNode:(Isgl3dParticleNode *)node;

/**
 * Method to generate particle paths for the given particles to provide the animation: in this case for an fountain animation.
 * @param particles and NSArray of Isgl3dGLParticles for which paths need to be created.
 * @return An NSArray of Isgl3dParticlePaths containing path data for the particles to follow during the animation.
 */
- (NSArray *) generateParticlePaths:(NSArray *)particles;

@end
