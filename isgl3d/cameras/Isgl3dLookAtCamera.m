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

#import "Isgl3dLookAtCamera.h"
#import "Isgl3dMatrix4.h"


@interface Isgl3dLookAtCamera (){
@private
    Isgl3dVector3 _eyePosition;
    Isgl3dVector3 _centerPosition;
    Isgl3dVector3 _up;
    
	Isgl3dVector3 _initialEyePosition;
	Isgl3dVector3 _initialCenterPosition;
}
- (void)updateViewMatrix;
@end


#pragma mark -
#
@implementation Isgl3dLookAtCamera

@synthesize eyePosition = _eyePosition;
@synthesize centerPosition = _centerPosition;
@synthesize up = _up;
@synthesize initialEyePosition = _initialEyePosition;
@synthesize initialCenterPosition = _initialCenterPosition;


- (id)initWithLens:(id<Isgl3dCameraLens>)lens eyeX:(float)eyeX eyeY:(float)eyeY eyeZ:(float)eyeZ centerX:(float)centerX centerY:(float)centerY centerZ:(float)centerZ upX:(float)upX upY:(float)upY upZ:(float)upZ {
    
    if (self = [super initWithLens:lens]) {
        _initialEyePosition = Isgl3dVector3Make(eyeX, eyeY, eyeZ);
        _initialCenterPosition = Isgl3dVector3Make(centerX, centerY, centerZ);
        
        _eyePosition = _initialEyePosition;
        _centerPosition = _initialCenterPosition;
        _up = Isgl3dVector3Make(upX, upY, upZ);
        
        [self updateViewMatrix];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)updateEyeX:(float)eyeX eyeY:(float)eyeY eyeZ:(float)eyeZ centerX:(float)centerX centerY:(float)centerY centerZ:(float)centerZ upX:(float)upX upY:(float)upY upZ:(float)upZ {
    
    _eyePosition = Isgl3dVector3Make(eyeX, eyeY, eyeZ);
    _centerPosition = Isgl3dVector3Make(centerX, centerY, centerZ);
    _up = Isgl3dVector3Make(upX, upY, upZ);
    
    [self updateViewMatrix];
}

- (void)updateViewMatrix {
    _viewMatrix = Isgl3dMatrix4MakeLookAt(_eyePosition.x, _eyePosition.y, _eyePosition.z,
                                          _centerPosition.x, _centerPosition.y, _centerPosition.z,
                                          _up.x, _up.y, _up.z);
}

- (void)reset {
    _eyePosition = _initialEyePosition;
    _centerPosition = _initialCenterPosition;
    [self updateViewMatrix];
}


#pragma mark -
#
- (void)setEyePosition:(Isgl3dVector3)eyePosition {
    _eyePosition = eyePosition;
    [self updateViewMatrix];
}

- (void)setCenterPosition:(Isgl3dVector3)centerPosition {
    _centerPosition = centerPosition;
    [self updateViewMatrix];
}

- (void)setUp:(Isgl3dVector3)up {
    _up = up;
    [self updateViewMatrix];
}

- (Isgl3dVector3)lookAtTarget {
    return _centerPosition;
}

@end
