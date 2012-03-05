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

#import "Isgl3dCamera.h"
#import "Isgl3dNode.h"
#import "Isgl3dVector3.h"


/**
 * Isgl3dLookAtCamera
 */
@interface Isgl3dLookAtCamera : Isgl3dCamera<Isgl3dTargetCamera> {
}

/**
 *
 */
@property (nonatomic,assign,readonly) Isgl3dVector3 up;
/**
 *
 */
@property (nonatomic,assign) Isgl3dVector3 centerPosition;
/**
 *
 */
@property (nonatomic,assign,readonly) Isgl3dVector3 lookAtTarget;
/**
 * The initial position of the camera as defined during its initialisation or set afterwards.
 * A call to reset on the camera will place the camera at this position.
 */
@property (nonatomic) Isgl3dVector3 initialEyePosition;
/**
 * The initial look-at position of the camera as defined during its initialistion or set afterwards. 
 * A call to reset on the camera will make the camera look-at this position.
 */
@property (nonatomic) Isgl3dVector3 initialCenterPosition;

/**
 *
 */
- (id)initWithLens:(id<Isgl3dCameraLens>)lens eyeX:(float)eyeX eyeY:(float)eyeY eyeZ:(float)eyeZ centerX:(float)centerX centerY:(float)centerY centerZ:(float)centerZ upX:(float)upX upY:(float)upY upZ:(float)upZ;

/**
 *
 */
- (void)updateEyeX:(float)eyeX eyeY:(float)eyeY eyeZ:(float)eyeZ centerX:(float)centerX centerY:(float)centerY centerZ:(float)centerZ upX:(float)upX upY:(float)upY upZ:(float)upZ;

/**
 * Resets the camera position and look-at to their initial values.
 */
- (void)reset;


@end
