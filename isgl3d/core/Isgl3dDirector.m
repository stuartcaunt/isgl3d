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

#import "Isgl3dDirector.h"
#import "Isgl3dEAGLView.h"
#import "Isgl3dView.h"
#import "Isgl3dLog.h"
#import "Isgl3dScheduler.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dColorUtil.h"
#import "Isgl3dObject3DGrabber.h"
#import "Isgl3dEvent3DHandler.h"
#import "Isgl3dTouchScreen.h"
#import "Isgl3dAccelerometer.h"
#import "Isgl3dTweener.h"
#import "Isgl3dFpsRenderer.h"

#import <QuartzCore/QuartzCore.h>
#import <sys/time.h>

static Isgl3dDirector * _instance = nil;

@interface Isgl3dDirector ()
- (id) initSingleton;
- (void) setContentScaleFactor:(float)contentScaleFactor;
- (void) mainLoop;
- (void) calculateDeltaTime;
- (void) render;
- (void) renderForEventCapture;
@end

@implementation Isgl3dDirector

@synthesize objectTouched = _objectTouched;
@synthesize windowRect = _windowRect;
@synthesize windowRectInPixels = _windowRectInPixels;
@synthesize isPaused = _isPaused;
@synthesize displayFPS = _displayFPS;
@synthesize contentScaleFactor = _contentScaleFactor;
@synthesize retinaDisplayEnabled = _retinaDisplayEnabled;
@synthesize deltaTime = _dt;

- (id) init {
	NSLog(@"Isgl3dDirector::init should not be called on singleton. Instance should be accessed via sharedInstance");
	
	return nil;
}

- (id) initSingleton {
	
	if ((self = [super init])) {
		// Initialise timing method
		_isAnimating = NO;
		_isPaused = NO;

		// Animation interval at 60fps
		_animationInterval = 1. / 60.;
		
		// Set up timer
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
			_displayLinkSupported = YES;
			Isgl3dLog(Info, @"Isgl3dDirector : created with CADisplayLink");

		} else {
			_displayLinkSupported = NO;
			Isgl3dLog(Info, @"Isgl3dDirector : created with NSTimer");
		}

		// Default device orientation
		_deviceOrientation = Isgl3dOrientation0;

		_views = [[NSMutableArray alloc] init];
		
		// Initialise timing so that dt = 0 on first tick
		_hasSignificationTimeChange = YES;

		// Default background color		
		_backgroundColor[0] = 0;
		_backgroundColor[1] = 0;
		_backgroundColor[2] = 0;
		_backgroundColor[3] = 1;
		
		// Create event3d handler
		_event3DHandler = [[Isgl3dEvent3DHandler alloc] init];
		
		_displayFPS = NO;
		
		_retinaDisplayEnabled = NO;
		_contentScaleFactor = 1.0f;
	}

	return self;
}

- (void) dealloc {
	Isgl3dLog(Info, @"Isgl3dDirector : dealloc");

	if (_glView) {
		[_glView release];
	}

	if (_renderer) {
		[_renderer release];
	}

	if (_fpsRenderer) {
		[_fpsRenderer release];
	}
	
	[_event3DHandler release];
	
	[_views release];
	
	[super dealloc];
}

+ (Isgl3dDirector *) sharedInstance {
	
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dDirector alloc] initSingleton];
		}
	}
		
	return _instance;
}

+ (void) resetInstance {
	if (_instance) {
		[_instance end];

		[_instance release];
		_instance = nil;
	}
}


// Properties
#pragma mark properties

- (CGSize) windowSize {
	return _windowRect.size;
}

- (CGSize) windowSizeInPixels {
	return _windowRectInPixels.size;
}

- (float *) backgroundColor {
	return _backgroundColor;
}

- (void) setBackgroundColor:(float *)color {
	memcpy(_backgroundColor, color, sizeof(float) * 4);
}

- (NSString *) backgroundColorString {
	return [Isgl3dColorUtil rgbaString:_backgroundColor];
}

- (void) setBackgroundColorString:(NSString *)colorString {
	[Isgl3dColorUtil hexColorStringToFloatArray:colorString floatArray:_backgroundColor];
}

- (isgl3dOrientation) deviceOrientation {
	return _deviceOrientation;
}

- (void) setDeviceOrientation:(isgl3dOrientation)orientation {

	if (orientation != _deviceOrientation) {
		_deviceOrientation = orientation;
		if (_deviceOrientation == Isgl3dOrientation0) {
			[[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait animated:NO];
			Isgl3dLog(Info, @"Isgl3dDirector : setting device orientation to portrait");
			
		} else if (_deviceOrientation == Isgl3dOrientation180) {
			[[UIApplication sharedApplication] setStatusBarOrientation: UIDeviceOrientationPortraitUpsideDown animated:NO];
			Isgl3dLog(Info, @"Isgl3dDirector : setting device orientation to portrait upside down");
			
		} else if (_deviceOrientation == Isgl3dOrientation90CounterClockwise) {
			[[UIApplication sharedApplication] setStatusBarOrientation: UIDeviceOrientationLandscapeLeft animated:NO];
			Isgl3dLog(Info, @"Isgl3dDirector : setting device orientation to landscape left");
			
		} else if (_deviceOrientation == Isgl3dOrientation90Clockwise) {
			[[UIApplication sharedApplication] setStatusBarOrientation: UIDeviceOrientationLandscapeRight animated:NO];
			Isgl3dLog(Info, @"Isgl3dDirector : setting device orientation to landscape right");
			
		} else {
			Isgl3dLog(Error, @"Isgl3dDirector : unknown device orientation");
		} 
	}

	// Update fps renderer projection	
	if (_fpsRenderer) {
		_fpsRenderer.orientation = _deviceOrientation;
	}
	
	// Set the device orientation in the accelerometer
	[Isgl3dAccelerometer sharedInstance].deviceOrientation = _deviceOrientation;
	
}

- (void) setOpenGLView:(Isgl3dEAGLView *)glView {
	if (glView != _glView) {
		if (_glView) {
			
			// Release the ui view
			[_glView release];
			_glView = nil;
			
			// Release the renderer
			[_renderer release];
			
			// Release the fps renderer
			[_fpsRenderer release];
		}
		
		if (glView) {
			_glView = [glView retain];

			// Get the window dimensions
			_windowRect = [_glView bounds];
			[self setContentScaleFactor:_contentScaleFactor];

			// Create the renderer	
			_renderer = [[_glView createRenderer] retain];

			// Add touch delegate
			_glView.touchDelegate = self;
			
			// Create fps renderer
			_fpsRenderer = [[Isgl3dFpsRenderer alloc] initWithOrientation:_deviceOrientation];
		}
		
	}
}

- (Isgl3dEAGLView *)openGLView {
	return _glView;
}

- (isgl3dShadowType) shadowRenderingMethod {
	return _renderer.shadowRenderingMethod;
}

- (void) setShadowRenderingMethod:(isgl3dShadowType)shadowRenderingMethod {
	_renderer.shadowRenderingMethod = shadowRenderingMethod;
}

- (float) shadowAlpha {
	return _renderer.shadowAlpha;
}

- (void) setShadowAlpha:(float)shadowAlpha {
	_renderer.shadowAlpha = shadowAlpha;
}

#pragma mark start animation control

- (void) setAnimationInterval:(float)animationInterval {
    if (animationInterval > 0) {
        _animationInterval = animationInterval;
		Isgl3dLog(Info, @"Isgl3dDirector : animation frame interval set to %3.1ffps", 1. / animationInterval);
        
        if (_isAnimating) {
            [self stopAnimation];
            [self startAnimation];
        }
    }	
}


- (void) startAnimation {
    if (!_isAnimating) {
        if (_displayLinkSupported) {

			// Convert animation interval into frameInterval
			int frameInterval = (int) floor(_animationInterval * 60.0f);

            _displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(mainLoop)];
            [_displayLink setFrameInterval:frameInterval];
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

        } else {
            _animationTimer = [NSTimer scheduledTimerWithTimeInterval:_animationInterval target:self selector:@selector(mainLoop) userInfo:nil repeats:TRUE];
		}
        
        _isAnimating = TRUE;
    }
}

- (void) stopAnimation {
    if (_isAnimating) {
        if (_displayLinkSupported) {
            [_displayLink invalidate];
            _displayLink = nil;
            
        } else {
            [_animationTimer invalidate];
            _animationTimer = nil;
        }
        
        _isAnimating = FALSE;
    }
}

- (void) run {
	[self startAnimation];	
}

- (void) end {
	[self stopAnimation];

	[Isgl3dScheduler resetInstance];
	[Isgl3dObject3DGrabber resetInstance];
	[Isgl3dTouchScreen resetInstance];
	[Isgl3dTweener reset];

	for (Isgl3dView * view in _views) {
		[view deactivate];
	}
	[_views removeAllObjects];

	[_renderer reset];
	[_renderer release];
	_renderer = nil;

	[_fpsRenderer release];
	_fpsRenderer = nil;
	
	[_glView release];
	_glView = nil;
}

- (void) pause {
	if (_isPaused) {
		return;
	}
	
	Isgl3dLog(Info, @"Isgl3dDirector : paused");
	_oldAnimationInterval = _animationInterval;
	[self setAnimationInterval:1/4.0];
	_isPaused = YES;
}

- (void) resume {
	if (!_isPaused) {
		return;
	}

	Isgl3dLog(Info, @"Isgl3dDirector : resumed");
	[self setAnimationInterval:_oldAnimationInterval];
	
	_isPaused = NO;
}

#pragma mark runtime errors


- (void) onMemoryWarning {
	Isgl3dLog(Error, @"Isgl3dDirector : received memory warning");
}

- (void) onSignificantTimeChange {
	_hasSignificationTimeChange = YES;
}


#pragma mark views

- (void) addView:(Isgl3dView *)view {
	[_views addObject:view];
	
	// Activate the view when it has been added
	[view activate];
}

- (void) removeView:(Isgl3dView *)view {
	[_views removeObject:view];

	// Deactivate the view when it has been removed
	[view deactivate];
}


#pragma mark public methods

- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y {
	return [_glView getPixelString:x y:y];
}

- (void) enableRetinaDisplay:(BOOL)enabled {
	if (enabled && !_glView) {
		Isgl3dLog(Error, @"Isgl3dDirector : cannot enable retina display before Isgl3dEAGLView has been set.");
		return;
	}
	
	// Check if alreay set
	if ((_retinaDisplayEnabled && enabled) || (!_retinaDisplayEnabled && !enabled)) {
		return;
	}
	
	// See if retina display is supported in iOS
	if (enabled) {
		if (![_glView respondsToSelector:@selector(setContentScaleFactor:)]) {
			Isgl3dLog(Error, @"Isgl3dDirector : retina display not supported in this version of iOS.");
		} else {
			
			// See if retina display is supported on device
			if ([UIScreen mainScreen].scale == 1.0f) {
				Isgl3dLog(Error, @"Isgl3dDirector : retina display not supported on this device.");
				
			} else {
				Isgl3dLog(Info, @"Isgl3dDirector : retina display enabled.");
				_retinaDisplayEnabled = YES;
				[self setContentScaleFactor:2.0f];
			}
			
		}
		
	} else {
		Isgl3dLog(Info, @"Isgl3dDirector : retina display disabled.");
		_retinaDisplayEnabled = NO;
		[self setContentScaleFactor:1.0f];
	}
}

- (void) setContentScaleFactor:(float)contentScaleFactor {
	if (_contentScaleFactor != contentScaleFactor) {
		_contentScaleFactor = contentScaleFactor;
		
		// Set content scale factor in EAGL view
		[_glView setContentScaleFactor:_contentScaleFactor];
		
		// Scale current window rectangle (cannot call [_glView bounds] because resizing view is asynchronous)
		_windowRectInPixels = CGRectMake(_windowRect.origin.x * _contentScaleFactor, 
			_windowRect.origin.y * _contentScaleFactor, 
			_windowRect.size.width * _contentScaleFactor, 
	        _windowRect.size.height * _contentScaleFactor);
	
		// Update the viewport in the fps renderer
		[_fpsRenderer updateViewport];
	
		Isgl3dLog(Info, @"Isgl3dDirector : content scale factor changed, window size in pixels = %ix%i",  (int)_windowRectInPixels.size.width, (int)_windowRectInPixels.size.height);
	}
}

- (void) onResizeFromLayer {
	_windowRect = [_glView bounds];
	_windowRectInPixels = CGRectMake(_windowRect.origin.x * _contentScaleFactor, 
		_windowRect.origin.y * _contentScaleFactor, 
		_windowRect.size.width * _contentScaleFactor, 
        _windowRect.size.height * _contentScaleFactor);

	// Update the viewport in the fps renderer
	[_fpsRenderer updateViewport];

	Isgl3dLog(Info, @"Isgl3dDirector : layer resized, window size in points = %ix%i and pixels = %ix%i", (int)_windowRect.size.width, (int)_windowRect.size.height,  (int)_windowRectInPixels.size.width, (int)_windowRectInPixels.size.height);
}

#pragma mark main loop

- (void) mainLoop {
	// Calculate change in time 
	[self calculateDeltaTime];
	
	// Update all timers
	if (!_isPaused) {
		[[Isgl3dScheduler sharedInstance] tick:_dt];	

		// Update model transformations in all view
		for (Isgl3dView * view in _views) {
			[view updateModelMatrices];
		}
	}
	
	// Render all views
	[self render];

	// Uncomment to view event capture render
	//[self renderForEventCapture];

	// Finalize OpenGL buffers
	[_glView finalizeRender];
}

- (void) calculateDeltaTime {
	struct timeval now;
	
	gettimeofday(&now, NULL);
	
	if (_hasSignificationTimeChange) {
		_dt = 0;
		_hasSignificationTimeChange = NO;
		
	} else {
		_dt = (now.tv_sec - _lastFrameTime.tv_sec) + (now.tv_usec - _lastFrameTime.tv_usec) / 1000000.0f;
		_dt = fmax(0, _dt);
	}
	
	_lastFrameTime = now;	
}

#pragma mark rendering

- (void) render {

	// Clear the color buffer of full screen (depth/stencil handled by individual views)
	[_renderer clear:ISGL3D_COLOR_BUFFER_BIT color:_backgroundColor viewport:_windowRectInPixels];

	// Render scenes in all views
	for (Isgl3dView * view in _views) {
		// Render view scene
		[view render:_renderer];
	}
	
	// Render the fps if desired
	if (_displayFPS) {
		[_fpsRenderer update:_dt andRender:_renderer isPaused:_isPaused];
	}
}

- (void) renderForEventCapture {

	// Initialise capture of objects
	[[Isgl3dObject3DGrabber sharedInstance] startCapture];

	static float black[4] = {0, 0, 0, 1};
	// Clear the color buffer of full screen (depth/stencil handled by individual views)
	[_renderer clear:ISGL3D_COLOR_BUFFER_BIT color:black viewport:_windowRectInPixels];

	// Render shadow maps in all view
	for (Isgl3dView * view in _views) {
		[view renderForEventCapture:_renderer];
	}
}

- (void) renderFPS {
	
}

#pragma mark Isgl3dTouchDelegate implementation

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// Render for 3d events
	[self renderForEventCapture];

	// Handle Object3D events
	_objectTouched = [_event3DHandler touchesBegan:touches withEvent:event];

	// Dispatch event to touch screen
	[[Isgl3dTouchScreen sharedInstance] touchesBegan:touches withEvent:event];

	_objectTouched = NO;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// Handle Object3D events
	[_event3DHandler touchesMoved:touches withEvent:event];

	// Dispatch event to touch screen
	[[Isgl3dTouchScreen sharedInstance] touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	// Handle Object3D events
	[_event3DHandler touchesEnded:touches withEvent:event];

	// Dispatch event to touch screen
	[[Isgl3dTouchScreen sharedInstance] touchesEnded:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

	// Dispatch event to touch screen
	[[Isgl3dTouchScreen sharedInstance] touchesCancelled:touches withEvent:event];
}


@end
