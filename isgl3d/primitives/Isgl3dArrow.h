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

/*
 * The Isgl3dArrow produces a 3-dimensional arrow shape, consisting of a closed cylinder as the arrow base, and 
 * a cone as the arrow head. The arrow is initially pointing vertically upwards, centered on (0, 0, 0).
 * 
 * The base cyliner is made up of (ns + 1) * (nt + 1) vertices.
 * To close the bottom of the arrow, (ns + 1) vertices are used.
 * The arrow head is made of of 2 * (ns + 1) vertices.
 * Total number of vertices = (nt + 4) * (ns + 1).
 */
@interface Isgl3dArrow : Isgl3dPrimitive {

@private
	float _radius;
	float _height;
	float _headRadius;
	float _headHeight;
	int _ns;
	int _nt;
}

/**
 * The radius of the arrow base.
 */
@property (readonly) float radius;

/**
 * The radius of the arrow head.
 */
@property (readonly) float headRadius;

/**
 * The total height of the arrow.
 */
@property (readonly) float height;

/**
 * The height of the arrow head only.
 */
@property (readonly) float headHeight;

/**
 * Allocates and initialises (autorelease) arrow with a given geometry.
 * @param height The total height of the arrow.
 * @param radius The radius of the base of the arrow.
 * @param headHeight The height of the head of the arrow.
 * @param headRadius The radius of the head of the arrow.
 * @param ns The number of segments radially around the base of the arrow
 * @param nt The number of segments vertically along the base of the arrow.
 */
+ (id) meshWithGeometry:(float)height radius:(float)radius headHeight:(float)headHeight headRadius:(float)headRadius ns:(int)ns nt:(int)nt;

/**
 * Initialises the arrow with a given geometry.
 * @param height The total height of the arrow.
 * @param radius The radius of the base of the arrow.
 * @param headHeight The height of the head of the arrow.
 * @param headRadius The radius of the head of the arrow.
 * @param ns The number of segments radially around the base of the arrow
 * @param nt The number of segments vertically along the base of the arrow.
 */
- (id) initWithGeometry:(float)height radius:(float)radius headHeight:(float)headHeight headRadius:(float)headRadius ns:(int)ns nt:(int)nt;

@end
