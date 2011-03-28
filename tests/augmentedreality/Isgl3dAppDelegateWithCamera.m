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

#import "Isgl3dAppDelegateWithCamera.h"
#import "Isgl3dViewController.h"

@implementation Isgl3dAppDelegateWithCamera

- (void) applicationDidFinishLaunching:(UIApplication*)application {
	[super applicationDidFinishLaunching:application];
	
	// Create a UIImagePickerController for the camera view
	UIImagePickerController * cameraController = [[[UIImagePickerController alloc] init] autorelease];
	
	// Check if camera available
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		// Use camera
		cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
		cameraController.showsCameraControls = NO;
	
		// Scale camera to fill full screen
		cameraController.cameraViewTransform = CGAffineTransformScale(cameraController.cameraViewTransform, 1.33, 1.33);
	
	} else {
		// Use photo album
		cameraController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	}
	
	// Add camera view to window and send to back
	[self.window addSubview:cameraController.view];
	[self.window sendSubviewToBack:cameraController.view];
	
	// Make the opengl view transparent
	self.viewController.view.backgroundColor = [UIColor clearColor];
	self.viewController.view.opaque = NO;
}

- (void) dealloc {
	
	[super dealloc];
}


@end
