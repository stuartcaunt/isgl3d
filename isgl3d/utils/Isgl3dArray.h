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

/**
 * Allocates and intitialises an Isgl3dArray with autorelease for a specific data type
 * 		Isgl3dArray * array = IA_ALLOC_INIT_AR(CGPoint);
 */
#define IA_ALLOC_INIT_AR(__type__) [[[Isgl3dArray alloc] initForSizeType:sizeof(__type__)] autorelease]

/**
 * Allocates and intitialises an Isgl3dArray with autorelease for a specific data type and capacity
 * 		Isgl3dArray * array = IA_ALLOC_INIT_WITH_CAPACITY_AR(CGPoint, 8);
 */
#define IA_ALLOC_INIT_WITH_CAPACITY_AR(__type__, __capacity__) [[[Isgl3dArray alloc] initForSizeType:sizeof(__type__) withCapacity:__capacity__] autorelease]

/**
 * Allocates and intitialises an Isgl3dArray with autorelease for a specific data type with data from a standard c array
 * 		float value[5] = {0, 1, 2, 3, 4};
 * 		Isgl3dArray * array = IA_ALLOC_INIT_WITH_CAPACITY_AR(float, value, 5);
 */
#define IA_ALLOC_INIT_WITH_ARRAY_AR(__type__, __array__, __count__) [[[Isgl3dArray alloc] initForSizeType:sizeof(__type__) withArray:__array__ count:__count__] autorelease]

/**
 * Allocates and intitialises an Isgl3dArray for a specific data type
 * 		Isgl3dArray * array = IA_ALLOC_INIT(CGPoint);
 */
#define IA_ALLOC_INIT(__type__) [[Isgl3dArray alloc] initForSizeType:sizeof(__type__)]

/**
 * Allocates and intitialises an Isgl3dArray for a specific data type and capacity
 * 		Isgl3dArray * array = IA_ALLOC_INIT_WITH_CAPACITY_AR(CGPoint, 8);
 */
#define IA_ALLOC_INIT_WITH_CAPACITY(__type__, __capacity__) [[Isgl3dArray alloc] initForSizeType:sizeof(__type__) withCapacity:__capacity__]

/**
 * Allocates and intitialises an Isgl3dArray for a specific data type with data from a standard c array
 * 		float value[5] = {0, 1, 2, 3, 4};
 * 		Isgl3dArray * array = IA_ALLOC_INIT_WITH_CAPACITY(float, value, 5);
 */
#define IA_ALLOC_INIT_WITH_ARRAY(__type__, __array__, __count__) [[Isgl3dArray alloc] initForSizeType:sizeof(__type__) withArray:__array__ count:__count__]

/**
 * Adds (copies) an object into the array
 * 		float f;
 * 		IA_ADD(array, f);
 */
#define IA_ADD(__array__, __value__) [__array__ add:&__value__]

/**
 * Adds (copies) a value into the array from a non-variable
 * 		IA_ADD_VAL(float, array, 0);
 */
#define IA_ADD_VAL(__type__, __array__, __value__) {__type__ __val = __value__; IA_ADD(__array__, __val); } 

/**
 * Returns a non-pointer value from a pointer value in the array for a given data type
 * 		float f = IA_GET(float, array, 2);
 */
#define IA_GET(__type__, __array__, __index__) ICA_CAST(__type__)[__array__ get:__index__]

/**
 * Returns a pointer to a value in the array
 * 		float * f = IA_GET_PTR(float *, array, 2);
 */
#define IA_GET_PTR(__type__, __array__, __index__) (__type__)[__array__ get:__index__]

/**
 * Iterates over the array returning pointers to elements in the array
 * 		IA_FOREACH_PTR(CGPoint *, point, array) {
 * 			float x = point->x;
 * 		}
 */
#define IA_FOREACH(__type__, __object__, __array__)	\
	Isgl3dCArray * __cArray__ = __array__->_cArray; \
	ICA_FOREACH(__type__, __object__, __cArray__)

/**
 * Iterates over the array returning elements in the array
 * 		IA_FOREACH(CGPoint, point, array) {
 * 			float x = point.x;
 * 		}
 */
#define IA_FOREACH_PTR(__type__, __object__, __array__)	\
	Isgl3dCArray * __cArray__ = __array__->_cArray; \
	ICA_FOREACH_PTR(__type__, __object__, __cArray__)


#import <Foundation/Foundation.h>
#import "Isgl3dCArray.h"

/**
 * Isgl3dArray is an objective c wrapper to the c structure Isgl3dCArray and associated c functions.
 *
 * Simple c structure to act as a container for any data type. The intention is to store copies of the 
 * original data rather than pointers to them. For example, this provides an array of structs if 
 * so desired.
 * 
 * A number of #defines are included to simplify the interface.
 * 
 * When adding objects to the array, the array automatically resizes if necessary. Each resize will double
 * the capacity of the array.
 *  
 */
@interface Isgl3dArray : NSObject {
@public
	Isgl3dCArray * _cArray;	
}

/**
 * Initialises an Isgl3dArray for a given size_t object with an initial capacity of 1.
 * @param sizeType the size in bytes for the objects to be stored.
 */
- (id) initForSizeType:(size_t)sizeType;

/**
 * Initialises an Isgl3dArray for a given size_t object with a specified capacity.
 * @param sizeType the size in bytes for the objects to be stored.
 * @param capacity The initial capacity (nuber of obejcts) of the array.
 */
- (id) initForSizeType:(size_t)sizeType withCapacity:(unsigned int)capacity;

/**
 * Initialises an Isgl3CArray for a given size_t object, initialised with the data from a standard c array.
 * Note the c array is assumed to have the same types of objects as the Isgl3dArray.
 * @param sizeType the size in bytes for the objects to be stored.
 * @param array the c array of data to be copied into the Isgl3dCArray.
 * @param count the number of elements to be copied.
 */
- (id) initForSizeType:(size_t)sizeType withArray:(void *)array count:(unsigned int)count;

/**
 * Adds a new value to the array. The value must be of the original size_t given to the Isgl3dArray at initialisation.
 * @param value The value to be added (copied into) the array.
 */
- (void) add:(const void *)value;

/**
 * Returns a pointer to an element in the array at a given index.
 * @param index The index of the element.
 * @return pointer to the element
 */
- (unsigned char *) get:(unsigned int)index;

/**
 * Clears the array. Note that this does not delete the allocated memory for the data, simply
 * initialises the count to zero.
 */
- (void) clear;

/**
 * Returns the raw array of data
 * @return the raw array of data
 */
- (unsigned char *) array;

/**
 * Returns the number of elements in the array
 * @return the number of elements in the array
 */
- (unsigned int) count;

@end
