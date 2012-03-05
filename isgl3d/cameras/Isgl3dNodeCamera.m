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

#import "Isgl3dNodeCamera.h"


static NSString *kLensProjectionMatrix = @"projectionMatrix";


@interface Isgl3dNodeCamera () {
@private
    Isgl3dVector3 _lookAtTarget;
    Isgl3dVector3 _up;

	Isgl3dVector3 _initialPosition;
	Isgl3dVector3 _initialLookAtTarget;
}
@end


#pragma mark -
#
@implementation Isgl3dNodeCamera

@synthesize viewMatrix = _viewMatrix;
@synthesize viewProjectionMatrix = _viewProjectionMatrix;
@synthesize lens = _lens;
@synthesize initialPosition = _initialPosition;
@synthesize initialLookAtTarget = _initialLookAtTarget;
@synthesize lookAtTarget = _lookAtTarget;
@synthesize up = _up;


- (id)initWithLens:(id<Isgl3dCameraLens>)lens position:(Isgl3dVector3)position lookAtTarget:(Isgl3dVector3)lookAtTarget up:(Isgl3dVector3)up {
    
    if (lens == nil)
        [NSException raise:NSInvalidArgumentException format:@"camera must be initialized with a lens"];
    
    if (self = [super init]) {
        _viewMatrix = Isgl3dMatrix4Identity;
        _viewProjectionMatrix = Isgl3dMatrix4Identity;
        _viewProjectionMatrixDirty = NO;

        self.lens = lens;
        
        self.position = position;
        _initialPosition = position;
        _initialLookAtTarget = lookAtTarget;
        
        _lookAtTarget = lookAtTarget;
        _up = up;
    }
    return self;
}

- (void)dealloc {
    [(NSObject<Isgl3dCameraLens> *)_lens removeObserver:self forKeyPath:kLensProjectionMatrix];
    [_lens release];
    _lens = nil;
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	Isgl3dNodeCamera *copy = [super copyWithZone:zone];
    
    // TODO: copy or retain?
    copy.lens = self.lens;
    
    return copy;
}


- (void)updateViewMatrix {
    Isgl3dVector3 eyePosition = [self worldPosition];    
    _viewMatrix = Isgl3dMatrix4MakeLookAt(eyePosition.x, eyePosition.y, eyePosition.z,
                                          _lookAtTarget.x, _lookAtTarget.y, _lookAtTarget.z,
                                          _up.x, _up.y, _up.z);
    _viewProjectionMatrixDirty = YES;
}

- (void)reset {
    self.position = _initialPosition;
    _lookAtTarget = _initialLookAtTarget;
    [self updateViewMatrix];
}


#pragma mark - Key-value-observing
#
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.lens) {
        if ([keyPath isEqualToString:kLensProjectionMatrixKey]) {
            _viewProjectionMatrixDirty = YES;
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


#pragma mark -
#
- (Isgl3dMatrix4)viewMatrix {

	BOOL viewMatrixDirty = (_localTransformationDirty || _transformationDirty);
    
	if (viewMatrixDirty) {
        Isgl3dMatrix4 identity = Isgl3dMatrix4Identity;
        [super updateWorldTransformation:&identity];

		[self updateViewMatrix];
	}
    return _viewMatrix;
}

- (void)setLens:(id<Isgl3dCameraLens>)lens {
    if (lens == nil)
        [NSException raise:NSInvalidArgumentException format:@"lens of camera must not be nil"];
    
    if (lens != _lens) {
        if (_lens != nil) {
            [(NSObject<Isgl3dCameraLens> *)_lens removeObserver:self forKeyPath:kLensProjectionMatrixKey];
        }
        
        [_lens release];
        _lens = [lens retain];
        
        if (_lens != nil) {
            [(NSObject<Isgl3dCameraLens> *)_lens addObserver:self forKeyPath:kLensProjectionMatrixKey options:0 context:nil];
        }
    }
}

- (Isgl3dMatrix4)projectionMatrix {
    return self.lens.projectionMatrix;
}

- (Isgl3dMatrix4)viewProjectionMatrix {
    if (_viewProjectionMatrixDirty) {
        _viewProjectionMatrix = Isgl3dMatrix4Multiply(self.lens.projectionMatrix, _viewMatrix);
        _viewProjectionMatrixDirty = NO;
    }
    return _viewProjectionMatrix;
}

- (void)setLookAtTarget:(Isgl3dVector3)lookAtTarget {
    _lookAtTarget = lookAtTarget;
    _localTransformationDirty = YES;
}

- (Isgl3dVector3)eyePosition {
	Isgl3dVector3 position = [self worldPosition];
    return position;
}

- (Isgl3dVector3)right {
    Isgl3dMatrix4 viewMatrix = self.viewMatrix;
    return Isgl3dVector3Make(viewMatrix.m00, viewMatrix.m10, viewMatrix.m20);
}

- (Isgl3dVector3)up {
    Isgl3dMatrix4 viewMatrix = self.viewMatrix;
    return Isgl3dVector3Make(viewMatrix.m01, viewMatrix.m11, viewMatrix.m21);
}

- (void)setUp:(Isgl3dVector3)up {
    _up = up;
    _localTransformationDirty = YES;
}

- (Isgl3dVector3)lookAt {
    Isgl3dMatrix4 viewMatrix = self.viewMatrix;
    return Isgl3dVector3Make(viewMatrix.m02, viewMatrix.m12, viewMatrix.m22);
}


#pragma mark -
#
- (void)updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {
    
	BOOL viewMatrixDirty = (_localTransformationDirty || _transformationDirty);
	[super updateWorldTransformation:parentTransformation];
    
	if (viewMatrixDirty) {
		[self updateViewMatrix];
	}
}

@end
