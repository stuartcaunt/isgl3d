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

@class Isgl3dGLParticle;
@class Isgl3dArray;

/**
 * The Isgl3dParticlePath contains discrete points along the path the associated particle is to follow during its animation.
 * For a given elapsed time, the desired position of the particle is calculated by interpolating between the points, given
 * that when the elapsed time is equal to the duration of the animation, the particle is at the last point in the animation.
 */
@interface Isgl3dParticlePath : NSObject {
	
@private
	Isgl3dGLParticle * _particle;
	Isgl3dArray * _path;
	float _duration;
	
	float _lastTime;
	BOOL _isCompleted; 
	float _delta;
	
}

/**
 * The particle associated with the animated path.
 */
@property (readonly) Isgl3dGLParticle * particle;

/**
 * Indicates whether the particle has reached the last point.
 */
@property (readonly) BOOL isCompleted;

/**
 * Allocates and initialises (autorelease) particle path with an Isgl3dGLParticle, an array of points that make up the path and a duration the 
 * particle is to take to reach the final point.
 * @param particle The particle.
 * @param path An array of position coordinates of the positions along the path.
 * @param duration The duration to move from the first to last point in the path.
 */
+ (id) pathWithParticle:(Isgl3dGLParticle *)particle andPath:(Isgl3dArray *)path forDuration:(float)duration;

/**
 * Initialises the particle path with an Isgl3dGLParticle, an array of points that make up the path and a duration the 
 * particle is to take to reach the final point.
 * @param particle The particle.
 * @param path An array of position coordinates of the positions along the path.
 * @param duration The duration to move from the first to last point in the path.
 */
- (id) initWithParticle:(Isgl3dGLParticle *)particle andPath:(Isgl3dArray *)path forDuration:(float)duration;

/**
 * Called internally by iSGL3D to update the position of the particle.
 * The particle path calculates the elapsed time an performs a linear interpolation between two points to calculate
 * the particle's current position.
 * @param timeDelta The time since the last update in seconds.
 */
- (void) update:(float)timeDelta;

/**
 * Called internally by iSGL3D to restart a particle along its path.
 * Sets the elapsed time to 0 and isCompleted to NO;
 */
- (void) restart;
@end
