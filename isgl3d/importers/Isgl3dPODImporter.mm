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

#import "Isgl3dPODImporter.h"
#import "PVRTModelPOD.h"
#import "Isgl3dGLMesh.h"
#import "Isgl3dBoneNode.h"
#import "Isgl3dBoneBatch.h"
#import "Isgl3dAnimatedMeshNode.h"
#import "Isgl3dColorMaterial.h"
#import "Isgl3dTextureMaterial.h"
#import "Isgl3dLight.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dCamera.h"
#import "Isgl3dDirector.h"
#import "isgl3dTypes.h"
#import "isgl3dArray.h"
#import "Isgl3dLog.h"

@interface Isgl3dPODImporter (PrivateMethods)

/**
 * @result (autorelease) Mesh created from POD data
 */
- (Isgl3dGLMesh *)createMeshFromPODData:(SPODMesh *)podData;

/**
 * @result (autorelease) BoneNode created from POD data
 */
- (Isgl3dBoneNode *) createBoneNode:(unsigned int)nodeId;

/**
 * @result (autorelease) AnimatedMesh created from POD data
 */
- (Isgl3dAnimatedMeshNode *) createAnimatedMeshNode:(unsigned int)nodeId meshId:(unsigned int)meshId mesh:(Isgl3dGLMesh *)mesh material:(Isgl3dMaterial *)material;

- (void) buildBones;
- (void) buildMeshesAndMaterials;
- (void) buildMeshNodes;

@end

@implementation Isgl3dPODImporter


+ (id) podImporterWithFile:(NSString *)path {
	return [[[self alloc] initWithFile:path] autorelease];
}

- (id) initWithFile:(NSString *)path {
	if ((self = [super init])) {
		_podScene = new CPVRTModelPOD();

		// cut filename into name and extension
		NSString * extension = [path pathExtension];
		NSString * fileName = [path stringByDeletingPathExtension];
		
		if (![[NSBundle mainBundle] pathForResource:fileName ofType:extension]) {
			NSLog(@"iSGL3D : Error : Isgl3dPODImporter : POD file %@ does not exist.", path);
		}
		
		if (_podScene->ReadFromFile([[[NSBundle mainBundle] pathForResource:fileName ofType:extension] UTF8String]) != PVR_SUCCESS) {
			NSLog(@"iSGL3D : Error : Isgl3dPODImporter : Unable to parse POD file %@", path);
			delete _podScene;
			return nil;
		}
		
		_podPath = path;

		_meshes = [[NSMutableArray alloc] init];
		_meshNodes = [[NSMutableDictionary alloc] init];
		_boneNodes = [[NSMutableDictionary alloc] init];
		_indexedNodes = [[NSMutableDictionary alloc] init];
		_boneNodeIndices = [[NSMutableArray alloc] init];
		_textures = [[NSMutableArray alloc] init];
		_materials = [[NSMutableArray alloc] init];
		_cameras = [[NSMutableArray alloc] init];
		_lights = [[NSMutableArray alloc] init];
		
		_textureMods = [[NSMutableDictionary alloc] init];
		_buildSceneObjectsComplete = NO;
		_buildMeshNodesComplete = NO;
		_boneBuildComplete = NO;
		_meshesAndMaterialsComplete = NO;
	}
	
	return self;
	
}

- (void) dealloc {

	[_meshes release];
	[_meshNodes release];
	[_boneNodes release];
	[_indexedNodes release];
	[_boneNodeIndices release];
	[_textures release];
	[_materials release];
	[_cameras release];
	[_lights release];
	[_textureMods release];

	delete _podScene;

	[super dealloc];
}

- (void) printPODInfo {
	NSLog(@"POD info:");
	NSLog(@"Number of cameras: %i", _podScene->nNumCamera);
	for (int i = 0; i < _podScene->nNumCamera; i++) {
		SPODCamera & cameraInfo = _podScene->pCamera[i];
		NSLog(@"\tcamera[%i] target index %i:", i, cameraInfo.nIdxTarget);
		NSLog(@"\tcamera[%i] FOV %f:", i, cameraInfo.fFOV);
		NSLog(@"\tcamera[%i] near %f:", i, cameraInfo.fNear);
		NSLog(@"\tcamera[%i] far %f:", i, cameraInfo.fFar);
	}
	NSLog(@"\n");

	NSLog(@"Number of lights: %i", _podScene->nNumLight);
	for (int i = 0; i < _podScene->nNumLight; i++) {
		SPODLight & lightInfo = _podScene->pLight[i];
		NSLog(@"\tlight[%i] target index %i:", i, lightInfo.nIdxTarget);
		NSLog(@"\tlight[%i] color [%f, %f, %f]:", i, lightInfo.pfColour[0], lightInfo.pfColour[1], lightInfo.pfColour[2]);
		NSLog(@"\tlight[%i] type (0 = Point, 1 = Directional, 2 = Spot) %i:", i, lightInfo.eType);
		NSLog(@"\tlight[%i] constant attenuation %f:", i, lightInfo.fConstantAttenuation);
		NSLog(@"\tlight[%i] linear attenuation %f:", i, lightInfo.fLinearAttenuation);
		NSLog(@"\tlight[%i] falloff angle %f:", i, lightInfo.fFalloffAngle);
		NSLog(@"\tlight[%i] falloff exponent %f:", i, lightInfo.fFalloffExponent);
	}
	NSLog(@"\n");

	NSLog(@"Number of meshes: %i", _podScene->nNumMesh);
	NSLog(@"Number of mesh nodes: %i", _podScene->nNumMeshNode);
	for (int i = 0; i < _podScene->nNumMesh; i++) {
		SPODMesh & mesh = _podScene->pMesh[i];
		NSLog(@"\tmesh[%i] number of vertices %i:", i, mesh.nNumVertex);
		NSLog(@"\tmesh[%i] number of faces %i:", i, mesh.nNumFaces);
		NSLog(@"\tmesh[%i] is interleaved: %@", i, (mesh.pInterleaved == 0) ? @"no" : @"yes");
	}
	NSLog(@"\n");

	NSLog(@"Number of nodes: %i", _podScene->nNumNode);
	for (int i = 0; i < _podScene->nNumNode; i++) {
		SPODNode & node = _podScene->pNode[i];
		NSLog(@"\tnode[%i] index %i:", i, node.nIdx);
		NSLog(@"\tnode[%i] name %s:", i, node.pszName);
		NSLog(@"\tnode[%i] material %i:", i, node.nIdxMaterial);
		NSLog(@"\tnode[%i] parent %i:", i, node.nIdxParent);
	}
	NSLog(@"\n");

	NSLog(@"Number of textures: %i", _podScene->nNumTexture);
	for (int i = 0; i < _podScene->nNumTexture; i++) {
		SPODTexture & texture = _podScene->pTexture[i];
		NSLog(@"\ttexture[%i] filename %s:", i, texture.pszName);
	}
	NSLog(@"\n");
	
	NSLog(@"Number of materials: %i", _podScene->nNumMaterial);
	for (int i = 0; i < _podScene->nNumMaterial; i++) {
		SPODMaterial & material = _podScene->pMaterial[i];
		NSLog(@"\tmaterial[%i] name %s:", i, material.pszName);
		NSLog(@"\tmaterial[%i] texture diffuse index %i:", i, material.nIdxTexDiffuse);
		NSLog(@"\tmaterial[%i] texture ambient index %i:", i, material.nIdxTexAmbient);
		NSLog(@"\tmaterial[%i] texture specular index %i:", i, material.nIdxTexSpecularColour);
		NSLog(@"\tmaterial[%i] texture spec level index %i:", i, material.nIdxTexSpecularLevel);
		NSLog(@"\tmaterial[%i] texture bump index %i:", i, material.nIdxTexBump);
		NSLog(@"\tmaterial[%i] opacity %f:", i, material.fMatOpacity);
		NSLog(@"\tmaterial[%i] ambient [%f, %f, %f]:", i, material.pfMatAmbient[0], material.pfMatAmbient[1], material.pfMatAmbient[2]);
		NSLog(@"\tmaterial[%i] diffuse [%f, %f, %f]:", i, material.pfMatDiffuse[0], material.pfMatDiffuse[1], material.pfMatDiffuse[2]);
		NSLog(@"\tmaterial[%i] specular [%f, %f, %f]:", i, material.pfMatSpecular[0], material.pfMatSpecular[1], material.pfMatSpecular[2]);
		NSLog(@"\tmaterial[%i] shininess %f:", i, material.fMatShininess);
	}
	NSLog(@"\n");
	
	NSLog(@"Number of frames: %i", _podScene->nNumFrame);
}

- (unsigned int) numberOfMeshes {
	return _podScene->nNumMesh;
}

- (unsigned int) numberOfCameras {
	return _podScene->nNumCamera;
}

- (unsigned int) numberOfLights {
	return _podScene->nNumLight;
}

- (unsigned int) numberOfFrames {
	return _podScene->nNumFrame;
}


- (void) addMeshesToScene:(Isgl3dNode *)scene {
	
	if (!_buildMeshNodesComplete) {
		[_meshNodes removeAllObjects];
		[_indexedNodes removeAllObjects];
		[self buildMeshNodes];
	}
	
	// Link meshes to materials: iterate through nodes, include only meshes (at beginning of array)
	for (int i = 0; i < _podScene->nNumMeshNode; i++) {
		SPODNode & nodeInfo = _podScene->pNode[i];

		NSLog(@"Adding node: %s:", nodeInfo.pszName);
		
		Isgl3dNode * node = [_meshNodes objectForKey:[NSString stringWithUTF8String:nodeInfo.pszName]];
		
		if (nodeInfo.nIdxParent == -1) {
			[scene addChild:node];
		} else {
			Isgl3dNode * parent = [_indexedNodes objectForKey:[NSNumber numberWithInteger:nodeInfo.nIdxParent]];
			
			if (parent) {
				[parent addChild:node];
			} else {
			}
		}
	}

	// Remove all mesh node objects so that they are recreated for the next call to this method
	_buildMeshNodesComplete = NO;
	
}

- (Isgl3dMeshNode *) meshNodeWithName:(NSString *)nodeName {
	
	Isgl3dMeshNode * node = [_meshNodes objectForKey:nodeName];
	if (!node) {
		NSLog(@"Unable to find mesh node with name %@", nodeName);
	}
	return node;
}

- (Isgl3dGLMesh *) meshFromNodeWithName:(NSString *)nodeName {
	Isgl3dMeshNode * meshNode = [self meshNodeWithName:nodeName];
	if (meshNode) {
		return meshNode.mesh;
	}
	
	return nil;
}

- (Isgl3dGLMesh *) meshAtIndex:(unsigned int)meshIndex {
	if (meshIndex >= _podScene->nNumMesh) {
		NSLog(@"Mesh at index %i not available: POD scene contains %i meshses", meshIndex, _podScene->nNumMesh);
		return nil;
	}
	
	return [_meshes objectAtIndex:meshIndex];
}

- (Isgl3dMaterial *) materialWithName:(NSString *)materialName {
	Isgl3dMaterial * material;
	for (int i = 0; i < _podScene->nNumMaterial; i++) {
		SPODMaterial & materialInfo = _podScene->pMaterial[i];
		if ([materialName isEqualToString:[NSString stringWithUTF8String:materialInfo.pszName]]) {

			if (i < [_materials count]) {
				material = [_materials objectAtIndex:i];
				break;
			}

		}
	}	

	if (!material) {
		NSLog(@"Unable to find material with name: %@", materialName);
	}
	return material;
}


- (Isgl3dCamera *) cameraAtIndex:(unsigned int)cameraIndex {
	if (!_buildSceneObjectsComplete) {
		[self buildSceneObjects];
	}	
	
	if (cameraIndex >= _podScene->nNumCamera) {
		NSLog(@"Camera at index %i not available: POD scene contains %i cameras", cameraIndex, _podScene->nNumCamera);
		return nil;
	}
	
	return [_cameras objectAtIndex:cameraIndex];
}

- (Isgl3dLight *) lightAtIndex:(unsigned int)lightIndex {
	if (!_buildSceneObjectsComplete) {
		[self buildSceneObjects];
	}	

	if (lightIndex >= _podScene->nNumLight) {
		NSLog(@"Light at index %i not available: POD scene contains %i lights", lightIndex, _podScene->nNumLight);
		return nil;
	}
	
	return [_lights objectAtIndex:lightIndex];
}

- (float *) ambientColor {
	return _podScene->pfColourAmbient;
}



- (void) configureLight:(Isgl3dLight *)light fromNode:(NSString *)nodeName {
	for (int i = 0; i < _podScene->nNumMeshNode; i++) {
		SPODNode & node = _podScene->pNode[i];
		if ([nodeName isEqualToString:[NSString stringWithUTF8String:node.pszName]]) {
			[light setRenderedMesh:[_meshes objectAtIndex:node.nIdx]];

			PVRTMat4 podTransformation;
			_podScene->GetWorldMatrix(podTransformation, node);
			[light setTransformationFromOpenGLMatrix:podTransformation.f];
			return;
		}
	}
	
	NSLog(@"Unable to find mesh with name %@", nodeName);
}


- (void) addBonesToSkeleton:(Isgl3dSkeletonNode *)skeleton {

	if (!_boneBuildComplete) {
		[_boneNodeIndices removeAllObjects];
		[_boneNodes removeAllObjects];
		[_indexedNodes removeAllObjects];
		[self buildBones];
	}


	// Build hierarchy of bones and add to skeleton
	for (NSNumber * nodeIndex in _boneNodeIndices) {
		int nodeId = [nodeIndex integerValue];
		SPODNode & nodeInfo = _podScene->pNode[nodeId];
	
		NSLog(@"Adding bone to skeleton: %s  (%i)", nodeInfo.pszName, nodeId);
		
		Isgl3dBoneNode * node = [_boneNodes objectForKey:[NSString stringWithUTF8String:nodeInfo.pszName]];
		//NSLog(@"bone position = %f %f %f", node.x, node.y, node.z);

		[skeleton addChild:node];
		
		/*
		if (nodeInfo.nIdxParent == -1) {
			[skeleton addChild:node];
		} else {
			BoneNode * parent = [_indexedNodes objectForKey:[NSNumber numberWithInteger:nodeInfo.nIdxParent]];
			[parent addChild:node];
		}
		*/
	}
	
	// Remove all bone node data for the next call to this method
	_boneBuildComplete = NO;
}

- (void) modifyTexture:(NSString *)podTextureFileName withTexture:(NSString *)replacementFileName {
	[_textureMods setObject:replacementFileName forKey:podTextureFileName];
}


/*
 * Private methods....
 */


- (void) buildMeshesAndMaterials {
	// Iterate over nodes and create meshes and materials as necessary

	// Create array of textures
	for (int i = 0; i < _podScene->nNumTexture; i++) {
		SPODTexture & textureInfo = _podScene->pTexture[i];
		
		NSString * textureFileName = [NSString stringWithUTF8String:textureInfo.pszName];
		if ([_textureMods objectForKey:textureFileName] != nil) {
			textureFileName = [_textureMods objectForKey:textureFileName];
		}
		
		NSString * extension = [textureFileName pathExtension];
		// Image formats supported by UIImage and pvr
		NSArray * acceptedFormats = [NSArray arrayWithObjects:@"png", @"jpg", @"jpeg", @"tiff", @"tif", @"gif", @"bmp", @"BMPf", @"ico", @"cur", @"xbm", @"pvr", nil];
		if (![acceptedFormats containsObject:extension]) {
			NSLog(@"iSGL3D : Error : Isgl3dPODImporter : POD %@ contains texture image with format that is not supported : %@", _podPath, textureFileName);
		} 
		
		NSLog(@"Creating texture from %@:", textureFileName);
		[_textures addObject:textureFileName];
	}

	
	// Create array of materials
	for (int i = 0; i < _podScene->nNumMaterial; i++) {
		SPODMaterial & materialInfo = _podScene->pMaterial[i];
	
		Isgl3dColorMaterial * material;
		NSLog(@"Creating material: %s:", materialInfo.pszName);
		
		if (!materialInfo.pszEffectFile) {
			if (materialInfo.nIdxTexDiffuse >= 0 && materialInfo.nIdxTexDiffuse < [_textures count]) {
				NSString * textureFileName = [_textures objectAtIndex:materialInfo.nIdxTexDiffuse];
				
				material = [Isgl3dTextureMaterial materialWithTextureFile:textureFileName shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:YES repeatY:YES];
				
			} else {
				material = [Isgl3dColorMaterial materialWithHexColors:@"FFFFFF" diffuse:@"FFFFFF" specular:@"FFFFFF" shininess:0];
			}
			
			// ignore other material types for the time being (ambient, specular, bump, ...)
			
			[material setAmbientColor:materialInfo.pfMatAmbient];
			[material setDiffuseColor:materialInfo.pfMatDiffuse];
			[material setSpecularColor:materialInfo.pfMatSpecular];
			[material setShininess:materialInfo.fMatShininess];
			
			[_materials addObject:material];
		} else {
			NSLog(@"Material has effect file and is currently not supported: %s", materialInfo.pszEffectFile);
		}
	}	
	
	// Create array of meshes
	for (int i = 0; i < _podScene->nNumMesh; i++) {
		SPODMesh & meshInfo = _podScene->pMesh[i];
		
		Isgl3dGLMesh * mesh = [self createMeshFromPODData:&meshInfo];
		[_meshes addObject:mesh];
	}
	
	_meshesAndMaterialsComplete = YES;
}

- (void) buildSceneObjects {
	
	if (!_buildMeshNodesComplete) {
		[self buildMeshNodes];
	}
	
	
	// Create array of cameras
	for (int i = 0; i < _podScene->nNumCamera; i++) {
		SPODCamera & cameraInfo = _podScene->pCamera[i];
		PVRTVECTOR3 pos;
		PVRTVECTOR3 lookAt;

		float fov = _podScene->GetCameraPos(pos, lookAt, i) * 180 / M_PI;
		float fNear = cameraInfo.fNear;
		float fFar = cameraInfo.fFar;
		
		NSLog(@"Creating camera: pos = [%f, %f, %f], lookAt = [%f, %f, %f], fov = %f, near = %f, far = %f", pos.x, pos.y, pos.z, lookAt.x, lookAt.y, lookAt.z, fov, fNear, fFar);
	
		CGSize windowSize = [Isgl3dDirector sharedInstance].windowSize;
		Isgl3dCamera * camera = [[Isgl3dCamera alloc] initWithWidth:windowSize.width height:windowSize.height andCoordinates:pos.x y:pos.y z:pos.z upX:0 upY:1 upZ:0 lookAtX:lookAt.x lookAtY:lookAt.y lookAtZ:lookAt.z];
		[camera setPerspectiveProjection:fov near:fNear far:fFar orientation:[Isgl3dDirector sharedInstance].deviceOrientation];
		

		[_cameras addObject:[camera autorelease]];
	}
	
	// Create lights
	for (int i = 0; i < _podScene->nNumLight; i++) {
		SPODLight & lightInfo = _podScene->pLight[i];
		
		PVRTVECTOR3 pos;
		PVRTVECTOR3 dirn;
		_podScene->GetLight(pos, dirn, i);
		
		Isgl3dLight * light = [Isgl3dLight lightWithColorArray:lightInfo.pfColour];
		
		light.constantAttenuation = lightInfo.fConstantAttenuation;
		light.linearAttenuation = lightInfo.fLinearAttenuation;
		light.quadraticAttenuation = lightInfo.fQuadraticAttenuation;
		if (lightInfo.eType == ePODPoint) {
			light.lightType = PointLight;
			light.position = iv3(pos.x, pos.y, pos.z);

		} else if (lightInfo.eType == ePODDirectional) {
			light.lightType = DirectionalLight;
			[light setDirection:dirn.x y:dirn.y z:dirn.z];

		} else {
			light.lightType = SpotLight;
			light.position = iv3(pos.x, pos.y, pos.z);
			light.spotCutoffAngle = lightInfo.fFalloffAngle * 180 / M_PI;
			light.spotFalloffExponent = lightInfo.fFalloffExponent;
			[light setSpotDirection:dirn.x y:dirn.y z:dirn.z];
		}
		
		[_lights addObject:light];
	}
	
	_buildSceneObjectsComplete = YES;
}

- (void) buildMeshNodes {
	
	if (!_meshesAndMaterialsComplete) {
		[self buildMeshesAndMaterials];
	}
	
	// Create all mesh nodes, link to materials and meshes.
	for (int i = 0; i < _podScene->nNumMeshNode; i++) {
		SPODNode & meshNodeInfo = _podScene->pNode[i];
		SPODMesh& meshInfo = _podScene->pMesh[meshNodeInfo.nIdx];
	
		// Get the mesh
		Isgl3dGLMesh * mesh = [_meshes objectAtIndex:meshNodeInfo.nIdx];
		Isgl3dMaterial * material = nil;

		// Set the material
		if (meshNodeInfo.nIdxMaterial >= 0 && meshNodeInfo.nIdxMaterial < [_materials count]) {
			material = [_materials objectAtIndex:meshNodeInfo.nIdxMaterial];
		} else {
			NSLog(@"No material for mesh: %s", meshNodeInfo.pszName);
		}


		// Check to see if the mesh has bone data
		Isgl3dMeshNode * node;
		if (meshInfo.sBoneIdx.pData && meshInfo.sBoneWeight.pData) {
			node = [self createAnimatedMeshNode:i meshId:meshNodeInfo.nIdx mesh:mesh material:material];
			[_meshNodes setObject:node forKey:[NSString stringWithUTF8String:meshNodeInfo.pszName]];
		
		} else {
		
			NSLog(@"Bulding mesh node: %s:", meshNodeInfo.pszName);
			node = [Isgl3dMeshNode nodeWithMesh:mesh andMaterial:material];
			[_meshNodes setObject:node forKey:[NSString stringWithUTF8String:meshNodeInfo.pszName]];
		}			

		[_indexedNodes setObject:node forKey:[NSNumber numberWithInteger:meshNodeInfo.nIdx]];

		// Add node alpha
		SPODMaterial & materialInfo = _podScene->pMaterial[meshNodeInfo.nIdxMaterial];
		node.alpha = materialInfo.fMatOpacity;
		node.transparent = node.alpha < 1.0 ? YES : NO;

		// Set the default node transformation
		_podScene->SetFrame(0);
		PVRTMat4 podTransformation;
		_podScene->GetWorldMatrix(podTransformation, meshNodeInfo);
		[node setTransformationFromOpenGLMatrix:podTransformation.f];
		
	}
	
	// Create all non-mesh nodes
	for (int i = 0; i < _podScene->nNumNode; i++) {
		SPODNode & nodeInfo = _podScene->pNode[i];
		
		// See if node already exists as a mesh node, otherise create simple node
		if (![_indexedNodes objectForKey:[NSNumber numberWithInteger:nodeInfo.nIdx]]) {
			Isgl3dNode * node = [Isgl3dNode node];
			[_indexedNodes setObject:node forKey:[NSNumber numberWithInteger:nodeInfo.nIdx]];
		}
		
	}
	
	
	_buildMeshNodesComplete = YES;
}

- (void) buildBones {
	
	// Get all bone node indexes from all meshes
	NSMutableArray * meshBoneNodeIndexes = [[NSMutableArray alloc] init];
	for (int i = 0; i < _podScene->nNumMesh; i++) {
		SPODMesh & meshNodeInfo = _podScene->pMesh[i];
		
		for (int iBatch = 0; iBatch < meshNodeInfo.sBoneBatches.nBatchCnt; iBatch++) {
			for (int iBone = 0; iBone < meshNodeInfo.sBoneBatches.pnBatchBoneCnt[iBatch]; iBone++) {

				// Get the Node of the bone
				int nodeId = meshNodeInfo.sBoneBatches.pnBatches[iBatch * meshNodeInfo.sBoneBatches.nBatchBoneMax + iBone];

				if (![meshBoneNodeIndexes containsObject:[NSNumber numberWithInteger:nodeId]]) {
					[meshBoneNodeIndexes addObject:[NSNumber numberWithInteger:nodeId]];
				}
			}
		}
	}	

	// Iterate over mesh bones and add any missing parents
	for (NSNumber * nodeIndex in meshBoneNodeIndexes) {
		int nodeId = [nodeIndex integerValue];
		SPODNode & nodeInfo = _podScene->pNode[nodeId];
		if (![_boneNodeIndices containsObject:[NSNumber numberWithInteger:nodeId]]) {
			[_boneNodeIndices addObject:[NSNumber numberWithInteger:nodeId]];
		}

		// Iterate over node parents
		int parentId = nodeInfo.nIdxParent;
		while (parentId != -1) {
			SPODNode & currentNodeInfo = _podScene->pNode[parentId];
			if (![_boneNodeIndices containsObject:[NSNumber numberWithInteger:parentId]]) {
				[_boneNodeIndices addObject:[NSNumber numberWithInteger:parentId]];
			}
			parentId = currentNodeInfo.nIdxParent;
		}
	}
	
	
	// Create the bone nodes
	for (NSNumber * nodeIndex in _boneNodeIndices) {
		int nodeId = [nodeIndex integerValue];
		[self createBoneNode:nodeId];
	}
	
	[meshBoneNodeIndexes release];
	_boneBuildComplete = YES;
}

- (Isgl3dAnimatedMeshNode *) createAnimatedMeshNode:(unsigned int)nodeId meshId:(unsigned int)meshId mesh:(Isgl3dGLMesh *)mesh material:(Isgl3dMaterial *)material {
	SPODNode & meshNodeInfo = _podScene->pNode[nodeId];
	SPODMesh& meshInfo = _podScene->pMesh[meshId];
			
	//NSLog(@"Bulding animated mesh node: %s:", meshNodeInfo.pszName);
	
	// Create new animted mesh node with default mesh and material
	Isgl3dAnimatedMeshNode * animatedMeshNode = [Isgl3dAnimatedMeshNode nodeWithMesh:mesh andMaterial:material];
	
	//NSLog(@"Number of bones per vertex = %i", meshInfo.sBoneIdx.n);
	[animatedMeshNode setNumberOfBonesPerVertex:meshInfo.sBoneIdx.n];
	
	// Get bone batches
	CPVRTBoneBatches boneBatches = meshInfo.sBoneBatches;
	int nBatches = boneBatches.nBatchCnt;
	//NSLog(@"Number of batches = %i", nBatches);
	for (int iBatch = 0; iBatch < nBatches; iBatch++) {
		
		// Get number of elements to draw for given batch an also the element offset 
		int nTriangles; 
		if (iBatch + 1 < nBatches) {
			nTriangles = boneBatches.pnBatchOffset[iBatch + 1] - boneBatches.pnBatchOffset[iBatch];
		} else {
			nTriangles = meshInfo.nNumFaces - boneBatches.pnBatchOffset[iBatch];
		}

		unsigned int numberOfElements = nTriangles * 3;  // 3 points per triangle
		unsigned int elementOffset = boneBatches.pnBatchOffset[iBatch] * 3;

		// Create BoneBatch
		Isgl3dBoneBatch * boneBatch = [Isgl3dBoneBatch boneBatchWithNumberOfElements:numberOfElements andElementOffset:elementOffset];
		[animatedMeshNode addBoneBatch:boneBatch];
		
		int numberOfBatchBones = boneBatches.pnBatchBoneCnt[iBatch];
		//NSLog(@"Number of bones for batch %i = %i", iBatch, numberOfBatchBones);
		
		// Iterate over frames and get transformations for all bones 
		for (int iFrame = 0; iFrame < _podScene->nNumFrame; iFrame++) {
			_podScene->SetFrame(iFrame);
			Isgl3dArray * transformations = IA_ALLOC_INIT_AR(Isgl3dMatrix4);

			// Iterate over all bones, get transformation for each
			for (int iBone = 0; iBone < numberOfBatchBones; iBone++) {
				int nodeId = boneBatches.pnBatches[iBatch * boneBatches.nBatchBoneMax + iBone];
				SPODNode & boneNodeInfo = _podScene->pNode[nodeId];

				// Set the bone transformation
				PVRTMat4 boneTransformation;
				_podScene->GetBoneWorldMatrix(boneTransformation, meshNodeInfo, boneNodeInfo);
				Isgl3dMatrix4 matrix = im4CreateFromOpenGL(boneTransformation.f);
				
				IA_ADD(transformations, matrix);
			}
			
			// Add bone transformations to BoneBatch for given frame
			[boneBatch addBoneTransformations:transformations forFrame:iFrame];
		}
		
	}

	return animatedMeshNode;	
}

- (Isgl3dGLMesh *)createMeshFromPODData:(SPODMesh *)podData {
	Isgl3dGLMesh * mesh = [Isgl3dGLMesh mesh];
	
	// Check if POD mesh is interleaved or not
	if (podData->pInterleaved == 0) {
		
	} else {
		unsigned int vertexDataSize = podData->nNumVertex * podData->sVertex.nStride;
		unsigned int numberOfElements = PVRTModelPODCountIndices(*podData);

		Isgl3dGLVBOData * vboData = [[Isgl3dGLVBOData alloc] init];
		vboData.stride = podData->sVertex.nStride;
		
//		NSLog(@"vertex stride = %i", podData->sVertex.nStride);
//		NSLog(@"normal stride = %i", podData->sNormals.nStride);
//		NSLog(@"uv stride = %i", podData->psUVW[0].nStride);
		
//		NSLog(@"vertex offset = %i", (int)(podData->sVertex.pData));
//		NSLog(@"normal offset = %i", (int)(podData->sNormals.pData));
//		NSLog(@"uv offset = %i", (int)(podData->psUVW[0].pData));
		
		vboData.positionOffset = (int)(podData->sVertex.pData);
		vboData.normalOffset = (int)(podData->sNormals.pData);
		if ((podData->nNumUVW)) {
			vboData.uvOffset = (int)(podData->psUVW[0].pData);
		}
				
		if (podData->sBoneIdx.pData && podData->sBoneWeight.pData) {
			vboData.boneIndexOffset = (int)(podData->sBoneIdx.pData);
			vboData.boneWeightOffset = (int)(podData->sBoneWeight.pData);
			
			vboData.boneIndexSize = podData->sBoneIdx.n;
			vboData.boneWeightSize = podData->sBoneWeight.n;
		}
				
		[mesh setVertices:podData->pInterleaved withVertexDataSize:vertexDataSize andIndices:podData->sFaces.pData withIndexDataSize:numberOfElements * sizeof(ushort) 
					andNumberOfElements:numberOfElements andVBOData:[vboData autorelease]];
	}
	
	return mesh;
}

- (Isgl3dBoneNode *) createBoneNode:(unsigned int)nodeId {
	Isgl3dBoneNode * boneNode = [_indexedNodes objectForKey:[NSNumber numberWithInteger:nodeId]];
	if (boneNode) {
		return boneNode;
	}
	
	SPODNode & nodeInfo = _podScene->pNode[nodeId];
	NSLog(@"Building bone %s (%i)", nodeInfo.pszName, nodeId);

	boneNode = [Isgl3dBoneNode boneNode];
	[_indexedNodes setObject:boneNode forKey:[NSNumber numberWithInteger:nodeId]];
	[_boneNodes setObject:boneNode forKey:[NSString stringWithUTF8String:nodeInfo.pszName]];

	// Set the default transformation
	_podScene->SetFrame(0);
	PVRTMat4 podTransformation;
	_podScene->GetWorldMatrix(podTransformation, nodeInfo);
	[boneNode setTransformationFromOpenGLMatrix:podTransformation.f];

	// Add frame transformations for all bones
	for (int iFrame = 0; iFrame < _podScene->nNumFrame; iFrame++) {
		_podScene->SetFrame(iFrame);
		PVRTMat4 podTransformation;
		_podScene->GetWorldMatrix(podTransformation, nodeInfo);
		[boneNode addFrameTransformationFromOpenGLMatrix:podTransformation.f];
	}	

	return boneNode;
}

@end
