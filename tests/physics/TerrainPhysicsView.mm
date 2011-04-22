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

#import "TerrainPhysicsView.h"
#import "Isgl3dPhysicsWorld.h"
#import "Isgl3dPhysicsObject3D.h"
#import "Isgl3dMotionState.h"
#import "Isgl3dDemoCameraController.h"

#include "btBulletDynamicsCommon.h"
#include "btBox2dShape.h"
#include "btHeightfieldTerrainShape.h"

@interface TerrainPhysicsView ()
- (void) createSphere;
- (Isgl3dPhysicsObject3D *) createPhysicsObject:(Isgl3dMeshNode *)node shape:(btCollisionShape *)shape mass:(float)mass restitution:(float)restitution isFalling:(BOOL)isFalling;
- (btCollisionShape *) createTerrainShapeFromFile:(NSString *)terrainDataFile width:(float)width depth:(float)depth nx:(unsigned int)nx ny:(unsigned int)ny channel:(unsigned int)channel height:(float)height;
- (UIImage *) loadImage:(NSString *)path;
@end

@implementation TerrainPhysicsView

- (id) init {
	
	if ((self = [super init])) {
		_physicsObjects = [[NSMutableArray alloc] init];
		_timeInterval = 0;
		
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 40;
		_cameraController.theta = 30;
		_cameraController.phi = 10;
		_cameraController.doubleTapEnabled = NO;

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

		// Create terrain node
		Isgl3dTextureMaterial * textureMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"RaceTrack1Terrain_1024.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dTerrainMesh * terrainMesh = [Isgl3dTerrainMesh meshWithTerrainDataFile:@"RaceTrack1Path_512.png" channel:2 width:32 depth:32 height:10 nx:32 nz:32];
		_terrain = [_physicsWorld createNodeWithMesh:terrainMesh andMaterial:textureMaterial];

		// Create terrain physics object
		btCollisionShape * terrainShape = [self createTerrainShapeFromFile:@"RaceTrack1Path_512.png" width:32 depth:32 nx:64 ny:64 channel:2 height:10];
		[self createPhysicsObject:_terrain shape:terrainShape mass:0 restitution:0.6 isFalling:NO];

		// Create elements for falling spheres
		_beachBallMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"BeachBall.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		float radius = 1.0;
		_sphereMesh = [[Isgl3dSphere alloc] initWithGeometry:radius longs:16 lats:16];
		_spheresNode = [[_physicsWorld createNode] retain];
	
		// Add light
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.002];
		[light setDirection:-1 y:-2 z:1];
		[self.scene addChild:light];	

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

	free(_terrainHeightData);
	
	[_physicsObjects release];
	[_physicsWorld release];
	[_beachBallMaterial release];
	[_sphereMesh release];
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

	_timeInterval += dt;
	
	// Add new object every 0.2 seconds
	if (_timeInterval > 0.2) {
		[self createSphere];
		_timeInterval = 0;		
	}

	// Remove objects that have fallen too low
	NSMutableArray * objectsToDelete = [NSMutableArray arrayWithCapacity:0];
	
	for (Isgl3dPhysicsObject3D * physicsObject in _physicsObjects) {
		if (physicsObject.node.y < -10) {
			[objectsToDelete addObject:physicsObject];
		}
	}

	for (Isgl3dPhysicsObject3D * physicsObject in objectsToDelete) {
		[_physicsWorld removePhysicsObject:physicsObject];
		[_physicsObjects removeObject:physicsObject];
	}
	
	// update camera
	[_cameraController update];
}

- (btCollisionShape *) createTerrainShapeFromFile:(NSString *)terrainDataFile width:(float)width depth:(float)depth nx:(unsigned int)nx ny:(unsigned int)ny channel:(unsigned int)channel height:(float)height {
	// Create UIImage
	UIImage * terrainDataImage = [self loadImage:terrainDataFile];
	
	// Get raw data from image
	unsigned int imageWidth = terrainDataImage.size.width;  
	unsigned int imageHeight = terrainDataImage.size.height;   
	unsigned char * pixelData = (unsigned char *)malloc(imageWidth * imageHeight * 4);  
	   
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(pixelData, imageWidth, imageHeight, 8, imageWidth * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	CGContextClearRect(context, CGRectMake(0, 0, imageWidth, imageHeight));
	CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), terrainDataImage.CGImage);  
	CGContextRelease(context);  

	// Create array of heights
	unsigned int heightDataNx = nx + 1;
	unsigned int heightDataNy = ny + 1;
	
	_terrainHeightData = (float *)malloc(heightDataNx * heightDataNy * sizeof(float));
	
	// Iterate once to get all terrain data needed in a simple array
	for (int j = 0; j <= ny; j++) {
		unsigned int pixelY = (j * imageHeight) / ny;
		if (pixelY >= imageHeight) {
			pixelY = imageHeight - 1;
		}

		for (int i = 0; i <= nx; i++) {
			unsigned int pixelX = (i * imageWidth) / nx;
			if (pixelX >= imageWidth) {
				pixelX = imageWidth - 1;
			}
						
			float pixelValue = pixelData[(pixelY * imageWidth + pixelX) * 4 + channel] / 255.0;
			_terrainHeightData[j * heightDataNx + i] = pixelValue * height;
		}
	}		
	

	// Create height field shape:
	//  Use identical min and max values to align zero of physics object with rendered zero
	//  Use margin in max height to ensure all terrain data is rendered up to max value
	btHeightfieldTerrainShape * groundShape = new btHeightfieldTerrainShape(heightDataNx, heightDataNy, _terrainHeightData, 1.0, -1.0 * height, 1.0 * height, 1, PHY_FLOAT, false);
	groundShape->setLocalScaling(btVector3(width / nx, 1.f, depth / ny));
	free (pixelData);
	
	return groundShape;	
}

- (void) createSphere {
	
	btCollisionShape * sphereShape = new btSphereShape(_sphereMesh.radius);
	Isgl3dMeshNode * node = [_spheresNode createNodeWithMesh:_sphereMesh andMaterial:_beachBallMaterial];
	[self createPhysicsObject:node shape:sphereShape mass:0.5 restitution:0.9 isFalling:YES]; 

	node.enableShadowCasting = YES;
	
}

- (Isgl3dPhysicsObject3D *) createPhysicsObject:(Isgl3dMeshNode *)node shape:(btCollisionShape *)shape mass:(float)mass restitution:(float)restitution isFalling:(BOOL)isFalling {

	if (isFalling) {
		[node setPositionValues:10 - (20.0 * random() / RAND_MAX) y:20 z:10 - (20.0 * random() / RAND_MAX)];
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

- (UIImage *) loadImage:(NSString *)path {
	// cut filename into name and extension
	NSString * extension = [path pathExtension];
	NSString * fileName = [path stringByDeletingPathExtension];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
	if (!filePath) {
		NSLog(@"Failed to load %@", path);
		return nil;
	}
	
	NSData * imageData = [[NSData alloc] initWithContentsOfFile:filePath];
    UIImage * image = [[UIImage alloc] initWithData:imageData];
   	[imageData release];
    
	if (image == nil) {
		NSLog(@"Failed to load %@", path);
	}

	return [image autorelease];	
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
	Isgl3dView * view = [TerrainPhysicsView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
