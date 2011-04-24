/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2011 Stuart Caunt
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

#import "Isgl3dBillboardNode.h"
#import "Isgl3dDirector.h"
#import "Isgl3dCamera.h"

@implementation Isgl3dBillboardNode

- (void) updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {
	// Modify rotation to face camera : use inverted view matrix
	Isgl3dCamera * camera = [Isgl3dDirector sharedInstance].activeCamera;
	Isgl3dMatrix4 viewMatrix = camera.viewMatrix;
	im4Invert3x3(&viewMatrix);
	
	_localTransformation.sxx = viewMatrix.sxx * _scaleX;
	_localTransformation.sxy = viewMatrix.sxy * _scaleX;
	_localTransformation.sxz = viewMatrix.sxz * _scaleX;
	_localTransformation.syx = viewMatrix.syx * _scaleY;
	_localTransformation.syy = viewMatrix.syy * _scaleY;
	_localTransformation.syz = viewMatrix.syz * _scaleY;
	_localTransformation.szx = viewMatrix.szx * _scaleZ;
	_localTransformation.szy = viewMatrix.szy * _scaleZ;
	_localTransformation.szz = viewMatrix.szz * _scaleZ;

	_localTransformationDirty = YES;
	_rotationMatrixDirty = NO;
	_eulerAnglesDirty = YES;
	
	[super updateWorldTransformation:parentTransformation];
}

@end
