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


@interface Isgl3dFocusZoomPerspectiveLens : NSObject <Isgl3dCameraLens> {
    
}
@property (nonatomic,assign,readonly) float nearZ;
@property (nonatomic,assign,readonly) float farZ;
@property (nonatomic,assign) float zoom;
@property (nonatomic,assign,readonly) Isgl3dMatrix4 projectionMatrix;
@property (nonatomic,assign,readonly) float fovyRadians;
@property (nonatomic,assign,readonly) float aspect;
@property (nonatomic,assign) float focus;


- (id)initFromViewSize:(CGSize)viewSize fovyDegrees:(float)fovyDegrees nearZ:(float)nearZ farZ:(float)farZ;
- (id)initFromViewSize:(CGSize)viewSize fovyRadians:(float)fovyRadians nearZ:(float)nearZ farZ:(float)farZ;

- (void)viewSizeUpdated:(CGSize)viewSize;

@end
