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

#import "PhysicsTestView.h"
#import "Isgl3dPhysicsWorld.h"
#import "Isgl3dPhysicsObject3D.h"
#import "Isgl3dMotionState.h"
#import "Isgl3dDemoCameraController.h"

#import <stdlib.h>
#import <time.h>

#include "btBulletDynamicsCommon.h"
#include "btBox2dShape.h"


@interface PhysicsTestView (PrivateMethods)
- (void) createSphere;
- (void) createCube;
- (Isgl3dPhysicsObject3D *) createPhysicsObject:(Isgl3dMeshNode *)node shape:(btCollisionShape *)shape mass:(float)mass restitution:(float)restitution isFalling:(BOOL)isFalling;
@end

@implementation PhysicsTestView

- (id) init {
	
	if ((self = [super init])) {
		_physicsObjects = [[NSMutableArray alloc] init];
	 	_lastStepTime = [[NSDate alloc] init];
	 
	 	srandom(time(NULL));
	
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 16;
		_cameraController.theta = 30;
		_cameraController.phi = 30;
		_cameraController.doubleTapEnabled = NO;
		
		// Enable shadow rendering
		[Isgl3dDirector sharedInstance].shadowRenderingMethod = Isgl3dShadowPlanar;
		[Isgl3dDirector sharedInstance].shadowAlpha = 0.4;


		// Create physics world with discrete dynamics
		_collisionConfig = new btDefaultCollisionConfiguration();
		_broadphase = new btDbvtBroadphase();
		_collisionDispatcher = new btCollisionDispatcher(_collisionConfig);
		_constraintSolver = new btSequentialImpulseConstraintSolver;
		_discreteDynamicsWorld = new btDiscreteDynamicsWorld(_collisionDispatcher, _broadphase, _constraintSolver, _collisionConfig);
		_discreteDynamicsWorld->setGravity(btVector3(0,-10,0));
	
		_physicsWorld = [[Isgl3dPhysicsWorld alloc] init];
		[_physicsWorld setDiscreteDynamicsWorld:_discreteDynamicsWorld];
		[self.scene addChild:_physicsWorld];
	
		// Create textures
		_beachBallMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"BeachBall.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
		_isglLogo = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"cardboard.jpg" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
		Isgl3dTextureMaterial * woodMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"wood.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	
	
		float radius = 1.0;
		float width = 2.0;
		_sphereMesh = [[Isgl3dSphere alloc] initWithGeometry:radius longs:16 lats:16];
		_cubeMesh = [[Isgl3dCube alloc] initWithGeometry:width height:width depth:width nx:2 ny:2];
	
		// Create two nodes for the different meshes
		_cubesNode = [[_physicsWorld createNode] retain];
		_spheresNode = [[_physicsWorld createNode] retain];
	
	
		// Create the ground surface
		Isgl3dPlane * plane = [[Isgl3dPlane alloc] initWithGeometry:10.0 height:10.0 nx:10 ny:10];
		btCollisionShape* groundShape = new btBox2dShape(btVector3(5, 5, 0));
		Isgl3dMeshNode * node = [_physicsWorld createNodeWithMesh:plane andMaterial:[woodMaterial autorelease]];
		[node setRotation:-90 x:1 y:0 z:0];
		[node setTranslation:0 y:-2 z:0];
		Isgl3dPhysicsObject3D * physicsObject = [self createPhysicsObject:node shape:groundShape mass:0 restitution:0.6 isFalling:NO];
		
	
		_light  = [[Isgl3dShadowCastingLight alloc] initWithHexColor:@"111111" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.003];
		[self.scene addChild:_light];
		[_light setTranslation:10 y:20 z:10];
	
		_light.planarShadowsNode = physicsObject.node;
	
		[self setSceneAmbient:@"666666"];


		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
	[_cameraController release];

	delete _discreteDynamicsWorld;
	delete _collisionConfig;
	delete _broadphase;
	delete _collisionDispatcher;
	delete _constraintSolver;
	
	[_physicsObjects release];
	[_physicsWorld release];
	[_beachBallMaterial release];
	[_isglLogo release];
	[_sphereMesh release];
	[_cubeMesh release];

	[_light release];
	
	[_cubesNode release];
	[_spheresNode release];

	[super dealloc];
}

- (void) onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController];
}

- (void) onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

- (void) tick:(float)dt {

	// Get time since last step
	NSDate * currentTime = [[NSDate alloc] init];
	
	NSTimeInterval timeInterval = [currentTime timeIntervalSinceDate:_lastStepTime];

	// Add new object every 0.5 seconds
	if (timeInterval > 0.2) {
		if (1.0 * random() / RAND_MAX > 0.5) {
			[self createSphere];
		} else {
			[self createCube];
		}
		
		[_lastStepTime release];
		_lastStepTime = currentTime;
	} else {
		[currentTime release];
	}

	// Remove objects that have fallen too low
	NSMutableArray * objectsToDelete = [[NSMutableArray alloc] init];
	
	for (Isgl3dPhysicsObject3D * physicsObject in _physicsObjects) {
		if (physicsObject.node.y < -10) {
			[objectsToDelete addObject:physicsObject];
		}
		
	}

	for (Isgl3dPhysicsObject3D * physicsObject in objectsToDelete) {
		[_physicsWorld removePhysicsObject:physicsObject];
		[_physicsObjects removeObject:physicsObject];
	}
	
	[objectsToDelete release];

	
	// update camera
	[_cameraController update];
}


- (void) createSphere {
	
	btCollisionShape * sphereShape = new btSphereShape(_sphereMesh.radius);
	Isgl3dMeshNode * node = [_spheresNode createNodeWithMesh:_sphereMesh andMaterial:_beachBallMaterial];
	[self createPhysicsObject:node shape:sphereShape mass:0.5 restitution:0.9 isFalling:YES]; 

	node.enableShadowCasting = YES;
	
}

- (void) createCube {
	
	btCollisionShape* boxShape = new btBoxShape(btVector3(_cubeMesh.width / 2, _cubeMesh.height / 2, _cubeMesh.depth / 2));
	Isgl3dMeshNode * node = [_cubesNode createNodeWithMesh:_cubeMesh andMaterial:_isglLogo];
	[self createPhysicsObject:node shape:boxShape mass:2 restitution:0.4 isFalling:YES]; 
	node.enableShadowCasting = YES;
}

- (Isgl3dPhysicsObject3D *) createPhysicsObject:(Isgl3dMeshNode *)node shape:(btCollisionShape *)shape mass:(float)mass restitution:(float)restitution isFalling:(BOOL)isFalling {

	if (isFalling) {
		[node setTranslation:1.5 - (3.0 * random() / RAND_MAX) y:10 + (10.0 * random() / RAND_MAX) z:1.5 - (3.0 * random() / RAND_MAX)];
	}

	Isgl3dMotionState * motionState = new Isgl3dMotionState(node);
	
	btVector3 localInertia(0, 0, 0);
	shape->calculateLocalInertia(mass, localInertia);
	btRigidBody * rigidBody = new btRigidBody(mass, motionState, shape, localInertia);
	rigidBody->setRestitution(restitution);

	Isgl3dPhysicsObject3D * physicsObject = [[Isgl3dPhysicsObject3D alloc] initWithNode:node andRigidBody:rigidBody];
	[_physicsWorld addPhysicsObject:physicsObject];

	[_physicsObjects addObject:physicsObject];
	
	return [physicsObject autorelease];
}


@end



#pragma mark AppDelegate

/*
 * Implement principal class: simply override the createViews method to return the desired demo view.
 */
@implementation AppDelegate

- (void) createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;

	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [PhysicsTestView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
