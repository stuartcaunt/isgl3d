/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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
#import "Isgl3dNodeCamera.h"
#import "Isgl3dLookAtCamera.h"
#import "Isgl3dDirector.h"
#import "isgl3dTypes.h"
#import "isgl3dArray.h"
#import "Isgl3dLog.h"
#import "Isgl3dMathUtils.h"


@interface Isgl3dPODImporter () {
@private
	CPVRTModelPOD *_podModel;
	NSString *_podPath;
	
	NSMutableArray *_meshes;
	NSMutableDictionary *_meshNodes;
	NSMutableDictionary *_boneNodes;
	NSMutableDictionary *_indexedNodes;
	NSMutableArray *_boneNodeIndices;
	NSMutableArray *_textures;
	NSMutableArray *_materials;
	NSMutableArray *_cameras;
	NSMutableArray *_lights;
	
	NSMutableDictionary *_textureMods;
	
	BOOL _buildSceneObjectsComplete;
	BOOL _buildMeshNodesComplete;
	BOOL _boneBuildComplete;
	BOOL _meshesAndMaterialsComplete;
}
/**
 * @result (autorelease) Mesh created from POD data
 */
- (Isgl3dGLMesh *)createMeshFromPODData:(SPODMesh *)podData;

/**
 * @result (autorelease) BoneNode created from POD data
 */
- (Isgl3dBoneNode *)createBoneNode:(unsigned int)nodeId;

/**
 * @result (autorelease) AnimatedMesh created from POD data
 */
- (Isgl3dAnimatedMeshNode *)createAnimatedMeshNode:(unsigned int)nodeId meshId:(unsigned int)meshId mesh:(Isgl3dGLMesh *)mesh material:(Isgl3dMaterial *)material;

- (void)buildBones;
- (void)buildMeshesAndMaterials;
- (void)buildMeshNodes;
@end


#pragma mark -
@implementation Isgl3dPODImporter

+ (id)podImporterWithResource:(NSString *)name {
	return [[[self alloc] initWithResource:name] autorelease];
}

+ (id)podImporterWithFile:(NSString *)filePath {
	return [[[self alloc] initWithFile:filePath] autorelease];
}

- (id)initWithResource:(NSString *)name {
    if ((name == nil) || (name.length == 0)) {
        [NSException raise:NSInvalidArgumentException format:@"invalid resource name specified"];
    }

    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    
    if (resourcePath == nil) {
        Isgl3dClassDebugLog(Isgl3dLogLevelError, @"POD file %@ does not exist.", resourcePath);

        [self release];
        self = nil;
        return self;
    }
        
    return [self initWithFile:resourcePath];
}

- (id)initWithFile:(NSString *)filePath {
    if ((filePath == nil) || (filePath.length == 0)) {
        [NSException raise:NSInvalidArgumentException format:@"invalid file path specified"];
    }

	if (self = [super init]) {
		_podModel = new CPVRTModelPOD();

		if (_podModel->ReadFromFile([filePath UTF8String]) != PVR_SUCCESS) {
			Isgl3dClassDebugLog(Isgl3dLogLevelError, @"Unable to parse POD file %@", filePath);
			delete _podModel;
            _podModel = NULL;

            [self release];
            self = nil;
			return self;
		}
		
		_podPath = filePath;

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

- (void)dealloc {

	[_meshes release];
    _meshes = nil;
	[_meshNodes release];
    _meshNodes = nil;
	[_boneNodes release];
    _boneNodes = nil;
	[_indexedNodes release];
    _indexedNodes = nil;
	[_boneNodeIndices release];
    _boneNodeIndices = nil;
	[_textures release];
    _textures = nil;
	[_materials release];
    _materials = nil;
	[_cameras release];
    _cameras = nil;
	[_lights release];
    _lights = nil;
	[_textureMods release];
    _textureMods = nil;

	delete _podModel;

	[super dealloc];
}

- (void)printPODInfo {
	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"POD info:");
	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"Number of cameras: %i", _podModel->nNumCamera);
	for (int i = 0; i < _podModel->nNumCamera; i++) {
		SPODCamera & cameraInfo = _podModel->pCamera[i];
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tcamera[%i] target index %i:", i, cameraInfo.nIdxTarget);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tcamera[%i] FOV %f:", i, cameraInfo.fFOV);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tcamera[%i] near %f:", i, cameraInfo.fNear);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tcamera[%i] far %f:", i, cameraInfo.fFar);
	}
	NSDebugLog(@"\n");

	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"Number of lights: %i", _podModel->nNumLight);
	for (int i = 0; i < _podModel->nNumLight; i++) {
		SPODLight & lightInfo = _podModel->pLight[i];
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tlight[%i] target index %i:", i, lightInfo.nIdxTarget);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tlight[%i] color [%f, %f, %f]:", i, lightInfo.pfColour[0], lightInfo.pfColour[1], lightInfo.pfColour[2]);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tlight[%i] type (0 = Point, 1 = Directional, 2 = Spot) %i:", i, lightInfo.eType);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tlight[%i] constant attenuation %f:", i, lightInfo.fConstantAttenuation);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tlight[%i] linear attenuation %f:", i, lightInfo.fLinearAttenuation);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tlight[%i] falloff angle %f:", i, lightInfo.fFalloffAngle);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tlight[%i] falloff exponent %f:", i, lightInfo.fFalloffExponent);
	}
	NSDebugLog(@"\n");

	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"Number of meshes: %i", _podModel->nNumMesh);
	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"Number of mesh nodes: %i", _podModel->nNumMeshNode);
	for (int i = 0; i < _podModel->nNumMesh; i++) {
		SPODMesh & mesh = _podModel->pMesh[i];
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmesh[%i] number of vertices %i:", i, mesh.nNumVertex);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmesh[%i] number of faces %i:", i, mesh.nNumFaces);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmesh[%i] is interleaved: %@", i, (mesh.pInterleaved == 0) ? @"no" : @"yes");
	}
	NSDebugLog(@"\n");

	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"Number of nodes: %i", _podModel->nNumNode);
	for (int i = 0; i < _podModel->nNumNode; i++) {
		SPODNode & node = _podModel->pNode[i];
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tnode[%i] index %i:", i, node.nIdx);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tnode[%i] name %s:", i, node.pszName);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tnode[%i] material %i:", i, node.nIdxMaterial);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tnode[%i] parent %i:", i, node.nIdxParent);
	}
	NSDebugLog(@"\n");

	NSDebugLog(@"Number of textures: %i", _podModel->nNumTexture);
	for (int i = 0; i < _podModel->nNumTexture; i++) {
		SPODTexture & texture = _podModel->pTexture[i];
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\ttexture[%i] filename %s:", i, texture.pszName);
	}
	NSDebugLog(@"\n");
	
	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"Number of materials: %i", _podModel->nNumMaterial);
	for (int i = 0; i < _podModel->nNumMaterial; i++) {
		SPODMaterial & material = _podModel->pMaterial[i];
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] name %s:", i, material.pszName);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] texture diffuse index %i:", i, material.nIdxTexDiffuse);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] texture ambient index %i:", i, material.nIdxTexAmbient);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] texture specular index %i:", i, material.nIdxTexSpecularColour);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] texture spec level index %i:", i, material.nIdxTexSpecularLevel);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] texture bump index %i:", i, material.nIdxTexBump);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] opacity %f:", i, material.fMatOpacity);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] ambient [%f, %f, %f]:", i, material.pfMatAmbient[0], material.pfMatAmbient[1], material.pfMatAmbient[2]);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] diffuse [%f, %f, %f]:", i, material.pfMatDiffuse[0], material.pfMatDiffuse[1], material.pfMatDiffuse[2]);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] specular [%f, %f, %f]:", i, material.pfMatSpecular[0], material.pfMatSpecular[1], material.pfMatSpecular[2]);
		Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"\tmaterial[%i] shininess %f:", i, material.fMatShininess);
	}
	NSDebugLog(@"\n");
	
	Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"Number of frames: %i", _podModel->nNumFrame);
}

- (unsigned int) numberOfMeshes {
	return _podModel->nNumMesh;
}

- (unsigned int) numberOfCameras {
	return _podModel->nNumCamera;
}

- (unsigned int) numberOfLights {
	return _podModel->nNumLight;
}

- (unsigned int) numberOfFrames {
	return _podModel->nNumFrame;
}


- (void)addMeshesToScene:(Isgl3dNode *)scene {
	
	if (!_buildMeshNodesComplete) {
		[_meshNodes removeAllObjects];
		[_indexedNodes removeAllObjects];
		[self buildMeshNodes];
	}
	
	// Link meshes to materials: iterate through nodes, include only meshes (at beginning of array)
	for (int i = 0; i < _podModel->nNumMeshNode; i++) {
		SPODNode &nodeInfo = _podModel->pNode[i];

		Isgl3dClassDebugLog(Isgl3dLogLevelDebug, @"Adding node: %s:", nodeInfo.pszName);
		
		Isgl3dNode *node = [_meshNodes objectForKey:[NSString stringWithUTF8String:nodeInfo.pszName]];
		
		if (nodeInfo.nIdxParent == -1) {
			[scene addChild:node];
		} else {
			Isgl3dNode *parent = [_indexedNodes objectForKey:[NSNumber numberWithInteger:nodeInfo.nIdxParent]];
			
			if (parent) {
				[parent addChild:node];
			} else {
                SPODNode &parentNode = _podModel->pNode[nodeInfo.nIdxParent];
                
                // Not sure if helpers may have a transformation matrix, this is unfortunately not documented inside the
                // PowerVR SDK. So just in case get and assign the world matrix for the node.
                PVRTMat4 podTransformation;
                _podModel->GetWorldMatrix(podTransformation, parentNode);
                [node setTransformationFromOpenGLMatrix:podTransformation.f];
                
                Isgl3dClassDebugLog(Isgl3dLogLevelDebug, @"node with non-mesh node parent (%d) %s:", nodeInfo.nIdxParent, parentNode.pszName);
                [scene addChild:node];
			}
		}
	}

	// Remove all mesh node objects so that they are recreated for the next call to this method
	_buildMeshNodesComplete = NO;
	
}

- (Isgl3dMeshNode *)meshNodeWithName:(NSString *)nodeName {
	
	Isgl3dMeshNode * node = [_meshNodes objectForKey:nodeName];
	if (!node) {
        Isgl3dClassDebugLog(Isgl3dLogLevelError, @"Unable to find mesh node with name %@", nodeName);
	}
	return node;
}

- (Isgl3dGLMesh *)meshFromNodeWithName:(NSString *)nodeName {
	Isgl3dMeshNode * meshNode = [self meshNodeWithName:nodeName];
	if (meshNode) {
		return meshNode.mesh;
	}
	
	return nil;
}

- (Isgl3dGLMesh *)meshAtIndex:(unsigned int)meshIndex {
	if (meshIndex >= _podModel->nNumMesh) {
		Isgl3dClassDebugLog(Isgl3dLogLevelError, @"Mesh at index %i not available: POD scene contains %i meshses", meshIndex, _podModel->nNumMesh);
		return nil;
	}
	
	return [_meshes objectAtIndex:meshIndex];
}

- (Isgl3dMaterial *)materialWithName:(NSString *)materialName {
	Isgl3dMaterial * material = NULL;
	for (int i = 0; i < _podModel->nNumMaterial; i++) {
		SPODMaterial & materialInfo = _podModel->pMaterial[i];
		if ([materialName isEqualToString:[NSString stringWithUTF8String:materialInfo.pszName]]) {

			if (i < [_materials count]) {
				material = [_materials objectAtIndex:i];
				break;
			}

		}
	}	

	if (!material) {
		Isgl3dClassDebugLog(Isgl3dLogLevelError, @"Unable to find material with name: %@", materialName);
	}
	return material;
}


- (Isgl3dNodeCamera *)cameraAtIndex:(unsigned int)cameraIndex {
	if (!_buildSceneObjectsComplete) {
		[self buildSceneObjects];
	}	
	
	if (cameraIndex >= _podModel->nNumCamera) {
		Isgl3dClassDebugLog(Isgl3dLogLevelError, @"Camera at index %i not available: POD scene contains %i cameras", cameraIndex, _podModel->nNumCamera);
		return nil;
	}
	
	return [_cameras objectAtIndex:cameraIndex];
}

- (Isgl3dLight *)lightAtIndex:(unsigned int)lightIndex {
	if (!_buildSceneObjectsComplete) {
		[self buildSceneObjects];
	}	

	if (lightIndex >= _podModel->nNumLight) {
		Isgl3dClassDebugLog(Isgl3dLogLevelError, @"Light at index %i not available: POD scene contains %i lights", lightIndex, _podModel->nNumLight);
		return nil;
	}
	
	return [_lights objectAtIndex:lightIndex];
}

- (float *)ambientColor {
	return _podModel->pfColourAmbient;
}



- (void)configureLight:(Isgl3dLight *)light fromNode:(NSString *)nodeName {
	for (int i = 0; i < _podModel->nNumMeshNode; i++) {
		SPODNode & node = _podModel->pNode[i];
		if ([nodeName isEqualToString:[NSString stringWithUTF8String:node.pszName]]) {
			[light setRenderedMesh:[_meshes objectAtIndex:node.nIdx]];

			PVRTMat4 podTransformation;
			_podModel->GetWorldMatrix(podTransformation, node);
			[light setTransformationFromOpenGLMatrix:podTransformation.f];
			return;
		}
	}
	
	Isgl3dClassDebugLog(Isgl3dLogLevelError, @"Unable to find mesh with name %@", nodeName);
}


- (void)addBonesToSkeleton:(Isgl3dSkeletonNode *)skeleton {

	if (!_boneBuildComplete) {
		[_boneNodeIndices removeAllObjects];
		[_boneNodes removeAllObjects];
		[_indexedNodes removeAllObjects];
		[self buildBones];
	}


	// Build hierarchy of bones and add to skeleton
	for (NSNumber * nodeIndex in _boneNodeIndices) {
		int nodeId = [nodeIndex integerValue];
		SPODNode & nodeInfo = _podModel->pNode[nodeId];
	
		Isgl3dClassDebugLog(Isgl3dLogLevelDebug, @"Adding bone to skeleton: %s  (%i)", nodeInfo.pszName, nodeId);
		
		Isgl3dBoneNode * node = [_boneNodes objectForKey:[NSString stringWithUTF8String:nodeInfo.pszName]];
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

- (void)modifyTexture:(NSString *)podTextureFileName withTexture:(NSString *)replacementFileName {
	[_textureMods setObject:replacementFileName forKey:podTextureFileName];
}


/*
 * Private methods....
 */


- (void)buildMeshesAndMaterials {
	// Iterate over nodes and create meshes and materials as necessary

	// Create array of textures
	for (int i = 0; i < _podModel->nNumTexture; i++) {
		SPODTexture & textureInfo = _podModel->pTexture[i];
		
		NSString * textureFileName = [NSString stringWithUTF8String:textureInfo.pszName];
		if ([_textureMods objectForKey:textureFileName] != nil) {
			textureFileName = [_textureMods objectForKey:textureFileName];
		}
		
		NSString * extension = [textureFileName pathExtension];
		// Image formats supported by UIImage and pvr
		NSArray * acceptedFormats = [NSArray arrayWithObjects:@"png", @"jpg", @"jpeg", @"tiff", @"tif", @"gif", @"bmp", @"BMPf", @"ico", @"cur", @"xbm", @"pvr", nil];
		if (![acceptedFormats containsObject:extension]) {
			Isgl3dClassDebugLog(Isgl3dLogLevelError, @"POD %@ contains texture image with format that is not supported : %@", _podPath, textureFileName);
		} 
		
		Isgl3dClassDebugLog(Isgl3dLogLevelDebug, @"Creating texture from %@:", textureFileName);
		[_textures addObject:textureFileName];
	}

	
	// Create array of materials
	for (int i = 0; i < _podModel->nNumMaterial; i++) {
		SPODMaterial & materialInfo = _podModel->pMaterial[i];
	
		Isgl3dColorMaterial * material;
		Isgl3dClassDebugLog(Isgl3dLogLevelDebug, @"Creating material: %s:", materialInfo.pszName);
		
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
			Isgl3dClassDebugLog(Isgl3dLogLevelWarn, @"Material has effect file and is currently not supported: %s", materialInfo.pszEffectFile);
		}
	}	
	
	// Create array of meshes
	for (int i = 0; i < _podModel->nNumMesh; i++) {
		SPODMesh & meshInfo = _podModel->pMesh[i];
		
		Isgl3dGLMesh * mesh = [self createMeshFromPODData:&meshInfo];
		[_meshes addObject:mesh];
	}
	
	_meshesAndMaterialsComplete = YES;
}

- (void)buildSceneObjects {
	
	if (!_buildMeshNodesComplete) {
		[self buildMeshNodes];
	}
	
	
	// Create array of cameras
	for (int i = 0; i < _podModel->nNumCamera; i++) {
		SPODCamera & cameraInfo = _podModel->pCamera[i];
		float nearZ = cameraInfo.fNear;
		float farZ = cameraInfo.fFar;
        
        PVRTVECTOR3 eye = { 0.0f, 0.0f, 0.0f };
        PVRTVECTOR3 center = { 0.0f, 0.0f, 0.0f };
        PVRTVECTOR3 up = { 0.0f, 0.0f, 0.0f };
        float fovyRadians = _podModel->GetCamera(eye, center, up, i);
		
		Isgl3dClassDebugLog(Isgl3dLogLevelDebug, @"Creating camera: pos = [%f, %f, %f], lookAt = [%f, %f, %f], fov = %f, near = %f, far = %f",
                            eye.x, eye.y, eye.z, center.x, center.y, center.z, Isgl3dMathRadiansToDegrees(fovyRadians), nearZ, farZ);
	
		CGSize windowSize = [Isgl3dDirector sharedInstance].windowSize;
        
        Isgl3dPerspectiveProjection *perspectiveLens = [[Isgl3dPerspectiveProjection alloc] initFromViewSize:windowSize fovyRadians:fovyRadians nearZ:nearZ farZ:farZ];
        
        Isgl3dNodeCamera *nodeCamera = [[Isgl3dNodeCamera alloc] initWithLens:perspectiveLens
                                                                     position:Isgl3dVector3Make(eye.x, eye.y, eye.z)
                                                                 lookAtTarget:Isgl3dVector3Make(center.x, center.y, center.z)
                                                                           up:Isgl3dVector3Make(up.x, up.y, up.z)];
        
        //Isgl3dLookAtCamera *camera = [[Isgl3dLookAtCamera alloc] initWithLens:perspectiveLens eyeX:eye.x eyeY:eye.y eyeZ:eye.z centerX:center.x centerY:center.y centerZ:center.z upX:up.x upY:up.y upZ:up.z];
        [perspectiveLens release];
        
		[_cameras addObject:nodeCamera];
        [nodeCamera release];
	}
	
	// Create lights
	for (int i = 0; i < _podModel->nNumLight; i++) {
		SPODLight & lightInfo = _podModel->pLight[i];
		
		PVRTVECTOR3 pos;
		PVRTVECTOR3 dirn;
		_podModel->GetLight(pos, dirn, i);
		
		Isgl3dLight * light = [Isgl3dLight lightWithColorArray:lightInfo.pfColour];
		
		light.constantAttenuation = lightInfo.fConstantAttenuation;
		light.linearAttenuation = lightInfo.fLinearAttenuation;
		light.quadraticAttenuation = lightInfo.fQuadraticAttenuation;
		if (lightInfo.eType == ePODPoint) {
			light.lightType = PointLight;
			light.position = Isgl3dVector3Make(pos.x, pos.y, pos.z);

		} else if (lightInfo.eType == ePODDirectional) {
			light.lightType = DirectionalLight;
			[light setDirection:dirn.x y:dirn.y z:dirn.z];

		} else {
			light.lightType = SpotLight;
			light.position = Isgl3dVector3Make(pos.x, pos.y, pos.z);
			light.spotCutoffAngle = lightInfo.fFalloffAngle * 180 / M_PI;
			light.spotFalloffExponent = lightInfo.fFalloffExponent;
			[light setSpotDirection:dirn.x y:dirn.y z:dirn.z];
		}
		
		[_lights addObject:light];
	}
	
	_buildSceneObjectsComplete = YES;
}

- (void)buildMeshNodes {
	
	if (!_meshesAndMaterialsComplete) {
		[self buildMeshesAndMaterials];
	}
	
	// Create all mesh nodes, link to materials and meshes.
	for (int i = 0; i < _podModel->nNumMeshNode; i++) {
		SPODNode &meshNodeInfo = _podModel->pNode[i];
		SPODMesh &meshInfo = _podModel->pMesh[meshNodeInfo.nIdx];
	
		// Get the mesh
		Isgl3dGLMesh *mesh = [_meshes objectAtIndex:meshNodeInfo.nIdx];
		Isgl3dMaterial *material = nil;

		// Set the material
		if (meshNodeInfo.nIdxMaterial >= 0 && meshNodeInfo.nIdxMaterial < [_materials count]) {
			material = [_materials objectAtIndex:meshNodeInfo.nIdxMaterial];
		} else {
			Isgl3dClassDebugLog(Isgl3dLogLevelWarn, @"No material for mesh: %s", meshNodeInfo.pszName);
		}


		// Check to see if the mesh has bone data
		Isgl3dMeshNode * node;
		if (meshInfo.sBoneIdx.pData && meshInfo.sBoneWeight.pData) {
			node = [self createAnimatedMeshNode:i meshId:meshNodeInfo.nIdx mesh:mesh material:material];
			[_meshNodes setObject:node forKey:[NSString stringWithUTF8String:meshNodeInfo.pszName]];
		
		} else {
		
			Isgl3dClassDebugLog(Isgl3dLogLevelDebug, @"Bulding mesh node: %s:", meshNodeInfo.pszName);
			node = [Isgl3dMeshNode nodeWithMesh:mesh andMaterial:material];
			[_meshNodes setObject:node forKey:[NSString stringWithUTF8String:meshNodeInfo.pszName]];
		}			

		[_indexedNodes setObject:node forKey:[NSNumber numberWithInteger:meshNodeInfo.nIdx]];

        if (material != nil) {
            // Add node alpha
            SPODMaterial & materialInfo = _podModel->pMaterial[meshNodeInfo.nIdxMaterial];
            node.alpha = materialInfo.fMatOpacity;
            node.transparent = node.alpha < 1.0 ? YES : NO;
        } else {
            node.isVisible = NO;
            node.alpha = 1.0;
            node.transparent = NO;
        }

		// Set the default node transformation
		_podModel->SetFrame(0);
		PVRTMat4 podTransformation;
		_podModel->GetTransformationMatrix(podTransformation, meshNodeInfo);
		[node setTransformationFromOpenGLMatrix:podTransformation.f];
		
	}
	
	// Create all non-mesh nodes
	for (int i = 0; i < _podModel->nNumNode; i++) {
		SPODNode & nodeInfo = _podModel->pNode[i];
		
		// See if node already exists as a mesh node, otherise create simple node
		if (![_indexedNodes objectForKey:[NSNumber numberWithInteger:nodeInfo.nIdx]]) {
			Isgl3dNode *node = [Isgl3dNode node];
			[_indexedNodes setObject:node forKey:[NSNumber numberWithInteger:nodeInfo.nIdx]];
		}
		
	}
	
	
	_buildMeshNodesComplete = YES;
}

- (void)buildBones {
	
	// Get all bone node indexes from all meshes
	NSMutableArray * meshBoneNodeIndexes = [[NSMutableArray alloc] init];
	for (int i = 0; i < _podModel->nNumMesh; i++) {
		SPODMesh & meshNodeInfo = _podModel->pMesh[i];
		
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
		SPODNode & nodeInfo = _podModel->pNode[nodeId];
		if (![_boneNodeIndices containsObject:[NSNumber numberWithInteger:nodeId]]) {
			[_boneNodeIndices addObject:[NSNumber numberWithInteger:nodeId]];
		}

		// Iterate over node parents
		int parentId = nodeInfo.nIdxParent;
		while (parentId != -1) {
			SPODNode & currentNodeInfo = _podModel->pNode[parentId];
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

- (Isgl3dAnimatedMeshNode *)createAnimatedMeshNode:(unsigned int)nodeId meshId:(unsigned int)meshId mesh:(Isgl3dGLMesh *)mesh material:(Isgl3dMaterial *)material {
	SPODNode & meshNodeInfo = _podModel->pNode[nodeId];
	SPODMesh& meshInfo = _podModel->pMesh[meshId];
			
	Isgl3dClassDebugLog2(Isgl3dLogLevelDebug, @"Bulding animated mesh node: %s:", meshNodeInfo.pszName);
	
	// Create new animted mesh node with default mesh and material
	Isgl3dAnimatedMeshNode * animatedMeshNode = [Isgl3dAnimatedMeshNode nodeWithMesh:mesh andMaterial:material];
	
	[animatedMeshNode setNumberOfBonesPerVertex:meshInfo.sBoneIdx.n];
	
	// Get bone batches
	CPVRTBoneBatches boneBatches = meshInfo.sBoneBatches;
	int nBatches = boneBatches.nBatchCnt;
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
		
		// Iterate over frames and get transformations for all bones 
		for (int iFrame = 0; iFrame < _podModel->nNumFrame; iFrame++) {
			_podModel->SetFrame(iFrame);
			Isgl3dArray * transformations = IA_ALLOC_INIT_AR(Isgl3dMatrix4);

			// Iterate over all bones, get transformation for each
			for (int iBone = 0; iBone < numberOfBatchBones; iBone++) {
				int nodeId = boneBatches.pnBatches[iBatch * boneBatches.nBatchBoneMax + iBone];
				SPODNode & boneNodeInfo = _podModel->pNode[nodeId];

				// Set the bone transformation
				PVRTMat4 boneTransformation;
				_podModel->GetBoneWorldMatrix(boneTransformation, meshNodeInfo, boneNodeInfo);
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

- (Isgl3dBoneNode *)createBoneNode:(unsigned int)nodeId {
	Isgl3dBoneNode * boneNode = [_indexedNodes objectForKey:[NSNumber numberWithInteger:nodeId]];
	if (boneNode) {
		return boneNode;
	}
	
	SPODNode & nodeInfo = _podModel->pNode[nodeId];
	Isgl3dClassDebugLog(Isgl3dLogLevelDebug, @"Building bone %s (%i)", nodeInfo.pszName, nodeId);

	boneNode = [Isgl3dBoneNode boneNode];
	[_indexedNodes setObject:boneNode forKey:[NSNumber numberWithInteger:nodeId]];
	[_boneNodes setObject:boneNode forKey:[NSString stringWithUTF8String:nodeInfo.pszName]];

	// Set the default transformation
	_podModel->SetFrame(0);
	PVRTMat4 podTransformation;
	_podModel->GetWorldMatrix(podTransformation, nodeInfo);
	[boneNode setTransformationFromOpenGLMatrix:podTransformation.f];

	// Add frame transformations for all bones
	for (int iFrame = 0; iFrame < _podModel->nNumFrame; iFrame++) {
		_podModel->SetFrame(iFrame);
		PVRTMat4 podTransformation;
		_podModel->GetWorldMatrix(podTransformation, nodeInfo);
		[boneNode addFrameTransformationFromOpenGLMatrix:podTransformation.f];
	}	

	return boneNode;
}

@end
