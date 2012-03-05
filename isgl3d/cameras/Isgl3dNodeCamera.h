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

#import "Isgl3dNode.h"
#import "Isgl3dCamera.h"
#import "Isgl3dCameraLens.h"


@interface Isgl3dNodeCamera : Isgl3dNode<Isgl3dTargetCamera> {
@protected
    id<Isgl3dCameraLens> _lens;
    
	Isgl3dMatrix4 _viewMatrix;
    Isgl3dMatrix4 _inverseViewMatrix;
	Isgl3dMatrix4 _viewProjectionMatrix;
	BOOL _viewProjectionMatrixDirty;
}

@property (nonatomic,assign,readonly) Isgl3dMatrix4 viewMatrix;
@property (nonatomic,assign,readonly) Isgl3dMatrix4 projectionMatrix;
@property (nonatomic,assign,readonly) Isgl3dMatrix4 viewProjectionMatrix;
@property (nonatomic,retain) id<Isgl3dCameraLens> lens;
@property (nonatomic,assign,readonly) Isgl3dVector3 eyePosition;

@property (nonatomic) Isgl3dVector3 initialPosition;
@property (nonatomic) Isgl3dVector3 initialLookAtTarget;
@property (nonatomic,assign) Isgl3dVector3 lookAtTarget;
@property (nonatomic,assign) Isgl3dVector3 up;


/**
 *
 */
- (id)initWithLens:(id<Isgl3dCameraLens>)lens position:(Isgl3dVector3)position lookAtTarget:(Isgl3dVector3)lookAtTarget up:(Isgl3dVector3)up;

/**
 * Resets the camera position and look-at to their initial values.
 */
- (void)reset;

@end
