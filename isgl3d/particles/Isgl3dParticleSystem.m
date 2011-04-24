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

#import "Isgl3dParticleSystem.h"
#import "Isgl3dGLParticle.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"


@implementation Isgl3dParticleSystem

@synthesize particles = _particles;

+ (id) particleSystem {
	return [[[self alloc] init] autorelease];
}

- (id) init {
	
	if ((self = [super init])) {
		_particles = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	[_particles release];
	
	[super dealloc];
}

- (Isgl3dGLParticle *) addParticle {
	Isgl3dGLParticle * particle = [[Isgl3dGLParticle alloc] init];
	[_particles addObject:particle];
	[particle release];
	
	_dirty = YES;
	return particle;
}

- (void) removeParticle:(Isgl3dGLParticle *)particle {
	[_particles removeObject:particle];
	
	_dirty = YES;
}

- (unsigned int)numberOfPoints {
	return [_particles count];
}

- (void) update {
	_dirty = YES;
}

- (void) fillArrays {
	int counter = 0;
	for (Isgl3dGLParticle * particle in _particles) {
		[_vertexData add:particle.x];
		[_vertexData add:particle.y];
		[_vertexData add:particle.z];
	
		[_vertexData add:[particle color][0]];
		[_vertexData add:[particle color][1]];
		[_vertexData add:[particle color][2]];
		[_vertexData add:[particle color][3]];
	
		[_vertexData add:particle.size];
	
		[_indices add:counter++];
	}
}

- (void) sortDecreasingDistanceFromX:(float)x y:(float)y z:(float)z {
	for (Isgl3dGLParticle * particle in _particles) {
		[particle calculateDistanceFromX:x y:y z:z];
	}	
	
	[_particles sortUsingSelector:@selector(compareDistances:)];
}

- (void) prepareForEventCapture:(float)r g:(float)g b:(float)b {
	for (Isgl3dGLParticle * particle in _particles) {
		[particle prepareForEventCapture:r g:g b:b];
	}	
	[self buildArrays];
}

- (void) restoreRenderColor {
	for (Isgl3dGLParticle * particle in _particles) {
		[particle restoreRenderColor];
	}	
	_dirty = YES;
}


@end
