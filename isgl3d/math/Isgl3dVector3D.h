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

#include "Isgl3dMiniVec.h"

#import <Foundation/Foundation.h>

/**
 * The Isgl3DVector3D contains data representing a 3-dimensional vector.
 * 
 * Its data is stored in an Isgl3dMiniVec3D structure. Applications can take advantage of both
 * data types, each have different advantages and disadvantages.
 * 
 * The main advantage of the Isgl3dVector3D is its simple API for performing vector algebra: the result
 * of an operation produces a new vector object that can be immediately used in another algebraic operation
 * producing code that is easy to read. The disadvantage of this is that if you have a lot of vector algebra to perform then
 * you may suffer a noticable performance penalty.
 * 
 * For large amounts of vector algebra, the Isgl3dMiniVec3D and associated methods are highly recommended.  
 */
@interface Isgl3dVector3D : NSObject {
	Isgl3dMiniVec3D _vector;
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
 * The vector components stored in an Isgl3dMiniVec3D. 
 */
@property (nonatomic) Isgl3dMiniVec3D miniVec3D;

/**
 * Returns the pointer to the internal Isgl3dMiniVec3D. Modifying the components of this structure
 * will also modify those of this object.
 */
@property (readonly) Isgl3dMiniVec3D * miniVec3DPointer;


/**
 * Constructs a vector initialised to zero.
 * @result (autorelease) Isgl3dVector3D with x = 0, y = 0 and z = 0.
 */
+ (Isgl3dVector3D *) vector;

/**
 * Constructs a vector with the given components
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 * @result (autorelease) Isgl3dVector3D with desired x, y, z components
 */
+ (Isgl3dVector3D *) vectorWithX:(float)x y:(float)y z:(float)z;

/**
 * Copies the components of the given vector into this one.
 * @param vector The vector to be copied. 
 * @result (autorelease) Isgl3dVector3D copied from given vector
 */
+ (Isgl3dVector3D *) vectorFromVector:(Isgl3dVector3D *)vector;

/**
 * Unit vector representing the forward direction (0, 0, -1).
 * @return The forward vector. 
 */
+ (Isgl3dVector3D *) FORWARD;

/**
 * Unit vector representing the backward direction (0, 0, 1).
 * @return The backward vector. 
 */
+ (Isgl3dVector3D *) BACKWARD;

/**
 * Unit vector representing the left direction (-1, 0, 0).
 * @return The left vector. 
 */
+ (Isgl3dVector3D *) LEFT;

/**
 * Unit vector representing the right direction (1, 0, 0).
 * @return The right vector. 
 */
+ (Isgl3dVector3D *) RIGHT;

/**
 * Unit vector representing the up direction (0, 1, 0).
 * @return The up vector. 
 */
+ (Isgl3dVector3D *) UP;

/**
 * Unit vector representing the down direction (0, -1, 0).
 * @return The down vector. 
 */
+ (Isgl3dVector3D *) DOWN;

/**
 * Initialises the vector with the given components.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 */
- (id) init:(float)x y:(float)y z:(float)z;

/**
 * Initialises the vector from an Isgl3dMiniVec3D structure.
 * @vector The Isgl3dMiniVec3D to be copied.
 */
- (id) initWithMiniVec3D:(Isgl3dMiniVec3D)vector;

/**
 * Returns a new vector identical to the present one.
 * @result (autorelease) Isgl3dVector3D clone.
 */
- (Isgl3dVector3D *) clone;

/**
 * Copies the components from the given vector.
 * @param from The Vector to be copied.
 */
- (void) copyFrom:(Isgl3dVector3D *)from;

/**
 * Resets the vector with given components.
 * @param x The x component.
 * @param y The y component.
 * @param z The z component.
 */
- (void) reset:(float)x y:(float)y z:(float)z;

/**
 * Returns the length of the vector.
 * @return The length of the vector.
 */
- (float) length;

/**
 * Adds the current vector to the given one.
 * @result (autorelease) Isgl3dVector3D after addition.
 */
- (Isgl3dVector3D *) add:(Isgl3dVector3D *)vector3D;

/**
 * Subtracts the given vector from this one.
 * @result (autorelease) Isgl3dVector3D after subtraction.
 */
- (Isgl3dVector3D *) sub:(Isgl3dVector3D *)vector3D;

/**
 * Scales the vector.
 * @result (autorelease) Isgl3dVector3D after scale.
 */
- (Isgl3dVector3D *) scale:(float)scale;

/**
 * Calculates the dot product of this vector with another.
 * @param vector The other vector in the dot product equation.
 * @result The dot product of the two vectors.
 */
- (float) dot:(Isgl3dVector3D *)vector;

/**
 * Calculates the cross product of this vector with another.
 * @result (autorelease) Isgl3dVector3D cross product.
 */
- (Isgl3dVector3D *) cross:(Isgl3dVector3D *)vertex;

/**
 * Normalizes the vector.
 */
- (void) normalize;

/**
 * Translates a vector by a given amount.
 * @param x The x translation.
 * @param y The y translation.
 * @param z The z translation.
 */
- (void) translate:(float)x y:(float)y z:(float)z;

/**
 * Rotates the vector around the x-axis by a specified angle centered on a given point in the y-z plane.
 * @param angle The amount of rotation in degrees.
 * @param centerY The center of the rotation in the y-z plane along the y-axis. 
 * @param centerZ The center of the rotation in the y-z plane along the z-axis. 
 */
- (void) rotateX:(float)angle centerY:(float)centerY centerZ:(float)centerZ;

/**
 * Rotates the vector around the y-axis by a specified angle centered on a given point in the x-z plane.
 * @param angle The amount of rotation in degrees.
 * @param centerX The center of the rotation in the x-z plane along the y-axis. 
 * @param centerZ The center of the rotation in the x-z plane along the z-axis. 
 */
- (void) rotateY:(float)angle centerX:(float)centerX centerZ:(float)centerZ;

/**
 * Rotates the vector around the z-axis by a specified angle centered on a given point in the x-y plane.
 * @param angle The amount of rotation in degrees.
 * @param centerX The center of the rotation in the x-y plane along the x-axis. 
 * @param centerY The center of the rotation in the x-y plane along the y-axis. 
 */
- (void) rotateZ:(float)angle centerX:(float)centerX centerY:(float)centerY;
	
/**
 * Returns the angle of the vector projected onto the x-y plane.
 * @result Vector angle, in the x-y plane.
 */
- (float) angleXY;

/**
 * Returns the angle of the vector projected onto the y-z plane.
 * @result Vector angle, in the y-z plane.
 */
- (float) angleYZ;

/**
 * Determines if this vector is equal to another.
 * @result YES if the given vector is equal to this one within a precision of 1.0e-6 for each component. 
 */
- (BOOL) equals:(Isgl3dVector3D *)vector;

/**
 * Returns the angle to the given vector from this one.
 * @param vector The vector.
 * @result The angle to the vector.
 */
- (float) angleToVector:(Isgl3dVector3D *)vector;

@end


