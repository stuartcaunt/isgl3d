/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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
	Isgl3dLogLevelDebug = 0,
	Isgl3dLogLevelInfo,
	Isgl3dLogLevelWarn,
	Isgl3dLogLevelError
} Isgl3dLogLevel;


#ifdef __cplusplus
extern "C" {
#endif

    
static NSString *Isgl3dLogPrefixForLogLevel(Isgl3dLogLevel level) {
    switch (level) {
        case Isgl3dLogLevelInfo:
            return @"iSGL3D";
            
        case Isgl3dLogLevelDebug:
            return @"iSGL3D (debug)";
            
        case Isgl3dLogLevelWarn:
            return @"iSGL3D (WARN)";
            
        case Isgl3dLogLevelError:
            return @"iSGL3D (ERROR)";
            
        default:
            break;
    }
    return @"iSGL3D";
}
    
    
#define Isgl3dLog(level, format, ...) NSLog([@"%@ " stringByAppendingString:format], Isgl3dLogPrefixForLogLevel(level), ##__VA_ARGS__)
    
    
#ifdef NDEBUG
#define NSDebugLog(...) ((void)0)
#define Isgl3dDebugLog(...) ((void)0)
#define Isgl3dDebugLog2(...) ((void)0)
#define Isgl3dClassDebugLog(...) ((void)0)
#define Isgl3dClassDebugLog2(...) ((void)0)
#else
#define NSDebugLog NSLog
#define Isgl3dDebugLog(level, format, ...) NSLog([@"%@ : " stringByAppendingString:format], Isgl3dLogPrefixForLogLevel(level), ##__VA_ARGS__)
#define Isgl3dClassDebugLog(level, format, ...) NSLog([@"%@ [%@]: " stringByAppendingString:format], Isgl3dLogPrefixForLogLevel(level), NSStringFromClass([self class]), ##__VA_ARGS__)
#if DEBUG >= 2
#define Isgl3dClassDebugLog2(level, format, ...) NSLog([@"%@ [%@]: " stringByAppendingString:format], Isgl3dLogPrefixForLogLevel(level), NSStringFromClass([self class]), ##__VA_ARGS__)
#else
#define Isgl3dClassDebugLog2(...) ((void)0)
#endif
#endif

    
#ifdef __cplusplus
}
#endif // extern "C"


#endif /*ISGL3DLOG_H_*/
