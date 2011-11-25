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

#import "Isgl3dLog.h"


static inline NSString* Isgl3dLevelStringForLevel(Isgl3dLogLevel level) {
	// Create string alternative to log level
	NSString * levelString = @"INFO ";
	if (level == Debug) {
		levelString = @"DEBUG";
	} else if (level == Warn) {
		levelString = @"WARN ";
	} else if (level == Error) {
		levelString = @"ERROR";
	} 
	return levelString;
}

static inline NSString* Isgl3dErrStringForGLErr(GLenum err) {
	switch (err) {
		case GL_NO_ERROR:
			return @"no error";
			
		case GL_INVALID_ENUM:
			return @"An unacceptable value is specified for an enumerated argument. The offending command is ignored and has no other side effect than to set the error flag.";

		case GL_INVALID_VALUE:
			return @"A numeric argument is out of range. The offending command is ignored and has no other side effect than to set the error flag.";

		case GL_INVALID_OPERATION:
			return @"The specified operation is not allowed in the current state. The offending command is ignored and has no other side effect than to set the error flag.";

//		case GL_STACK_OVERFLOW:
//			return @"This command would cause a stack overflow. The offending command is ignored and has no other side effect than to set the error flag.";
			
//		case GL_STACK_UNDERFLOW:
//			return @"This command would cause a stack underflow. The offending command is ignored and has no other side effect than to set the error flag.";
			
		case GL_OUT_OF_MEMORY:
			return @"There is not enough memory left to execute the command. The state of the GL is undefined, except for the state of the error flags, after this error is recorded.";
			
#ifdef GL_ES_VERSION_2_0			
//		case GL_TABLE_TOO_LARGE:
//			return @"The specified table exceeds the implementation's maximum supported table size.  The offending command is ignored and has no other side effect than to set the error flag.";			
#endif
	}
	
	return @"unknown error";
}


void Isgl3dLog(Isgl3dLogLevel level, NSString * message, ...) {
	
	// Create string alternative to log level
	NSString * levelString = Isgl3dLevelStringForLevel(level);
	
	if (message) {
	    // Get the arguments
	    va_list args;
	    va_start(args, message);
	
	    NSString * fullMessage = [[NSString alloc] initWithFormat:message arguments:args];
		
		NSLog(@"iSGL3D : %@ : %@", levelString, fullMessage);
		
		[fullMessage release];
	} else {
		NSLog(@"iSGL3D : %@ : <nil message>", levelString);
	}
}

void Isgl3dGLErrLog(Isgl3dLogLevel level, GLenum err, NSString * message, ...) {
	// Create string alternative to log level
	NSString * levelString = Isgl3dLevelStringForLevel(level);
	
	if (message) {
	    // Get the arguments
	    va_list args;
	    va_start(args, message);
		
		NSMutableString * fullMessage = [[NSMutableString alloc] initWithFormat:message arguments:args];
		[fullMessage appendFormat:@"\n  underlying OpenGL error : %@", Isgl3dErrStringForGLErr(err)];
		
		NSLog(@"iSGL3D : %@ : %@", levelString, fullMessage);
		
		[fullMessage release];
	} else {
		NSLog(@"iSGL3D : %@ : <nil message>", levelString);
	}
}

