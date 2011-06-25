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
#import "Isgl3dParticlePath.h"
#import "Isgl3dParticleNode.h"
#import "Isgl3dParticleSystem.h"
#import "Isgl3dGLParticle.h"

@interface Isgl3dParticleGenerator (PrivateMethods)
- (void) updateParticles;
- (Isgl3dGLParticle *)createParticle;
- (void) removeParticle:(Isgl3dGLParticle *)particle;
@end

@implementation Isgl3dParticleGenerator

@synthesize nParticles = _nParticles;
@synthesize maxParticles = _maxParticles;
@synthesize particleRate = _particleRate;
@synthesize randomizeColor = _randomizeColor;
@synthesize size = _size;
@synthesize randomizeSize = _randomizeSize;
@synthesize nPathSteps = _nPathSteps;


+ (id) generatorWithParticleSystem:(Isgl3dParticleSystem *)particleSystem andNode:(Isgl3dParticleNode *)node {
	return [[[self alloc] initWithParticleSystem:particleSystem andNode:node] autorelease];
}

- (id) initWithParticleSystem:(Isgl3dParticleSystem *)particleSystem andNode:(Isgl3dParticleNode *)node {
	
	if ((self = [super init])) {
		_particleSystem = [particleSystem retain];
		_particleNode = [node retain];

		_nParticles = 0;
		_maxParticles = MAX_PARTICLES;
		_particleRate = 200;
		
		_animating = FALSE;
		_animationFrameInterval = 1;
		_animationTimer = nil;
		
		_randomizeColor = NO;
		_size = 4;
		_randomizeSize = NO;
		
		_lastTime = 0;
		_precTime = 0;
		
		_nPathSteps = 100;
		_particlePaths = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	[_particleSystem release];
	[_particleNode release];
	[_particlePaths release];
		
	[super dealloc];
}

- (void) startAnimation {
	// Check to see if animation already happening
	if (!_animating) {
		_animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * _animationFrameInterval) target:self selector:@selector(updateParticles) userInfo:nil repeats:TRUE];
		
		_animating = TRUE;
	}	
}

- (void) stopAnimation {
	if (_animating) {
		[_animationTimer invalidate];
		_animationTimer = nil;
		_animating = FALSE;
	}	
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval {
	if (frameInterval >= 1) {
		_animationFrameInterval = frameInterval;
		
		if (_animating) {
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void) updateParticles {
	float timeDelta = ((1.0 / 60.0) * _animationFrameInterval);
	float newTime = _precTime + timeDelta;
	
	NSMutableArray * finishedPaths = [[NSMutableArray alloc] init];
	
	// update existing particles
	for (Isgl3dParticlePath * particlePath in _particlePaths) {
		[particlePath update:timeDelta];
		
		if (particlePath.isCompleted) {
			[finishedPaths addObject:particlePath];
		}
	}
	
	if (_selfDestructing) {
		for (Isgl3dParticlePath * particlePath in finishedPaths) {
			[self removeParticle:particlePath.particle];
			[_particlePaths removeObject:particlePath];
		}
	} else {
		for (Isgl3dParticlePath * particlePath in finishedPaths) {
			[particlePath restart];
		}
	}
	[finishedPaths release];
	
	// Self destruct	
	if (_nParticles == 0 && _selfDestructing) {
		[_particleNode removeFromParent];
		[self stopAnimation];
		[_instance release];
		
	} else if (!_selfDestructing) {
		
		// Create new ones
		float timeInterval = newTime - _lastTime;
		unsigned int particleNumber = floorf(_particleRate * timeInterval);

        		
		if (particleNumber != 0) {
			_lastTime = newTime;
            _precTime = _lastTime;
			
			if (_nParticles + particleNumber > _maxParticles) {
				particleNumber = _maxParticles - _nParticles;
			}
			
			// Create the required number of particles
			NSMutableArray * particles = [NSMutableArray arrayWithCapacity:particleNumber];
			for (int i = 0; i < particleNumber; i++) {
				[particles addObject:[self createParticle]];
			}
			
			// Generate the particle paths
			NSArray * particlePaths = [self generateParticlePaths:particles];
			for (Isgl3dParticlePath * particlePath in particlePaths) {
				[_particlePaths addObject:particlePath];
			}
		} else {
			_precTime = newTime;
		}    
	}	
	
}

- (NSArray *) generateParticlePaths:(NSArray *)particles {
	return nil;
}

- (Isgl3dGLParticle *) createParticle {
	Isgl3dGLParticle * particle = [_particleSystem addParticle];
	if (_randomizeColor) {
		[particle setColor:(1.0 * random() / RAND_MAX) g:(1.0 * random() / RAND_MAX) b:(1.0 * random() / RAND_MAX)];
	}
	if (_randomizeSize) {
		[particle setSize:(_size * random() / RAND_MAX)];
	} else {
		[particle setSize:_size];
	}


	_nParticles += 1;
	
	return particle;
}

- (void) removeParticle:(Isgl3dGLParticle *)particle {
	[_particleSystem removeParticle:particle];
	_nParticles -= 1;

}

- (BOOL) selfDestructing {
	return _selfDestructing;
}

- (void) setSelfDestructing:(BOOL)isSelfDestructing {
	// Release old instance if no longer self destructing
	if (_selfDestructing) {
		[_instance release];
	}
	
	_selfDestructing = isSelfDestructing;
	if (_selfDestructing) {
		_instance = self;
		[_instance retain];
	}
}


@end
