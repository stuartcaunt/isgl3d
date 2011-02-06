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

#import <Foundation/Foundation.h>

/**
 * A utility class for storing arrays of unsigned short values.
 * 
 * The array resizes automatically as more values are added. The capacity of the array is always a power of 2.
 */
@interface Isgl3dUShortArray : NSObject {
	    
@private
	ushort * _array;
	int _arraySize;
	int _size;
}


/**
 * Initialises an empty array with a capacity of 1.
 */
- (id) init;

/**
 * Initialises an empty array with a given capacity.
 * The capacity of the array is always a power of 2 so, for example, if the initial capacity
 * is set to 19 through this, the real capacity will be 32.
 * @param size The initial capacity of the array.
 */
- (id) initWithSize:(unsigned int)size;

/**
 * Initialises the array with data.
 * @param count The number of elements in the array provided.
 * @param array The initial data to be stored in the array.
 */
- (id) initWithArray:(int)count array:(ushort *)array;

/**
 * Returns the value for the given index. An error is reported if the index is outside the array capacity.
 */
- (ushort) get:(int)index;

/**
 * Returns the raw array of data.
 * @return The raw array of unsigned short values.
 */
- (ushort *) array;

/**
 * Adds a value to the array. The array resizes automatically if capacity is reached.
 * @param value The value to be added.
 */
- (void) add:(ushort)value;

/**
 * Returns the number of data elements in the array (not the capacity).
 * @return The number of data elemets in the array.
 */
- (int) size;

@end
