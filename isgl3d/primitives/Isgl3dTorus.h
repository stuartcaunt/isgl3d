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
 * The Isgl3dTorus constructs a 3-dimensional torus mesh. The torus is centered on (0, 0, 0) and has its axis of symmetry along 
 * the y-axis.
 * 
 * The torus geometry is configured through the tube radius (the radius of the tube that makes the torus) and the radius from the
 * origin to the tube center.
 * 
 * Total number of vertices = (ns + 1) * (nt + 1). 
 */
@interface Isgl3dTorus : Isgl3dPrimitive {
	    
	
@private
	float _radius;
	float _tubeRadius;
	int _ns;
	int _nt;
}

/**
 * The radius from the origin to the tube center.
 */
@property (readonly) float radius;

/**
 * The radius of the tube.
 */
@property (readonly) float tubeRadius;

/**
 * Allocates and initialises (autorelease) torus with the specified geometry.
 * @param radius The radius from the origin to the tube center.
 * @param tubeRadius The radius of the tube.
 * @param ns The number of segments around the torus.
 * @param nt The number of segments around the tube.
 */
+ (id) meshWithGeometry:(float)radius tubeRadius:(float)tubeRadius ns:(int)ns nt:(int)nt;

/**
 * Initialises the torus with the specified geometry.
 * @param radius The radius from the origin to the tube center.
 * @param tubeRadius The radius of the tube.
 * @param ns The number of segments around the torus.
 * @param nt The number of segments around the tube.
 */
- (id) initWithGeometry:(float)radius tubeRadius:(float)tubeRadius ns:(int)ns nt:(int)nt;

@end
