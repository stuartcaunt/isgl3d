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

#import "Isgl3dFloatArray.h"
#import "Isgl3dLog.h"

@interface Isgl3dFloatArray (PrivateMethods)
- (void)resize;
@end

@implementation Isgl3dFloatArray

- (id) init {    
    if ((self = [super init])) {
		_array = (float *)malloc(sizeof(float));
    	_arraySize = 1;
    	_size = 0;
    }
	
    return self;
}

- (id) initWithSize:(unsigned int)size {    
    if ((self = [super init])) {
    	
    	// Convert to power of 2 number
    	unsigned int arraySize = pow(2, ceil(log2(size)));
		_array = (float *)malloc(arraySize * sizeof(float));
    	_arraySize = arraySize;
    	
    	_size = 0;
    }
	
    return self;
}

- (id)initWithStdArray:(int)count array:(float*)array {
	if ([self init]) {
		for (int i = 0; i < count; i++) {
			[self add:array[i]];
		}
    }
	
    return self;
}

- (void) dealloc {

	free(_array);
	
	[super dealloc];
}

- (void)resize {
	int newSize;
	if (_arraySize == 0) {
		newSize = 1;
	} else {
		newSize = _arraySize * 2;
	}
	
	float* newArray = (float *)malloc(newSize * sizeof(float));
	if (_array) {
		// copy data
		for (int i = 0; i < _arraySize; i++) {
			newArray[i] = _array[i];
		}
		
		// destroy old array
		free(_array);
	}
	
	// set array pointer to new array
	_arraySize = newSize;
	_array = newArray;
}

- (float)get:(int)index {
	if (index < _size) {
		return _array[index];
	}
	Isgl3dLog(Error, @"Requested index %i is out of bounds [0, %i]", index, _size - 1);
	return 0;
}

- (float *) array {
	return _array;
}

- (void)add:(float)value {
	if (_size == _arraySize) {
		[self resize];
	}
	_array[_size++] = value;
}

- (int)size {
	return _size;
}



@end
