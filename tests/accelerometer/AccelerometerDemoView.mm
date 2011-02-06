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

#import "AccelerometerDemoView.h"
#import "isgl3d.h"

#include "Isgl3dPhysicsWorld.h"
#include "Isgl3dPhysicsObject3D.h"
#include "Isgl3dMotionState.h"

#include "btBulletDynamicsCommon.h"
#include <BulletCollision/CollisionShapes/btBox2dShape.h>

@interface AccelerometerDemoView ()
- (void) translateCamera:(float)phi;
- (Isgl3dPhysicsObject3D *) createPhysicsObject:(Isgl3dMeshNode *)node shape:(btCollisionShape *)shape mass:(float)mass restitution:(float)restitution;
- (void) buildUI;
@end

@implementation AccelerometerDemoView

- (void) dealloc {
	delete _discreteDynamicsWorld;
	delete _collisionConfig;
	delete _broadphase;
	delete _collisionDispatcher;
	delete _constraintSolver;
	
	[_physicsWorld release];

	[super dealloc];
}

- (void) initView {
	[super initView];
	
	_pauseActive = NO;	 	
	_theta = M_PI / 2;
	_orbitalDistance = 20;

	// Initialise camera position
	[self translateCamera:M_PI / 4.0];	

	self.isLandscape = YES;	
		
	self.shadowRenderingMethod = SHADOW_RENDERING_PLANAR;
	self.shadowAlpha = 0.4;
	
}

- (void) initScene {
	[super initScene];
	
	// Create physics world with discrete dynamics
	_collisionConfig = new btDefaultCollisionConfiguration();
	_broadphase = new btDbvtBroadphase();
	_collisionDispatcher = new btCollisionDispatcher(_collisionConfig);
	_constraintSolver = new btSequentialImpulseConstraintSolver;
	_discreteDynamicsWorld = new btDiscreteDynamicsWorld(_collisionDispatcher, _broadphase, _constraintSolver, _collisionConfig);
	_discreteDynamicsWorld->setGravity(btVector3(0,-10,0));

	_physicsWorld = [[Isgl3dPhysicsWorld alloc] init];
	[_physicsWorld setDiscreteDynamicsWorld:_discreteDynamicsWorld];
	[_scene addChild:_physicsWorld];

	// Create the sphere
	Isgl3dTextureMaterial * beachBallMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"BeachBall.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dSphere * sphereMesh = [[Isgl3dSphere alloc] initWithGeometry:1 longs:16 lats:16];
	Isgl3dMeshNode * sphereNode = [_scene createNodeWithMesh:[sphereMesh autorelease] andMaterial:[beachBallMaterial autorelease]];
	[sphereNode setTranslation:0 y:3 z:0];
	sphereNode.enableShadowCasting = YES;

	btCollisionShape * sphereShape = new btSphereShape(sphereMesh.radius);
	[self createPhysicsObject:sphereNode shape:sphereShape mass:1.0 restitution:0.9]; 

	// Create the ground surface
	Isgl3dTextureMaterial * woodMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"wood.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dPlane * plane = [[Isgl3dPlane alloc] initWithGeometry:100.0 height:100.0 nx:10 ny:10];
	Isgl3dMeshNode * groundNode = [_physicsWorld createNodeWithMesh:plane andMaterial:[woodMaterial autorelease]];
	[groundNode setRotation:-90 x:1 y:0 z:0];
	[groundNode setTranslation:0 y:-2 z:0];

	btCollisionShape* groundShape = new btBox2dShape(btVector3(50, 50, 0));
	[self createPhysicsObject:groundNode shape:groundShape mass:0 restitution:0.6];
	
	// Add shadow casting light
	Isgl3dShadowCastingLight * light  = [[Isgl3dShadowCastingLight alloc] initWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.001];
	[light setTranslation:10 y:20 z:10];
	light.planarShadowsNode = groundNode;
	[_scene addChild:light];

	// Initialise accelerometer
	[[Isgl3dAccelerometer sharedInstance] setup:30];
	[[Isgl3dAccelerometer sharedInstance] startTiltCalibration];

	// Build the UI
	[self buildUI];
}

- (void) updateScene {
	[super updateScene];
	
	if (_pauseActive) {
		
		// Don't update the transformation matrices (except for camera)
		[self skipUpdates];

		// Move the camera if it is active
		if (_cameraActive) {
			_theta += 0.05 * [[Isgl3dAccelerometer sharedInstance] rotationAngle];
			[self translateCamera:[[Isgl3dAccelerometer sharedInstance] tiltAngle]];
		}

	}  else {
		// Update gravity if calibration not in progress
		if (![Isgl3dAccelerometer sharedInstance].isCalibrating) {
			float G = 10.0;
			float * gravityVector = [Isgl3dAccelerometer sharedInstance].gravity;

			// Rotate gravity vector x-z components relative to camera horizontal angle
			// (Accelerometer returns gravity relative to the device itself: needs to be converted to coordinates of camera)
			float horizontalAngle = atan2(_camera.viewMatrix.szx, _camera.viewMatrix.szz);
			float transformedGravity[3];
			transformedGravity[0] =  cos(horizontalAngle) * gravityVector[0] + sin(horizontalAngle) * gravityVector[2];
			transformedGravity[1] = gravityVector[1];
			transformedGravity[2] = -sin(horizontalAngle) * gravityVector[0] + cos(horizontalAngle) * gravityVector[2];
			
			[_physicsWorld setGravity:transformedGravity[0] * G y:transformedGravity[1]* G z:transformedGravity[2] * G];
		} else {
			[self skipUpdates];
		}
	}
}

- (void) calibrateAccelerometer:(Isgl3dEvent3D *)event {
	// Calibrates the accelerometer tilt
	[[Isgl3dAccelerometer sharedInstance] startTiltCalibration];
}

- (void) togglePause:(Isgl3dEvent3D *)event {
	// Toggles the scene transformation calculations
	_pauseActive = !_pauseActive;
	if (!_pauseActive) {
		_cameraActive = NO;
	}
	
}

- (void) toggleCamera:(Isgl3dEvent3D *)event {
	// Toggles the camera mode
	_cameraActive = !_cameraActive;
	_pauseActive = _cameraActive;
	
	if (!_cameraActive) {
		[[Isgl3dAccelerometer sharedInstance] startTiltCalibration];
	}
}

- (void) translateCamera:(float)phi {
	// Calculate the position of the camera from given angles
	float y = _orbitalDistance * cos(phi);
	float radius = _orbitalDistance * sin(phi);
	float x = radius * sin(_theta);
	float z = radius * cos(_theta);
	[_camera setTranslation:x y:y z:z];
}

- (Isgl3dPhysicsObject3D *) createPhysicsObject:(Isgl3dMeshNode *)node shape:(btCollisionShape *)shape mass:(float)mass restitution:(float)restitution {
	// Create a motion state for the object
	Isgl3dMotionState * motionState = new Isgl3dMotionState(node);
	
	// Create a rigid body
	btVector3 localInertia(0, 0, 0);
	shape->calculateLocalInertia(mass, localInertia);
	btRigidBody * rigidBody = new btRigidBody(mass, motionState, shape, localInertia);
	rigidBody->setRestitution(restitution);
	rigidBody->setActivationState(DISABLE_DEACTIVATION);

	// Create a physics object and add it to the physics world
	Isgl3dPhysicsObject3D * physicsObject = [[Isgl3dPhysicsObject3D alloc] initWithNode:node andRigidBody:rigidBody];
	[_physicsWorld addPhysicsObject:physicsObject];
	
	return [physicsObject autorelease];
}

- (void) buildUI {
	Isgl3dGLUI * ui = [[Isgl3dGLUI alloc] initWithView:self];

	// Create a button to calibrate the accelerometer
	Isgl3dTextureMaterial * calibrateButtonMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"angle.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dGLUIButton * calibrateButton = [[Isgl3dGLUIButton alloc] initWithMaterial:[calibrateButtonMaterial autorelease]];
	[ui addComponent:[calibrateButton autorelease]];
	[calibrateButton setX:8 andY:8];
	calibrateButton.alpha = 0.7;
	[calibrateButton addEvent3DListener:self method:@selector(calibrateAccelerometer:) forEventType:TOUCH_EVENT];

	// Create a button to pause the scene
	Isgl3dTextureMaterial * pauseButtonMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"pause.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dGLUIButton * pauseButton = [[Isgl3dGLUIButton alloc] initWithMaterial:[pauseButtonMaterial autorelease]];
	[ui addComponent:[pauseButton autorelease]];
	[pauseButton setX:432 andY:270];
	pauseButton.alpha = 0.7;
	[pauseButton addEvent3DListener:self method:@selector(togglePause:) forEventType:TOUCH_EVENT];

	// Create a button to allow movement of the camera
	Isgl3dTextureMaterial * cameraButtonMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"camera.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dGLUIButton * cameraButton = [[Isgl3dGLUIButton alloc] initWithMaterial:[cameraButtonMaterial autorelease]];
	[ui addComponent:[cameraButton autorelease]];
	[cameraButton setX:8 andY:270];
	cameraButton.alpha = 0.7;
	[cameraButton addEvent3DListener:self method:@selector(toggleCamera:) forEventType:TOUCH_EVENT];

	// Activate the ui
	[self setActiveUI:ui];
}

@end



#pragma mark AppController

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppController

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[AccelerometerDemoView alloc] initWithFrame:frame] autorelease];
}

@end
