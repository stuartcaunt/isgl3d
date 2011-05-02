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

#import "KeyframePODAnimationTestView.h"
#import "TestMesh.h"
#import "Isgl3dDemoCameraController.h"
#import "Isgl3dPODImporter.h"

@interface KeyframePODAnimationTestView ()
- (Isgl3dGLMesh *) createNewMeshFromPODMesh:(Isgl3dGLMesh *)podMesh;
@end

@implementation KeyframePODAnimationTestView

- (id) init {
	
	if ((self = [super init])) {
		
		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 120;
		_cameraController.theta = 0;
		_cameraController.phi = 30;
		_cameraController.doubleTapEnabled = NO;

		// Import pod data
		Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:@"Scene_float.pod"];
		[podImporter buildSceneObjects];

		// Get the teapot mesh (plus POD data has non-normalised normals) 
		Isgl3dGLMesh * teapotMesh = [podImporter meshAtIndex:2];
		teapotMesh.normalizationEnabled = YES;

		// Create animated keyframe mesh using the teapot mesh as the first mesh
		_mesh = [Isgl3dKeyframeMesh keyframeMeshWithMesh:teapotMesh];
		
		// Add a new keyframe mesh (in this case generated from the original pod but in practice would be a separate pod mesh having the same number of vertices)
		[_mesh addKeyframeMesh:[self createNewMeshFromPODMesh:teapotMesh]];
		
		// Set up animation data (1 second no animation, 2 seconds shrink to sphere, 2 seconds return to teapot)
		[_mesh addKeyframeAnimationData:0 duration:1.0f];
		[_mesh addKeyframeAnimationData:0 duration:2.0f];
		[_mesh addKeyframeAnimationData:1 duration:1.0f];
		[_mesh addKeyframeAnimationData:1 duration:2.0f];
		
		// Start the automatic mesh animation
		[_mesh startAnimation];

		// Get material from POD file		
		Isgl3dMaterial * material = [podImporter materialWithName:@"Material #2"];
		
		// Create a node using keyframe mesh and material
		Isgl3dNode * node = [self.scene createNodeWithMesh:_mesh andMaterial:material];
		node.position = iv3(0, -20, 0);

		// Add light to scene
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.000];
		light.position = iv3(100, 50, 20);
		[self.scene addChild:light];

		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
	[_cameraController release];

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
	// update camera
	[_cameraController update];
}

- (Isgl3dGLMesh *) createNewMeshFromPODMesh:(Isgl3dGLMesh *)podMesh {
	
	// This simply creates a new mesh from the original pod data but modifies the vertex postions
	// For this test we simply map the vertices down onto a sphere using their normal vector data
	Isgl3dGLMesh * mesh = [[Isgl3dGLMesh alloc] init];
	[mesh setVertices:podMesh.vertexData withVertexDataSize:podMesh.vertexDataSize andIndices:podMesh.indices withIndexDataSize:podMesh.indexDataSize 
					andNumberOfElements:podMesh.numberOfElements andVBOData:podMesh.vboData];

	Isgl3dGLVBOData * vboData = mesh.vboData;
	unsigned int stride = vboData.stride;
	unsigned int positionOffsetX = vboData.positionOffset;
	unsigned int positionOffsetY = vboData.positionOffset + sizeof(float);
	unsigned int positionOffsetZ = vboData.positionOffset + 2 * sizeof(float);
	unsigned int normalOffsetX = vboData.normalOffset;
	unsigned int normalOffsetY = vboData.normalOffset + sizeof(float);
	unsigned int normalOffsetZ = vboData.normalOffset + 2 * sizeof(float);
	unsigned int numberOfVertices = mesh.numberOfVertices;
	
	// Get raw vertex data array from mesh
	unsigned char * vertexData = mesh.vertexData;

	// Create some "dummy" data, here just use the normal data to map all the vertices onto a shere
	float nx, ny, nz;
	float length;
	float radius = 20.0f;
	for (unsigned int i = 0; i < numberOfVertices; i++) {
		nx = *((float*)&vertexData[stride * i + normalOffsetX]);
		ny = *((float*)&vertexData[stride * i + normalOffsetY]);
		nz = *((float*)&vertexData[stride * i + normalOffsetZ]);
		length = sqrt(nx*nx + ny*ny + nz*nz);
		
		
		*((float*)&vertexData[stride * i + positionOffsetX]) = radius * nx / length;
		*((float*)&vertexData[stride * i + positionOffsetY]) = radius * ny / length;
		*((float*)&vertexData[stride * i + positionOffsetZ]) = radius * nz / length;
	}
	
	return [mesh autorelease];
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
	Isgl3dView * view = [KeyframePODAnimationTestView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
