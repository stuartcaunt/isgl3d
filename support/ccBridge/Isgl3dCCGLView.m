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

#import "Isgl3dCCGLView.h"
#import "Isgl3dDirector.h"
#import "Isgl3dLog.h"
#import "Isgl3dGLRenderer1.h"
#import "Isgl3dGLTextureFactory.h"
#import "Isgl3dGLTextureFactoryState1.h"
#import "Isgl3dGLVBOFactory1.h"

@interface Isgl3dCCGLView ()
- (void) initialiseForIsgl3d;
@end

@implementation Isgl3dCCGLView

@synthesize isgl3dTouchDelegate = _touchDelegate;

- (id) initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self initialiseForIsgl3d];
	}
	
	return self;
}

- (id) initWithFrame:(CGRect)frame pixelFormat:(NSString*)format {
	if ((self = [super initWithFrame:frame pixelFormat:format])) {
		[self initialiseForIsgl3d];
	}
	
	return self;	
}

- (id) initWithFrame:(CGRect)frame pixelFormat:(NSString*)format depthFormat:(GLuint)depth preserveBackbuffer:(BOOL)retained sharegroup:(EAGLSharegroup*)sharegroup multiSampling:(BOOL)sampling numberOfSamples:(unsigned int)nSamples {
	if ((self = [super initWithFrame:frame pixelFormat:format depthFormat:depth preserveBackbuffer:retained sharegroup:sharegroup multiSampling:sampling numberOfSamples:nSamples])) {
		[self initialiseForIsgl3d];
	}
	
	return self;	
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self initialiseForIsgl3d];
	}
	
	return self;	
}

- (void) dealloc {
	
    [super dealloc];
}

- (void) initialiseForIsgl3d {

	[self setMultipleTouchEnabled:YES];

	// Initialise texture factory and vbo factory
	[[Isgl3dGLTextureFactory sharedInstance] setState:[[[Isgl3dGLTextureFactoryState1 alloc] init] autorelease]];
	[[Isgl3dGLVBOFactory sharedInstance] setConcreteFactory:[[[Isgl3dGLVBOFactory1 alloc] init] autorelease]];
	
	Isgl3dLog(Info, @"Isgl3dCCGLView : Cocos2d EAGLView with OpenGL ES 1.X used.");
}

- (Isgl3dGLRenderer *) createRenderer {
	Isgl3dGLRenderer1 * renderer = [[Isgl3dGLRenderer1 alloc] init];
	renderer.stencilBufferAvailable = NO;
	
	return [renderer autorelease];
}

- (void) finalizeRender {
	[self swapBuffers];
}

- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y {
	uint8_t pixelData[4]; 
	unsigned int backingHeight = self.surfaceSize.height;
	
	glReadPixels(x, backingHeight - y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, &pixelData);
	
	NSString * pixelString = [NSString stringWithFormat:@"0x%02X%02X%02X", pixelData[0], pixelData[1], pixelData[2]];
	return pixelString;
}


- (void) layoutSubviews {
	[super layoutSubviews];
	
	[[Isgl3dDirector sharedInstance] onResizeFromLayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	if (_touchDelegate) {
		[_touchDelegate touchesBegan:touches withEvent:event];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	if (_touchDelegate) {
		[_touchDelegate touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	if (_touchDelegate) {
		[_touchDelegate touchesEnded:touches withEvent:event];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	if (_touchDelegate) {
		[_touchDelegate touchesCancelled:touches withEvent:event];
	}
}


@end
