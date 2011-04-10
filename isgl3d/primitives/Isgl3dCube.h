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

#import "Isgl3dPrimitive.h"

/**
 * The Isgl3dCube produces a 3-dimensional mesh of a cube, or more precisely a rectangular prism since the sides can 
 * be of different lengths. The cube is centered at the origin.
 * 
 * Total number of vertices = 6 * (nx + 1) * (ny + 1).
 * 
 * The UV mapping for each face is identical. This means that with a texture material, the same texture
 * will be rendered on each face. To render different textures on each face an Isgl3dMultiTextureCube must be used.
 * 
 * Alternatively, a single sphere-mapped texture can be mapped to a cube using the Isgl3dCubeSphere.
 */
@interface Isgl3dCube : Isgl3dPrimitive {
	    
	
@private
	float _width;
	float _height;
	float _depth;
	
	int _nx;
	int _ny;
}

/**
 * The width of the cube (along the x-axis).
 */
@property (readonly) float width;

/**
 * The height of the cube (along the y-axis).
 */
@property (readonly) float height;

/**
 * The depth of the cube (along the z-axis).
 */
@property (readonly) float depth;

/**
 * Allocates and initialises (autorelease) cube with the the specified geometry.
 * @param width The width of the cube (along the x-axis).
 * @param height The height of the cube (along the y-axis).
 * @param depth The depth of the cube (along the z-axis).
 * @param nx the number of segments horizontally of a face.
 * @param ny the number of segments vertically of a face.
 */
+ (id) meshWithGeometry:(float)width height:(float)height depth:(float)depth nx:(int)nx ny:(int)ny;

/**
 * Initialises the cube with the the specified geometry.
 * @param width The width of the cube (along the x-axis).
 * @param height The height of the cube (along the y-axis).
 * @param depth The depth of the cube (along the z-axis).
 * @param nx the number of segments horizontally of a face.
 * @param ny the number of segments vertically of a face.
 */
- (id) initWithGeometry:(float)width height:(float)height depth:(float)depth nx:(int)nx ny:(int)ny;


@end
