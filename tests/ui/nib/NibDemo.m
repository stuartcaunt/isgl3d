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

#import "NibDemo.h"
#import "TestViewController.h"
#import "Isgl3dViewController.h"


#pragma mark UIHUDView

@implementation UIHUDView

- (id) init {
	
	if ((self = [super init])) {
		Isgl3dGLUIButton * button = [Isgl3dGLUIButton buttonWithMaterial:nil];
		[self.scene addChild:button];
		[button setX:8 andY:self.viewport.size.height/2];
		[button addEvent3DListener:self method:@selector(buttonPressed:) forEventType:TOUCH_EVENT];
        
	}
	
	return self;
}

- (void) dealloc {
    
	[super dealloc];
}

- (void) buttonPressed:(Isgl3dEvent3D *)event {
	NSLog(@"Button pressed");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate) {
        [appDelegate switchViews];
    }    
}


@end


#pragma mark NibDemoe

@implementation NibDemo

- (id) init {
	
    
    if ((self = [super init])) {
        
        // Translate the camera.
        [self.camera setPosition:iv3(0, 3, 7)];
        
		// Create an Isgl3dMultiMaterialCube with random colors.
		_cube = [Isgl3dMultiMaterialCube cubeWithDimensionsAndRandomColors:3 height:3 depth:3 nSegmentWidth:2 nSegmentHeight:2 nSegmentDepth:2];
		
		// Add the cube to the scene.
		[self.scene addChild:_cube];
        
        [self schedule:@selector(tick:)];
    }
	
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}


- (void) tick:(float)dt {
	// Rotate the cube around the y axis
	_cube.rotationY += 1;

}


@end



#pragma mark AppDelegate

@implementation AppDelegate

@synthesize testViewController = _testViewController;


- (void) applicationDidFinishLaunching:(UIApplication*)application {
    
	// Instantiate the Isgl3dDirector and set background color
	[Isgl3dDirector sharedInstance].backgroundColorString = @"333333ff"; 
    
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;
    
	// Set the director to display the FPS
	[Isgl3dDirector sharedInstance].displayFPS = YES; 
    
    
    // Specify auto-rotation strategy if required (for example via the UIViewController and only landscape)
    [Isgl3dDirector sharedInstance].autoRotationStrategy = Isgl3dAutoRotationByUIViewController;
    [Isgl3dDirector sharedInstance].allowedAutoRotations = Isgl3dAllowedAutoRotationsLandscapeOnly;
    
    // Enable retina display : uncomment if desired
    //	[[Isgl3dDirector sharedInstance] enableRetinaDisplay:YES];
    
    // Enables anti aliasing (MSAA) : uncomment if desired (note may not be available on all devices and can have performance cost)
    //	[Isgl3dDirector sharedInstance].antiAliasingEnabled = YES;
    
    // Set the animation frame rate
    [[Isgl3dDirector sharedInstance] setAnimationInterval:1.0/60];
 
    
    // Create the UIWindow
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    

    // Create the controller with the provided nib file TestView.xib
    self.testViewController = [[TestViewController alloc] initWithNibName:@"TestView" bundle:nil];
    self.testViewController.wantsFullScreenLayout = YES;
	// Add the view of the controller to the window and make it visible
  	[self.window addSubview:self.testViewController.view];
	[self.window makeKeyAndVisible];
    
	
	// Run the director
	[[Isgl3dDirector sharedInstance] run];
}


- (void) dealloc {
	[_testViewController release];
	[super dealloc];
}




/** A very simple method to show how interaction between a isgl3d and
 * a UIViewController can be implemented. This method just switch between
 * the TestViewController and the UIViewController that has the Isgl3dEAGLView instance
 * assigned. 
 */
- (void) switchViews
{
    if (self.viewController == nil || self.viewController.view.superview == nil) {
        [self.testViewController.view removeFromSuperview];
        
        if (!self.viewController)
        {
            // Create the UIViewController
            self.viewController = [[Isgl3dViewController alloc] initWithNibName:nil bundle:nil];
            self.viewController.wantsFullScreenLayout = YES;
            
            // Create OpenGL view (here for OpenGL ES 1.1)
            Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrameForES1:[self.window bounds]];
            
            // Set view in director
            [Isgl3dDirector sharedInstance].openGLView = glView;
            
            // Add the OpenGL view to the view controller
            self.viewController.view = glView;
            
            // Creates the view and adds them to the director
            [[Isgl3dDirector sharedInstance] addView:[NibDemo view]];
            
            // Create UI and add to Isgl3dDirector
            Isgl3dView * ui = [UIHUDView view];
            [[Isgl3dDirector sharedInstance] addView:ui];
        }
        [self.window addSubview:self.viewController.view];
        [self.window bringSubviewToFront:self.viewController.view];
        
        
    } else 
    {
        [self.viewController.view removeFromSuperview];
        
        [self.window addSubview:self.testViewController.view];
        [self.window bringSubviewToFront:self.testViewController.view];
    }
}


@end
