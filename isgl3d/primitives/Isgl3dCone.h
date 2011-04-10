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
 * The Isgl3dCone produces a 3-dimensional mesh of a cone with its axis along the y-axis, centered on (0, 0, 0).
 * 
 * The radii at both ends of the cone can be specified as can whether the cone is open-ended or not.
 * 
 * If the cone is open-ended, total number of vertices = (nt + 1) * (ns + 1). 
 * If the cone is closes, total number of vertices = (nt + 3) * (ns + 1). 
 */
@interface Isgl3dCone : Isgl3dPrimitive {
	    
	
@private
	float _topRadius;
	float _bottomRadius;
	float _height;
	int _ns;
	int _nt;
	BOOL _openEnded;
}

/**
 * The radius at the top of the cone.
 */
@property (readonly) float topRadius;

/**
 * The radius at the bottom of the cone.
 */
@property (readonly) float bottomRadius;

/**
 * The height of the cone.
 */
@property (readonly) float height;

/**
 * Allocates and initialises (autorelease) cone with a given geometry.
 * @param height The total height of the cone.
 * @param topRadius The radius of the top of the cone.
 * @param bottomRadius The radius of the bottom of the cone.
 * @param ns The number of segments radially around the cone.
 * @param nt The number of segments vertically along the cone.
 * @param openEnded Indicates if the cone is open-ended or not.
 */
+ (id) meshWithGeometry:(float)height topRadius:(float)topRadius bottomRadius:(float)bottomRadius ns:(int)ns nt:(int)nt openEnded:(BOOL)openEnded;

/**
 * Initialises the cone with a given geometry.
 * @param height The total height of the cone.
 * @param topRadius The radius of the top of the cone.
 * @param bottomRadius The radius of the bottom of the cone.
 * @param ns The number of segments radially around the cone.
 * @param nt The number of segments vertically along the cone.
 * @param openEnded Indicates if the cone is open-ended or not.
 */
- (id) initWithGeometry:(float)height topRadius:(float)topRadius bottomRadius:(float)bottomRadius ns:(int)ns nt:(int)nt openEnded:(BOOL)openEnded;

@end
