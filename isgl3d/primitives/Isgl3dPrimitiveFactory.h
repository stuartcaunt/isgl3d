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
#import <CoreGraphics/CoreGraphics.h>

@class Isgl3dGLMesh;
@class Isgl3dPlane;
@class Isgl3dTextureMaterial;

/**
 * The Isgl3dPrimitiveFactory is a utility class for creating certain meshes.
 * 
 * The singleton pattern is used and all access to this class should come from the instance method.
 * 
 * This class is mainly used for the user interface components. 
 */
@interface Isgl3dPrimitiveFactory : NSObject {

@private
	NSMutableDictionary * _primitives;

}

/**
 * Returns the default user inteface button width.
 */
@property (readonly) unsigned int UIButtonWidth;

/**
 * Returns the default user inteface button height.
 */
@property (readonly) unsigned int UIButtonHeight;

/**
 * Returns the singleton instance of the Isgl3dPrimitiveFactory.
 * @return The singleton instance of the Isgl3dPrimitiveFactory.
 */
+ (Isgl3dPrimitiveFactory *) sharedInstance;

/**
 * Resets the singleton instance.
 */
+ (void) resetInstance;

/**
 * Returns the default mesh to render a bone.
 * @return The default mesh to render a bone.
 */
- (Isgl3dGLMesh *) boneMesh;

/*
 * Returns the default mesh to render a user interface button.
 * @return The default mesh to render a user interface button.
 */
- (Isgl3dGLMesh *) UIButtonMesh;

/**
 * Creates a mesh (an Isgl3dPlane) to render a label component of the user interface.
 * The Isgl3dUVMap is automatically calculated for the label, given the content size, since the texture material
 * associated with the label will most likely have an unused area (see Isgl3dTextureMaterial).
 * @result (autorelease) The Isgl3dGLMesh for the label for given size with UVs automatically calculated.
 */
- (Isgl3dGLMesh *) UILabelMeshWithWidth:(unsigned int)width height:(unsigned int)height contentSize:(CGSize)contentSize;

/**
 * Creates an Isgl3dPlane with the given geometry and with a UV map to match the content size of the texture.
 * @param width The width of the plane in the x-direction.
 * @param height The height of the plane in the y-direction.
 * @param nx The number of segments along the x-axis.
 * @param ny The number of segments along the y-axis.
 * @param material The texture material.
 * @result (autorelease) The Isgl3dGLMesh for the label for given size with UVs automatically calculated.
 */
- (Isgl3dPlane *) planeWithGeometry:(float)width height:(float)height nx:(int)nx ny:(int)ny forMaterial:(Isgl3dTextureMaterial *)material;

@end
