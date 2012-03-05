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

#import "Isgl3dBillboardNode.h"
#import "Isgl3dDirector.h"
#import "Isgl3dCamera.h"
#import "Isgl3dMatrix4.h"


@implementation Isgl3dBillboardNode

- (void)updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {

	// Update world transformation, including all children as normal	
	[super updateWorldTransformation:parentTransformation];

	// Modify the final world transformation so that the rotation
	// faces the camera : use inverted view matrix
	Isgl3dCamera * camera = [Isgl3dDirector sharedInstance].activeCamera;
	Isgl3dMatrix4 viewMatrix = camera.viewMatrix;
    viewMatrix = Isgl3dMatrix4Invert(viewMatrix, NULL);
	
	_worldTransformation.m00 = viewMatrix.m00 * _scaleX;
	_worldTransformation.m10 = viewMatrix.m10 * _scaleX;
	_worldTransformation.m20 = viewMatrix.m20 * _scaleX;
	_worldTransformation.m01 = viewMatrix.m01 * _scaleY;
	_worldTransformation.m11 = viewMatrix.m11 * _scaleY;
	_worldTransformation.m21 = viewMatrix.m21 * _scaleY;
	_worldTransformation.m02 = viewMatrix.m02 * _scaleZ;
	_worldTransformation.m12 = viewMatrix.m12 * _scaleZ;
	_worldTransformation.m22 = viewMatrix.m22 * _scaleZ;
}

@end
