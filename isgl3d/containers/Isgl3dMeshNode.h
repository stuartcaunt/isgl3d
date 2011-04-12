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

@class Isgl3dGLMesh;
@class Isgl3dMaterial;

/**
 * The Isgl3dMeshNode is one of the primary types of nodes available in iSGL3D. It is used to render meshes
 * with materials.
 */
@interface Isgl3dMeshNode : Isgl3dNode {

@protected
	BOOL _skinningEnabled;

@private
	Isgl3dGLMesh * _mesh;
	Isgl3dMaterial * _material;

	BOOL _doubleSided;
	
	float _occlusionAlpha;
	
}

/**
 * Indicates whether both sides of the mesh should be rendered.
 * By default only the front face of a mesh is rendered. The "side" of a mesh is defined by the order
 * of the vertices in the mesh data. By default triangles defined with counter-clockwise ordering
 * of elements are considered front-facing, those that are clockwise are back-facing.
 */
@property (nonatomic) BOOL doubleSided;

/**
 * The mesh to be rendered.
 */
@property (nonatomic, retain) Isgl3dGLMesh * mesh;

/**
 * The material to map onto the mesh.
 */
@property (nonatomic, retain) Isgl3dMaterial * material;

/**
 * Allocates and initialises (autorelease) node with a mesh and a material.
 * @param mesh The mesh to be rendered.
 * @param material The material to be mapped onto the mesh
 */
+ (id) nodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material;

/**
 * Initialises the node with a mesh and a material.
 * @param mesh The mesh to be rendered.
 * @param material The material to be mapped onto the mesh
 */
- (id) initWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material;

@end
