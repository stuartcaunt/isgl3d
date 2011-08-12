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

#import <UIKit/UIKit.h>
 

#import "Isgl3dEvent3DDispatcher.h"
#import "Isgl3dVector.h"
#import "Isgl3dMatrix.h"
#import "isgl3dTypes.h"


@class Isgl3dMeshNode;
@class Isgl3dSkeletonNode;
@class Isgl3dFollowNode;
@class Isgl3dCamera;
@class Isgl3dLight;
@class Isgl3dParticleNode;
@class Isgl3dBillboardNode;
@class Isgl3dMaterial;
@class Isgl3dGLMesh;
@class Isgl3dGLParticle;
@class Isgl3dGLRenderer;
@class Isgl3dActionManager;
@class Isgl3dAction;

/**
 * The Isgl3dNode provides an interface to perform transformations on a node.
 * It is used to calculated the transformation for a model given a parent transformation and is optimised
 * to only recalculate transformations if necessary.
 * 
 * The Isgl3dNode contains two transformation matrices: the local transformation and the world
 * transformation. The local transformation is the displacement/rotation of the object in its local
 * frame of reference. The world transformation is the transformation of the object in world-space taking
 * into account parent transformations.
 * 
 * The Isgl3dNode is the root of all the different types of nodes in iSGL3D. All elements included
 * in the scene graph must inherit from this class.
 * 
 * The Isgl3dNode is not itself rendered on the scene (see for example Isgl3dMeshNode or Isgl3dParticleNode
 * amongst others that are rendered). The principal purpose of the Isgl3dNode is to provide structure
 * to the scene graph, group elements together and act as a container for other nodes. It therefore has
 * the notion of "children" and "parent" nodes.
 * 
 */
@interface Isgl3dNode : Isgl3dEvent3DDispatcher <NSCopying> {

@protected

	float _rotationX;
	float _rotationY;
	float _rotationZ;
	float _scaleX;
	float _scaleY;
	float _scaleZ;

	Isgl3dMatrix4 _localTransformation;
	Isgl3dMatrix4 _worldTransformation;

	BOOL _transformationDirty;
	BOOL _localTransformationDirty;
	BOOL _eulerAnglesDirty;
	BOOL _rotationMatrixDirty;



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

	BOOL _isVisible;
	
	BOOL _isRunning;
	
@private

	Isgl3dNode * _parent;

	BOOL _hasChildren;
}

/**
 * Returns the world transformation of the node.
 */
@property (readonly) Isgl3dMatrix4 worldTransformation;

/**
 * The local displacement along the x-axis in the objects frame of reference.
 */
@property (nonatomic) float x;

/**
 * The local displacement along the y-axis in the objects frame of reference.
 */
@property (nonatomic) float y;

/**
 * The local displacement along the z-axis in the objects frame of reference.
 */
@property (nonatomic) float z;

/**
 * The position of the object in the local frame of reference.
 */
@property (nonatomic) Isgl3dVector3 position;

/**
 * The rotation about the x-axis in the objects frame of reference.
 */
@property (nonatomic) float rotationX;

/**
 * The rotation about the y-axis in the objects frame of reference.
 */
@property (nonatomic) float rotationY;

/**
 * The rotation about the z-axis in the objects frame of reference.
 */
@property (nonatomic) float rotationZ;

/**
 * The scale of the object in the x direction
 */
@property (nonatomic) float scaleX;

/**
 * The scale of the object in the y direction
 */
@property (nonatomic) float scaleY;

/**
 * The scale of the object in the z direction
 */
@property (nonatomic) float scaleZ;




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
 * Indicates whether the node is visible or not. For rendered nodes (eg Isgl3dMeshNode) this allows them to be
 * dynamically made visible or not while keeping them in the scene.
 * Note: this affects all child nodes too.
 */
@property (nonatomic) BOOL isVisible;

/**
 * The gesture recognizers currently attached to this node.
 */
@property (nonatomic, readonly) NSArray *gestureRecognizers;

/**
 * Allocates and initialises (autorelease) node (position at (0, 0, 0) and zero rotation and no scaling).
 */
+ (id) node;

/**
 * Initialises the node (position at (0, 0, 0) and zero rotation and no scaling).
 */
- (id) init;

#pragma mark translation rotation scaling


/**
 * Sets the object's position to a given point.
 * @param x The position along the x axis in the object's local frame of reference.
 * @param y The position along the y axis in the object's local frame of reference.
 * @param z The position along the z axis in the object's local frame of reference.
 */
- (void) setPositionValues:(float)x y:(float)y z:(float)z;

/**
 * Translates the object by a given amount from its current position in the objects local frame of reference.
 * Note that this is useful for example to make a node move "left" or "right" with vector (-1, 0, 0) and (1, 0, 0)
 * @param x The displacement along the x axis in the object's local frame of reference.
 * @param y The displacement along the y axis in the object's local frame of reference.
 * @param z The displacement along the z axis in the object's local frame of reference.
 */
- (void) translateByValues:(float)x y:(float)y z:(float)z;

/**
 * Translates the object along a vector from its current position.
 * @param vector The displacement in three dimensions in the object's local frame of reference.
 */
- (void) translateByVector:(Isgl3dVector3)vector;

/**
 * Rotates the object about its local x axis by given angle
 * @param angle The angle of rotation in degrees
 */
- (void) pitch:(float)angle;

/**
 * Rotates the object about its local y axis by given angle
 * @param angle The angle of rotation in degrees
 */
- (void) yaw:(float)angle;

/**
 * Rotates the object about its local z axis by given angle
 * @param angle The angle of rotation in degrees
 */
- (void) roll:(float)angle;

/**
 * Performs a general rotation of the object by a given angle about a vector defined
 * as (x, y, z). The rotation is added to the current object's rotation.
 * @param angle The angle in degrees.
 * @param x The x component of the axis of rotation.
 * @param y The y component of the axis of rotation.
 * @param z The z component of the axis of rotation.
 */
- (void) rotate:(float)angle x:(float)x y:(float)y z:(float)z;

/**
 * Sets the rotation of the object by a given angle about a general vector defined
 * as (x, y, z). 
 * @param angle The angle in degrees.
 * @param x The x component of the axis of rotation.
 * @param y The y component of the axis of rotation.
 * @param z The z component of the axis of rotation.
 */
- (void) setRotation:(float)angle x:(float)x y:(float)y z:(float)z;

/**
 * Sets a global scaling factor for the object (identical in x-, y- and z-directions).
 * @param scale The scaling factor.
 */
- (void) setScale:(float)scale;

/**
 * Sets scaling factors along each axis.
 * @param scaleX The scaling factor in the x-direction.
 * @param scaleY The scaling factor in the y-direction.
 * @param scaleZ The scaling factor in the z-direction.
 */
- (void) setScale:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ;

/**
 * Reset's the local transformation.
 */
- (void) resetTransformation;

/**
 * Set's the object's local transformation from a given transformation matrix.
 * @param transformation The local transformation of the object.
 */
- (void) setTransformation:(Isgl3dMatrix4)transformation;

/**
 * Set's the object's local transformation from array of column-wise values representing
 * a 4x4 matrix (same format as OpenGL).
 * @param transformation The local transformation of the object as a column-wise array of values.
 */
- (void) setTransformationFromOpenGLMatrix:(float *)transformation;

/**
 * USed to obtain the local transformation as a column-wise array of values representing the 
 * 4x4 matrix.
 * @param transformation Current column-wise array of values for the local transformation is stored here.
 */
- (void) getTransformationAsOpenGLMatrix:(float *)transformation;

/**
 * Copies the current world position of the object into an array of 4 values representing the 4 translation elements of a 4x4 matrix (tx, ty, tz, tw).
 * @param position The current world position (tx, ty, tz, tw) of the object is set into this float array.
 */
- (void) copyWorldPositionToArray:(float *)position;

/**
 * Returns the world position as an I3DVector.
 */
- (Isgl3dVector3) worldPosition;

/**
 * This is used to return the equation of a plane that passes through the object's world position
 * given a normal to the plane in the object's local frame of reference.
 * This is intended for use when generating planar shadows.
 * @param normal The normal to the plane.
 * @result Vector representation of the plane with transformed normal passing through the object's position. 
 */
- (Isgl3dVector4) asPlaneWithNormal:(Isgl3dVector3)normal;

/*
 * Indicates to the object that its transformation needs to be recalculated.
 * Note that this intended to be called internally by iSGL3D.
 * @param isDirty Indicates whether the transformation needs to be recalculated or not.
 */
- (void) setTransformationDirty:(BOOL)isDirty;

/*
 * Updates the world transformation of the object given the parent's world transformation.
 * Note that this intended to be called internally by iSGL3D.
 * @param parentTransformation The parent's world transformation matrix.
 */
- (void) updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation;

/*
 * Given a view matrix, this returns the distance along the observer's viewing direction to the object.
 * Note that this intended to be called internally by iSGL3D, used for z-sorting of nodes.
 * @param viewMatrix The view matrix to transform objects to the viewer's frame of reference.
 * @return Distance along the z-axis of the viewer to the object.
 */
- (float) getZTransformation:(Isgl3dMatrix4 *)viewMatrix;


#pragma mark scene graph


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
 * Utility method to create an Isgl3dBillboardNode and add it as a child.
 * @param mesh The mesh to be rendered.
 * @param material The material to be displayed on the mesh.
 * @return (autorelease) The created node.
 */
- (Isgl3dBillboardNode *) createBillboardNodeWithMesh:(Isgl3dGLMesh *)mesh andMaterial:(Isgl3dMaterial *)material;

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
 * Activates the node and all its children. Called when a view is made active or a child is added to an already active node.
 * Note : This is called internally by iSGL3D and should not be called manually. Any code that needs to
 * be handled when the node is activated should be added in "onActivated".
 */
- (void) activate;

/**
 * Deactivates the node and all its children. Called when a view is made deactive or a child is removed from an active node.
 * Note : This is called internally by iSGL3D and should not be called manually. Any code that needs to
 * be handled when the node is deactivated should be added in "onDeactivated".
 */
- (void) deactivate;

/**
 * Called by "activate": any code that needs to be called when a node is activated should be implemented here in sub-classes.
 */
- (void) onActivated;

/**
 * Called by "deactivate": any code that needs to be called when a node is deactivated should be implemented here in sub-classes.
 */
- (void) onDeactivated;

/**
 * Removes all child nodes.
 */
- (void) clearAll;

/**
 * Sets the mode of occlusion. The mode determines how the alpha value is calculated, relating to the distance
 * to the target and the angle from the vector between the observer and the target. the following modes are available
 * <ul>
 * <li>Isgl3dOcclusionQuadDistanceAndAngle: Occlusion alpha calculated from quadratic distance and angle.</li>
 * <li>Isgl3dOcclusionDistanceAndAngle: Occlusion alpha calculated from linear distance and angle.</li>
 * <li>Isgl3dOcclusionQuadDistance: Occlusion alpha calculated from quadratic distance only.</li>
 * <li>Isgl3dOcclusionDistance: Occlusion alpha calculated from linear distance only.</li>
 * <li>Isgl3dOcclusionAngle: Occlusion alpha calculated from angle only.</li>
 * </ul>
 * The occlusion mode is static, therefore the same for all nodes in the scene.
 * @param mode The mode of occlusion.
 */
+ (void) setOcclusionMode:(Isgl3dOcclusionMode)mode;

/**
 * Returns the current occlusion mode.
 * @return the occlusion mode. 
 */
+ (Isgl3dOcclusionMode) occlusionMode;

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
 * @param maxAngle The maximum angle for which occlusion should be considered. 
 */
- (void) occlusionTest:(Isgl3dVector3 *)eye normal:(Isgl3dVector3 *)normal targetDistance:(float)targetDistance maxAngle:(float)maxAngle;

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

/**
 * Add a gesture recognizer to this node.
 * Note that you may not change the delegate of the gesture recognizer after it has been added.
 * The UIGestureRecognizerDelegate has to be set before the gesture recognizer is being added to a node.
 * @param gestureRecognizer The gesture recognizer to be added. Must not be nil.
 */
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

/**
 * Removes a gesture recognizer handling touches for this node.
 * @param gestureRecognizer The gesture recognizer to be removed. Must not be nil.
 */
- (void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

/**
 * Returns the original gesture recognizer delegate for the specified gesture recognizer.
 * To be used after a gesture recognizer has been added to a node.
 * @result The gesture recognizer delegate if the node contains the specified gesture recognizer.
 */
- (id<UIGestureRecognizerDelegate>)gestureRecognizerDelegateFor:(UIGestureRecognizer *)gestureRecognizer;

/**
 * Sets the gesture recognizer delegate for a gesture recognizer of the node.
 * To be used after a gesture recognizer has been added to a node.
 * param aDelegate The gesture recognizer delegate to set.
 * param gestureRecognizer The gesture recognizer of the node for which the delegate should be set.
 */
- (void)setGestureRecognizerDelegate:(id<UIGestureRecognizerDelegate>)aDelegate forGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

/**
 * Runs a Isgl3dAction using this node as the target.
 * @param action The action to be run on this node.
 */
- (void) runAction:(Isgl3dAction *)action;

/**
 * Stops a Isgl3dAction.
 * @param action The action to be stopped.
 */
- (void) stopAction:(Isgl3dAction *)action;

/**
 * Stops all actions associated with this node.
 */
- (void) stopAllActions;

@end
