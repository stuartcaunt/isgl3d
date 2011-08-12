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

#import "Isgl3dNode.h"
#import "Isgl3dMeshNode.h"
#import "Isgl3dParticleNode.h"
#import "Isgl3dBillboardNode.h"
#import "Isgl3dFollowNode.h"
#import "Isgl3dSkeletonNode.h"
#import "Isgl3dCamera.h"
#import "Isgl3dLight.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dQuaternion.h"
#import "Isgl3dDirector.h"
#import "Isgl3dActionManager.h"
#import "Isgl3dAction.h"

static Isgl3dOcclusionMode Isgl3dNode_OcclusionMode = Isgl3dOcclusionQuadDistanceAndAngle;

@interface Isgl3dNode ()
- (void) updateEulerAngles;
- (void) updateRotationMatrix;
- (void) updateLocalTransformation; 
@end

@implementation Isgl3dNode

@synthesize worldTransformation = _worldTransformation;
@synthesize parent = _parent;
@synthesize children = _children;
@synthesize enableShadowRendering = _enableShadowRendering;
@synthesize enableShadowCasting = _enableShadowCasting;
@synthesize isPlanarShadowsNode = _isPlanarShadowsNode;
@synthesize alpha = _alpha;
@synthesize transparent = _transparent;
@synthesize alphaCulling = _alphaCulling;
@synthesize alphaCullValue = _alphaCullValue;
@synthesize interactive = _interactive;
@synthesize isVisible = _isVisible;

+ (id) node {
	return [[[self alloc] init] autorelease];
}

- (id) init {    
    if ((self = [super init])) {

		_localTransformation = im4Identity();
		_worldTransformation = im4Identity();

		_rotationX = 0;    	
		_rotationY = 0;    	
		_rotationZ = 0;    	
		_scaleX = 1;    	
		_scaleY = 1;    	
		_scaleZ = 1;    	

    	_eulerAnglesDirty = NO;
		_rotationMatrixDirty = NO;
		_localTransformationDirty = NO;
		_transformationDirty = YES;


       	_children = [[NSMutableArray alloc] init];

    	_enableShadowRendering = YES;
    	_enableShadowCasting = NO;
    	_isPlanarShadowsNode = NO;
    	
    	_hasChildren = NO;

    	_alpha = 1.0;
		_transparent = NO;
		_alphaCullValue = 0.0;
		_alphaCulling = NO;
		
		_lightingEnabled = YES;
		_interactive = NO;
		
		_isVisible = YES;
	}
	
    return self;
}

- (void) dealloc {
	[_children release];

	[[Isgl3dActionManager sharedInstance] stopAllActionsForTarget:self];
	
	[super dealloc];
}

- (id) copyWithZone:(NSZone *)zone {
    Isgl3dNode * copy = [[[self class] allocWithZone:zone] init];

	copy->_rotationX = _rotationX;
	copy->_rotationY = _rotationY;
	copy->_rotationZ = _rotationZ;
	copy->_scaleX = _scaleX;
	copy->_scaleY = _scaleY;
	copy->_scaleZ = _scaleZ;
    
    copy->_worldTransformation = _worldTransformation;
    copy->_localTransformation = _localTransformation;

    copy->_transformationDirty = _transformationDirty;
    copy->_localTransformationDirty = _localTransformationDirty;
    copy->_eulerAnglesDirty = _eulerAnglesDirty;
    copy->_rotationMatrixDirty = _rotationMatrixDirty;

    copy->_lightingEnabled = _lightingEnabled;
    copy->_enableShadowCasting = _enableShadowCasting;
    copy->_enableShadowRendering = _enableShadowRendering;
    copy->_isPlanarShadowsNode = _isPlanarShadowsNode;
    copy->_alpha = _alpha;
    copy->_transparent = _transparent;
    copy->_alphaCulling = _alphaCulling;
    copy->_alphaCullValue = _alphaCullValue;
    copy->_lightingEnabled = _lightingEnabled;
    copy->_interactive = _interactive;
    copy->_isVisible = _isVisible;

	for (Isgl3dNode * child in _children) {
		[copy addChild:[[child copy] autorelease]];
	}
	
    return copy;
}

#pragma mark translation rotation scaling

- (float) x {
	return _localTransformation.tx;
}

- (void) setX:(float)x {
	_localTransformation.tx = x;
	
	_transformationDirty = YES;
}

- (float) y {
	return _localTransformation.ty;
}

- (void) setY:(float)y {
	_localTransformation.ty = y;
	
	_transformationDirty = YES;
}

- (float) z {
	return _localTransformation.tz;
}

- (void) setZ:(float)z {
	_localTransformation.tz = z;
	
	_transformationDirty = YES;
}

- (Isgl3dVector3) position {
	return im4ToPosition(&_localTransformation);
}

- (void) setPosition:(Isgl3dVector3)position {
	_localTransformation.tx = position.x;
	_localTransformation.ty = position.y;
	_localTransformation.tz = position.z;
	
	_transformationDirty = YES;
}

- (float) rotationX {
	if (_eulerAnglesDirty) {
		[self updateEulerAngles];
	}
	return _rotationX;
}

- (void) setRotationX:(float)rotationX {
	_rotationX = rotationX;
	
	_rotationMatrixDirty = YES;
	_localTransformationDirty = YES;
}

- (float) rotationY {
	if (_eulerAnglesDirty) {
		[self updateEulerAngles];
	}
	return _rotationY;
}

- (void) setRotationY:(float)rotationY {
	_rotationY = rotationY;
	
	_rotationMatrixDirty = YES;
	_localTransformationDirty = YES;
}

- (float) rotationZ {
	if (_eulerAnglesDirty) {
		[self updateEulerAngles];
	}
	return _rotationZ;
}

- (void) setRotationZ:(float)rotationZ {
	_rotationZ = rotationZ;
	
	_rotationMatrixDirty = YES;
	_localTransformationDirty = YES;
}

- (float) scaleX {
	return _scaleX;
}

- (void) setScaleX:(float)scaleX {
	_scaleX = scaleX;

	_localTransformationDirty = YES;
}

- (float) scaleY {
	return _scaleY;
}

- (void) setScaleY:(float)scaleY {
	_scaleY = scaleY;

	_localTransformationDirty = YES;
}

- (float) scaleZ {
	return _scaleZ;
}

- (void) setScaleZ:(float)scaleZ {
	_scaleZ = scaleZ;

	_localTransformationDirty = YES;
}

- (void) setPositionValues:(float)x y:(float)y z:(float)z {
	im4SetTranslation(&_localTransformation, x, y, z);
	
	_transformationDirty = YES;
}

- (void) translateByValues:(float)x y:(float)y z:(float)z {
	if (_rotationMatrixDirty) {
		[self updateRotationMatrix];
	}
	im4Translate(&_localTransformation, x, y, z);
	
	_transformationDirty = YES;
}

- (void) translateByVector:(Isgl3dVector3)vector {
	if (_rotationMatrixDirty) {
		[self updateRotationMatrix];
	}
	im4TranslateByVector(&_localTransformation, &vector);
	
	_transformationDirty = YES;
}

- (void) pitch:(float)angle {
	if (_rotationMatrixDirty) {
		[self updateRotationMatrix];
	}

	Isgl3dVector3 axis = im4MultVector3x3(&_localTransformation, &Isgl3dVector3Right);
	[self rotate:angle x:axis.x y:axis.y z:axis.z];
}

- (void) yaw:(float)angle {
	if (_rotationMatrixDirty) {
		[self updateRotationMatrix];
	}

	Isgl3dVector3 axis = im4MultVector3x3(&_localTransformation, &Isgl3dVector3Up);
	[self rotate:angle x:axis.x y:axis.y z:axis.z];
}

- (void) roll:(float)angle {
	if (_rotationMatrixDirty) {
		[self updateRotationMatrix];
	}

	Isgl3dVector3 axis = im4MultVector3x3(&_localTransformation, &Isgl3dVector3Backward);
	[self rotate:angle x:axis.x y:axis.y z:axis.z];
}

- (void) rotate:(float)angle x:(float)x y:(float)y z:(float)z {
	im4Rotate(&_localTransformation, angle, x, y, z);
	
	_rotationMatrixDirty = NO;
	_eulerAnglesDirty = YES;
	_localTransformationDirty = YES;
}

- (void) setRotation:(float)angle x:(float)x y:(float)y z:(float)z {
	im4SetRotation(&_localTransformation, angle, x, y, z);
	
	_rotationMatrixDirty = NO;
	_eulerAnglesDirty = YES;
	_localTransformationDirty = YES;
}


- (void) setScale:(float)scale {
	[self setScale:scale scaleY:scale scaleZ:scale];
}

- (void) setScale:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ {
	_scaleX = scaleX;
	_scaleY = scaleY;
	_scaleZ = scaleZ;

	_localTransformationDirty = YES;
}

- (void) resetTransformation {
	_localTransformation = im4Identity();
	
	_localTransformationDirty = YES;
	_rotationMatrixDirty = NO;
	_eulerAnglesDirty = YES;
}

- (void) setTransformation:(Isgl3dMatrix4)transformation {
	_localTransformation = transformation;
	
	_localTransformationDirty = YES;
	_rotationMatrixDirty = NO;
	_eulerAnglesDirty = YES;
}

- (void) setTransformationFromOpenGLMatrix:(float *)transformation {
	im4SetTransformationFromOpenGLMatrix(&_localTransformation, transformation);
	
	_localTransformationDirty = YES;
	_rotationMatrixDirty = NO;
	_eulerAnglesDirty = YES;
}

- (void) getTransformationAsOpenGLMatrix:(float *)transformation {
	if (_localTransformationDirty) {
		[self updateLocalTransformation];
	}
	
	im4GetTransformationAsOpenGLMatrix(&_localTransformation, transformation);
}


- (void) copyWorldPositionToArray:(float *)position {
	position[0] = _worldTransformation.tx;
	position[1] = _worldTransformation.ty;
	position[2] = _worldTransformation.tz;
	position[3] = _worldTransformation.tw;
}

- (Isgl3dVector3) worldPosition {
	return iv3(_worldTransformation.tx, _worldTransformation.ty, _worldTransformation.tz);
	
}

- (float) getZTransformation:(Isgl3dMatrix4 *)viewMatrix {
	Isgl3dMatrix4 modelViewMatrix;
	im4Copy(&modelViewMatrix, viewMatrix);
	im4Multiply(&modelViewMatrix, &_worldTransformation);
	
	float z = modelViewMatrix.tz;
	
	return z;
}

- (Isgl3dVector4) asPlaneWithNormal:(Isgl3dVector3)normal {
	
	Isgl3dVector3 transformedNormal = im4MultVector3x3(&_worldTransformation, &normal); 
	
	float A = transformedNormal.x;
	float B = transformedNormal.y;
	float C = transformedNormal.z;
	float D = -(A * _worldTransformation.tx + B * _worldTransformation.ty + C * _worldTransformation.tz);
	
	return iv4(A, B, C, D);
}

- (void) updateEulerAngles {
	Isgl3dVector3 r = im4ToEulerAngles(&_localTransformation);
	_rotationX = r.x;
	_rotationY = r.y;
	_rotationZ = r.z;
	
	_eulerAnglesDirty = NO;
}

- (void) updateRotationMatrix {
	im4SetRotationFromEuler(&_localTransformation, _rotationX, _rotationY, _rotationZ);
	
	_rotationMatrixDirty = NO;
}

- (void) updateLocalTransformation {
	// Translation already set
	
	// Convert rotation matrix into euler angles if necessary
	if (_rotationMatrixDirty) {
		[self updateRotationMatrix];
	}
	
	// Scale transformation (no effect on translation)
	im4Scale(&_localTransformation, _scaleX, _scaleY, _scaleZ);
	
	_localTransformationDirty = NO;
	_transformationDirty = YES;
}


- (void) setTransformationDirty:(BOOL)isDirty {
	_transformationDirty = isDirty;
}

- (void) updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {
	
	// Recalculate local transformation if necessary
	if (_localTransformationDirty) {
		[self updateLocalTransformation];
	}
	
	// Update transformation matrices if needed
	if (_transformationDirty) {

		// Let all children know that they must update their world transformation, 
		//   even if they themselves have not locally changed
		if (_hasChildren) {
			for (Isgl3dNode * node in _children) {
				[node setTransformationDirty:YES];
			}
		}

		// Calculate world transformation
		if (parentTransformation) {
			im4Copy(&_worldTransformation, parentTransformation);
			im4Multiply(&_worldTransformation, &_localTransformation);
			
		} else {
			im4Copy(&_worldTransformation, &_localTransformation);
		}
		
		_transformationDirty = NO;
	}
	
	// Update all children transformations
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node updateWorldTransformation:&_worldTransformation];
	    }
	}
}

#pragma mark scene graph

- (Isgl3dNode *) createNode {
	return [self addChild:[Isgl3dNode node]];
}

- (Isgl3dMeshNode *) createNodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material {
	return (Isgl3dMeshNode *)[self addChild:[Isgl3dMeshNode nodeWithMesh:mesh andMaterial:material]];
}

- (Isgl3dParticleNode *) createNodeWithParticle:(Isgl3dGLParticle *)particle andMaterial:(Isgl3dMaterial *)material {
	return (Isgl3dParticleNode *)[self addChild:[Isgl3dParticleNode nodeWithParticle:particle andMaterial:material]];
}

- (Isgl3dBillboardNode *) createBillboardNodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material {
	return (Isgl3dBillboardNode *)[self addChild:[Isgl3dBillboardNode nodeWithMesh:mesh andMaterial:material]];
}

- (Isgl3dSkeletonNode *) createSkeletonNode {
	return (Isgl3dSkeletonNode *)[self addChild:[Isgl3dSkeletonNode skeletonNode]];
}

- (Isgl3dFollowNode *) createFollowNodeWithTarget:(Isgl3dNode *)target {
	return (Isgl3dFollowNode *)[self addChild:[Isgl3dFollowNode nodeWithTarget:target]];
}

- (Isgl3dLight *) createLightNode {
	return (Isgl3dLight *)[self addChild:[Isgl3dLight light]];
}

- (Isgl3dNode *) addChild:(Isgl3dNode *)child {
	child.parent = self;
	[_children addObject:child];
	_hasChildren = YES;
	
	if (_isRunning) {
		[child activate];
	}
	
	return child;
}

- (void) removeChild:(Isgl3dNode *)child {
	child.parent = nil;
	[_children removeObject:child];
	
	if (_isRunning) {
		[child deactivate];
	}
	
	[[Isgl3dActionManager sharedInstance] stopAllActionsForTarget:self];
	
	if ([_children count] == 0) {
		_hasChildren = NO;
	}
}

- (void) removeFromParent {
	[_parent removeChild:self];
}

- (void) activate {
	_isRunning = YES;
	for (Isgl3dNode * child in _children) {
		[child activate];
	}
	
	[[Isgl3dActionManager sharedInstance] resumeActionsForTarget:self];
	
	[self onActivated];
}

- (void) deactivate {
	_isRunning = NO;
	for (Isgl3dNode * child in _children) {
		[child deactivate];
	}

	[[Isgl3dActionManager sharedInstance] pauseActionsForTarget:self];
	
	[self onDeactivated];
}

- (void) onActivated {
	// To be over-ridden	
}

- (void) onDeactivated {
	// To be over-ridden	
}

- (void) clearAll {
	[_children removeAllObjects];
}

- (void) renderLights:(Isgl3dGLRenderer *)renderer {
	
	if (_hasChildren && _isVisible) {
		for (Isgl3dNode * node in _children) {
			if (node.isVisible) {
				[node renderLights:renderer];
			}
	    }
	}
}

- (void) render:(Isgl3dGLRenderer *)renderer opaque:(BOOL)opaque {
	
	if (_hasChildren && _isVisible) {
		for (Isgl3dNode * node in _children) {
			if (node.isVisible) {
				[node render:renderer opaque:opaque];
			}
	    }
	}
}

- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer {
	
	if (_hasChildren && _isVisible) {
		for (Isgl3dNode * node in _children) {
			if (node.isVisible) {
				[node renderForEventCapture:renderer];
			}
	    }
	}
}

- (void) renderForShadowMap:(Isgl3dGLRenderer *)renderer {
	
	if (_hasChildren && _isVisible) {
		for (Isgl3dNode * node in _children) {
			if (node.isVisible) {
				[node renderForShadowMap:renderer];
			}
	    }
	}
}

- (void) renderForPlanarShadows:(Isgl3dGLRenderer *)renderer {
	
	if (_hasChildren && _isVisible) {
		for (Isgl3dNode * node in _children) {
			if (node.isVisible) {
				[node renderForPlanarShadows:renderer];
			}
	    }
	}
}

- (void) collectAlphaObjects:(NSMutableArray *)alphaObjects {
	if (_hasChildren && _isVisible) {
		for (Isgl3dNode * node in _children) {
			if (node.isVisible) {
				[node collectAlphaObjects:alphaObjects];
			}
	    }
	}	
}

- (void) enableAlphaCullingWithValue:(float)value {
	_alphaCulling = YES;
	_alphaCullValue = value;
}

- (void) occlusionTest:(Isgl3dVector3 *)eye normal:(Isgl3dVector3 *)normal targetDistance:(float)targetDistance maxAngle:(float)maxAngle {
	if (_hasChildren && _isVisible) {
		for (Isgl3dNode * node in _children) {
			if (node.isVisible) {
				[node occlusionTest:eye normal:normal targetDistance:targetDistance maxAngle:maxAngle];
			}
	    }
	}	
}


+ (void) setOcclusionMode:(Isgl3dOcclusionMode)mode {
	Isgl3dNode_OcclusionMode = mode;
}

+ (Isgl3dOcclusionMode) occlusionMode {
	return Isgl3dNode_OcclusionMode;
}

- (BOOL) lightingEnabled {
	return _lightingEnabled;
}

- (void) setLightingEnabled:(BOOL)lightingEnabled {
	_lightingEnabled = lightingEnabled;
}

- (void) createShadowMaps:(Isgl3dGLRenderer *)renderer forScene:(Isgl3dNode *)scene {
	if (_hasChildren && _isVisible) {
		for (Isgl3dNode * node in _children) {
			if (node.isVisible) {
				[node createShadowMaps:renderer forScene:scene];
			}
	    }
	}
}

- (void) createPlanarShadows:(Isgl3dGLRenderer *)renderer forScene:(Isgl3dNode *)scene {
	if (_hasChildren && _isVisible) {
		for (Isgl3dNode * node in _children) {
			if (node.isVisible) {
				[node createPlanarShadows:renderer forScene:scene];
			}
	    }
	}
}

- (void) enableShadowCastingWithChildren:(BOOL)enableShadowCasting {
	_enableShadowCasting = enableShadowCasting;
	for (Isgl3dNode * node in _children) {
		[node enableShadowCastingWithChildren:enableShadowCasting];
    }
}

- (void) setAlphaWithChildren:(float)alpha {
	_alpha = alpha;
	for (Isgl3dNode * node in _children) {
		[node setAlphaWithChildren:alpha];
    }
}


- (NSArray *)gestureRecognizers {
	return [[Isgl3dDirector sharedInstance] gestureRecognizersForNode:self];
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
	[[Isgl3dDirector sharedInstance] addGestureRecognizer:gestureRecognizer forNode:self];
}

- (void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
	[[Isgl3dDirector sharedInstance] removeGestureRecognizer:gestureRecognizer fromNode:self];
}

- (id<UIGestureRecognizerDelegate>)gestureRecognizerDelegateFor:(UIGestureRecognizer *)gestureRecognizer {
	return [[Isgl3dDirector sharedInstance] gestureRecognizerDelegateFor:gestureRecognizer];
}

- (void)setGestureRecognizerDelegate:(id<UIGestureRecognizerDelegate>)aDelegate forGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
	[[Isgl3dDirector sharedInstance] setGestureRecognizerDelegate:aDelegate forGestureRecognizer:gestureRecognizer];
}

- (void) runAction:(Isgl3dAction *)action {
	[[Isgl3dActionManager sharedInstance] addAction:action toTarget:self isPaused:!_isRunning];
}

- (void) stopAction:(Isgl3dAction *)action {
	[[Isgl3dActionManager sharedInstance] stopAction:action];
}

- (void) stopAllActions {
	[[Isgl3dActionManager sharedInstance] stopAllActionsForTarget:self];
}

@end
