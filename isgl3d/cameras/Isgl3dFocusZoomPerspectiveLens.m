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

#import "Isgl3dFocusZoomPerspectiveLens.h"
#import "Isgl3dMathUtils.h"


static inline Isgl3dMatrix4 Isgl3dMatrix4MakePerspectiveWithZoom(float fovyRadians, float aspect, float nearZ, float farZ, float zoom)
{
	float top = tanf(fovyRadians / 2.0f) * nearZ / zoom;
	float bottom = -top;
	float left = aspect * bottom;
	float right = aspect * top;
    
	float A = (right + left) / (right - left);
	float B = (top + bottom) / (top - bottom);
	float C = (farZ + nearZ) / (nearZ - farZ);
	float D = (2.0f * farZ * nearZ) / (nearZ - farZ);
    
    Isgl3dMatrix4 m = { (2.0f * nearZ) / (right - left), 0.0f,                           0.0f,  0.0f,
                        0.0f,                            2.0f * nearZ / (top - bottom),  0.0f,  0.0f,
                        A,                               B,                              C,    -1.0f,
                        0.0f,                            0.0f,                           D,     0.0f };
    
    return m;
}


@interface Isgl3dFocusZoomPerspectiveLens () {
@private
    Isgl3dMatrix4 _projectionMatrix;
    
    CGSize _viewSize;
    
    float _fovyRadians;
    float _aspect;
    float _nearZ;
    float _farZ;
    
    float _focus;
    float _zoom;
}
@property (nonatomic,assign,readwrite) float fovyRadians;
@end


#pragma mark -
@implementation Isgl3dFocusZoomPerspectiveLens

@synthesize projectionMatrix = _projectionMatrix;
@synthesize fovyRadians = _fovyRadians;
@synthesize nearZ = _nearZ;
@synthesize farZ = _farZ;
@synthesize aspect = _aspect;
@synthesize focus = _focus;
@synthesize zoom = _zoom;


- (id)initFromViewSize:(CGSize)viewSize fovyDegrees:(float)fovyDegrees nearZ:(float)nearZ farZ:(float)farZ {
    return [self initFromViewSize:viewSize fovyRadians:Isgl3dMathDegreesToRadians(fovyDegrees) nearZ:nearZ farZ:farZ];
}

- (id)initFromViewSize:(CGSize)viewSize fovyRadians:(float)fovyRadians nearZ:(float)nearZ farZ:(float)farZ {
    if ((viewSize.width == 0.0f) && (viewSize.height == 0.0f))
        [NSException raise:NSInvalidArgumentException format:@"invalid view size specified for camera lens"];
    
    if (self = [super init]) {
        _zoom = 1.0f;

        _nearZ = nearZ;
        _farZ = farZ;
        _fovyRadians = fovyRadians;

        _viewSize = viewSize;
        _aspect = _viewSize.width / _viewSize.height;
        
        _focus = 0.5f * _viewSize.height / (_zoom * tan(_fovyRadians / 2.0f));
        _projectionMatrix = Isgl3dMatrix4MakePerspectiveWithZoom(_fovyRadians, _aspect, _nearZ, _farZ, _zoom);
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewSizeUpdated:(CGSize)viewSize {
    _viewSize = viewSize;
    _aspect = _viewSize.width / _viewSize.height;
    self.fovyRadians = 2.0f * atan2(_viewSize.height, 2.0f * _zoom * _focus);
}


- (void)updatePerspectiveProjection {
    [self willChangeValueForKey:kLensProjectionMatrixKey];
    
    _projectionMatrix = Isgl3dMatrix4MakePerspectiveWithZoom(_fovyRadians, _aspect, _nearZ, _farZ, _zoom);
    
    [self didChangeValueForKey:kLensProjectionMatrixKey];
}


#pragma mark -
#
- (void)setFovyRadians:(float)fovyRadians {
    if (_fovyRadians != fovyRadians) {
        _fovyRadians = fovyRadians;

        [self updatePerspectiveProjection];
    }
}

- (void)setFocus:(float)focus {
	if (_focus != focus) {
		_focus = focus;
        self.fovyRadians = 2.0f * atan2(_viewSize.height, 2.0f * _zoom * _focus);
	}	
}

- (void)setZoom:(float)zoom {
	if (zoom != _zoom) {
		_zoom = zoom;
        self.fovyRadians = 2.0f * atan2(_viewSize.height, 2.0f * _zoom * _focus);
	}
}

@end
