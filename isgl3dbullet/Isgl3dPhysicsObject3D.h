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

#import "Isgl3dVector.h"

@class Isgl3dNode;
class btRigidBody;

/**
 * The Isgl3dPhysicsObject3D contains both an Isgl3dNode and a btRigidBody providing a strong link between both
 * the physicaly object and its rendered peer.
 * 
 * Note that when the Isgl3dPhysicsObject3D is deleted, the associated btRigidBody, the btCollisionShape and
 * the btMotionState are also deleted. During construction, The Isgl3dNode is retained and when the
 * Isgl3dPhysicsObject3D is deleted the Isgl3dNode is released.
 */
@interface Isgl3dPhysicsObject3D : NSObject {
	
@private
	Isgl3dNode * _node;
	btRigidBody * _rigidBody;

}

/**
 * Returns the associated Isgl3dNode.
 */
@property (readonly) Isgl3dNode * node;

/**
 * Returns the associated btRigidBody.
 */
@property (readonly) btRigidBody * rigidBody;

/**
 * Allocates and initialises (autorelease) Isgl3dPhysicsObject3D with an Isgl3dNode and a btRigidBody.
 * @param node The Isgl3dNode.
 * @param rigidBody The btRigidBody.
 */
+ (id) physicsObjectWithNode:(Isgl3dNode *)node andRigidBody:(btRigidBody *)rigidBody;

/**
 * Initialises the Isgl3dPhysicsObject3D with an Isgl3dNode and a btRigidBody.
 * @param node The Isgl3dNode.
 * @param rigidBody The btRigidBody.
 */
- (id) initWithNode:(Isgl3dNode *)node andRigidBody:(btRigidBody *)rigidBody;

/**
 * Applies a force, defined as a vector, to the btRigidBody at a given vector position.
 * @param force The force to be applied.
 * @param position The position at which the force is applied.
 */
- (void) applyForce:(Isgl3dVector3)force withPosition:(Isgl3dVector3)position;

@end
