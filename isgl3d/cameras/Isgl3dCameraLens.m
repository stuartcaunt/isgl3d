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

#import "Isgl3dCameraLens.h"
#import "Isgl3dMathUtils.h"


@interface Isgl3dPerspectiveProjection () {
@private
    Isgl3dMatrix4 _projectionMatrix;
    
    float _fovyRadians;
    float _aspect;
    float _nearZ;
    float _farZ;

    float _zoom;
}
@end


@interface Isgl3dOrthographicProjection () {
@private
    Isgl3dMatrix4 _projectionMatrix;
    
    float _left;
    float _right;
    float _bottom;
    float _top;
    float _nearZ;
    float _farZ;
    
    float _zoom;
}
@end


#pragma mark -
#
@implementation Isgl3dPerspectiveProjection

@synthesize projectionMatrix = _projectionMatrix;
@synthesize fovyRadians = _fovyRadians;
@synthesize nearZ = _nearZ;
@synthesize farZ = _farZ;
@synthesize aspect = _aspect;
@synthesize zoom = _zoom;


+ (id)createWithFovyDegrees:(float)fovyDegrees aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ {
    return [[[self alloc] initWithFovyRadians:Isgl3dMathDegreesToRadians(fovyDegrees) aspect:aspect nearZ:nearZ farZ:farZ] autorelease];
}

+ (id)createWithFovyRadians:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ {
    return [[[self alloc] initWithFovyRadians:fovyRadians aspect:aspect nearZ:nearZ farZ:farZ] autorelease];
}

+ (id)createFromViewSize:(CGSize)viewSize withFovyDegrees:(float)fovyDegrees nearZ:(float)nearZ farZ:(float)farZ {
    return [[[self alloc] initFromViewSize:viewSize fovyRadians:Isgl3dMathDegreesToRadians(fovyDegrees) nearZ:nearZ farZ:farZ] autorelease];
}

+ (id)createFromViewSize:(CGSize)viewSize withFovyRadians:(float)fovyRadians nearZ:(float)nearZ farZ:(float)farZ {
    return [[[self alloc] initFromViewSize:viewSize fovyRadians:fovyRadians nearZ:nearZ farZ:farZ] autorelease];
}


#pragma mark -
#
- (id)initWithFovyDegrees:(float)fovyDegrees aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ {
    return [self initWithFovyRadians:Isgl3dMathDegreesToRadians(fovyDegrees) aspect:aspect nearZ:nearZ farZ:farZ];
}

- (id)initWithFovyRadians:(float)fovyRadians aspect:(float)aspect nearZ:(float)nearZ farZ:(float)farZ {
    if (self = [super init]) {
        _zoom = 1.0f;
        
        _fovyRadians = fovyRadians;
        _aspect = aspect;
        _nearZ = nearZ;
        _farZ = farZ;
        
        _projectionMatrix = Isgl3dMatrix4MakePerspective(_fovyRadians * _zoom, _aspect, _nearZ, _farZ);
    }
    return self;
}

- (id)initFromViewSize:(CGSize)size fovyDegrees:(float)fovyDegrees nearZ:(float)nearZ farZ:(float)farZ {
    return [self initFromViewSize:size fovyRadians:Isgl3dMathDegreesToRadians(fovyDegrees) nearZ:nearZ farZ:farZ];
}

- (id)initFromViewSize:(CGSize)size fovyRadians:(float)fovyRadians nearZ:(float)nearZ farZ:(float)farZ {
    
    float aspect = size.width / size.height;
    return [self initWithFovyRadians:fovyRadians aspect:aspect nearZ:nearZ farZ:farZ];
}

- (void)dealloc {
    [super dealloc];
}

- (void)setAspect:(float)aspect
{
    if (aspect != _aspect)
    {
        _aspect = aspect;
        
        [self willChangeValueForKey:kLensProjectionMatrixKey];

        // update the projection matrix
        float cotan = 1.0f / tanf(_fovyRadians * _zoom / 2.0f);
        _projectionMatrix.m00 = cotan / aspect;
        //_projectionMatrix = Isgl3dMatrix4MakePerspective(_fovyRadians*_zoom, _aspect, _nearZ, _farZ);
        
        [self didChangeValueForKey:kLensProjectionMatrixKey];
    }
}

- (void)setZoom:(float)zoom {
    if (_zoom != zoom) {
        _zoom = zoom;
        
        [self willChangeValueForKey:kLensProjectionMatrixKey];
        
        _projectionMatrix = Isgl3dMatrix4MakePerspective(_fovyRadians*_zoom, _aspect, _nearZ, _farZ);
        
        [self didChangeValueForKey:kLensProjectionMatrixKey];
    }
}

- (void)viewSizeUpdated:(CGSize)viewSize {
    self.aspect = viewSize.width / viewSize.height;
}

@end


#pragma mark -
#
@implementation Isgl3dOrthographicProjection

@synthesize projectionMatrix = _projectionMatrix;
@synthesize left = _left;
@synthesize right = _right;
@synthesize bottom = _bottom;
@synthesize top = _top;
@synthesize nearZ = _nearZ;
@synthesize farZ = _farZ;
@synthesize zoom = _zoom;


+ (id)createWithLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ {
    return [[[self alloc] initWithLeft:left right:right bottom:bottom top:top nearZ:nearZ farZ:farZ] autorelease];
}


#pragma mark -
#
- (id)initWithLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ {
    if (self = [super init]) {
        _zoom = 1.0f;

        _left = left;
        _right = right;
        _bottom = bottom;
        _top = top;
        _nearZ = nearZ;
        _farZ = farZ;
        
        _projectionMatrix = Isgl3dMatrix4MakeOrtho(_left, _right, _bottom, _top, _nearZ, _farZ);
    }
    return self;
}

- (id)initFromViewSize:(CGSize)size nearZ:(float)nearZ farZ:(float)farZ {
    if (self = [super init]) {
        _zoom = 1.0f;

        _left = 0.0f;
        _right = size.width;
        _bottom = 0.0f;
        _top = size.height;
        _nearZ = nearZ;
        _farZ = farZ;
        
        _projectionMatrix = Isgl3dMatrix4MakeOrtho(_left, _right, _bottom, _top, _nearZ, _farZ);
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)updateWithLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top nearZ:(float)nearZ farZ:(float)farZ {
    _left = left;
    _right = right;
    _bottom = bottom;
    _top = top;
    _nearZ = nearZ;
    _farZ = farZ;
    
    [self willChangeValueForKey:kLensProjectionMatrixKey];
    
    _projectionMatrix = Isgl3dMatrix4MakeOrtho(_left*_zoom, _right*_zoom, _bottom*_zoom, _top*_zoom,
                                               _nearZ, _farZ);
    
    [self didChangeValueForKey:kLensProjectionMatrixKey];
}

- (void)setZoom:(float)zoom {
    if (_zoom != zoom) {
        _zoom = zoom;
        
        [self willChangeValueForKey:kLensProjectionMatrixKey];
        
        _projectionMatrix = Isgl3dMatrix4MakeOrtho(_left*_zoom, _right*_zoom, _bottom*_zoom, _top*_zoom,
                                                   _nearZ, _farZ);
        
        [self didChangeValueForKey:kLensProjectionMatrixKey];
    }
}

- (void)viewSizeUpdated:(CGSize)viewSize {
    [self updateWithLeft:_left right:(_left+viewSize.width) bottom:0.0f top:(_bottom+viewSize.height) nearZ:_nearZ farZ:_farZ];
}

@end
