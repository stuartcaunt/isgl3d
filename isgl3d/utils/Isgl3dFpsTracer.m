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

#import "Isgl3dFpsTracer.h"

@implementation Isgl3dFpsTracer


- (id) init {
	if ((self = [super init])) {
		
		_lastTime = [[NSDate alloc] init];
		_tickIndex = 0;
		for (int i = 0; i < FPS_TIMES_LENGTH; i++) {
			_times[i] = 0;
		}
	}
	return self;
}

- (void) dealloc {
	[_lastTime dealloc];
	
	[super dealloc];
}
 
- (Isgl3dFpsTracingInfo) tick {
	Isgl3dFpsTracingInfo result;
	
	NSDate * currentTime = [[NSDate alloc] init];
	NSTimeInterval timeInterval = [currentTime timeIntervalSinceDate:_lastTime];
	[_lastTime release];
	_lastTime = currentTime;
	
	_times[_tickIndex++] = timeInterval;
	
	if (_tickIndex >= FPS_TIMES_LENGTH) {
		_tickIndex = 0;
	}
	
	// Calculate average time
	float totalTime = 0;
	for (int i = 0; i < FPS_TIMES_LENGTH; i++) {
		totalTime += _times[i];
	}
	totalTime /= FPS_TIMES_LENGTH;
	result.time = totalTime * 1000.0;
	
	result.fps = 1.0 / totalTime;
	
	return result;	
}

@end
