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

#import "Isgl3dAnimatedMeshNode.h"
#import "Isgl3dBoneBatch.h"
#import "Isgl3dGLMesh.h"
#import "Isgl3dMaterial.h"
#import "Isgl3dGLRenderer.h"

@implementation Isgl3dAnimatedMeshNode

+ (id) nodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material {
	return [[[self alloc] initWithMesh:mesh andMaterial:material] autorelease];
}


- (id) initWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material {
    if ((self = [super initWithMesh:mesh andMaterial:material])) {
			
		_boneBatches = [[NSMutableArray alloc] init];
		_numberOfBonesPerVertex = 0;
		
		_skinningEnabled = YES;
    }
	
    return self;
}

- (void) dealloc {
	[_boneBatches release];
	
	[super dealloc];
}

- (void) addBoneBatch:(Isgl3dBoneBatch *)boneBatch {
	[_boneBatches addObject:boneBatch];
}

- (void) setNumberOfBonesPerVertex:(unsigned int)numberOfBonesPerVertex {
	_numberOfBonesPerVertex = numberOfBonesPerVertex;
}

- (void) setFrame:(unsigned int)frameNumber {
	for (Isgl3dBoneBatch * boneBatch in _boneBatches) {
		[boneBatch setFrame:frameNumber];
	}
}

- (void) setTransformationDirty:(BOOL)isDirty {
	[super setTransformationDirty:isDirty];
	for (Isgl3dBoneBatch * boneBatch in _boneBatches) {
		[boneBatch setTransformationDirty:isDirty];
	}
}

- (void) updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {
	BOOL transformationDirty = _transformationDirty;
	[super updateWorldTransformation:parentTransformation];
	
	// Need to reset the current node transformation: the "model" matrices 
	// Are included in the bone matrices.
	if (transformationDirty) {
		_worldTransformation = im4Identity();
	}
	
	for (Isgl3dBoneBatch * boneBatch in _boneBatches) {
		[boneBatch updateWorldTransformation:parentTransformation];
	}

}

- (void) renderMesh:(Isgl3dGLRenderer *)renderer {
	[renderer enableSkinning:YES];

	[renderer setNumberOfBonesPerVertex:_numberOfBonesPerVertex];

	[renderer onModelRenderReady];
	for (Isgl3dBoneBatch * boneBatch in _boneBatches) {
		[boneBatch renderMesh:renderer];
	}
	[renderer onModelRenderEnds];
}

@end
