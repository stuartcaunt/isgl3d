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

void Isgl3dLog(Isgl3dLogLevel level, NSString * message, ...) {
	
	// Create string alternative to log level
	NSString * levelString = @"INFO ";
	if (level == Debug) {
		levelString = @"DEBUG";
	} else if (level == Warn) {
		levelString = @"WARN ";
	} else if (level == Error) {
		levelString = @"ERROR";
	} 
	
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
