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
 * The Isgl3DVector4D contains data representing a 4-dimensional vector.
 * 
 * A typical use of this is to store data representing a plane as used for planar shadows in iSGL3D.
 */
@interface Isgl3dVector4D : NSObject {
	float _x;
	float _y;
	float _z;
	float _w;
}


/**
 * The x component of the vector.
 */
@property (nonatomic) float x;

/**
 * The y component of the vector.
 */
@property (nonatomic) float y;

/**
 * The z component of the vector.
 */
@property (nonatomic) float z;

/**
 * The w component of the vector.
 */
@property (nonatomic) float w;


/**
 * Constructs a vector initialised to zero for the x,y and z values; 1 for the w value.
 * @result (autorelease) Isgl3dVector4D with x = 0, y = 0, z = 0 and w = 1
 */
+ (Isgl3dVector4D *) vector;

/**
 * Constructs a vector with the given components
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 * @result (autorelease) Isgl3dVector4D with desired x, y, z components (w = 1)
 */
+ (Isgl3dVector4D *) vectorWithX:(float)x y:(float)y z:(float)z;

/**
 * Constructs a vector with the given components
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 * @param w The w component.
 * @result (autorelease) Isgl3dVector4D with desired x, y, z, w components
 */
+ (Isgl3dVector4D *) vectorWithX:(float)x y:(float)y z:(float)z w:(float)w;

/**
 * Initialises the vector with the given components.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 */
- (id) init:(float)x y:(float)y z:(float)z;

/**
 * Initialises the vector with the given components.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 * @param w The w component.
 */
- (id) init:(float)x y:(float)y z:(float)z w:(float)w;

/**
 * Returns a new vector identical to the present one.
 * @result (autorelease) Isgl3dVector4D clone.
 */
- (Isgl3dVector4D *) clone;


/**
 * Copies the components from the given vector.
 * @param from The Vector to be copied.
 */
- (void) copyFrom:(Isgl3dVector4D *)from;


/**
 * Resets the vector with given components. The w component is set to 1.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 */
- (void) reset:(float)x y:(float)y z:(float)z;

/**
 * Resets the vector with given components.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 * @param w The w component.
 */
- (void) reset:(float)x y:(float)y z:(float)z w:(float)w;

/**
 * Returns the length of the vector.
 * @return The length of the vector.
 */
- (float) length;

/**
 * Adds the current vector to the given one.
 * @result (autorelease) Isgl3dVector4D after addition
 */
- (Isgl3dVector4D *) add:(Isgl3dVector4D *)vector4D;

/**
 * Subtracts the given vector from this one.
 * @result (autorelease) Isgl3dVector4D after subtraction
 */
- (Isgl3dVector4D *) sub:(Isgl3dVector4D *)vector4D;

/**
 * Scales the vector.
 * @result (autorelease) Isgl3dVector4D after scale
 */
- (Isgl3dVector4D *) scale:(float)scale;

/**
 * Calculates the dot product of this vector with another.
 * @param vector The other vector in the dot product equation.
 * @result The dot product of the two vectors.
 */
- (float) dot:(Isgl3dVector4D *)vector4D;

/**
 * Normalizes the vector.
 */
- (void) normalize;

@end


