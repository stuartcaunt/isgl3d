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

#import "Isgl3dGLVBOData.h"


@implementation Isgl3dGLVBOData

@synthesize vboIndex = _vboIndex; 
@synthesize stride = _stride; 
@synthesize positionOffset = _positionOffset; 
@synthesize normalOffset = _normalOffset; 
@synthesize uvOffset = _uvOffset; 
@synthesize colorOffset = _colorOffset; 
@synthesize sizeOffset = _sizeOffset; 
@synthesize boneIndexOffset = _boneIndexOffset; 
@synthesize boneWeightOffset = _boneWeightOffset; 
@synthesize boneIndexSize = _boneIndexSize; 
@synthesize boneWeightSize = _boneWeightSize; 

- (id) init {
	
	if ((self = [super init])) {
		_vboIndex = 0;
		
		_positionOffset = -1;
		_normalOffset = -1;
		_uvOffset = -1;
		_colorOffset = -1;
		_sizeOffset = -1;
		
		_boneIndexOffset = -1;
		_boneWeightOffset = -1;
		_boneIndexSize = 1;
		_boneWeightSize = 1;
	}
	
	return self;
}


- (void) dealloc {
	
	[super dealloc];
}

@end
