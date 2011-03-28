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

@class Isgl3dView3D;
@class Isgl3dMatrix4D;
@class Isgl3dGLUIComponent;
@class Isgl3dNode;
@class Isgl3dGLRenderer;


/**
 * The Isgl3dGLUI provides an optional user interface to the iSGL3D framework.
 * 
 * The user interface is rendered above the 3D scene and the components behave in the same way as
 * other Isgl3dNodes: the can be manipulated and transformed as desired. Positions of objects are
 * relevant to the pixel width and height of the screen.
 * 
 * The coordinates in the ISgl3dGLUI component go from (0, 0) at the top-left of the screen to (width, height) at the
 * bottom right of the screen.
 * 
 * After construction of an Isgl3dGLUI, it needs to be added to the Isgl3dView3D as the activeUI for it to be rendered.
 * 
 * The Isgl3dGLUI provides only simple functionality at the moment: complex and automatic layouts for example are not
 * yet provided: for this reason the current API may change as the functionality increases later.
 * 
 * WARNING: This class is deprecated and will be removed in v1.2
 * The functionality of this class can be performed using the Isgl3dBasic2DView (helper class for Isgl3dView). All 
 * Isgl3dGLUIComponents can be added directly as children to scene contained in the Isgl3dView.
 * 
 * @deprecated Will be removed in v1.2
 */
@interface Isgl3dGLUI : NSObject {
	
@private
	Isgl3dView3D * _view;
	
	Isgl3dMatrix4D * _projectionMatrix;
	Isgl3dMatrix4D * _viewMatrix;
	
	Isgl3dNode * _uiElements;
}

/**
 * Initialises the user interface with the view.
 * @param view The Isgl3dView3D view.
 */
- (id) initWithView:(Isgl3dView3D *)view;

/**
 * Adds an Isgl3dGLUIComponent to the user interface.
 */
- (void) addComponent:(Isgl3dGLUIComponent *)component;

/*
 * Renders the user interface. Iterates over all components to perform the same operation.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 * @param renderer The renderer.
 */
- (void) render:(Isgl3dGLRenderer *)renderer;

/*
 * Renders the user interface for event capture. Iterates over all components to perform the same operation.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 * @param renderer The renderer.
 */
- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer;

@end
