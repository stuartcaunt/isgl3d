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

#import "Isgl3dVector.h"
#import "Isgl3dCamera.h"

/**
 * The Isgl3dSpringCamera is similar to the Isgl3dFollowCamera in that it is used to automatically
 * move a camera as a target node moves. However, unlike the Isgl3dFollowCamera, it follows the
 * full transformation (position and rotation) of the target rather than its position and movement.
 * 
 * The Isgl3dSpringCamera can be thought of as being attached to the target at a specific desired
 * location relative to the target's local coordinate system. The movement of the camera is such
 * that it appears to be attached via a spring and has damping dependent on its velocity.
 * 
 * By modifying the stiffness of the spring, the amount of damping and its mass, the
 * behaviour of the camera as the target moves can be modified.
 * 
 * As well as a desired position relative to the target, a look-at position (also relative to the  
 * target) can be specified.
 */
@interface Isgl3dSpringCamera : Isgl3dCamera {
	    
@private
	Isgl3dNode * _target;

	//Matrix4D * _targetTransformation;

	Isgl3dVector3 _positionOffset;
	Isgl3dVector3 _lookOffset;
	Isgl3dVector3 _velocity;

	Isgl3dVector3 _desiredPosition;
	Isgl3dVector3 _desiredLookAtPosition;
	Isgl3dVector3 _acceleration;


	float _stiffness;
	float _damping;
	float _mass;
	
	BOOL _initialized;
	BOOL _useRealTime;
}

/**
 * Specifies the desired position of camera relative to the target. 
 */
@property (nonatomic) Isgl3dVector3 positionOffset;

/**
 * Specifies the camera look-at position relative to the target. 
 */
@property (nonatomic) Isgl3dVector3 lookOffset;

/**
 * Modifies the stiffness of the spring. By default this is 10.
 */
@property (nonatomic) float stiffness;

/**
 * Modifies the amount of damping. By default this is 4.
 */
@property (nonatomic) float damping;

/**
 * Modifies the mass of the camera. By default this is 1.
 */
@property (nonatomic) float mass;

/**
 * Returns the target node.
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
