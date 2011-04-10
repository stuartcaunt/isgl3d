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
 * The Isgl3dOvoid constructs a 3-dimensional ovoid mesh. An ovoid is an egg-shaped object.
 * The definition here is taken from http://www.mathematische-basteleien.de/eggcurves.htm
 * 
 * The equation in two dimensions for the oval is
 * f(y) * x^2 / a^2 + y^2 / b^2 = 1
 * where f(y) = (1 - k * y) / (1 + k * y)
 * 
 * The ovoid is centered on (0, 0, 0) and its axis of symmetry is along the y-axis.
 *  
 * Total number of vertices = (lats + 1) * (longs + 1). 
 */
@interface Isgl3dOvoid : Isgl3dPrimitive {
	    
	
@private
	float _a;
	float _b;
	float _k;
	int _longs;
	int _lats;
}

/**
 * The radius in the x-direction of the ovoid when k = 0.
 */
@property (readonly) float a;

/**
 * The radius in the y-direction.
 */
@property (readonly) float b;

/**
 * A factor to modify the shape of the curve. 0 produces an ellipsoid, 0.1 produces a typical egg shape.
 */
@property (readonly) float k;

/**
 * The number of longitudinal segments.
 */
@property (readonly) int longs;

/**
 * The number of latitudinal segments.
 */
@property (readonly) int lats;

/**
 * Allocates and initialises (autorelease) Isgl3dOvoid with the specified geometry.
 * @param a The radius in the x-direction of the ovoid when k = 0.
 * @param b The radius in the y-direction.
 * @param k A factor to modify the shape of the curve. 0 produces an ellipsoid, 0.1 produces a typical egg shape.
 * @param longs The number of longitudinal segments.
 * @param lats The number of latitudinal segments.
 */
+ (id) meshWithGeometry:(float)a b:(float)b k:(float)k longs:(int)longs lats:(int)lats;

/**
 * Initialises the Isgl3dOvoid with the specified geometry.
 * @param a The radius in the x-direction of the ovoid when k = 0.
 * @param b The radius in the y-direction.
 * @param k A factor to modify the shape of the curve. 0 produces an ellipsoid, 0.1 produces a typical egg shape.
 * @param longs The number of longitudinal segments.
 * @param lats The number of latitudinal segments.
 */
- (id) initWithGeometry:(float)a b:(float)b k:(float)k longs:(int)longs lats:(int)lats;

@end
