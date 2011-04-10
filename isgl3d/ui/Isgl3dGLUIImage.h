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
 * The Isgl3dGLUIImage displays an image on the user interface.
 * 
 * Part or all of the image can be displayed and the height and width of the image can be set also.
 */
@interface Isgl3dGLUIImage : Isgl3dGLUIComponent {
	
@private
}

/**
 * Allocates and initialises (autorelease) Isgl3dGLUIImage with a material (typically an Isgl3dTextureMaterial) to be rendered.
 * All the image of the texture is displayed.
 * @param material The material to be rendered as an image on the user interface.
 * @param width The desired width of the component in pixels.
 * @param height The desired height of the component in pixels.
 */
+ (id) imageWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height;

/**
 * Allocates and initialises (autorelease) Isgl3dGLUIImage with a material (typically an Isgl3dTextureMaterial) to be rendered for which only a specified rectangle will be displayed.
 * @param material The material to be rendered as an image on the user interface.
 * @param rectangle The CGRect coordinates of the part of the image that is to be displayed.
 * @param width The desired width of the component in pixels.
 * @param height The desired height of the component in pixels.
 */
+ (id) imageWithMaterial:(Isgl3dMaterial *)material andRectangle:(CGRect)rectangle width:(unsigned int)width height:(unsigned int)height;

/**
 * Initialises the Isgl3dGLUIImage with a material (typically an Isgl3dTextureMaterial) to be rendered.
 * All the image of the texture is displayed.
 * @param material The material to be rendered as an image on the user interface.
 * @param width The desired width of the component in pixels.
 * @param height The desired height of the component in pixels.
 */
- (id) initWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height;

/**
 * Initialises the Isgl3dGLUIImage with a material (typically an Isgl3dTextureMaterial) to be rendered for which only a specified rectangle will be displayed.
 * @param material The material to be rendered as an image on the user interface.
 * @param rectangle The CGRect coordinates of the part of the image that is to be displayed.
 * @param width The desired width of the component in pixels.
 * @param height The desired height of the component in pixels.
 */
- (id) initWithMaterial:(Isgl3dMaterial *)material andRectangle:(CGRect)rectangle width:(unsigned int)width height:(unsigned int)height;


@end
