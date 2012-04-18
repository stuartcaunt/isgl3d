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

#import "Isgl3dGLContext.h"
#ifdef GL_ES_VERSION_2_0
#import <OpenGLES/ES2/gl.h>
#else
#import <OpenGLES/ES1/gl.h>
#endif


static NSArray *_glExtensionsNames = nil;

static BOOL CheckForGLExtension(NSString *searchName) {
    if (_glExtensionsNames == nil) {
        const char *extensionsCStr = (const char *)glGetString(GL_EXTENSIONS);
        NSString *extensionsString = [NSString stringWithCString:extensionsCStr encoding: NSASCIIStringEncoding];
        _glExtensionsNames = [[extensionsString componentsSeparatedByString:@" "] retain];
    }
    return [_glExtensionsNames containsObject:searchName];
}


@implementation Isgl3dGLContext

@synthesize backingWidth = _backingWidth;
@synthesize backingHeight = _backingHeight;
@synthesize stencilBufferAvailable = _stencilBufferAvailable;
@synthesize msaaAvailable=_msaaAvailable;
@synthesize msaaEnabled=_msaaEnabled;


+ (BOOL)openGLExtensionSupported:(NSString *)extensionName {
    return CheckForGLExtension(extensionName);
}


- (id)init {
	
	if ((self = [super init])) {
		_msaaAvailable = NO;
        _msaaEnabled = NO;
	}
	
	return self;
}

- (void)dealloc {
	
	[super dealloc];
}

- (Isgl3dGLRenderer *) createRenderer {
	return nil;
}

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer {
	return true;
}

- (void)prepareRender {
}

- (void)finalizeRender {
}

- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y {
	return nil;
}

- (void)switchToStandardBuffers {
}

- (void)switchToMsaaBuffers {
}

@end
