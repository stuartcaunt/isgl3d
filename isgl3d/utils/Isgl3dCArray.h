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

#ifndef ISGL3D_ARRAY_H_
#define ISGL3D_ARRAY_H_

/**
 * Creates a new Isgl3dCArray for a specific type
 * 		Isgl3dCArray * a = ICA_NEW(CGPoint);
 */ 
#define ICA_NEW(__type__) iaCreateForTypeSize(sizeof(__type__))

/**
 * Creates a new Isgl3dCArray for a specific type with given capacity
 * 		Isgl3dCArray * a = ICA_NEW_WITH_CAPACITY(CGPoint, 8);
 */ 
#define ICA_NEW_WITH_CAPACITY(__type__, __capacity__) iaCreateForTypeSizeWithCapacity(sizeof(__type__), __capacity__)

/**
 * Creates a new Isgl3dCArray for a specific type, initialised from an existing c array
 * 		float value[4] = { 0, 1, 2, 3 };
 * 		Isgl3dCArray * a = ICA_NEW_WITH_ARRAY(float, values, 4);
 */ 
#define ICA_NEW_WITH_ARRAY(__type__, __array__, __count__) iaCreateForTypeSizeWithArray(sizeof(__type__), __array__, __count__)

/**
 * Deletes the Isgl3dCArray and frees all data. The array is then set to null.
 * 		ICA_DELETE(array);
 */
#define ICA_DELETE(__array__) iaDelete(__array__); __array__ = 0

/**
 * Adds (copies) an object into the array
 * 		float f;
 * 		ICA_ADD(array, f);
 */
#define ICA_ADD(__array__, __value__) iaAdd(__array__, &__value__)

/**
 * Adds (copies) a value into the array from a non-variable
 * 		ICA_ADD_VAL(float, array, 0);
 */
#define ICA_ADD_VAL(__type__, __array__, __value__) {__type__ __val = __value__; ICA_ADD(__array__, __val); } 

/**
 * Casts a pointer to a non-pointer type (used by other #defines)
 */
#define ICA_CAST(__type__) *(__type__ *)

/**
 * Returns a non-pointer value from a pointer value in the array for a given data type
 * 		float f = ICA_GET(float, array, 2);
 */
#define ICA_GET(__type__, __array__, __index__) ICA_CAST(__type__)iaGet(__array__, __index__)

/**
 * Returns a pointer to a value in the array
 * 		float * f = ICA_GET_PTR(float *, array, 2);
 */
#define ICA_GET_PTR(__type__, __array__, __index__) (__type__)iaGet(__array__, __index__)

/**
 * Returns the pointer location to an element position in the array (used internally and by other #defines)
 */
#define ICA_POSITION(__array__, __position__) &(__array__->array[__position__ * __array__->sizeType])

/**
 * Iterates over the array returning pointers to elements in the array
 * 		ICA_FOREACH_PTR(CGPoint *, point, array) {
 * 			float x = point->x;
 * 		}
 */
#define ICA_FOREACH_PTR(__type__, __object__, __array__)	\
	__type__ __object__ = (__type__)__array__->array; \
	for(unsigned int __i = 0, count = __array__->count; __i < count; __i++, __object__ = (__type__)ICA_POSITION(__array__, __i))

/**
 * Iterates over the array returning elements in the array
 * 		ICA_FOREACH(CGPoint, point, array) {
 * 			float x = point.x;
 * 		}
 */
#define ICA_FOREACH(__type__, __object__, __array__)	\
	__type__ __object__ = ICA_CAST(__type__)__array__->array; \
	for(unsigned int __i = 0, count = __array__->count; __i < count; __i++, __object__ = ICA_CAST(__type__)ICA_POSITION(__array__, __i))

/**
 * Simple c structure to act as a container for any data type. The intention is to store copies of the 
 * original data rather than pointers to them. For example, this provides an array of structs if 
 * so desired.
 * 
 * A number of #defines are included to simplify the interface to the c functionality.
 * 
 * When adding objects to the array, the array automatically resizes if necessary. Each resize will double
 * the capacity of the array.
 */
typedef struct {
	unsigned int capacity;
	unsigned int count;
	size_t sizeType;
	unsigned char * array;
} Isgl3dCArray;

/**
 * Creates an Isgl3dCArray for a given size_t object with a specified capacity.
 * @param sizeType the size in bytes for the objects to be stored.
 * @param capacity The initial capacity (nuber of obejcts) of the array.
 */
static inline Isgl3dCArray * iaCreateForTypeSizeWithCapacity(size_t sizeType, unsigned int capacity) {
	Isgl3dCArray * array = (Isgl3dCArray *)malloc(sizeof(Isgl3dCArray));
	array->capacity = capacity;
	array->count = 0;
	array->sizeType = sizeType;
	array->array = (unsigned char *)malloc(capacity * sizeType);
	
	return array;
}

/**
 * Creates an Isgl3dCArray for a given size_t object with an initial capacity of 1.
 * @param sizeType the size in bytes for the objects to be stored.
 */
static inline Isgl3dCArray * iaCreateForTypeSize(size_t sizeType) {
	return iaCreateForTypeSizeWithCapacity(sizeType, 1);
}

/**
 * Creates an Isgl3dCArray for a given size_t object, initialised with the data from a standard c array.
 * Note the c array is assumed to have the same types of objects as the Isgl3dCArray.
 * @param sizeType the size in bytes for the objects to be stored.
 * @param a the c array of data to be copied into the Isgl3dCArray.
 * @param count the number of elements to be copied.
 */
static inline Isgl3dCArray * iaCreateForTypeSizeWithArray(size_t sizeType, void * a, unsigned int count) {
	// Find nearest power of 2 capacity
	unsigned int capacity = 1;
    while (capacity < count) {
        capacity <<= 1;
    }
    
	Isgl3dCArray * array = (Isgl3dCArray *)malloc(sizeof(Isgl3dCArray));
	array->capacity = capacity;
	array->count = count;
	array->sizeType = sizeType;
	array->array = (unsigned char *)malloc(capacity * sizeType);
	
	memcpy(array->array, a, array->sizeType * count);
	
	return array;
}

/**
 * Deletes the Isgl3dCArray and frees all data stored in it.
 * @param array The array to be deleted.
 */
static inline void iaDelete(Isgl3dCArray * array) {
	if (array == 0) {
		return;
	}
	
	free(array->array);
	free(array);
}

/**
 * Doubles the capacity of the array.
 * @param array The array to be doubled in capacity.
 */
static inline void iaDoubleCapacity(Isgl3dCArray * array) {
	array->capacity *= 2;
	array->array = (unsigned char *)realloc(array->array, array->capacity * array->sizeType);	
}

/**
 * Iteratively doubles the size of the array until it is large enough to add extra data.
 * @param array The array to be increased in size (if necessary).
 * @param extra The number of elements to be added to the array.
 */
static inline void iaResizeIfNecessary(Isgl3dCArray * array, unsigned int extra) {
	while (array->capacity < array->count + extra) {
		iaDoubleCapacity(array);
	}
}

/**
 * Adds a new value to the array. The value must be of the original size_t given to the Isgl3dCArray at initialisation.
 * @param array The array to be added to.
 * @param value The value to be added (copied into) the array.
 */
static inline void iaAdd(Isgl3dCArray * array, const void * value) {
	iaResizeIfNecessary(array, 1);
	memcpy(ICA_POSITION(array, array->count++), value, array->sizeType);
}


/**
 * Returns a pointer to an element in the array at a given index.
 * @param array The array to get the element from.
 * @param index The index of the element.
 */
static inline unsigned char * iaGet(Isgl3dCArray * array, unsigned int index) {
	assert(index < array->count);
	return ICA_POSITION(array, index);
}

/**
 * Clears the array. Note that this does not delete the allocated memory for the data, simply
 * initialises the count to zero.
 * @param array The array to be cleared.
 */
static inline void iaClear(Isgl3dCArray * array) {
	array->count = 0;
}

#endif /*ISGL3D_ARRAY_H_*/