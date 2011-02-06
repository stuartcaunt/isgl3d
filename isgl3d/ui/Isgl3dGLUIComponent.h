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

#define GLUICOMPONENT_DEFAULT_DEPTH -100

#import "Isgl3dMeshNode.h"
#import <UIKit/UIKit.h>

/**
 * Provides a base class for all components that can be added to the Isgl3dGLUI. It provides
 * the main handling of positioning a component correctly on the screen.
 * 
 * By default the x and y values of the component correspond to position on the screen where the top-left
 * pixel will be paced. The component can be centered on this point both horizontally and vertically if 
 * required.
 */
@interface Isgl3dGLUIComponent : Isgl3dMeshNode {
	
@private
	unsigned int _x;
	unsigned int _y;
	unsigned int _width;
	unsigned int _height;
	
	BOOL _meshDirty;
	
	BOOL _isVisible;
	
	// "Fix left & top" stop pixel movement of component on specified side when resizing
	BOOL _fixLeft;
	BOOL _fixTop;

	BOOL _centerX;
	BOOL _centerY;
}

/**
 * The x-coordinate in pixels on the screen of the component. By default the left hand side of the component is placed here.
 */
@property (readonly) unsigned int x;

/**
 * The y-coordinate in pixels on the screen of the component. By default the top of the component is placed here.
 */
@property (readonly) unsigned int y;

/**
 * The width of the component.
 */
@property (readonly) unsigned int width;

/**
 * The height of the component.
 */
@property (readonly) unsigned int height;

/**
 * Whether the component is visible or not. If the component is not visible then no user events will occur (for example for 
 * an Isgl3dGLUIButton).
 */
@property (nonatomic) BOOL visible;

/**
 * Fix left is used to correct undesirable behaviour when the component it resized (such as with an Isgl3dProgressBar). With
 * fixLeft the left hand side of the component will not move.
 */
@property (nonatomic) BOOL fixLeft;

/**
 * Fix top is used to correct undesirable behaviour when the component it resized (such as with an Isgl3dProgressBar). With
 * fixTop the top of the component will not move.
 */
@property (nonatomic) BOOL fixTop;

/**
 * Specifies whether the component should be centered horizontally on its x value.
 */
@property (nonatomic) BOOL centerX;

/**
 * Specifies whether the component should be centered vertically on its y value.
 */
@property (nonatomic) BOOL centerY;


/**
 * Initialises the component with a mesh and material.
 * This is called automatically by the concrete Isgl3DGLUI components.
 * @param mesh The mesh to be rendered.
 * @param material The material to be drawn over the mesh.
 */
- (id) initWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material;

/**
 * Sets both x and y at the same time.
 * @param x The x-coordinate in pixels on the screen of the component.
 * @param y The y-coordinate in pixels on the screen of the component.
 */
- (void) setX:(unsigned int)x andY:(unsigned int)y;
- (void) setWidth:(unsigned int)width andHeight:(unsigned int)height;

@end
