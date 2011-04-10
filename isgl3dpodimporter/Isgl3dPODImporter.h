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

#import <Foundation/Foundation.h>

@class Isgl3dMaterial;
@class Isgl3dNode;
@class Isgl3dView3D;
@class Isgl3dMeshNode;
@class Isgl3dSkeletonNode;
@class Isgl3dCamera;
@class Isgl3dLight;

/**
 * The Isgl3dPODImporter provides an example of how to import POWERVR POD data into iSGL3D.
 * 
 * Essentially, the Isgl3dPODImporter provides an interface to the POWERVR POD importer tools available from
 * the Imagination Technologies Limited, POWERVR SDK (http://www.imgtec.com/powervr/insider/powervr-sdk.asp),
 * of which some of the C++ tools classes are contained here in the pvrtools directory with kind permission 
 * of Imagination Technologies Limited.
 * 
 * With this importer, full scene details can be retrieved and reproduced in iSGL3D (including meshes and
 * materials, cameras and lighting).
 * 
 * For meshes and materials, skinning data is obtained from the pod as are bones. Both animated meshes and
 * bones (or rather joints) can be rendered. Texture names contained in the POD data can be overridden
 * to use user-defined textures.
 */
@interface Isgl3dPODImporter : NSObject {
	
class CPVRTModelPOD;

@private
	Isgl3dView3D * _view3D;

	CPVRTModelPOD * _podScene;
	NSString * _podPath;
	
	NSMutableArray * _meshes;
	NSMutableDictionary * _meshNodes;
	NSMutableDictionary * _boneNodes;
	NSMutableDictionary * _indexedNodes;
	NSMutableArray * _boneNodeIndices;
	NSMutableArray * _textures;
	NSMutableArray * _materials;
	NSMutableArray * _cameras;
	NSMutableArray * _lights;
	
	NSMutableDictionary * _textureMods;
	
	BOOL _buildComplete;
	BOOL _boneBuildComplete;
}

/**
 * Allocates and initialises (autorelease) importer with the POD data file path.
 * @param path The path to the POD data file.
 */
+ (id) podImporterWithFile:(NSString *)path;

/**
 * Initialises the importer with the POD data file path and the view3D.
 * @param path The path to the POD data file.
 * @param view3D the Isgl3dView3D.
 * 
 * @deprecated Will be removed in v1.2
 */
- (id) initWithFile:(NSString *)path andView3D:(Isgl3dView3D *)view3D;

/**
 * Initialises the importer with the POD data file path.
 * @param path The path to the POD data file.
 */
- (id) initWithFile:(NSString *)path;

/**
 * Prints to the console information about the structure and contents of the POD.
 */
- (void) printPODInfo;

/**
 * Returns the number of meshes in the scene.
 * @return The number of meshes in the scene.
 */
- (unsigned int) numberOfMeshes;

/**
 * Returns the number of cameras in the scene.
 * @return The number of cameras in the scene.
 */
- (unsigned int) numberOfCameras;

/**
 * Returns the number of lights in the scene.
 * @return The number of lights in the scene.
 */
- (unsigned int) numberOfLights;

/**
 * Returns the number of frames in the scene (for the bone/mesh animation).
 * @return The number of frames in the scene (for the bone/mesh animation).
 */
- (unsigned int) numberOfFrames;

/**
 * Adds Isgl3dMeshNodes containing the meshes and relevant materaisl to the scene (or any other Isgl3dNode)
 * from the data in the POD file.
 * This creates a number of Isgl3dMeshNodes taking both material and mesh data, along with
 * transformations for the node provided by the file. All animated meshes are also added to the scene.
 * @param scene The node to which the POD scene contents are added to as children.
 */
- (void) addMeshesToScene:(Isgl3dNode *)scene;

/**
 * Adds Isgl3dBoneNodes to an Isgl3dSkeletonNode from the data in the POD file.
 * The bone nodes contain the animation transformations used for the skinning but this is not necessary
 * to produce animated meshes (this is done by the addMeshesToScene: method). Adding the bones can
 * be useful to view the movement of the bones without a mesh.
 * @param skeleton The Isgl3dSkeletonNode to which the bones are added.
 */
- (void) addBonesToSkeleton:(Isgl3dSkeletonNode *)skeleton;

/**
 * Returns the Isgl3dMeshNode corresponding to a node name (as defined in the POD file).
 * All node names can be obtained via printPODInfo.
 * @param nodeName the name of the node as defined in the POD file.
 * @return The Corresponding Isgl3dMeshNode.
 */
- (Isgl3dMeshNode *) meshNodeWithName:(NSString *)nodeName;

/**
 * Returns the Isgl3dMaterial corresponding to a material name (as defined in the POD file).
 * All material names can be obtained via printPODInfo.
 * @param materialName the name of the material as defined in the POD file.
 * @return The Corresponding Isgl3dMaterial.
 */
- (Isgl3dMaterial *) materialWithName:(NSString *)materialName;

/**
 * Returns the Isgl3dCamera corresponding to a camera index (as defined in the POD file).
 * All camera indices can be obtained via printPODInfo.
 * @param cameraIndex the index of the camera as defined in the POD file.
 * @return The Corresponding Isgl3dCamera.
 */
- (Isgl3dCamera *) cameraAtIndex:(unsigned int)cameraIndex;

/**
 * Returns the Isgl3dLight corresponding to a light index (as defined in the POD file).
 * All light indices can be obtained via printPODInfo.
 * @param lightIndex the index of the light as defined in the POD file.
 * @return The Corresponding Isgl3dLight.
 */
- (Isgl3dLight *) lightAtIndex:(unsigned int)lightIndex;

/**
 * Returns the scene ambient color (rgb) as defined in the POD file.
 * @return the scene ambient color (rgb) as defined in the POD file.
 */
- (float *) ambientColor;

/**
 * Takes the transformation matrix of a node in the POD file and applies it to
 * and Isgl3dLight. All node names can be obtained via printPODInfo.
 * @param light The Isgl3dLight to be configured.
 * @param nodeName The name of the node as defined in the POD file.
 */
- (void) configureLight:(Isgl3dLight *)light fromNode:(NSString *)nodeName;

/**
 * Overrides a texture file name, defined in the POD file, with another user-defined one.
 * @param podTextureFileName The original texture file name as defined in the POD data.
 * @param replacementFileName The user-defined texture file name.
 */
- (void) modifyTexture:(NSString *)podTextureFileName withTexture:(NSString *)replacementFileName;


@end


