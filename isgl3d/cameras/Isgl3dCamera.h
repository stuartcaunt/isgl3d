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

#import <UIKit/UIKit.h>

#import "Isgl3dCameraLens.h"
#import "isgl3dTypes.h"
#import "isgl3dMatrix.h"


@protocol Isgl3dCamera <NSObject>
/**
 * The current view matrix.
 */
@property (nonatomic,assign,readonly) Isgl3dMatrix4 viewMatrix;
/**
 * The current projection matrix of the camera lens.
 */
@property (nonatomic,assign,readonly) Isgl3dMatrix4 projectionMatrix;
/**
 * The combined view and projection matrices.
 */
@property (nonatomic,assign,readonly) Isgl3dMatrix4 viewProjectionMatrix;
/**
 * The current camera lens of the receiver.
 */
@property (nonatomic,retain) id<Isgl3dCameraLens> lens;
/**
 * Eye position.
 */
@property (nonatomic,assign,readonly) Isgl3dVector3 eyePosition;
/**
 * Right vector.
 */
@property (nonatomic,assign,readonly) Isgl3dVector3 right;
/**
 * Up vector.
 */
@property (nonatomic,assign,readonly) Isgl3dVector3 up;
/**
 * Look at vector.
 */
@property (nonatomic,assign,readonly) Isgl3dVector3 lookAt;
@end


#pragma mark -
/**
 *
 */
@protocol Isgl3dTargetCamera <Isgl3dCamera,NSObject>
@property (nonatomic,assign,readonly) Isgl3dVector3 lookAtTarget;
@end


#pragma mark -
/**
 * The Isgl3dCamera is the principal form of camera used in iSGL3D. It behaves as a traditional camera and is 
 * used to provide a projection of the scene as viewed from an observer.
 */
@interface Isgl3dCamera : NSObject<Isgl3dCamera> {
@protected
    id<Isgl3dCameraLens> _lens;
    
	Isgl3dMatrix4 _viewMatrix;
    Isgl3dMatrix4 _inverseViewMatrix;
	Isgl3dMatrix4 _viewProjectionMatrix;
	BOOL _viewProjectionMatrixDirty;
}

@property (nonatomic,assign,readwrite) Isgl3dMatrix4 viewMatrix;
@property (nonatomic,assign,readonly) Isgl3dMatrix4 projectionMatrix;
@property (nonatomic,assign,readonly) Isgl3dMatrix4 viewProjectionMatrix;
@property (nonatomic,retain) id<Isgl3dCameraLens> lens;
@property (nonatomic,assign) Isgl3dVector3 eyePosition;
@property (nonatomic,assign,readonly) Isgl3dVector3 right;
@property (nonatomic,assign,readonly) Isgl3dVector3 up;
@property (nonatomic,assign,readonly) Isgl3dVector3 lookAt;

/**
 *
 */
+ (id)cameraWithLens:(id<Isgl3dCameraLens>)lens;

/**
 *
 */
+ (id)cameraWithPerspectiveProjection:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ;

/**
 *
 */
+ (id)cameraWithOrthographicProjection:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ;

/**
 * Initializes a new camera with the given camera lens.
 * Default initialisation of the camera: The camera is position at (0, 0, 10) looking directly towards the origin
 * with its y-axis parallel to the world-space y-axis.
 * @param lens The camera lens defining the projection matrix. An exception will be raised if this parameter is nil.
 */
- (id)initWithLens:(id<Isgl3dCameraLens>)lens;

/**
 * Initializes a new camera. A Isgl3dPerspectiveProjection lens for the orthographic will be automatically created and assigned to the receiver.
 * Default initialisation of the camera: The camera is position at (0, 0, 10) looking directly towards the origin
 * with its y-axis parallel to the world-space y-axis.
 * @param fovyRadians The angle of the vertical viewing area.
 * @param aspect The ratio between the horizontal and the vertical viewing area.
 * @param nearZ The near clipping distance. Must be positive.
 * @param farZ The far clipping distance. Must be positive and greater than the near distance.
 */
- (id)initWithPerspectiveProjection:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ;

/**
 * Initializes a new camera. A Isgl3dOrthographicProjection lens for the orthographic will be automatically created and assigned to the receiver.
 * Default initialisation of the camera: The camera is position at (0, 0, 10) looking directly towards the origin
 * with its y-axis parallel to the world-space y-axis.
 * @param left The left coordinate of the projection volume in eye coordinates.
 * @param right The right coordinate of the projection volume in eye coordinates.
 * @param bottom The bottom coordinate of the projection volume in eye coordinates.
 * @param top The top coordinate of the projection volume in eye coordinates.
 * @param nearZ The near coordinate of the projection volume in eye coordinates. Must be positive.
 * @param farZ The far coordinate of the projection volume in eye coordinates. Must be positive and greater than the near distance.
 */
- (id)initWithOrthographicProjection:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ;

@end
