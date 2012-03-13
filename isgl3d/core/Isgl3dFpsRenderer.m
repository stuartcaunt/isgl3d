/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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

#import "Isgl3dFpsRenderer.h"
#import "Isgl3dGLUILabel.h"
#import "Isgl3dGLU.h"
#import "Isgl3dDirector.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dMatrix4.h"
#import "Isgl3dOverlayCamera.h"


@interface Isgl3dFpsRenderer () {
@private
	Isgl3dGLUILabel * _fpsLabel;
	int _displayCounter;
	float _deltaTimes[ISGL3D_FPS_N_TICKS];
	float _fps;
	unsigned long _tickIndex;
}
@end


#pragma mark -
@implementation Isgl3dFpsRenderer 

- (id)init {
	if (self = [super init]) {

		// Initialise fps calculation
		_displayCounter = 0;
		_tickIndex = 0;
		for (int i = 0; i < ISGL3D_FPS_N_TICKS; i++) {
			_deltaTimes[i] = 0;
		}

		// Initialise label
		_fpsLabel = [[Isgl3dGLUILabel alloc] initWithText:@"0.0" fontName:@"Helvetica" fontSize:24];
		[_fpsLabel setX:8 andY:8];
		_fpsLabel.transparent = YES;
	}
    return self;
}

- (void)dealloc {
	[_fpsLabel release];
    _fpsLabel = nil;

	[super dealloc];
}

- (void)update:(float)dt andRender:(Isgl3dGLRenderer *)renderer overlayCamera:(Isgl3dOverlayCamera *)overlayCamera isPaused:(BOOL)isPaused {

	if (!isPaused) {
		// Update fps calculation
		_deltaTimes[_tickIndex++] = dt;
		
		if (_tickIndex >= ISGL3D_FPS_N_TICKS) {
			_tickIndex = 0;
		}
		
		// Calculate average dt
		float averageDt = 0;
		for (int i = 0; i < ISGL3D_FPS_N_TICKS; i++) {
			averageDt += _deltaTimes[i];
		}
		averageDt /= ISGL3D_FPS_N_TICKS;
		
		// Calculate average fps
		_fps = 1.0 / averageDt;
	
		// Update the label text
		_displayCounter++;
		if (_displayCounter == 0 || _displayCounter == 10) {
			[_fpsLabel setText:[NSString stringWithFormat:@"%3.1f", _fps]];
			_displayCounter = 0;
		}

	} else {
		if (_displayCounter != -1) {
			// Set the label text to "paused"
			[_fpsLabel setText:[NSString stringWithFormat:@"paused", _fps]];
			_displayCounter = -1;
		}
	}

	// Update model transformation for label
	[_fpsLabel updateWorldTransformation:nil];
	
	// Clear the depth buffer
	[renderer clear:(ISGL3D_DEPTH_BUFFER_BIT) viewport:overlayCamera.viewport];

	// Cleanup from last render
	[renderer clean];

	// Set view and projection matrices
    Isgl3dMatrix4 projectionMatrix = overlayCamera.projectionMatrix;
    Isgl3dMatrix4 viewMatrix = overlayCamera.viewMatrix;
    
	[renderer setProjectionMatrix:&projectionMatrix];
	[renderer setViewMatrix:&viewMatrix];

	// Render label
	[_fpsLabel render:renderer opaque:NO];

}
@end
