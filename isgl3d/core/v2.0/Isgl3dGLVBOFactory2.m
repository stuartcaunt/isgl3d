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

#import "Isgl3dGLVBOFactory2.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"
#import "Isgl3dLog.h"

@implementation Isgl3dGLVBOFactory2

- (id) init {
	if ((self = [super init])) {
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}



- (unsigned int) createBufferFromArray:(const float*)array size:(int)size {
	// set up buffer to store array
	GLuint bufferIndex;
	glGenBuffers(1, &bufferIndex);
	glBindBuffer(GL_ARRAY_BUFFER, bufferIndex);
	
	// Copy data from local memory
	glBufferData(GL_ARRAY_BUFFER, (GLsizeiptr)(size * sizeof(GLfloat)), array, GL_STATIC_DRAW);
	
	return bufferIndex;
}

- (unsigned int) createBufferFromFloatArray:(Isgl3dFloatArray *)floatArray {
	return [self createBufferFromArray:[floatArray array] size:[floatArray size]];
}

- (unsigned int) createBufferFromElementArray:(const unsigned short*)array size:(int)size {
	// set up buffer to store array
	GLuint bufferIndex;
	glGenBuffers(1, &bufferIndex);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, bufferIndex);
	
	// Copy data from local memory
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, (GLsizeiptr)(size * sizeof(GLushort)), array, GL_STATIC_DRAW);
	
	return bufferIndex;
}

- (unsigned int) createBufferFromUShortElementArray:(Isgl3dUShortArray *)ushortArray {
	return [self createBufferFromElementArray:[ushortArray array] size:[ushortArray size]];
}

- (unsigned int) createBufferFromUnsignedCharArray:(const unsigned char *)array size:(unsigned int)size {
	// set up buffer to store array
	GLuint bufferIndex;
	glGenBuffers(1, &bufferIndex);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, bufferIndex);
	
	// Copy data from local memory
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, (GLsizeiptr)(size), array, GL_STATIC_DRAW);

	GLenum err = glGetError();
	if (err != GL_NO_ERROR) {
		Isgl3dLog(Warn, @"Error creating buffer %i. glError: 0x%04X", bufferIndex, err);
	}
		
	return bufferIndex;
}

- (void) createBufferFromArray:(const float*)array size:(int)size atIndex:(unsigned int)bufferIndex {
	glBindBuffer(GL_ARRAY_BUFFER, bufferIndex);
	
	// Copy data from local memory
	glBufferData(GL_ARRAY_BUFFER, (GLsizeiptr)(size * sizeof(GLfloat)), array, GL_STATIC_DRAW);
}

- (void) createBufferFromFloatArray:(Isgl3dFloatArray *)floatArray atIndex:(unsigned int)bufferIndex {
	[self createBufferFromArray:[floatArray array] size:[floatArray size] atIndex:bufferIndex];
}

- (void) createBufferFromElementArray:(const unsigned short*)array size:(int)size atIndex:(unsigned int)bufferIndex {
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, bufferIndex);
	
	// Copy data from local memory
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, (GLsizeiptr)(size * sizeof(GLushort)), array, GL_STATIC_DRAW);
}

- (void) createBufferFromUShortElementArray:(Isgl3dUShortArray *)ushortArray atIndex:(unsigned int)bufferIndex {
	[self createBufferFromElementArray:[ushortArray array] size:[ushortArray size] atIndex:bufferIndex];
}

- (void) createBufferFromUnsignedCharArray:(const unsigned char *)array size:(unsigned int)size atIndex:(unsigned int)bufferIndex {
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, bufferIndex);
	
	// Copy data from local memory
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, (GLsizeiptr)(size), array, GL_STATIC_DRAW);
}

- (void) deleteBuffer:(unsigned int)bufferIndex {
	if (bufferIndex > 0) {
		glDeleteBuffers(1, &bufferIndex);
	}
}


@end
