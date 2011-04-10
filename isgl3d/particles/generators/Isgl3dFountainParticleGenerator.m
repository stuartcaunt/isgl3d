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

#import "Isgl3dFountainParticleGenerator.h"
#import "Isgl3dParticlePath.h"
#import "Isgl3dGLParticle.h"
#import "Isgl3dArray.h"
#import "Isgl3dVector.h"
#import <stdlib.h>
#import <time.h>

@implementation Isgl3dFountainParticleGenerator

@synthesize scatterAngle = _scatterAngle;
@synthesize height = _height;
@synthesize time = _time;

- (id) initWithParticleSystem:(Isgl3dParticleSystem *)particleSystem andNode:(Isgl3dParticleNode *)node {
	
	if ((self = [super initWithParticleSystem:particleSystem andNode:node])) {
		srandom(time(NULL));
		_scatterAngle = 90;
		_time = 2;
		_height = 7;
	}
	
	return self;
}

- (void) dealloc {

	[super dealloc];
}

- (NSArray *) generateParticlePaths:(NSArray *)particles {
	unsigned int particleNumber = [particles count];
	NSMutableArray * particlePaths = [NSMutableArray arrayWithCapacity:particleNumber];
	
	for (Isgl3dGLParticle * particle in particles) {
		
		float angle = (M_PI / 360.0) * _scatterAngle * random() / RAND_MAX;
		float theta = M_PI * 2.0 * random() / RAND_MAX;
		
		float yEnd = _height * cos(angle);
		float r = _height * sin(angle) * random() / RAND_MAX;
		float xEnd = r * cos(theta);
		float zEnd = r * sin(theta);

		float f = 0.2;
		float g = 2 * (1.0 + 2 * f + 2 * sqrt(f * (1 + f)));
		float v0 = sqrt(2 * g * (1 + f));

		Isgl3dArray * path = IA_ALLOC_INIT_WITH_CAPACITY_AR(Isgl3dVector3, self.nPathSteps);
		for (int i = 0; i < self.nPathSteps; i++) {
			float progression = i / (self.nPathSteps - 1.0);
			
			float x = xEnd * progression;
			float y = yEnd * (v0 * progression - 0.5 * g * progression * progression);
			float z = zEnd * progression;
			
			Isgl3dVector3 pathData = iv3(x, y, z);
			IA_ADD(path, pathData);
		}
		
		Isgl3dParticlePath * particlePath = [Isgl3dParticlePath pathWithParticle:particle andPath:path forDuration:_time];
		[particlePaths addObject:particlePath];
	}
	
	return particlePaths;
}

@end
