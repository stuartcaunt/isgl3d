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

@class Isgl3dGLRenderer;



@protocol Isgl3dTouchDelegate
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end


/**
 * The Isgl3dGLView provides the interface needed by the Isgl3dDirector for OpenGL-specific 
 * functionality. This is implemented by Isgl3dEAGLView.
 * 
 *  __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@protocol Isgl3dGLView

/**
 * Sets the Isgl3dTouchDelegate for the view. 
 * The Isgl3dTouchDelegate provides the principal controller for all UI touch events. 
 * This, in practice, is the Isgl3dDirector and so should never be called in an iSGL3D application.
 */
@property (nonatomic, assign) id<Isgl3dTouchDelegate> isgl3dTouchDelegate;

/**
 * Returns true if MSAA is supported.
 */
@property (nonatomic, readonly) BOOL msaaAvailable;

/**
 * Indicates wether MSAA should be enabled. MSAA won't be enabled if it's not available.
 */
@property (nonatomic, assign) BOOL msaaEnabled;

/**
 * Allocates, initialises and returns an autoreleased Isgl3dGLRenderer for either OpenGL 1.1 or 2.0.
 * This is used by the Isgl3dDirector to obtain an OpenGL renderer.
 * @returns the Isgl3dGLRenderer.
 */
- (Isgl3dGLRenderer *)createRenderer;

/*
 *
 */
- (void) prepareRender;

/**
 * Used to finalize the rendering in OpenGL. 
 * This should never be called manually.
 */
- (void) finalizeRender;

/**
 * Returns the pixel colour as a hex string for a specific x and y location on the screen.
 * @param x The x location of the pixel (always assuming the device is in portrait mode)
 * @param y The y location of the pixel (always assuming the device is in portrait mode)
 * @return The hexidecimal value for the pixel colour.
 */
- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y;

/**
 *
 */
- (void)switchToStandardBuffers;
- (void)switchToMsaaBuffers;


@end


