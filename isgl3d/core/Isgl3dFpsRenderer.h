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

#define ISGL3D_FPS_N_TICKS 20

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "isgl3dTypes.h"
#import "isgl3dMatrix.h"

@class Isgl3dGLUILabel;
@class Isgl3dGLRenderer;

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */

/**
 * The Isgl3dFpsRenderer is used to display the current framerate.
 *  
 * Note: it is used internally by the Isgl3dDirector.
 * 
 * The frame rate is shown in the bottom left of the display for whichever orientation is used.
 */
@interface Isgl3dFpsRenderer : NSObject {

@private
	Isgl3dGLUILabel * _fpsLabel;
	int _displayCounter;
	float _deltaTimes[ISGL3D_FPS_N_TICKS];
	float _fps;
	unsigned long _tickIndex;
	Isgl3dMatrix4 _projectionMatrix;
	Isgl3dMatrix4 _viewMatrix;
	CGRect _viewportInPixels;
	isgl3dOrientation _orientation;
}

@property (nonatomic) isgl3dOrientation orientation;

/**
 * Initialises an Isgl3dFpsRenderer with the specified orientation.
 * @param orientation The orientation of the device.
 */
- (id) initWithOrientation:(isgl3dOrientation)orientation;

/**
 * Updates the calculation of the current framerate and renders the value on the display.
 * Rendering occurs once every 10 frames. If isPaused is specified then the framerate is
 * not calculated and "paused" is displayed in its place.
 */
- (void) update:(float)dt andRender:(Isgl3dGLRenderer *)renderer isPaused:(BOOL)isPaused;

/**
 * Updates the viewport rectangle. Called when the Isgl3dDirector has a change in viewport size or content scale factor.
 */
- (void) updateViewport;

@end
