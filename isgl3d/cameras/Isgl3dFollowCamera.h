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

#import "Isgl3dCamera.h"
#import "Isgl3dMiniVec.h"

/**
 * The Isgl3dFollowCamera is used to follow the movement (translations) of a target node.
 * 
 * Unlike the Isgl3dSpringCamera (which is assumed to be fixed to a point on the target), the follow
 * camera will not react to rotations of the target, only the translations in space.
 * 
 * As the target node moves, the camera will attempt to follow it as if it is attached with a spring and
 * with resistance. If the target is rolling across a plane, the camera will maintain its position
 * relative to the rolling object but will not roll with it.
 * 
 * By modifying the stiffness of the spring, the resistance to movement and the mass of the camera,
 * the behaviour of the camera can be changed accordingly.
 */
@interface Isgl3dFollowCamera : Isgl3dCamera {
	    
@private
	Isgl3dNode * _target;

	Isgl3dMatrix4D * _targetMovementIT;

	Isgl3dMiniVec3D _currentTargetPosition;
	Isgl3dMiniVec3D _currentPosition;
	
	Isgl3dMiniVec3D _oldTargetPosition;
	Isgl3dMiniVec3D _oldPosition;
	
	Isgl3dMiniVec3D _desiredPosition;
	Isgl3dMiniVec3D _elasticForce;
	Isgl3dMiniVec3D _dampingForce;
	Isgl3dMiniVec3D _velocity;
	Isgl3dMiniVec3D _acceleration;
	Isgl3dMiniVec3D _newVelocity;
	Isgl3dMiniVec3D _newPosition;
	Isgl3dMiniVec3D _newPositionInPlane;
	Isgl3dMiniVec3D _targetPosition;

	float _stiffness;
	float _damping;
	float _mass;
	float _lookAhead;

	BOOL _useRealTime;
	NSDate * _time;
	
	BOOL _initialized;
}

/**
 * The desired position of the camera, relative to the target node.
 */
@property (nonatomic) Isgl3dMiniVec3D desiredPosition;

/**
 * The stiffness of the spring attaching the camera to the target node.
 */
@property (nonatomic) float stiffness;

/**
 * The damping of the movement of the camera.
 */
@property (nonatomic) float damping;

/**
 * The mass of the camera (higher mass requires more force in the spring to move the camera).
 */
@property (nonatomic) float mass;

/**
 * The offset in front of the target node to which the camera is directed. 
 */
@property (nonatomic) float lookAhead;

/**
 * The target node.
 */
@property (readonly) Isgl3dNode * target;

/**
 * Uses real time to calculate the changes in position and the resulting acceleration on the camera.
 * This can produce adverse effects if low frame rates are encountered. If not using real time, a delay 
 * of 1/60s is assumed.
 */
@property (nonatomic) BOOL useRealTime;

/**
 * Initialises the Isgl3dFollowCamera with the view and target node
 * @param view3D The Isgl3dView3D in use.
 * @param target The target node.
 */
- (id) initWithView:(Isgl3dView3D *)view3D andTarget:(Isgl3dNode *)target;

/**
 * Sets the target to a different Isgl3dNode.
 * @param target The target node.
 */
- (void) setTarget:(Isgl3dNode *)target;

@end
