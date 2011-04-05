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

#import "Isgl3dArray.h"

@implementation Isgl3dArray

- (id) initForSizeType:(size_t)sizeType {
	if ((self = [super init])) {
		_cArray = iaCreateForTypeSize(sizeType);
	}
	return self;
}

- (id) initForSizeType:(size_t)sizeType withCapacity:(unsigned int)capacity {
	if ((self = [super init])) {
		_cArray = iaCreateForTypeSizeWithCapacity(sizeType, capacity);
	}
	return self;
}

- (id) initForSizeType:(size_t)sizeType withArray:(void *)array count:(unsigned int)count {
	if ((self = [super init])) {
		_cArray = iaCreateForTypeSizeWithArray(sizeType, array, count);
	}
	return self;
}

- (void) dealloc {
	ICA_DELETE(_cArray);
	
	[super dealloc];
}

- (void) add:(const void *)value {
	iaAdd(_cArray, value);
}

- (unsigned char *) get:(unsigned int)index {
	return iaGet(_cArray, index);
}

- (void) clear {
	iaClear(_cArray);
}

- (unsigned char *) array {
	return _cArray->array;
}

- (unsigned int) count {
	return _cArray->count;
}

@end
