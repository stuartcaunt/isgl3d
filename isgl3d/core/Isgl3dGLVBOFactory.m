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

#import "Isgl3dGLVBOFactory.h"
#import "Isgl3dLog.h"

static Isgl3dGLVBOFactory * _instance = nil;

@implementation Isgl3dGLVBOFactory

- (id) init {
	
	if ((self = [super init])) {
	}
	
	return self;
}

- (void) dealloc {
	if (_concreteFactory) {
		[_concreteFactory release]; 
	}
	
	[super dealloc];
}

+ (Isgl3dGLVBOFactory *) sharedInstance {
	
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dGLVBOFactory alloc] init];
		}
	}
		
	return _instance;
}

+ (void) resetInstance {
	if (_instance) {
		[_instance release];
		_instance = nil;
	}
}

- (void) setConcreteFactory:(Isgl3dGLVBOFactory *)concreteFactory {
	if (concreteFactory != _concreteFactory) {
		if (_concreteFactory) {
			[_concreteFactory release];
			_concreteFactory = nil;
		}
		
		if (concreteFactory) {
			_concreteFactory = [concreteFactory retain];
		}
	}
}

- (unsigned int) createBufferFromArray:(const float*)array size:(int)size {
	if (_concreteFactory) {
		return [_concreteFactory createBufferFromArray:array size:size];
	}

	Isgl3dLog(Error, @"Isgl3dGLVBOFactory.createBufferFromArray: not initialised with concrete factory");
	return 0;	
}

- (unsigned int) createBufferFromFloatArray:(Isgl3dFloatArray *)floatArray {
	if (_concreteFactory) {
		return [_concreteFactory createBufferFromFloatArray:floatArray];
	}

	Isgl3dLog(Error, @"Isgl3dGLVBOFactory.createBufferFromFloatArray: not initialised with concrete factory");
	return 0;	
}

- (unsigned int) createBufferFromElementArray:(const unsigned short*)array size:(int)size {
	if (_concreteFactory) {
		return [_concreteFactory createBufferFromElementArray:array size:size];
	}

	Isgl3dLog(Error, @"GLVBOFactory.createBufferFromElementArray: not initialised with concrete factory");
	return 0;	
}

- (unsigned int) createBufferFromUShortElementArray:(Isgl3dUShortArray *)ushortArray {
	if (_concreteFactory) {
		return [_concreteFactory createBufferFromUShortElementArray:ushortArray];
	}

	Isgl3dLog(Error, @"Isgl3dGLVBOFactory.createBufferFromUShortElementArray: not initialised with concrete factory");
	return 0;	
}

- (unsigned int) createBufferFromUnsignedCharArray:(const unsigned char *)array size:(unsigned int)size {
	if (_concreteFactory) {
		return [_concreteFactory createBufferFromUnsignedCharArray:array size:size];
	}

	Isgl3dLog(Info, @"Isgl3dGLVBOFactory.createBufferFromUnsignedCharArray: not initialised with concrete factory");
	return 0;	
}

- (void) createBufferFromArray:(const float*)array size:(int)size atIndex:(unsigned int)bufferIndex {
	if (_concreteFactory) {
		[_concreteFactory createBufferFromArray:array size:size atIndex:bufferIndex];
	} else {
		Isgl3dLog(Error, @"Isgl3dGLVBOFactory.createBufferFromArray: not initialised with concrete factory");
	}
}

- (void) createBufferFromFloatArray:(Isgl3dFloatArray *)floatArray atIndex:(unsigned int)bufferIndex {
	if (_concreteFactory) {
		[_concreteFactory createBufferFromFloatArray:floatArray atIndex:bufferIndex];
	} else {
		Isgl3dLog(Error, @"Isgl3dGLVBOFactory.createBufferFromFloatArray: not initialised with concrete factory");
	}
}

- (void) createBufferFromElementArray:(const unsigned short*)array size:(int)size atIndex:(unsigned int)bufferIndex {
	if (_concreteFactory) {
		[_concreteFactory createBufferFromElementArray:array size:size atIndex:bufferIndex];
	} else {
		Isgl3dLog(Error, @"Isgl3dGLVBOFactory.createBufferFromElementArray: not initialised with concrete factory");
	}
}

- (void) createBufferFromUShortElementArray:(Isgl3dUShortArray *)ushortArray atIndex:(unsigned int)bufferIndex {
	if (_concreteFactory) {
		[_concreteFactory createBufferFromUShortElementArray:ushortArray atIndex:bufferIndex];
	} else {
		Isgl3dLog(Error, @"Isgl3dGLVBOFactory.createBufferFromUShortElementArray: not initialised with concrete factory");
	}
}

- (void) createBufferFromUnsignedCharArray:(const unsigned char *)array size:(unsigned int)size atIndex:(unsigned int)bufferIndex {
	if (_concreteFactory) {
		[_concreteFactory createBufferFromUnsignedCharArray:array size:size atIndex:bufferIndex];
	} else {
		Isgl3dLog(Error, @"Isgl3dGLVBOFactory.createBufferFromUnsignedCharArray: not initialised with concrete factory");
	}
}

- (void) deleteBuffer:(unsigned int)bufferIndex {
	if (_concreteFactory) {
		[_concreteFactory deleteBuffer:bufferIndex];
	} else {
		Isgl3dLog(Error, @"Isgl3dGLVBOFactory.deleteBuffer: not initialised with concrete factory");
	}
}


@end
