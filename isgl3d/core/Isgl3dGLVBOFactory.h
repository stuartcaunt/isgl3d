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

@class Isgl3dFloatArray;
@class Isgl3dUShortArray;

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dGLVBOFactory : NSObject {

@private
	Isgl3dGLVBOFactory * _concreteFactory;
}

- (id) init;

+ (Isgl3dGLVBOFactory *) sharedInstance;
+ (void) resetInstance;

- (void) setConcreteFactory:(Isgl3dGLVBOFactory *)concreteFactory;

- (unsigned int) createBufferFromArray:(const float*)array size:(int)size;
- (unsigned int) createBufferFromFloatArray:(Isgl3dFloatArray *)floatArray;
- (unsigned int) createBufferFromElementArray:(const unsigned short*)array size:(int)size;
- (unsigned int) createBufferFromUShortElementArray:(Isgl3dUShortArray *)ushortArray;
- (unsigned int) createBufferFromUnsignedCharArray:(const unsigned char *)array size:(unsigned int)size;

- (void) createBufferFromArray:(const float*)array size:(int)size atIndex:(unsigned int)bufferIndex;
- (void) createBufferFromFloatArray:(Isgl3dFloatArray *)floatArray atIndex:(unsigned int)bufferIndex;
- (void) createBufferFromElementArray:(const unsigned short*)array size:(int)size atIndex:(unsigned int)bufferIndex;
- (void) createBufferFromUShortElementArray:(Isgl3dUShortArray *)ushortArray atIndex:(unsigned int)bufferIndex;
- (void) createBufferFromUnsignedCharArray:(const unsigned char *)array size:(unsigned int)size atIndex:(unsigned int)bufferIndex;

- (void) deleteBuffer:(unsigned int)bufferIndex;

@end

