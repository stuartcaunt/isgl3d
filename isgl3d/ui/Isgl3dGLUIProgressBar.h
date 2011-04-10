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

#import "Isgl3dGLUIComponent.h"

/**
 * The Isgl3dGLUIProgressBar is used to display a progress bar on the Isgl3dGLUI user interface.
 * 
 * The progress bar can be oriented horizontally or vertically.
 * 
 * As the progress is changed, the size of the progress bar changes. By default a horizontal progress
 * bar icnreases in size on the right-hand side as the progress increases. For a vertical one, the bottom of the
 * bar moves downwards as the progress increases. This behavious can be swapped by using the isSwapped property.
 * 
 * The changes to the progress bar size can be stepped so that not all modifications to the progress result in a 
 * graphical change. For example a progress bar of 20 pixels need only be updated every 5% change in progress.
 * This can also improve the performance of the application.
 */
@interface Isgl3dGLUIProgressBar : Isgl3dGLUIComponent {
	
@private
	unsigned int _originalX;
	unsigned int _originalY;
	unsigned int _fullWidth;
	unsigned int _fullHeight;
	
	float _progress;
	float _progressStepSize;
	
	BOOL _isVertical;
	BOOL _isSwapped;
}

/**
 * The progress step size for which the progress bar size is modified. Default is 5%.
 */
@property (nonatomic) float progressStepSize;

/**
 * The current progress of the progress bar.
 */
@property (nonatomic) float progress;

/**
 * Swaps the side on which movement is perceived in the progress bar.
 */
@property (nonatomic) BOOL isSwapped;

/**
 * Allocates and initialises (autorelease) progress bar with a material and specified geometrical properties.
 * @param material The material to be rendered.
 * @param width The width of the progress bar in pixels.
 * @param height The height of the progress bar in pixels.
 * @param isVertical Specified whether the progress bar is oriented vertically or not.
 */
+ (id) progressBarWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height vertical:(BOOL)isVertical;

/**
 * Initialises the progress bar with a material and specified geometrical properties.
 * @param material The material to be rendered.
 * @param width The width of the progress bar in pixels.
 * @param height The height of the progress bar in pixels.
 * @param isVertical Specified whether the progress bar is oriented vertically or not.
 */
- (id) initWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height vertical:(BOOL)isVertical;


@end
