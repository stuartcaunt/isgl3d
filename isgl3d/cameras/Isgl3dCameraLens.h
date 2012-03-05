/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2012 Holger Wiedemann
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
#import "Isgl3dMatrix4.h"


static NSString *kLensProjectionMatrixKey = @"projectionMatrix";


/**
 * Isgl3dCameraLens protocol
 */
@protocol Isgl3dCameraLens <NSObject>
/**
 * The near value of the camera.
 * Objects closer than this value will not be rendered.
 */
@property (nonatomic,assign,readonly) float nearZ;
/**
 * The far value of the camera.
 * Objects further than this value will not be rendered.
 */
@property (nonatomic,assign,readonly) float farZ;
/**
 * The zoom of the camera (in perspective mode).
 * This represents the amount of zooming of the camera so that objects appear closer or further away.
 */
@property (nonatomic,assign) float zoom;
/**
 *
 */
@property (nonatomic,assign,readonly) Isgl3dMatrix4 projectionMatrix;
/**
 *
 */
- (void)viewSizeUpdated:(CGSize)viewSize;
@end


#pragma mark -
#
/**
 * Isgl3dPerspectiveProjection class for a perspective projection camera lens
 */
@interface Isgl3dPerspectiveProjection : NSObject <Isgl3dCameraLens>

@property (nonatomic,assign,readonly) float nearZ;
@property (nonatomic,assign,readonly) float farZ;
@property (nonatomic,assign) float zoom;
@property (nonatomic,assign,readonly) Isgl3dMatrix4 projectionMatrix;
@property (nonatomic,assign,readonly) float fovyRadians;
/**
 * The aspect ratio of the camera (in perspective mode).
 * This defines the ratio between the maximum horizontal angle and the maximum vertical angle.
 */
@property (nonatomic,assign,readwrite) float aspect;

+ (id)createWithFovyDegrees:(float)fovyDegrees aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ;
+ (id)createWithFovyRadians:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ;
+ (id)createFromViewSize:(CGSize)viewSize withFovyDegrees:(float)fovyDegrees nearZ:(float)nearZ farZ:(float)farZ;
+ (id)createFromViewSize:(CGSize)viewSize withFovyRadians:(float)fovyRadians nearZ:(float)nearZ farZ:(float)farZ;

/**
 * Initializes a new perspective projection camera lens.
 * @param fovyRadians The angle (in degrees) of the vertical viewing area.
 * @param aspect The ratio between the horizontal and the vertical viewing area.
 * @param nearZ The near clipping distance. Must be positive.
 * @param farZ The far clipping distance. Must be positive and greater than the near distance.
 */
- (id)initWithFovyDegrees:(float)fovyDegrees aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ;

/**
 * Initializes a new perspective projection camera lens.
 * @param fovyRadians The angle (in radians) of the vertical viewing area.
 * @param aspect The ratio between the horizontal and the vertical viewing area.
 * @param nearZ The near clipping distance. Must be positive.
 * @param farZ The far clipping distance. Must be positive and greater than the near distance.
 */
- (id)initWithFovyRadians:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ;

/**
 *
 */
- (id)initFromViewSize:(CGSize)size fovyDegrees:(float)fovyDegrees nearZ:(float)nearZ farZ:(float)farZ;

/**
 *
 */
- (id)initFromViewSize:(CGSize)size fovyRadians:(float)fovyRadians nearZ:(float)nearZ farZ:(float)farZ;

/**
 *
 */
- (void)viewSizeUpdated:(CGSize)viewSize;

@end


#pragma mark -
#
/**
 * Isgl3dOrthographicProjection class for orthographic projection camera lens
 */
@interface Isgl3dOrthographicProjection : NSObject <Isgl3dCameraLens>

@property (nonatomic,assign,readonly) float nearZ;
@property (nonatomic,assign,readonly) float farZ;
@property (nonatomic,assign) float zoom;
@property (nonatomic,assign,readonly) Isgl3dMatrix4 projectionMatrix;
/**
 * The left value of the camera (in orthographic mode).
 * Objects further to the left (along the x-axis) than this value will not be rendered.
 */
@property (nonatomic,assign,readonly) float left;
/**
 * The right value of the camera (in orthographic mode).
 * Objects further to the right (along the x-axis) than this value will not be rendered.
 */
@property (nonatomic,assign,readonly) float right;
/**
 * The bottom value of the camera (in orthographic mode).
 * Objects below this (along the y-axis) than this value will not be rendered.
 */
@property (nonatomic,assign,readonly) float bottom;
/**
 * The top value of the camera (in orthographic mode).
 * Objects above this (along the y-axis) than this value will not be rendered.
 */
@property (nonatomic,assign,readonly) float top;

/**
 *
 */
+ (id)createWithLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ;

/**
 * Initializes a new orthographic projection camera lens.
 * @param left The left coordinate of the projection volume in eye coordinates.
 * @param right The right coordinate of the projection volume in eye coordinates.
 * @param bottom The bottom coordinate of the projection volume in eye coordinates.
 * @param top The top coordinate of the projection volume in eye coordinates.
 * @param nearZ The near coordinate of the projection volume in eye coordinates. Must be positive.
 * @param farZ The far coordinate of the projection volume in eye coordinates. Must be positive and greater than the near distance.
 */
- (id)initWithLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ;

/**
 *
 */
- (id)initFromViewSize:(CGSize)size nearZ:(float)nearZ farZ:(float)farZ;

/**
 *
 */
- (void)updateWithLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ;

/**
 *
 */
- (void)viewSizeUpdated:(CGSize)viewSize;

@end
