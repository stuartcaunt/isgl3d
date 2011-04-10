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

#import "Isgl3dNode.h"

@class Isgl3dPhysicsObject3D;
class btRigidBody;
class btDiscreteDynamicsWorld;
class btCollisionShape;

/**
 * The Isgl3dPhysicsWorld provides a wrapper to the btDiscreteDynamicsWorld and contains all the Isgl3dPhysicsObject3D objects. 
 * It inherits from Isgl3dNode so is added directly to the scene. At every frame it updates automatically the 
 * btDiscreteDynamicsWorld (the physics simulation is updated) and hence the transformations of the physics
 * objects (btRigidBody) are updated.
 */
@interface Isgl3dPhysicsWorld : Isgl3dNode {
	
@private
	btDiscreteDynamicsWorld * _discreteDynamicsWorld;

	NSDate * _lastStepTime;
	NSMutableArray * _physicsObjects;

}

/**
 * Allocates and initialises (autorelease) Isgl3dPhysicsWorld;
 */
+ (id) physicsWorld;

/**
 * Initialises the Isgl3dPhysicsWorld;
 */
- (id) init;

/**
 * Sets the btDiscreteDynamicsWorld in which the Bullet Physics simulation takes place. The btDiscreteDynamicsWorld is
 * automatically stepped at every rendered frame.
 */
- (void) setDiscreteDynamicsWorld:(btDiscreteDynamicsWorld *)discreteDynamicsWorld;

/**
 * Adds a new Isgl3dPhysicsObject3D containing both a btRigidBody and an Isgl3dNode. Note, this DOES NOT add the
 * node contained in the physics object to the scene: this needs to be done independently. The btRigidBody is
 * added to the btDiscreteDynamicsWorld.
 * @param physicsObject The Isgl3dPhysicsObject3D containing both btRigidBody and Isgl3dNode.
 */
- (void) addPhysicsObject:(Isgl3dPhysicsObject3D *)physicsObject;

/**
 * Removes an Isgl3dPhysicsObject3D from the physics world. Note, this DOES remove the associated Isgl3dNode
 * from its parent node in the scene. The btRigidBody is removed from the btDiscreteDynamicsWorld.
 * @param physicsObject The Isgl3dPhysicsObject3D to remove.
 */
- (void) removePhysicsObject:(Isgl3dPhysicsObject3D *)physicsObject;

/**
 * Sets the size and direction of gravity in the physics simulation.
 * @param x The x component of the gravity vectory.
 * @param y The y component of the gravity vectory.
 * @param z The z component of the gravity vectory.
 */
- (void) setGravity:(float)x y:(float)y z:(float)z;

/**
 * Utility method to create an Isgl3dPhysicsObject3D from an Isgl3dNode and a btCollisionShape. A btRigidBody is created for
 * the shape with an Isgl3dMotionShape containing the node. Both btRigidBody and Isgl3dNode are returned in the Isgl3dPhysicsObject3D.
 * @param node The Isgl3dNode to be manipulated as a result of the physics simulation.
 * @param shape The shape of the object.
 * @param mass The mass of the object.
 * @param restitution The restitution of the object.
 * @return (autorelease) The created Isgl3dPhysicsObject3D containing the btRigidBody and the Isgl3dNode.
 */
- (Isgl3dPhysicsObject3D *) createPhysicsObject:(Isgl3dNode *)node shape:(btCollisionShape *)shape mass:(float)mass restitution:(float)restitution;

@end
