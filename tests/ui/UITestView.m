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

#import "UITestView.h"

@interface UITestView ()
- (void) buildUI;
@end

@implementation UITestView

- (void) dealloc {

	[super dealloc];
}

- (void) initView {
	[super initView];

	self.isLandscape = YES;

}

- (void) initScene {
	[super initScene];
	
	// Build the UI
	[self buildUI];
}

- (void) updateScene {
	[super updateScene];

}

- (void) buildUI {
	Isgl3dGLUI * ui = [[Isgl3dGLUI alloc] initWithView:self];

	// Create a button to calibrate the accelerometer
	Isgl3dTextureMaterial * calibrateButtonMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"angle.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dGLUIButton * calibrateButton = [[Isgl3dGLUIButton alloc] initWithMaterial:[calibrateButtonMaterial autorelease]];
	[ui addComponent:calibrateButton];
	[calibrateButton setX:8 andY:8];

	// Create a button to pause the scene
	Isgl3dTextureMaterial * pauseButtonMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"pause.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dGLUIButton * pauseButton = [[Isgl3dGLUIButton alloc] initWithMaterial:[pauseButtonMaterial autorelease]];
	[ui addComponent:pauseButton];
	[calibrateButton setX:400 andY:8];

	// Create a button to allow movement of the camera
	Isgl3dTextureMaterial * cameraButtonMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"camera.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dGLUIButton * cameraButton = [[Isgl3dGLUIButton alloc] initWithMaterial:[cameraButtonMaterial autorelease]];
	[ui addComponent:cameraButton];
	[cameraButton setX:400 andY:260];

	// Activate the ui
	[self setActiveUI:ui];
}

@end



#pragma mark AppController

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppController

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[UITestView alloc] initWithFrame:frame] autorelease];
}

@end
