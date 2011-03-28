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

#import "Isgl3dEvent3DDispatcher.h"
#import "Isgl3dVector3D.h"

@class Isgl3dMatrix4D;
@class Isgl3dVector4D;

/**
 * The Isgl3dGLObject3D provides an interface to the Isgl3dNode to perform transformations on a node.
 * It is used to calculated the transformation for a model given a parent transformation and is optimised
 * to only recalculate transformations if necessary.
 * 
 * The Isgl3dGLObject3D contains two transformation matrices: the local transformation and the global
 * transformation. The local transformation is the displacement/rotation of the object in its local
 * frame of reference. The global transformation is the transformation of the object in world-space taking
 * into account parent transformations.
 */
@interface Isgl3dGLObject3D : Isgl3dEvent3DDispatcher {

@protected
	Isgl3dMatrix4D * _localTransformation;
	Isgl3dMatrix4D * _transformation;

	BOOL _transformationDirty;

@private
	Isgl3dMatrix4D * _scaleTransformation;
	BOOL _scaling;
	Isgl3dVector3D * _position;
}

/**
 * Returns the global transformation of the 3D object.
 */
@property (readonly) Isgl3dMatrix4D * transformation;

/**
 * The local displacement along the x-axis in the objects frame of reference.
 */
@property (nonatomic) float x;

/**
 * The local displacement along the y-axis in the objects frame of reference.
 */
@property (nonatomic) float y;

/**
 * The local displacement along the z-axis in the objects frame of reference.
 */
@property (nonatomic) float z;

/**
 * Initialises the Isgl3dGLObject3D (position at (0, 0, 0) and zero rotation
 * and no scaling).
 */
- (id) init;

/**
 * Performs a general rotation of the object by a given angle about a vector defined
 * as (x, y, z). The rotation is added to the current object's rotation.
 * @param angle The angle in degrees.
 * @param x The x component of the axis of rotation.
 * @param y The y component of the axis of rotation.
 * @param z The z component of the axis of rotation.
 */
- (void) rotate:(float)angle x:(float)x y:(float)y z:(float)z;

/**
 * Sets the rotation of the object by a given angle about a general vector defined
 * as (x, y, z). 
 * @param angle The angle in degrees.
 * @param x The x component of the axis of rotation.
 * @param y The y component of the axis of rotation.
 * @param z The z component of the axis of rotation.
 */
- (void) setRotation:(float)angle x:(float)x y:(float)y z:(float)z;

/**
 * Translates the object by a given amount from its current position.
 * @param x The displacement along the x axis in the object's local frame of reference.
 * @param y The displacement along the y axis in the object's local frame of reference.
 * @param z The displacement along the z axis in the object's local frame of reference.
 */
- (void) translate:(float)x y:(float)y z:(float)z;

/**
 * Translates the object along a vector from its current position.
 * @param vector The displacement in three dimensions in the object's local frame of reference.
 */
- (void) translateByVector:(Isgl3dVector3D *)vector;

/**
 * Translates the object along a given vector from its current position by a given distance.
 * @param direction The direction of the displacement in the object's local frame of reference.
 * @param distance The distance to move the object by.
 */
- (void) moveAlong:(Isgl3dVector3D *)direction distance:(float)distance;

/**
 * Sets the object's position to a given point in the object's frame of reference.
 * @param x The position along the x axis in the object's local frame of reference.
 * @param y The position along the y axis in the object's local frame of reference.
 * @param z The position along the z axis in the object's local frame of reference.
 */
- (void) setTranslation:(float)x y:(float)y z:(float)z;

/**
 * Sets the object's position to a given point in the object's frame of reference.
 * @param translation The vector position in the object's local frame of reference..
 */
- (void) setTranslationVector:(Isgl3dVector3D *)translation;

/**
 * Sets the object's position to a given point in the object's frame of reference.
 * @param translation The vector position in the object's local frame of reference..
 */
- (void) setTranslationMiniVec3D:(Isgl3dMiniVec3D *)translation;

/**
 * Sets a global scaling factor for the object (identical in x-, y- and z-directions).
 * @param scale The scaling factor.
 */
- (void) setScale:(float)scale;

/**
 * Sets scaling factors along each axis.
 * @scaleX The scaling factor in the x-direction.
 * @scaleY The scaling factor in the y-direction.
 * @scaleZ The scaling factor in the z-direction.
 */
- (void) setScale:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ;

/**
 * Reset's the local transformation.
 */
- (void) resetTransformation;

/**
 * Set's the object's local transformation from an Isgl3dMatrix4D.
 * @param transformation The local transformation of the object.
 */
- (void) setTransformation:(Isgl3dMatrix4D *)transformation;

/**
 * Set's the object's local transformation from array of column-wise values representing
 * a 4x4 matrix (same format as OpenGL).
 * @param transformation The local transformation of the object as a column-wise array of values.
 */
- (void) setTransformationFromOpenGLMatrix:(float *)transformation;

/**
 * USed to obtain the local transformation as a column-wise array of values representing the 
 * 4x4 matrix.
 * @param transformation Current column-wise array of values for the local transformation is stored here.
 */
- (void) getTransformationAsOpenGLMatrix:(float *)transformation;

/**
 * Copies the current global position of the object into an array of 4 values representing the 4 translation elements of a 4x4 matrix (tx, ty, tz, tw).
 * @param position The current global position (tx, ty, tz, tw) of the object is set into this float array.
 */
- (void) copyPositionTo:(float *)position;

/**
 * Takes the position directly from another Isgl3dGLObject3D object.
 * @param object3D The object whose position is to be copied.
 */
- (void) copyPositionFromObject3D:(Isgl3dGLObject3D *)object3D;

/**
 * Returns the global position as an Isgl3dVector3D.
 */
- (Isgl3dVector3D *) position;


/**
 * Copies the global position of the object into the passed Isgl3dMiniVec3D structure.
 * @param position After the call this contains the object's current global position.
 */
- (void) positionAsMiniVec3D:(Isgl3dMiniVec3D *)position;

/**
 * This is used to return the equation of a plane that passes through the object's global position
 * given a normal to the plane in the object's local frame of reference.
 * This is intended for use when generating planar shadows.
 * @result (autorelease) Vector representation of the plane with transformed normal passing through the object's position. 
 */
- (Isgl3dVector4D *) asPlaneWithNormal:(Isgl3dVector4D *)normal;

/*
 * Indicates to the object that its global transformation needs to be recalculated.
 * Note that this intended to be called internally by iSGL3D.
 * @param isDirty Indicates whether the transformation needs to be recalculated or not.
 */
- (void) setTransformationDirty:(BOOL)isDirty;

/*
 * Updates the global transformation of the object given the parent's global transformation.
 * Note that this intended to be called internally by iSGL3D.
 * @param parentTransformation The parent's global transformation matrix.
 */
- (void) updateGlobalTransformation:(Isgl3dMatrix4D *)parentTransformation;

/*
 * Given a view matrix, this returns the distance along the observer's viewing direction to the object.
 * Note that this intended to be called internally by iSGL3D, used for z-sorting of nodes.
 * @param viewMatrix The view matrix to transform objects to the viewer's frame of reference.
 * @return Distance along the z-axis of the viewer to the object.
 */
- (float) getZTransformation:(Isgl3dMatrix4D *)viewMatrix;

@end
