#import "AppDelegate.h"
#import "HelloWorldView.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "RootViewController.h"
#import "Isgl3dCCGLView.h"
#import "CCDirector+Isgl3d.h"
#import "cocos2d.h"

@interface AppDelegate ()
- (void) initialiseIsgl3d:(Isgl3dCCGLView *)glView;
- (void) initialiseCocos2d:(Isgl3dCCGLView *)glView;
@end

@implementation AppDelegate

@synthesize window = _window;

- (void) applicationDidFinishLaunching:(UIApplication*)application {

	// Create the UIWindow
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// Create the UIViewController
	_viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	_viewController.wantsFullScreenLayout = YES;
	
	// Create cocos2d OpenGL view, modified to run with iSGL3D.
	Isgl3dCCGLView * glView = [Isgl3dCCGLView viewWithFrame:[_window bounds] pixelFormat:kEAGLColorFormatRGB565 depthFormat:GL_DEPTH_COMPONENT16_OES];

	// Initialise both directors
	[self initialiseCocos2d:glView];
	[self initialiseIsgl3d:glView];
	
	// Add callbacks to render cocos2d during isgl3d render loop
	[Isgl3dDirector sharedInstance].renderPhaseCallback = self;

	// Add the OpenGL view to the view controller
	_viewController.view = glView;

	// Add view to window and make visible
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];

	// Creates the view(s) and adds them to the Isgl3dDirector
	[[Isgl3dDirector sharedInstance] addView:[HelloWorldView view]];	

	// Create scene for Cocos2d director
	[[CCDirector sharedDirector] pushScene: [HelloWorldLayer scene]];
	
	// Run the Isgl3dDirector
	[[Isgl3dDirector sharedInstance] run];
}

- (void) dealloc {
	if (_viewController) {
		[_viewController release];
	}
	if (_window) {
		[_window release];
	}
	[[CCDirector sharedDirector] end];
	[super dealloc];
}

- (void) initialiseIsgl3d:(Isgl3dCCGLView *)glView {
	// Instantiate the Isgl3dDirector and set background color
	[Isgl3dDirector sharedInstance].backgroundColorString = @"222222FF"; 

	// Set the director to display the FPS
	[Isgl3dDirector sharedInstance].displayFPS = YES; 

	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;

	// Set view in director
	[Isgl3dDirector sharedInstance].openGLView = glView;
	
	// Set the animation frame rate
	[[Isgl3dDirector sharedInstance] setAnimationInterval:1.0/60];
}

- (void) initialiseCocos2d:(Isgl3dCCGLView *)glView {
	CCDirector *director = [CCDirector sharedDirector];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// Set the device orientation
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
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
	
	// End and reset Isgl3dDirector	
	[Isgl3dDirector resetInstance];

	// End CCDirector
	[[CCDirector sharedDirector] end];	

	// Release
	[_viewController release];

	[_window release];
	_window = nil;
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] onMemoryWarning];
	[[CCDirector sharedDirector] purgeCachedData];
}

- (void) applicationSignificantTimeChange:(UIApplication *)application {
	[[Isgl3dDirector sharedInstance] onSignificantTimeChange];
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) preRender {
	// not needed
}

- (void) postRender {
	// Render the cocos2d scene
	[[CCDirector sharedDirector] drawSceneForIsgl3d];
}

@end
