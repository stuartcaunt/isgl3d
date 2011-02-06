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

#import "Isgl3dGLObject3D.h"

#define OCCULTATION_MODE_QUAD_DISTANCE_AND_ANGLE 0
#define OCCULTATION_MODE_DISTANCE_AND_ANGLE 1
#define OCCULTATION_MODE_QUAD_DISTANCE 2
#define OCCULTATION_MODE_DISTANCE 3
#define OCCULTATION_MODE_ANGLE 4

@class Isgl3dView3D;
@class Isgl3dMatrix4D;
@class Isgl3dVector3D;
@class Isgl3dMeshNode;
@class Isgl3dSkeletonNode;
@class Isgl3dFollowNode;
@class Isgl3dCamera;
@class Isgl3dLight;
@class Isgl3dParticleNode;
@class Isgl3dMaterial;
@class Isgl3dGLMesh;
@class Isgl3dGLParticle;
@class Isgl3dGLRenderer;

/**
 * The Isgl3dNode is the root of all the different types of nodes in iSGL3D. All elements included
 * in the scene graph must inherit from this class.
 * 
 * The Isgl3dNode is not itself rendered on the scene (see for example Isgl3dMeshNode or Isgl3dParticleNode
 * amongst others that are rendered). The principal purpose of the Isgl3dNode is to provide structure
 * to the scene graph, group elements together and act as a container for other nodes. It therefore has
 * the notion of "children" and "parent" nodes.
 * 
 */
@interface Isgl3dNode : Isgl3dGLObject3D {

@protected
	NSMutableArray * _children;

	BOOL _enableShadowCasting;	
	BOOL _enableShadowRendering;
	
	BOOL _isPlanarShadowsNode;

	float _alpha;
	BOOL _transparent;
	BOOL _alphaCulling;
	float _alphaCullValue;

	BOOL _lightingEnabled;
	
	BOOL _interactive;
	
@private
	Isgl3dNode * _parent;

	BOOL _hasChildren;
}

/**
 * The children of this node. Returns an NSArray of Isgl3dNodes.
 */
@property (readonly) NSArray * children;

/**
 * The parent of this node. Can be null if the node is at the root of the scene graph.
 */
@property (assign) Isgl3dNode * parent;

/**
 * Indicates whether the node is to have shadows rendered on it (only when shadow mapping
 * is in use). By default shadows are rendered onto the node.
 */
@property (nonatomic) BOOL enableShadowRendering;

/**
 * Indicates whether the node will cast shadows. By default the node does not cast a shadow.
 */
@property (nonatomic) BOOL enableShadowCasting;

/**
 * Used to specify that this node is used for rendering planar shadows (only when planar
 * shadows are in use). By default the node is not used for planar shadows.
 */
@property (nonatomic) BOOL isPlanarShadowsNode;

/**
 * Specifies the transparency of the node. The value should be between 0 (fully transparent)
 * to 1 (fully opaque). The default value is 1.
 */
@property (nonatomic) float alpha;

/**
 * Explicitly specifies whether the node contains transparency (for example with a texture material
 * that contains transparent pixels). Transparent nodes are handled differently to opaque nodes during the render
 * process to ensure that they are rendered correctly. Transparency in OpenGL needs to be handled delicately: for
 * example if a transparent object is in front of an opaque one but is rendered first, the opaque object will not
 * be visible because the z-buffer will disable rendering of pixels behind the nearer object. However if the opaque
 * object is rendered first (before the z-buffer has been filled), it will be visible behind the transparent one.
 * In iSGL3D therefore, all nodes that have either an alpha value or are explicitly set as transparent are rendered
 * after all the opaque nodes. A further option in Isgl3dScene3D allows for z-sorting of transparent objects
 * to further improve the rendering. By default the node is not transparent.
 */
@property (nonatomic) BOOL transparent;

/**
 * Indicates whether pixels of a certain alpha value should be culled completely: this means that they are not
 * added to the z-buffer either. By default no alpha culling occurs.
 */
@property (nonatomic) BOOL alphaCulling;

/**
 * Specifies the alpha value at which pixels should be culled: pixels with alpha less than this will not be rendered
 * at all. By default this is 1.
 */
@property (nonatomic) float alphaCullValue;

/**
 * Specified whether the node should be rendered with lighting and shading effects. For an Isgl3dMeshNode for example
 * with a texture material, the rendered texture colours are identical to the original image file. By default
 * lighting is enabled.
 */
@property (nonatomic) BOOL lightingEnabled;

/**
 * Indicates whether the node reacts to user touch interactions. By default, the node is not interactive.
 */
@property (nonatomic) BOOL interactive;

/**
 * Initialises the node.
 */
- (id) init;

/**
 * Utility method to create an Isgl3dNode and add it as a child.
 * @return Isgl3dNode (autorelease) The created node.
 */
- (Isgl3dNode *) createNode;

/**
 * Utility method to create an Isgl3dMeshNode and add it as a child.
 * @param mesh The mesh to be rendered.
 * @param material The material to be mapped onto the mesh.
 * @return (autorelease) The created node.
 */
- (Isgl3dMeshNode *) createNodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material;

/**
 * Utility method to create an Isgl3dParticleNode and add it as a child.
 * @param particle The particle to be rendered.
 * @param material The material to be displayed on the particle.
 * @return (autorelease) The created node.
 */
- (Isgl3dParticleNode *) createNodeWithParticle:(Isgl3dGLParticle *)particle andMaterial:(Isgl3dMaterial *)material;

/**
 * Utility method to create an Isgl3dSkeletonNode and add it as a child.
 * @return (autorelease) The created node.
 */
- (Isgl3dSkeletonNode *) createSkeletonNode;

/**
 * Utility method to create an Isgl3dFollowNode and add it as a child.
 * @param target The target node to be followed.
 * @return (autorelease) The created node.
 */
- (Isgl3dFollowNode *) createFollowNodeWithTarget:(Isgl3dNode *)target;

/**
 * Utility method to create an Isgl3dCamera and add it as a child.
 * @param view The Isgl3dView3D.
 * @return (autorelease) The created node.
 */
- (Isgl3dCamera *) createCameraNodeWithView:(Isgl3dView3D *)view;

/**
 * Utility method to create an Isgl3dLight and add it as a child.
 * @return (autorelease) The created node.
 */
- (Isgl3dLight *) createLightNode;

/**
 * Adds a child node to the current one. The parent of the child node is automatically set.
 * @param child The child node to be added.
 * @return The child node.
 */
- (Isgl3dNode *) addChild:(Isgl3dNode *)child;

/**
 * Removes a child node to the current one. The parent of the child node is automatically set to nil.
 * @param child The child node to be removed.
 */
- (void) removeChild:(Isgl3dNode *)child;

/**
 * Removes the node from its parent.
 */
- (void) removeFromParent;

/**
 * Removes all child nodes.
 */
- (void) clearAll;

/**
 * Sets the mode of occultation. The mode determines how the alpha value is calculated, relating to the distance
 * to the target and the angle from the vector between the observer and the target. the following modes are available
 * <ul>
 * <li>OCCULTATION_MODE_QUAD_DISTANCE_AND_ANGLE: Occultation alpha calculated from quadratic distance and angle.</li>
 * <li>OCCULTATION_MODE_DISTANCE_AND_ANGLE: Occultation alpha calculated from linear distance and angle.</li>
 * <li>OCCULTATION_MODE_QUAD_DISTANCE: Occultation alpha calculated from quadratic distance only.</li>
 * <li>OCCULTATION_MODE_DISTANCE: Occultation alpha calculated from linear distance only.</li>
 * <li>OCCULTATION_MODE_ANGLE: Occultation alpha calculated from angle only.</li>
 * </ul>
 * The occultation mode is static, therefore the same for all nodes in the scene.
 * @param mode The mode of occultation.
 */
+ (void) setOccultationMode:(unsigned int)mode;

/**
 * Returns the current occultation mode.
 * @return the occultation mode. 
 */
+ (unsigned int) occultationMode;

/**
 * Sets whether the node casts shadows and iterates over children with the same value.
 * @param enableShadowCasting Specifies whether shadow casting is enabled or not.
 */
- (void) enableShadowCastingWithChildren:(BOOL)enableShadowCasting;

/**
 * Sets the alpha value for the node and iterates over all children with the same value.
 * @param alpha The alpha value of the node (between 0 and 1).
 */
- (void) setAlphaWithChildren:(float)alpha;

/**
 * Sets the node to be alpha culling for a specific value of alpha.
 * @param value The minimum alpha value that will be rendered, less than this and the pixel is culled.
 */
- (void) enableAlphaCullingWithValue:(float)value;

/*
 * Renders/initialises the lighting contained in the node. Iterates over children to perform the same operation.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 * @param renderer The renderer.
 */
- (void) renderLights:(Isgl3dGLRenderer *)renderer;

/*
 * Renders all renderable nodes. Iterates over children to perform the same operation.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 * @param renderer The renderer.
 */
- (void) render:(Isgl3dGLRenderer *)renderer opaque:(BOOL)opaque;

/*
 * Renders for event capture if interactive. Iterates over children to perform the same operation.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 * @param renderer The renderer.
 */
- (void) renderForEventCapture:(Isgl3dGLRenderer *)renderer;

/*
 * Renders for shadow map creating, if node is shadow casting. Iterates over children to perform the same operation.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 * @param renderer The renderer.
 */
- (void) renderForShadowMap:(Isgl3dGLRenderer *)renderer;

/*
 * Renders for planar shadows, if node is shadow casting. Iterates over children to perform the same operation.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 * @param renderer The renderer.
 */
- (void) renderForPlanarShadows:(Isgl3dGLRenderer *)renderer;

/*
 * Obtains all child nodes that are transparent (either explicitly set or with an alpha < 1).
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 */
- (void) collectAlphaObjects:(NSMutableArray *)alphaObjects;

/*
 * Determines if and by how much the node is occulting the a target. The alpha value of the 
 * node is modified accordingly.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly.
 * @param eye The position of the observer.
 * @param normal The direction from the observer to the target.
 * @param targetDistance The distance from the observer to the target.
 * @param maxAngle The maximum angle for which occultation should be considered. 
 */
- (void) occultationTest:(Isgl3dMiniVec3D *)eye normal:(Isgl3dMiniVec3D *)normal targetDistance:(float)targetDistance maxAngle:(float)maxAngle;

/*
 * Creates the shadow map for the scene. The shadow rendering light is searched for in the node
 * to produce this.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 */
- (void) createShadowMaps:(Isgl3dGLRenderer *)renderer forScene:(Isgl3dNode *)scene;

/*
 * Creates the matrices necessary for planar shadows in the scene. The shadow rendering light is searched for in the node
 * to produce this.
 * 
 * Note: this is called internally by iSGL3D and should not be called directly. 
 */
- (void) createPlanarShadows:(Isgl3dGLRenderer *)renderer forScene:(Isgl3dNode *)scene;

@end
