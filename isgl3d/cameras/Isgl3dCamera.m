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

#import "Isgl3dCamera.h"
#import "Isgl3dGLU.h"
#import "Isgl3dLog.h"
#import "Isgl3dMathUtils.h"


@interface Isgl3dCamera () {
@private
    BOOL _inverseViewMatrixDirty;
    BOOL _eyePositionDirty;
    Isgl3dVector3 _eyePosition;
}
@property (nonatomic,assign,readonly) Isgl3dMatrix4 inverseViewMatrix;
@end


#pragma mark -
#
@implementation Isgl3dCamera

@synthesize viewMatrix = _viewMatrix;
@synthesize viewProjectionMatrix = _viewProjectionMatrix;
@synthesize lens = _lens;


+ (id)cameraWithLens:(id<Isgl3dCameraLens>)lens {
    return [[[self alloc] initWithLens:lens] autorelease];
}

+ (id)cameraWithPerspectiveProjection:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ {
    return [[[self alloc] initWithPerspectiveProjection:fovyRadians aspect:aspect nearZ:nearZ farZ:farZ] autorelease];
}

+ (id)cameraWithOrthographicProjection:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ {
    return [[[self alloc] initWithOrthographicProjection:left right:right bottom:bottom top:top nearZ:nearZ farZ:farZ] autorelease];
}


#pragma mark -
#
- (id)init {
    [NSException raise:NSInvalidArgumentException format:@"camera must be initialized with a lens"];
    return nil;
}

- (id)initWithLens:(id<Isgl3dCameraLens>)lens {
    if (lens == nil)
        [NSException raise:NSInvalidArgumentException format:@"camera must be initialized with a lens"];

    if (self = [super init]) {
        self.viewMatrix = Isgl3dMatrix4Identity;
        
        self.lens = lens;
    }
    return self;
}

- (id)initWithPerspectiveProjection:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ {
    if (self = [super init]) {
        self.viewMatrix = Isgl3dMatrix4Identity;
        _inverseViewMatrix = Isgl3dMatrix4Identity;
        
        Isgl3dPerspectiveProjection *perspectiveProjection = [[Isgl3dPerspectiveProjection alloc] initWithFovyRadians:fovyRadians aspect:aspect nearZ:nearZ farZ:farZ];
        self.lens = perspectiveProjection;
        [perspectiveProjection release];
    }
    return self;
}

- (id)initWithOrthographicProjection:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ {
    if (self = [super init]) {
        self.viewMatrix = Isgl3dMatrix4Identity;
        _inverseViewMatrix = Isgl3dMatrix4Identity;

        Isgl3dOrthographicProjection *orthographicProjection = [[Isgl3dOrthographicProjection alloc] initWithLeft:left right:right bottom:bottom top:top nearZ:nearZ farZ:farZ];
        self.lens = orthographicProjection;
        [orthographicProjection release];
    }
    return self;
}

- (void)dealloc {
    [(NSObject<Isgl3dCameraLens> *)_lens removeObserver:self forKeyPath:kLensProjectionMatrixKey];
    [_lens release];
    _lens = nil;
    
    [super dealloc];
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
- (void)setViewMatrix:(Isgl3dMatrix4)viewMatrix {
    if ((viewMatrix.m03 != 0.0f) || (viewMatrix.m13 != 0.0f) || (viewMatrix.m23 != 0.0f) || (viewMatrix.m33 != 1.0f))
        [NSException raise:NSInvalidArgumentException format:@"invalid view matrix for camera"];
    
    _viewProjectionMatrixDirty = YES;
    _inverseViewMatrixDirty = YES;
    _eyePositionDirty = YES;
    
    _viewMatrix = viewMatrix;
}

- (Isgl3dMatrix4)inverseViewMatrix {
    if (_inverseViewMatrixDirty) {
        _inverseViewMatrix = Isgl3dMatrix4Invert(_viewMatrix, NULL);
        _inverseViewMatrixDirty = NO;
    }
    return _inverseViewMatrix;
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

- (Isgl3dVector3)eyePosition {
    // check if the eye position needs to be recalculated
    if (_eyePositionDirty) {
        // get the eye position from the inverse view matrix
        Isgl3dMatrix4 inverseViewMatrix = self.inverseViewMatrix;
        _eyePosition = Isgl3dVector3Make(inverseViewMatrix.m30, inverseViewMatrix.m31, inverseViewMatrix.m32);
    }
    return _eyePosition;
}

- (void)setEyePosition:(Isgl3dVector3)eyePosition {
    _eyePosition = eyePosition;

    Isgl3dVector3 lookAtVector = self.lookAt;
    Isgl3dVector3 upVector = self.up;
    _viewMatrix = Isgl3dMatrix4MakeLookAt(_eyePosition.x, _eyePosition.y, _eyePosition.z,
                                          lookAtVector.x, lookAtVector.y, lookAtVector.z,
                                          upVector.x, upVector.y, upVector.z);
    
    _eyePositionDirty = NO;
    _inverseViewMatrixDirty = YES;
    _viewProjectionMatrixDirty = YES;
}

- (Isgl3dVector3)right {
    return Isgl3dVector3Make(_viewMatrix.m00, _viewMatrix.m10, _viewMatrix.m20);
}

- (Isgl3dVector3)up {
    return Isgl3dVector3Make(_viewMatrix.m01, _viewMatrix.m11, _viewMatrix.m21);
}

- (Isgl3dVector3)lookAt {
    return Isgl3dVector3Make(_viewMatrix.m02, _viewMatrix.m12, _viewMatrix.m22);
}

@end
