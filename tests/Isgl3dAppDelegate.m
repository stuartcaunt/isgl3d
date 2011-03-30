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

#import "Isgl3dAppDelegate.h"
#import "Isgl3dViewController.h"
#import "Isgl3d.h"

@implementation Isgl3dAppDelegate

@synthesize window = _window;

- (void) applicationDidFinishLaunching:(UIApplication*)application {

	// Create the UIWindow
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Instantiate the Isgl3dDirector and set background color
	[Isgl3dDirector sharedInstance].backgroundColorString = @"333333ff"; 

	// Set the director to display the FPS
	[Isgl3dDirector sharedInstance].displayFPS = YES; 

	// Create the UIViewController
	_viewController = [[Isgl3dViewController alloc] initWithNibName:nil bundle:nil];
	_viewController.wantsFullScreenLayout = YES;
	
	// Create OpenGL view (here for OpenGL ES 1.1)
	Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrameForES1:[_window bounds]];

	// Set view in director
	[Isgl3dDirector sharedInstance].openGLView = glView;
	
	// Add the OpenGL view to the view controller
	_viewController.view = glView;
	
	// Set the animation frame rate
	[[Isgl3dDirector sharedInstance] setAnimationInterval:1.0/60];

	// Creates the view(s) and adds them to the director
	[self createViews];

	// Add view to window and make visible
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];
	
	// Run the director
	[[Isgl3dDirector sharedInstance] run];
}

- (void) dealloc {
	if (_viewController) {
		[_viewController release];
	}
	if (_window) {
		[_window release];
	}
	
	[super dealloc];
}

- (void) createViews {
	// Implement in sub-classes
}

- (void) applicationWillResignActive:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] pause];
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] resume];
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] stopAnimation];
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] startAnimation];
}

- (void) applicationWillTerminate:(UIApplication *)application {
	// Remove the OpenGL view from the view controller
	[[Isgl3dDirector sharedInstance].openGLView removeFromSuperview];
	
	// End and reset the director	
	[Isgl3dDirector resetInstance];
	
	// Release
	[_viewController release];
	_viewController = nil;
	[_window release];
	_window = nil;
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] onMemoryWarning];
}

- (void) applicationSignificantTimeChange:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] onSignificantTimeChange];
}

@end
