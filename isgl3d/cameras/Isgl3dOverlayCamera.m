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

#import "Isgl3dOverlayCamera.h"


@interface Isgl3dOverlayCamera () {
@private
    CGRect _viewport;    
}
@end


#pragma mark -
@implementation Isgl3dOverlayCamera

@synthesize viewport = _viewport;


- (id)initWithViewport:(CGRect)viewport eyeX:(float)eyeX eyeY:(float)eyeY eyeZ:(float)eyeZ centerX:(float)centerX centerY:(float)centerY centerZ:(float)centerZ upX:(float)upX upY:(float)upY upZ:(float)upZ {
    
    _viewport = viewport;
    Isgl3dOrthographicProjection *orthographicLens = [[Isgl3dOrthographicProjection alloc] initFromViewSize:viewport.size nearZ:1.0f farZ:1000.0f];
    
    if (orthographicLens == nil) {
        self = nil;
        return nil;
    }
    
    if (self = [super initWithLens:orthographicLens
                              eyeX:eyeX eyeY:eyeY eyeZ:eyeZ
                           centerX:centerX centerY:centerY centerZ:centerZ
                               upX:upX upY:upY upZ:upZ]) {
    }
    [orthographicLens release];
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}


#pragma mark -
- (void)setViewport:(CGRect)viewport {
    _viewport = viewport;
    
    [self.lens viewSizeUpdated:_viewport.size];
}

@end
