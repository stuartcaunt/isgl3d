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

#ifndef ISGL3DLOG_H_
#define ISGL3DLOG_H_

#import <Foundation/Foundation.h>
#ifdef GL_ES_VERSION_2_0
#import <OpenGLES/ES2/gl.h>
#else
#import <OpenGLES/ES1/gl.h>
#endif


typedef enum {
	Debug = 0,
	Info,
	Warn,
	Error
} Isgl3dLogLevel;


#ifdef __cplusplus
extern "C" {
#endif
	
void Isgl3dLog(Isgl3dLogLevel level, NSString * message, ...);
void Isgl3dGLErrLog(Isgl3dLogLevel level, GLenum err, NSString * message, ...);

#ifdef __cplusplus
}
#endif // extern "C"


#endif /*ISGL3DLOG_H_*/
