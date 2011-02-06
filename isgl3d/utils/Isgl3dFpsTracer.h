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

#define FPS_TIMES_LENGTH 20

/**
 * Structure containing data for the current tick.
 */
typedef struct {
	/**
	 * Number of Frame Per Second.
	 */
	float fps;
	
	/**
	 * Time, in milli-seconds, of the traced code sequence.
	 */
	float time;
} Isgl3dFpsTracingInfo;

/**
 * The Isgl3dFpsTracer is a utility class for measuring the actual frames-per-second of the application.
 * 
 * The method "tick" should be called at every frame: when this is called the time since the last call is
 * calculated. The time intervals are averaged over the last 20 frames and the fps is calculated. 
 */
@interface Isgl3dFpsTracer : NSObject {
	
@private
	float _times[FPS_TIMES_LENGTH];
	NSDate * _lastTime;
	
	unsigned long _tickIndex;
}

/**
 * Initialises the Isgl3dFpsTracer.
 */
- (id) init;

/**
 * Calculates the time interval since the last "tick" call. The resulting Isgl3dFpsTracingInfo provides
 * an average over the last 20 frames.
 * @return The Isgl3dFpsTracingInfo containing the frames per second and the average time (in milliseconds) between frames.
 */
- (Isgl3dFpsTracingInfo) tick;


@end
