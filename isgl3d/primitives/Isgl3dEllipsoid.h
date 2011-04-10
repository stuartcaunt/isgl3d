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
 * The Isgl3dEllipsoid produces a 3-dimensional mesh of an ellipsoid. Unlike a sphere, the ellipsoid has different radii along 
 * each axis.
 * 
 * Total number of vertices = (lats + 1) * (longs + 1). 
 */
@interface Isgl3dEllipsoid : Isgl3dPrimitive {
	
@private
	float _radiusX;
	float _radiusY;
	float _radiusZ;
	int _longs;
	int _lats;
}

/**
 * The radius along the x-axis.
 */
@property (readonly) float radiusX;

/**
 * The radius along the y-axis.
 */
@property (readonly) float radiusY;

/**
 * The radius along the z-axis.
 */
@property (readonly) float radiusZ;

/**
 * The number of longitudinal segments.
 */
@property (readonly) int longs;

/**
 * The number of latitudinal segments.
 */
@property (readonly) int lats;

/**
 * Allocates and initialises (autorelease) ellipsoid with a specific geometry.
 * @param radiusX The radius along the x-axis.
 * @param radiusY The radius along the y-axis.
 * @param radiusZ The radius along the z-axis.
 * @param longs The number of longitudinal segments.
 * @param lats The number of latitudinal segments.
 */
+ (id) meshWithGeometry:(float)radiusX radiusY:(float)radiusY radiusZ:(float)radiusZ longs:(int)longs lats:(int)lats;

/**
 * Initialises the ellipsoid with a specific geometry.
 * @param radiusX The radius along the x-axis.
 * @param radiusY The radius along the y-axis.
 * @param radiusZ The radius along the z-axis.
 * @param longs The number of longitudinal segments.
 * @param lats The number of latitudinal segments.
 */
- (id) initWithGeometry:(float)radiusX radiusY:(float)radiusY radiusZ:(float)radiusZ longs:(int)longs lats:(int)lats;

@end
