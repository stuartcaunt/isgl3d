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
#import "Isgl3dEventType.h"

/**
 * The Isgl3dEvent3D class provides a container for an object that has been touched and the set of touches currently 
 * active.
 * 
 * The instances of this class are generated automatically by the iSGL3D framework.
 */
@interface Isgl3dEvent3D : NSObject {
	    
@private
	id _object;
	
	NSSet * _touches;
}

/**
 * Initialises the Isgl3dEvent3D with an object and a set of active UITouches.
 * object The object that has been touched.
 * touches the set of active UITouches.
 */
- (id) initWithObject:(id)object forTouches:(NSSet *)touches;

/**
 * Returns the object that has been touched.
 * @return the id of the object touched.
 */
@property (readonly) id object;

/**
 * Returns the set of active UITouches.
 * @return the set of active UITouches.
 */
@property (readonly) NSSet * touches;

@end
