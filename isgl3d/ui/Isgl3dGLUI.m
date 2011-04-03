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

#import "Isgl3dGLUI.h"
#import "Isgl3dGLUIComponent.h"
#import "Isgl3dNode.h"
#import "Isgl3dView3D.h"
#import "Isgl3dGLU.h"
#import "Isgl3dGLRenderer.h"

@implementation Isgl3dGLUI


- (id) initWithView:(Isgl3dView3D *)view {
	if ((self = [super init])) {
		_view = [view retain];
		

		int width = view.width;
		int height = view.height;

		_viewMatrix = [Isgl3dGLU lookAt:0 eyey:0 eyez:1 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:1];
		_projectionMatrix = [Isgl3dGLU ortho:0 right:width bottom:0 top:height near:1 far:1000 zoom:1 landscape:view.isLandscape];
		
		_uiElements = [[Isgl3dNode alloc] init];
	}
	return self;
}

- (void) dealloc {
	[_view release];	
	
	[_uiElements release];
	
	[super dealloc];
}


- (void) addComponent:(Isgl3dGLUIComponent *)component {
	[_uiElements addChild:component];
}

- (void) render:(Isgl3dGLRenderer *)renderer {
	// Set view/projection matrices
	[renderer setProjectionMatrix:&_projectionMatrix];
	[renderer setViewMatrix:&_viewMatrix];
	
	// Update transformations
	[_uiElements updateWorldTransformation:nil];

	// Render opaque elements
	[_uiElements render:renderer opaque:true];
	
	// Render transparent elements
	[_uiElements render:renderer opaque:false];
}

- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer {

	// Set view/projection matrices
	[renderer setProjectionMatrix:&_projectionMatrix];
	[renderer setViewMatrix:&_viewMatrix];
	
	[_uiElements renderForEventCapture:renderer];
}



@end
