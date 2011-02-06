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

#ifndef ISGL3DMOTIONSTATE_H_
#define ISGL3DMOTIONSTATE_H_

#include <LinearMath/btTransform.h>
#include <LinearMath/btMotionState.h>

@class Isgl3dNode;

/*
 * The Isgl3dMotionState inherits from btMotionState and is passed in the constructor of a btRigidBody.
 * The Isgl3dMotionState constructor takes an Isgl3dNode: this node corresponds to the rendered equivalent
 * to the btRigidBody. This provides the bridging between the btRigidBody and the Isgl3dNode, allowing the 
 * transformation from one to be passed to the other. During the simulation step of Bullet, the btMotionState
 * allows direct access to the transformation of the physics object to update any graphical peers.
 */
class Isgl3dMotionState : public btMotionState {

public :
	Isgl3dMotionState(Isgl3dNode * sceneNode);
	virtual ~Isgl3dMotionState();

	/**
	 * Gets the transformation of the the Isgl3dNode and applies it to the btRigidBody.
	 * Called internally by the Bullet physics engine.
	 */
	virtual void getWorldTransform(btTransform& centerOfMassWorldTrans ) const;

	/**
	 * Gets the transformation of the the btRigidBody and applies it to the Isgl3dNode.
	 * Called internally by the Bullet physics engine.
	 */
	virtual void setWorldTransform(const btTransform& centerOfMassWorldTrans);


private :
	Isgl3dNode * _node;
	
};


#endif /*ISGL3DMOTIONSTATE_H_*/
