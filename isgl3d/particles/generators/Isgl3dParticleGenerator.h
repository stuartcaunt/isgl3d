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

#import <Foundation/Foundation.h>

#define MAX_PARTICLES 1000

@class Isgl3dGLParticle;
@class Isgl3dParticleSystem;
@class Isgl3dParticleNode;
@class Isgl3dParticlePath;

/**
 * The Isgl3dParticleGenerator is the parent class for all particle generators. Sub-classing this class allows for different
 * types of particle generators.
 * 
 * The particle generator allows for different configurations: The maximum number of particles displayed and the particle rate allow 
 * for fine-tuning the number of particles generated. Particles can be given random sizes and colors. The generator can also be
 * told to release itself at the end of the animation to assist in garbage collection.
 * 
 * To improve the performance of the particle generators, the paths of the particles are pre-generated. The Isgl3dParticlePath contains 
 * an array of points along the path and the current position is interpolated for the given time. To avoid excessive creation and destruction
 * of particles, when a particle reaches the end of its animation it restarts along the same path (unless the generator is "self destruction"
 * for which the animation occurs just once).
 * 
 */
@interface Isgl3dParticleGenerator : NSObject {
	
@private
	Isgl3dParticleSystem * _particleSystem;
	Isgl3dParticleNode * _particleNode;

	unsigned int _nParticles;
	unsigned int _maxParticles;
	unsigned int _particleRate;
	
	BOOL _animating;
	NSInteger _animationFrameInterval;
    NSTimer * _animationTimer;

	BOOL _randomizeColor;
	float _size;
	BOOL _randomizeSize;
	
	float _lastTime;
	float _precTime;
	
	BOOL _selfDestructing;
	Isgl3dParticleGenerator * _instance;
	
	NSMutableArray * _particlePaths;

	int _nPathSteps;
	
}

/**
 * Returns the current number of particles on the screen.
 */
@property (readonly) unsigned int nParticles;

/**
 * Defines the maximum number of particles to be displayed. Default is 1000.
 */
@property (nonatomic) unsigned int maxParticles;

/**
 * Defines the rate of generation of particles. Default is 200 per second.
 */
@property (nonatomic) unsigned int particleRate;

/**
 * If set, will randomize the color of the particles. Default is NO.
 */
@property (nonatomic) BOOL randomizeColor;

/**
 * Sets the size of the particles, or the maximum size if randomizeSize is selection. Default is 4.
 */
@property (nonatomic) float size;

/**
 * If set, will randomize the size of the particles (up to the maximum defined by size). Default is NO.
 */
@property (nonatomic) BOOL randomizeSize;

/**
 * Specifies that the particle generator should release itself after all particle animations have terminated.
 * This releives the developers from releasing the generator themselves.
 */
@property (nonatomic) BOOL selfDestructing;

/**
 * Defines the number of discrete points are contained in the Isgl3dParticlePath. Default is 100.
 */
@property (nonatomic) int nPathSteps;


/*
 * Allocates and initialises (autorelease) generator with a particle system and a particle node.
 * @param particleSystem The particle system.
 * @param node The particle node.
 */
+ (id) generatorWithParticleSystem:(Isgl3dParticleSystem *)particleSystem andNode:(Isgl3dParticleNode *)node;

/*
 * Initialises the generator with a particle system and a particle node.
 * @param particleSystem The particle system.
 * @param node The particle node.
 */
- (id) initWithParticleSystem:(Isgl3dParticleSystem *)particleSystem andNode:(Isgl3dParticleNode *)node;

/**
 * Starts the animation.
 */
- (void) startAnimation;

/**
 * Stops the animation.
 */
- (void) stopAnimation;

/**
 * Specifies the animation frame interval, the number of frames that should be skipped before updating the
 * animation. By default this is 1 implying a desired frame rate of 60fps. A value of 2 would produce 30fps.
 * @param frameInterval The interval between frames to update the animation. 
 */
- (void) setAnimationFrameInterval:(NSInteger)frameInterval;

/**
 * Method to generate particle paths for the given particles to provide the animation.
 * This is overloaded by extended classes in which new Isgl3dParticlePaths are created at the given
 * frame rate. Once the maximum number of particles has been reached the particle paths are re-used
 * to improve performance (avoids unnecessary creation and destruction of objects).
 * @param particles and NSArray of Isgl3dGLParticles for which paths need to be created.
 * @return An NSArray of Isgl3dParticlePaths containing path data for the particles to follow during the animation.
 */
- (NSArray *) generateParticlePaths:(NSArray *)particles;


@end
