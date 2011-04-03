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

static unsigned int Isgl3dNode_OcclusionMode = OCCLUSION_MODE_QUAD_DISTANCE_AND_ANGLE;


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

- (id) init {    
    if ((self = [super init])) {

		_localTransformation = im4Identity();
		_scaleTransformation = im4Identity();
		_worldTransformation = im4Identity();
    	
		_scaling = false;
    	
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
	
	[super dealloc];
}



#pragma mark translation rotation scaling

- (float) x {
	return _localTransformation.tx;
}

- (void) setX:(float)x {
	_localTransformation.tx = x;
	[self setTransformationDirty:YES];
}

- (float) y {
	return _localTransformation.ty;
}

- (void) setY:(float)y {
	_localTransformation.ty = y;
	[self setTransformationDirty:YES];
}

- (float) z {
	return  _localTransformation.tz;
}

- (void) setZ:(float)z {
	_localTransformation.tz = z;
	[self setTransformationDirty:YES];
}

- (Isgl3dVector3) translationVector {
	return iv3(_localTransformation.tx, _localTransformation.ty, _localTransformation.tz);
}

- (void) setTranslationVector:(Isgl3dVector3)translation {
	_localTransformation.tx = translation.x;
	_localTransformation.ty = translation.y;
	_localTransformation.tz = translation.z;
	[self setTransformationDirty:YES];	
}

- (void) rotate:(float)angle x:(float)x y:(float)y z:(float)z {
	im4Rotate(&_localTransformation, angle, x, y, z);
	[self setTransformationDirty:YES];
}

- (void) setRotation:(float)angle x:(float)x y:(float)y z:(float)z {
	im4SetRotation(&_localTransformation, angle, x, y, z);
	[self setTransformationDirty:YES];
}

- (void) translate:(float)x y:(float)y z:(float)z {
	im4Translate(&_localTransformation, x, y, z);
	[self setTransformationDirty:YES];
}

- (void) setTranslation:(float)x y:(float)y z:(float)z {
	im4SetTranslation(&_localTransformation, x, y, z);
	[self setTransformationDirty:YES];
}

- (void) translateByVector:(Isgl3dVector3)vector {
	im4TranslateByVector(&_localTransformation, &vector);
	[self setTransformationDirty:YES];
}

- (void) translateAlongVector:(Isgl3dVector3)direction distance:(float)distance {
	iv3Normalize(&direction);
	Isgl3dVector3 transformedAxis = im4MultVector3x3(&_worldTransformation, &direction);
	iv3Scale(&transformedAxis, distance);

	im4TranslateByVector(&_localTransformation, &transformedAxis);
}

- (void) setTranslationByNode:(Isgl3dNode *)node {
	[self setTranslationVector:node.translationVector];
}

- (void) setScale:(float)scale {
	[self setScale:scale scaleY:scale scaleZ:scale];
}

- (void) setScale:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ {

	if (scaleX != 1.0 || scaleY != 1.0 || scaleZ != 1.0) {
		_scaleTransformation = im4CreateFromScales(scaleX, scaleY, scaleZ);
		_scaling = YES;
	} else {
		_scaleTransformation = im4Identity();
		_scaling = NO;
	}
	[self setTransformationDirty:YES];
}

- (void) resetTransformation {
	_localTransformation = im4Identity();
	[self setTransformationDirty:YES];
}

- (void) setTransformation:(Isgl3dMatrix4)transformation {
	_localTransformation = transformation;
	[self setTransformationDirty:YES];
}

- (void) setTransformationFromOpenGLMatrix:(float *)transformation {
	im4SetTransformationFromOpenGLMatrix(&_localTransformation, transformation);
	[self setTransformationDirty:YES];
}

- (void) getTransformationAsOpenGLMatrix:(float *)transformation {
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


#pragma mark scene graph

- (Isgl3dNode *) createNode {
	return [[self addChild:[[Isgl3dNode alloc] init]] autorelease];
}

- (Isgl3dMeshNode *) createNodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material {
	return (Isgl3dMeshNode *)[[self addChild:[[Isgl3dMeshNode alloc] initWithMesh:mesh andMaterial:material]] autorelease];
}

- (Isgl3dParticleNode *) createNodeWithParticle:(Isgl3dGLParticle *)particle andMaterial:(Isgl3dMaterial *)material {
	return (Isgl3dParticleNode *)[[self addChild:[[Isgl3dParticleNode alloc] initWithParticle:particle andMaterial:material]] autorelease];
}

- (Isgl3dBillboardNode *) createNodeWithBillboard:(Isgl3dBillboard *)billboard andMaterial:(Isgl3dMaterial *)material {
	return (Isgl3dBillboardNode *)[[self addChild:[[Isgl3dBillboardNode alloc] initWithBillboard:billboard andMaterial:material]] autorelease];
}

- (Isgl3dSkeletonNode *) createSkeletonNode {
	return (Isgl3dSkeletonNode *)[[self addChild:[[Isgl3dSkeletonNode alloc] init]] autorelease];
}

- (Isgl3dFollowNode *) createFollowNodeWithTarget:(Isgl3dNode *)target {
	return (Isgl3dFollowNode *)[[self addChild:[[Isgl3dFollowNode alloc] initWithTarget:target]] autorelease];
}

- (Isgl3dCamera *) createCameraNodeWithView:(Isgl3dView3D *)view {
	return (Isgl3dCamera *)[[self addChild:[[Isgl3dCamera alloc] initWithView:view]] autorelease];
}

- (Isgl3dLight *) createLightNode {
	return (Isgl3dLight *)[[self addChild:[[Isgl3dLight alloc] init]] autorelease];
}

- (Isgl3dNode *) addChild:(Isgl3dNode *)child {
	child.parent = self;
	[_children addObject:child];
	_hasChildren = YES;
	
	return child;
}

- (void) removeChild:(Isgl3dNode *)child {
	child.parent = nil;
	[_children removeObject:child];
	
	if ([_children count] == 0) {
		_hasChildren = NO;
	}
}

- (void) removeFromParent {
	[_parent removeChild:self];
}

- (void) clearAll {
	[_children removeAllObjects];
}

- (void) setTransformationDirty:(BOOL)isDirty {
	_transformationDirty = isDirty;

	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node setTransformationDirty:isDirty];
	    }
	}
}

- (void) updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {
	// Update transformation matrices if needed
	if (_transformationDirty) {
		
		if (parentTransformation) {
			im4Copy(&_worldTransformation, parentTransformation);
			im4Multiply(&_worldTransformation, &_localTransformation);
			
//			[_worldTransformation copyFrom:parentTransformation];
//			[_worldTransformation multiply:_localTransformation];
		
		} else {
//			[_worldTransformation copyFrom:_localTransformation];
			im4Copy(&_worldTransformation, &_localTransformation);
		}
		
		if (_scaling) {
//			[_worldTransformation multiply:_scaleTransformation];
			im4Multiply(&_worldTransformation, &_scaleTransformation);
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


+ (void) setOcclusionMode:(unsigned int)mode {
	Isgl3dNode_OcclusionMode = mode;
}

+ (unsigned int) occlusionMode {
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


@end
