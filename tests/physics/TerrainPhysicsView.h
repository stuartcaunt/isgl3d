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

#import "isgl3d.h"

@class Isgl3dDemoCameraController;
@class Isgl3dPhysicsWorld;

class btDefaultCollisionConfiguration;
class btDbvtBroadphase;
class btCollisionDispatcher;
class btSequentialImpulseConstraintSolver;
class btDiscreteDynamicsWorld;

@interface TerrainPhysicsView : Isgl3dBasic3DView {

	btDefaultCollisionConfiguration * _collisionConfig;
	btDbvtBroadphase * _broadphase;
	btCollisionDispatcher * _collisionDispatcher;
	btSequentialImpulseConstraintSolver * _constraintSolver;
	btDiscreteDynamicsWorld * _discreteDynamicsWorld;

	
	Isgl3dMeshNode * _terrain;
	float * _terrainHeightData;
	
	Isgl3dPhysicsWorld * _physicsWorld;
	Isgl3dNode * _spheresNode;
	NSMutableArray * _physicsObjects;
	Isgl3dTextureMaterial * _beachBallMaterial;
	Isgl3dSphere * _sphereMesh;
	float _timeInterval;
	
	Isgl3dDemoCameraController * _cameraController;	
}

@end


/*
 * Principal class to be instantiated in main.h. 
 */
#import "Isgl3dAppDelegate.h"
@interface AppDelegate : Isgl3dAppDelegate
- (void) createViews;
@end


