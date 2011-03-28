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

#import "Isgl3dFpsDisplay.h"
#import "Isgl3dFpsTracer.h"
#import "Isgl3dGLUI.h"
#import "Isgl3dGLUILabel.h"
#import "Isgl3dView3D.h"

@implementation Isgl3dFpsDisplay


- (id) initWithView:(Isgl3dView3D *)view {
	
    if ((self = [super init])) {

		_view = [view retain];
		_fpsTracer = [[Isgl3dFpsTracer alloc] init];
		_added = NO;
		_counter = 0;
    }
	
    return self;
}

- (void) dealloc {
	[_view release];
	[_fpsLabel release]; 
	
	[super dealloc];
}

- (void) update {
	Isgl3dFpsTracingInfo fpsTracingInfo = [_fpsTracer tick];

	if (_added) {
	
		if (_counter++ == 10) {
			[_fpsLabel setText:[NSString stringWithFormat:@"%3.1f", fpsTracingInfo.fps]];
			_counter = 0;
		}
		
	} else {
		// Get ui
		if (!_view.activeUI) {
			Isgl3dGLUI * ui = [[Isgl3dGLUI alloc] initWithView:_view];
			_view.activeUI = [ui autorelease];
		} 

		if (_view.isLandscape) {
			_position = CGPointMake(8, 290);
		} else {
			_position = CGPointMake(8, 450);
		}

		// add fps label
		_fpsLabel = [[Isgl3dGLUILabel alloc] initWithText:@"0.0" fontName:@"Arial" fontSize:24];
		[_view.activeUI addComponent:_fpsLabel];
		[_fpsLabel setX:_position.x andY:_position.y];
		_fpsLabel.z = -20;
		_fpsLabel.transparent = YES;
		
		_added = YES;
	}
}

- (CGPoint) position {
	return _position;
}

- (void) setPosition:(CGPoint)position {
	_position = position;
	[_fpsLabel setX:position.x andY:position.y];
}

@end
	