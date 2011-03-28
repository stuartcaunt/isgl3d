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
#import "Isgl3dView3D.h"

@implementation Isgl3dAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;;

- (void) applicationDidFinishLaunching:(UIApplication*)application {

	[application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated:NO];

	// Create the UIWindow
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Create the UIViewController
	_viewController = [[Isgl3dViewController alloc] initWithNibName:nil bundle:nil];
	
	// Create the specific view (initialises the OpenGL context)
	_viewController.view = [self viewWithFrame:[_window bounds]];

	// Add view to window and make visible
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];
}

- (void) dealloc {
	[_viewController release];
	[_window release];
	
	[super dealloc];
}

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	// override me
	return nil;
}


-(void) applicationWillResignActive:(UIApplication *)application {
	[_viewController stopAnimation];
}

-(void) applicationDidBecomeActive:(UIApplication *)application {
	[_viewController startAnimation];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {	
	[_viewController stopAnimation];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

-(void) applicationSignificantTimeChange:(UIApplication *)application {
}

@end
