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

#import "Isgl3dParticlePath.h"
#import "Isgl3dGLParticle.h"
#import "Isgl3dArray.h"
#import "Isgl3dVector.h"

@implementation Isgl3dParticlePath

@synthesize particle = _particle;
@synthesize isCompleted = _isCompleted;

+ (id) pathWithParticle:(Isgl3dGLParticle *)particle andPath:(Isgl3dArray *)path forDuration:(float)duration {
	return [[[self alloc] initWithParticle:particle andPath:path forDuration:duration] autorelease];
}

- (id) initWithParticle:(Isgl3dGLParticle *)particle andPath:(Isgl3dArray *)path forDuration:(float)duration {
	
	if ((self = [super init])) {
		_particle = particle;
		[particle retain];
		
		_path = path;
		[path retain];
		
		_duration = duration;
		
		_lastTime = 0;
		_isCompleted = NO;
		
		_delta = 1.0 / ([_path count] - 1.0);
	}
	
	return self;
}

- (void) dealloc {
	[_particle release];
	
	[_path release];

	[super dealloc];
}

- (void) update:(float)timeDelta {
	_lastTime = _lastTime + timeDelta;
	float timeInterval = _lastTime;
	
	// Check to see if this is the last tween
	if (timeInterval >= _duration) {
		timeInterval = _duration;
		
		_isCompleted = YES;
	}

	if (!_isCompleted) {
		float progress = timeInterval / _duration;
		int step = floor(progress / _delta);
		float innerProgress = (progress - (step * _delta)) / _delta;
		
		Isgl3dVector3 * data1 = IA_GET_PTR(Isgl3dVector3 *, _path, step);
		Isgl3dVector3 * data2 = IA_GET_PTR(Isgl3dVector3 *, _path, step + 1);
//		Isgl3dParticlePathData * data1 = [_path objectAtIndex:step];
//		Isgl3dParticlePathData * data2 = [_path objectAtIndex:step + 1];
		
		_particle.x = data1->x + (data2->x - data1->x) * innerProgress;
		_particle.y = data1->y + (data2->y - data1->y) * innerProgress;
		_particle.z = data1->z + (data2->z - data1->z) * innerProgress;

	} else {
		Isgl3dVector3 * data = IA_GET_PTR(Isgl3dVector3 *, _path, [_path count] - 1);
//		Isgl3dParticlePathData * data = [_path objectAtIndex:[_path count] - 1];
		
		_particle.x = data->x;
		_particle.y = data->y;
		_particle.z = data->z;
	}
}

- (void) restart {
	_lastTime = 0;
	_isCompleted = NO;
}

@end
