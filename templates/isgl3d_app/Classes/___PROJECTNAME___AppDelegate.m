//
//  ___PROJECTNAME___AppDelegate.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "___PROJECTNAME___AppDelegate.h"
#import "Isgl3dViewController.h"
#import "HelloWorldView.h"

@implementation ___PROJECTNAME___AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;;

- (void) applicationDidFinishLaunching:(UIApplication*)application {

	[application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated:NO];

	// Create the UIWindow
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Create the UIViewController
	_viewController = [[Isgl3dViewController alloc] initWithNibName:nil bundle:nil];
	
	// Create the specific view (initialises the OpenGL context)
	_viewController.view = [[[HelloWorldView alloc] initWithFrame:[_window bounds]] autorelease];

	// Add view to window and make visible
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];
}

- (void) dealloc {
	[_viewController release];
	[_window release];
	
	[super dealloc];
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
