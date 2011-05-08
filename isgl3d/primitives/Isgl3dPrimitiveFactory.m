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

#import "Isgl3dPrimitiveFactory.h"
#import "Isgl3dSphere.h"
#import "Isgl3dPlane.h"
#import "Isgl3dGLMesh.h"
#import "Isgl3dUVMap.h"
#import "Isgl3dDirector.h"
#import "Isgl3dTextureMaterial.h"

#define BONE_MESH @"__boneMesh"
#define GLUIBUTTON_MESH @"__glUIButtonMesh"
#define GLUILABEL_MESH @"__glUILabelMesh"

#define GLUIBUTTON_WIDTH 48
#define GLUIBUTTON_HEIGHT 48

static Isgl3dPrimitiveFactory * _instance = nil;

@implementation Isgl3dPrimitiveFactory

- (id) init {
	if ((self = [super init])) {
		_primitives = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	[_primitives release];
	
	[super dealloc];

}


+ (Isgl3dPrimitiveFactory *) sharedInstance {
	
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dPrimitiveFactory alloc] init];
		}
	}
		
	return _instance;
}

+ (void) resetInstance {
	if (_instance) {
		[_instance release];
		_instance = nil;
	}
}

- (Isgl3dGLMesh *) boneMesh {
	Isgl3dGLMesh * boneMesh = [_primitives objectForKey:BONE_MESH];
	if (!boneMesh) {
		boneMesh = [Isgl3dSphere meshWithGeometry:3 longs:4 lats:4];
		[_primitives setObject:boneMesh forKey:BONE_MESH];
	}
	return boneMesh;	
}

- (Isgl3dGLMesh *) UIButtonMesh {
	Isgl3dGLMesh * buttonMesh = [_primitives objectForKey:GLUIBUTTON_MESH];
	if (!buttonMesh) {
		buttonMesh = [Isgl3dPlane meshWithGeometry:GLUIBUTTON_WIDTH * [Isgl3dDirector sharedInstance].contentScaleFactor height:GLUIBUTTON_HEIGHT * [Isgl3dDirector sharedInstance].contentScaleFactor nx:2 ny:2];
		[_primitives setObject:buttonMesh forKey:GLUIBUTTON_MESH];
	}
	return buttonMesh;	
}

- (Isgl3dGLMesh *) UILabelMeshWithWidth:(unsigned int)width height:(unsigned int)height contentSize:(CGSize)contentSize {
	float uMax = contentSize.width / width;
	float vMax = contentSize.height / height;
	
	Isgl3dGLMesh * labelMesh = [Isgl3dPlane meshWithGeometryAndUVMap:contentSize.width height:contentSize.height nx:2 ny:2 uvMap:[Isgl3dUVMap uvMapWithUA:0 vA:0 uB:uMax vB:0 uC:0 vC:vMax]];
//	GLMesh * labelMesh = [[Plane alloc] initWithGeometryAndUVMap:width height:height nx:2 ny:2 uvMap:[UVMap uvMapWithUA:0 vA:0 uB:0.5 vB:0 uC:0 vC:0.5]];
	return labelMesh;	
}

- (Isgl3dPlane *) planeWithGeometry:(float)width height:(float)height nx:(int)nx ny:(int)ny forMaterial:(Isgl3dTextureMaterial *)material {
	float uMax = material.contentSize.width / material.width;
	float vMax = material.contentSize.height / material.height;
	
	Isgl3dPlane * plane = [Isgl3dPlane meshWithGeometryAndUVMap:width height:height nx:nx ny:ny uvMap:[Isgl3dUVMap uvMapWithUA:0 vA:0 uB:uMax vB:0 uC:0 vC:vMax]];
	return plane;	
}

- (unsigned int) UIButtonWidth {
	return GLUIBUTTON_WIDTH;
}

- (unsigned int) UIButtonHeight {
	return GLUIBUTTON_HEIGHT;
}

@end
