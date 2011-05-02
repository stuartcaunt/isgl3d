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

#import "Isgl3dCone.h"


/**
 * The Isgl3dCylinder is identical to the Isgl3dCone except that the top radius and bottom radius are both equal.
 */
@interface Isgl3dCylinder : Isgl3dCone {
	    
	
@private
}

/**
 * Allocates and initialises (autorelease) cylinder with the specified geometry.
 * @param height The total height of the cylinder.
 * @param radius The radius of the cylinder.
 * @param ns The number of segments radially around the cylinder.
 * @param nt The number of segments vertically along the cylinder.
 * @param openEnded Indicates if the cylinder is open-ended or not.
 */
+ (id) meshWithGeometry:(float)height radius:(float)radius ns:(int)ns nt:(int)nt openEnded:(BOOL)openEnded;

/**
 * Initialises the cylinder with the specified geometry.
 * @param height The total height of the cylinder.
 * @param radius The radius of the cylinder.
 * @param ns The number of segments radially around the cylinder.
 * @param nt The number of segments vertically along the cylinder.
 * @param openEnded Indicates if the cylinder is open-ended or not.
 */
- (id) initWithGeometry:(float)height radius:(float)radius ns:(int)ns nt:(int)nt openEnded:(BOOL)openEnded;

@end
