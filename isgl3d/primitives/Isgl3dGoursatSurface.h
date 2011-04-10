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
 * The Isgl3dGoursatSurface produces a 3-dimensional mesh corresponding to a Goursat's surface.
 * http://mathworld.wolfram.com/GoursatsSurface.html
 * 
 * Goursat's surface corresponds to a quartic equation:
 * (x^4 + y^4 + z^4) + a * (x^2 + y^2 + z^2)^2 + b * (x^2 + y^2 + z^2) + c = 0
 * 
 * By modifying the parameters a, b and c the shape of the surface can be drastically changed.
 * 
 * A simple use of this is to create a rounded cube for which a = 0, b = -1 and c = 0.5.
 * 
 * Total number of vertices = (lats + 1) * (longs + 1). 
 */
@interface Isgl3dGoursatSurface : Isgl3dPrimitive {
	    
	
@private
	float _a;
	float _b;
	float _c;
	float _width;
	float _height;
	float _depth;
	int _longs;
	int _lats;
}

/**
 * The value of a in Goursat's surface equation.
 */
@property (readonly) float a;

/**
 * The value of b in Goursat's surface equation.
 */
@property (readonly) float b;

/**
 * The value of c in Goursat's surface equation.
 */
@property (readonly) float c;

/**
 * The x-coordinates on the surface are multiplied by this factor. 
 */
@property (readonly) float width;

/**
 * The y-coordinates on the surface are multiplied by this factor. 
 */
@property (readonly) float height;

/**
 * The z-coordinates on the surface are multiplied by this factor. 
 */
@property (readonly) float depth;

/**
 * The number of longitudinal segments.
 */
@property (readonly) int longs;

/**
 * The number of latitudinal segments.
 */
@property (readonly) int lats;

/**
 * Allocates and initialises (autorelease) goursat surface with the specified geometry.
 * @param a The value of a in Goursat's surface equation.
 * @param b The value of b in Goursat's surface equation.
 * @param c The value of c in Goursat's surface equation.
 * @param width The x-coordinates on the surface are multiplied by this factor.
 * @param height The y-coordinates on the surface are multiplied by this factor.
 * @param depth The z-coordinates on the surface are multiplied by this factor.
 * @param longs The number of longitudinal segments.
 * @param lats The number of latitudinal segments.
 */
+ (id) meshWithGeometry:(float)a b:(float)b c:(float)c width:(float)width height:(float)height depth:(float)depth longs:(int)longs lats:(int)lats;

/**
 * Initialises the goursat surface with the specified geometry.
 * @param a The value of a in Goursat's surface equation.
 * @param b The value of b in Goursat's surface equation.
 * @param c The value of c in Goursat's surface equation.
 * @param width The x-coordinates on the surface are multiplied by this factor.
 * @param height The y-coordinates on the surface are multiplied by this factor.
 * @param depth The z-coordinates on the surface are multiplied by this factor.
 * @param longs The number of longitudinal segments.
 * @param lats The number of latitudinal segments.
 */
- (id) initWithGeometry:(float)a b:(float)b c:(float)c width:(float)width height:(float)height depth:(float)depth longs:(int)longs lats:(int)lats;

@end
