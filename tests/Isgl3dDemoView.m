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

#import "Isgl3dDemoView.h"
#import "Isgl3dFpsDisplay.h"

@implementation Isgl3dDemoView

- (void) dealloc {

	[_scene release];
	[_camera release];

	[_fpsDisplay release];

	[super dealloc];
}

- (void) initView {

	float clearColor[4] = {0, 0, 0, 1};
    [self prepareView:clearColor];

	_scene = [[Isgl3dScene3D alloc] init];
	[self setActiveScene:_scene];
	
	_camera = [[Isgl3dCamera alloc] initWithView:self];
	[_camera setPerspectiveProjection:45 near:1 far:10000 landscape:NO];
	[_scene addChild:_camera];
	[self setActiveCamera:_camera];
	
	[self setActiveUI:nil];

	_fpsDisplay = [[Isgl3dFpsDisplay alloc] initWithView:self];

}

- (void) initScene {
	

}

- (void) updateScene {

	[_fpsDisplay update];

}


@end

