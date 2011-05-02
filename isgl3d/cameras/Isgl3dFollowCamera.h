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

	Isgl3dMatrix4 _targetMovementIT;

	Isgl3dVector3 _currentTargetPosition;
	Isgl3dVector3 _currentPosition;
	
	Isgl3dVector3 _oldTargetPosition;
	Isgl3dVector3 _oldPosition;
	
	Isgl3dVector3 _desiredPosition;
	Isgl3dVector3 _elasticForce;
	Isgl3dVector3 _dampingForce;
	Isgl3dVector3 _velocity;
	Isgl3dVector3 _acceleration;
	Isgl3dVector3 _newVelocity;
	Isgl3dVector3 _newPosition;
	Isgl3dVector3 _newPositionInPlane;
	Isgl3dVector3 _targetPosition;

	float _stiffness;
	float _damping;
	float _mass;
	float _lookAhead;

	BOOL _useRealTime;
	
	BOOL _initialized;
}

/**
 * The desired position of the camera, relative to the target node.
 */
@property (nonatomic) Isgl3dVector3 desiredPosition;

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
 * Allocates and initialises (autorelease) camera with a target node.
 * Note: For perspective projections the camera can only be used if the width and height are set 
 * @param target The target node.
 */
+ (id) cameraWithTarget:(Isgl3dNode *)target;

/**
 * Allocates and initialises (autorelease) camera with a specified width and height and a target.
 * @param width The width of the view.
 * @param height The height of the view.
 * @param target The target node.
 */
+ (id) cameraWithWidth:(float)width andHeight:(float)height andTarget:(Isgl3dNode *)target;

/**
 * Allocates and initialises (autorelease) camera with user-defined geometry and a target node.
 * @param width The width of the view.
 * @param height The height of the view.
 * @param x The x position of the camera.
 * @param y The y position of the camera.
 * @param z The z position of the camera.
 * @param upX The x component of the up vector.
 * @param upY The y component of the up vector.
 * @param upZ The z component of the up vector.
 * @param lookAtX The x position where the camera will look at.
 * @param lookAtY The y position where the camera will look at.
 * @param lookAtZ The z position where the camera will look at.
 * @param target The target node.
 */
+ (id) cameraWithWidth:(float)width height:(float)height andCoordinates:(float)x y:(float)y z:(float)z upX:(float)upX upY:(float)upY upZ:(float)upZ lookAtX:(float)lookAtX lookAtY:(float)lookAtY lookAtZ:(float)lookAtZ andTarget:(Isgl3dNode *)target;

/**
 * Initialises the camera with a target node.
 * Note: For perspective projections the camera can only be used if the width and height are set 
 * @param target The target node.
 */
- (id) initWithTarget:(Isgl3dNode *)target;

/**
 * Initialises the camera with a specified width and height and a target.
 * @param width The width of the view.
 * @param height The height of the view.
 * @param target The target node.
 */
- (id) initWithWidth:(float)width andHeight:(float)height andTarget:(Isgl3dNode *)target;

/**
 * Initialises the camera with user-defined geometry and a target node.
 * @param width The width of the view.
 * @param height The height of the view.
 * @param x The x position of the camera.
 * @param y The y position of the camera.
 * @param z The z position of the camera.
 * @param upX The x component of the up vector.
 * @param upY The y component of the up vector.
 * @param upZ The z component of the up vector.
 * @param lookAtX The x position where the camera will look at.
 * @param lookAtY The y position where the camera will look at.
 * @param lookAtZ The z position where the camera will look at.
 * @param target The target node.
 */
- (id) initWithWidth:(float)width height:(float)height andCoordinates:(float)x y:(float)y z:(float)z upX:(float)upX upY:(float)upY upZ:(float)upZ lookAtX:(float)lookAtX lookAtY:(float)lookAtY lookAtZ:(float)lookAtZ andTarget:(Isgl3dNode *)target;

/**
 * Sets the target to a different Isgl3dNode.
 * @param target The target node.
 */
- (void) setTarget:(Isgl3dNode *)target;

@end
