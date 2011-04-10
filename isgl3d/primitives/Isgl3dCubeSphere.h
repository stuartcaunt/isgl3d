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
 * The Isgl3dCubeSphere creates a cube mesh by mapping the spherical coordinates of a sphere onto a surrounding cube (ie the vertex points
 * are found as the intersection of a line from the origin, through a point on the sphere and one of the planar faces of the cube).
 * 
 * The UV coordinates of the Isgl3dCubeSphere are therefore the same as those for the Isgl3dSphere, however the geometrical positions are those of a cube.
 * 
 * This can be useful when a single texture image is to be mapped to a cube: a typical example is the creation of a sky-box with a single texture.
 * 
 * To produce the cube correctly, the number of longs and lats need to be divisible by 4. If this is not the case then they are ajusted accordingly.
 * 
 * For lats and longs divisible by 4 the number of vertices = (lats + 1) * (longs + 1). 
 */
@interface Isgl3dCubeSphere : Isgl3dPrimitive {
	    
	
@private
	float _radius;
	int _longs;
	int _lats;
}

/**
 * The radius of the inner-sphere, equivalent to the distance from the center of a face to the origin.
 */
@property (readonly) float radius;

/**
 * The number of longitudinal segments.
 */
@property (readonly) int longs;

/**
 * The number of latitudinal segments.
 */
@property (readonly) int lats;

/**
 * Allocates and initialises (autorelease) cube with the given geometry.
 * @param radius The radius of the inner-sphere, equivalent to the distance from the center of a face to the origin.
 * @param longs The number of longitudinal segments.
 * @param lats The number of latitudinal segments.
 */
+ (id) meshWithGeometry:(float)radius longs:(int)longs lats:(int)lats;

/**
 * Initialises the cube with the given geometry.
 * @param radius The radius of the inner-sphere, equivalent to the distance from the center of a face to the origin.
 * @param longs The number of longitudinal segments.
 * @param lats The number of latitudinal segments.
 */
- (id) initWithGeometry:(float)radius longs:(int)longs lats:(int)lats;

@end
