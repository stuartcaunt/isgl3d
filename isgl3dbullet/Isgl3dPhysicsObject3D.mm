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

#import "Isgl3dPhysicsObject3D.h"
#import "Isgl3dNode.h"
#import "Isgl3dVector3D.h"

#include "btBulletDynamicsCommon.h"

@implementation Isgl3dPhysicsObject3D

@synthesize node = _node;
@synthesize rigidBody = _rigidBody;

- (id) initWithNode:(Isgl3dNode *)node andRigidBody:(btRigidBody *)rigidBody {
    if ((self = [super init])) {
    	_node = [node retain];
    	_rigidBody = rigidBody;
    	
    }
	
    return self;
}

- (void) dealloc {
	[_node release];
	
	delete _rigidBody->getMotionState();
	delete _rigidBody->getCollisionShape();
	delete _rigidBody;

	[super dealloc];
}

- (void) applyForce:(Isgl3dVector3D *)force withPosition:(Isgl3dVector3D *)position {
	btVector3 bodyForce(force.x, force.y, force.z);
	btVector3 bodyPosition(position.x, position.y, position.z);

	_rigidBody->applyForce(bodyForce, bodyPosition);	
}

@end
