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

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@class Isgl3dGLRenderer;

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dGLContext : NSObject {

@protected	
	// The pixel dimensions of the CAEAGLLayer
	int _backingWidth;
	int _backingHeight;
	float _clearColor[4];
	
	BOOL _stencilBufferAvailable;

	BOOL _msaaAvailable;
	BOOL _msaaEnabled;
	int _msaaSamples;
	BOOL _framebufferDiscardAvailable;
	
	Isgl3dGLRenderer * _currentRenderer;
}

@property (readonly) int backingWidth;
@property (readonly) int backingHeight;
@property (readonly) BOOL stencilBufferAvailable;
@property (nonatomic, readonly) BOOL msaaAvailable;
@property (nonatomic, assign) BOOL msaaEnabled;

/**
 * @result (autorelease) GLRenderer depending on Context version
 */
- (Isgl3dGLRenderer *) createRenderer;

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;

- (void) prepareRender;
- (void) finalizeRender;
- (void) switchToStandardBuffers;
- (void) switchToMsaaBuffers;

- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y;

@end

