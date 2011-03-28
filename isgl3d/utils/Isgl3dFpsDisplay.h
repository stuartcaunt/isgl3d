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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Isgl3dFpsTracer;
@class Isgl3dGLUILabel;
@class Isgl3dView3D;

/**
 * The Isgl3dFpsDisplay is a utility class to display the current frame rate above the 3D scene using the Isgl3dGLUI and an Isgl3dGLUILabel.
 * Simple instantiated with an Isgl3dView3d, the Isgl3dFpsDisplay automatically adds the label to the view and determines whether the
 * device is in landscape or portrait mode.
 * 
 * It uses the Isgl3dFpsTracer to calculate the average framerate over the last 20 frames. The label text is updated every 10 frames.
 * 
 * The position of the label is set automatically but can be modified by the user.
 * 
 * WARNING: This class is deprecated and will be removed in v1.2
 * 
 * @deprecated Will be removed in v1.2
 */
@interface Isgl3dFpsDisplay : NSObject {

@private
	Isgl3dView3D * _view;

	Isgl3dFpsTracer * _fpsTracer;
	Isgl3dGLUILabel * _fpsLabel;
	
	CGPoint _position;
	BOOL _added;
	int _counter;
}

@property (nonatomic) CGPoint position;

/**
 * Initialises the Isgl3dFpsDisplay with the view.
 * @param view The Isgl3dView3D object.
 */
- (id) initWithView:(Isgl3dView3D *)view;

/**
 * Must be called at every frame to update the calculated frame rate and the displayed text.
 * This should be called in the <em>updateScene</em> method of the Isgl3dView3D sub-class.
 */
- (void) update;

/**
 * Returns the current position of the Isgl3dGLUILabel showing the framerate.
 * @return a CGPoint containing the x and y coordinates of the fps label.
 */
- (CGPoint) position;

/**
 * Sets the position of the Isgl3dGLUILabel showing the framerate.
 * @param position The position of the fps label.
 */
- (void) setPosition:(CGPoint)position;

@end
