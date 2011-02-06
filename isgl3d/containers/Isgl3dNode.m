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
#import "Isgl3dFollowNode.h"
#import "Isgl3dSkeletonNode.h"
#import "Isgl3dCamera.h"
#import "Isgl3dLight.h"
#import "Isgl3dMatrix4D.h"
#import "Isgl3dVector3D.h"
#import "Isgl3dGLRenderer.h"

static unsigned int Isgl3dNode_OccultationMode = OCCULTATION_MODE_QUAD_DISTANCE_AND_ANGLE;


@implementation Isgl3dNode

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

- (id) init {    
    if (self = [super init]) {

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
	}
	
    return self;
}

- (void) dealloc {
	[_children release];
	
	[super dealloc];
}

- (Isgl3dNode *) createNode {
	return [[self addChild:[[Isgl3dNode alloc] init]] autorelease];
}

- (Isgl3dMeshNode *) createNodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material {
	return (Isgl3dMeshNode *)[[self addChild:[[Isgl3dMeshNode alloc] initWithMesh:mesh andMaterial:material]] autorelease];
}

- (Isgl3dParticleNode *) createNodeWithParticle:(Isgl3dGLParticle *)particle andMaterial:(Isgl3dMaterial *)material {
	return (Isgl3dParticleNode *)[[self addChild:[[Isgl3dParticleNode alloc] initWithParticle:particle andMaterial:material]] autorelease];
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
	[super setTransformationDirty:isDirty];
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node setTransformationDirty:isDirty];
	    }
	}
}

- (void) udpateGlobalTransformation:(Isgl3dMatrix4D *)parentTransformation {
	[super udpateGlobalTransformation:parentTransformation];
	
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node udpateGlobalTransformation:_transformation];
	    }
	}
}

- (void) renderLights:(Isgl3dGLRenderer *)renderer {
	
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node renderLights:renderer];
	    }
	}
}

- (void) render:(Isgl3dGLRenderer *)renderer opaque:(BOOL)opaque {
	
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node render:renderer opaque:opaque];
	    }
	}
}

- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer {
	
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node renderForEventCapture:renderer];
	    }
	}
}

- (void) renderForShadowMap:(Isgl3dGLRenderer *)renderer {
	
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node renderForShadowMap:renderer];
	    }
	}
}

- (void) renderForPlanarShadows:(Isgl3dGLRenderer *)renderer {
	
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node renderForPlanarShadows:renderer];
	    }
	}
}

- (void) collectAlphaObjects:(NSMutableArray *)alphaObjects {
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node collectAlphaObjects:alphaObjects];
	    }
	}	
}

- (void) enableAlphaCullingWithValue:(float)value {
	_alphaCulling = YES;
	_alphaCullValue = value;
}

- (void) occultationTest:(Isgl3dMiniVec3D *)eye normal:(Isgl3dMiniVec3D *)normal targetDistance:(float)targetDistance maxAngle:(float)maxAngle {
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node occultationTest:eye normal:normal targetDistance:targetDistance maxAngle:maxAngle];
	    }
	}	
}


+ (void) setOccultationMode:(unsigned int)mode {
	Isgl3dNode_OccultationMode = mode;
}

+ (unsigned int) occultationMode {
	return Isgl3dNode_OccultationMode;
}

- (BOOL) lightingEnabled {
	return _lightingEnabled;
}

- (void) setLightingEnabled:(BOOL)lightingEnabled {
	_lightingEnabled = lightingEnabled;
}

- (void) createShadowMaps:(Isgl3dGLRenderer *)renderer forScene:(Isgl3dNode *)scene {
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node createShadowMaps:renderer forScene:scene];
	    }
	}
}

- (void) createPlanarShadows:(Isgl3dGLRenderer *)renderer forScene:(Isgl3dNode *)scene {
	if (_hasChildren) {
		for (Isgl3dNode * node in _children) {
			[node createPlanarShadows:renderer forScene:scene];
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
