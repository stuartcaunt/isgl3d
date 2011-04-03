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

#import "Isgl3dFpsRenderer.h"
#import "Isgl3dGLUILabel.h"
#import "Isgl3dGLU.h"
#import "Isgl3dDirector.h"
#import "Isgl3dGLRenderer.h"

@implementation Isgl3dFpsRenderer 

- (id) initWithOrientation:(isgl3dOrientation)orientation {
	if ((self = [super init])) {

		_orientation = orientation;
		
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

		// Get viewport from director
		_viewportInPixels = [Isgl3dDirector sharedInstance].windowRectInPixels;
		
		// Create view and projection matrices
		_viewMatrix = [Isgl3dGLU lookAt:0 eyey:0 eyez:1 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:1];
		_projectionMatrix = [Isgl3dGLU ortho:0 right:_viewportInPixels.size.width bottom:0 top:_viewportInPixels.size.height near:1 far:1000 zoom:1 orientation:orientation];
		
	}
    return self;
}

- (void) dealloc {
	[_fpsLabel release];

	[super dealloc];
}

- (isgl3dOrientation)orientation {
	return _orientation;
}

- (void) setOrientation:(isgl3dOrientation)orientation {
	
	// Update projection matrix
	_orientation = orientation;
	_projectionMatrix = [Isgl3dGLU ortho:0 right:_viewportInPixels.size.width bottom:0 top:_viewportInPixels.size.height near:1 far:1000 zoom:1 orientation:orientation];
}

- (void) updateViewport {
	// Get viewport from director
	_viewportInPixels = [Isgl3dDirector sharedInstance].windowRectInPixels;
	
	// Update projection matrix
	_projectionMatrix = [Isgl3dGLU ortho:0 right:_viewportInPixels.size.width bottom:0 top:_viewportInPixels.size.height near:1 far:1000 zoom:1 orientation:_orientation];
}

- (void) update:(float)dt andRender:(Isgl3dGLRenderer *)renderer isPaused:(BOOL)isPaused {

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
	[renderer clear:(ISGL3D_DEPTH_BUFFER_BIT) viewport:_viewportInPixels];

	// Cleanup from last render
	[renderer clean];

	// Set view and projection matrices
	[renderer setProjectionMatrix:&_projectionMatrix];
	[renderer setViewMatrix:&_viewMatrix];

	// Render label
	[_fpsLabel render:renderer opaque:NO];

}
@end
