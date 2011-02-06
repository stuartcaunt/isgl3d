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


/**
 * Container class for positions along a particle path, used by Isgl3dParticlePath.
 */
@interface Isgl3dParticlePathData : NSObject {
	
@private
	float _x;
	float _y;
	float _z;
}

/**
 * The position along the x-axis.
 */
@property (readonly) float x;

/**
 * The position along the y-axis.
 */
@property (readonly) float y;

/**
 * The position along the z-axis.
 */
@property (readonly) float z;

/**
 * Initialises the path data with a given coordinate.
 * @param x The position along the x-axis.
 * @param y The position along the y-axis.
 * @param z The position along the z-axis.
 */
- (id) initWithX:(float)x y:(float)y z:(float)z;

@end
