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

#import "Isgl3dGLUIComponent.h"
#import "Isgl3dNode.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dDirector.h"

@implementation Isgl3dGLUIComponent

@synthesize x = _x;
@synthesize y = _y;
@synthesize width = _width;
@synthesize height = _height;
@synthesize visible = _isVisible;
@synthesize fixLeft = _fixLeft;
@synthesize fixTop = _fixTop;
@synthesize centerX = _centerX;
@synthesize centerY = _centerY;
 
- (id) initWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material {
	if ((self = [super initWithMesh:mesh andMaterial:material])) {
		_x = 0;
		_y = 0;
		self.z = GLUICOMPONENT_DEFAULT_DEPTH;
		_width = 0;
		_height = 0;
		_meshDirty = YES;
		
		_isVisible = YES;
		
		_fixLeft = YES;
		_fixTop = YES;
		_centerX = NO;
		_centerY = NO;
		self.lightingEnabled = NO;
	}
	return self;
}

- (void) dealloc {
	
	[super dealloc];
}

- (void) setX:(unsigned int)x andY:(unsigned int)y {
	_x = x * [Isgl3dDirector sharedInstance].contentScaleFactor;
	_y = y * [Isgl3dDirector sharedInstance].contentScaleFactor;
	_meshDirty = YES;
}

- (void) setWidth:(unsigned int)width andHeight:(unsigned int)height {
	_width = width * [Isgl3dDirector sharedInstance].contentScaleFactor;
	_height = height * [Isgl3dDirector sharedInstance].contentScaleFactor;
	_meshDirty = YES;
}

- (void) updateGlobalTransformation:(Isgl3dMatrix4D *)parentTransformation {
	if (_meshDirty) {
		float x;
		float y;
		if (_centerX) {
			x = 1.0 * _x;
		} else {
			if (_fixLeft) {
				x = _x + (_width + 1)/ 2;
			} else {
				x = _x + _width / 2;
			}
		}
		
		if (_centerY) {
			y = _y;
		} else {
			if (_fixTop) {
				y = (float)(_y + (_height + 1) / 2);
			} else {
				y = (float)(_y + _height / 2);
			}
		}
				
		[self setTranslation:x y:y z:self.z];
//		NSLog(@"setting x = %f y = %f z = %f", x, y, self.z);
//		[self setTranslation:x y:y z:-0.1];
		
		_meshDirty = NO;
	}
	
	[super updateGlobalTransformation:parentTransformation];
}

- (void) render:(Isgl3dGLRenderer *)renderer opaque:(BOOL)opaque {
	if (_isVisible) {
		[super render:renderer opaque:opaque];
	}
}

- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer {
	if (_isVisible) {
		[super renderForEventCapture:renderer];
	}
}

@end
