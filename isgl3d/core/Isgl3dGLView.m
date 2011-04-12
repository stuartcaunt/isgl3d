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

#import "Isgl3dGLView.h"
#import "v2.0/Isgl3dGLContext2.h"
#import "v1.1/Isgl3dGLContext1.h"
#import "Isgl3dLog.h"


@interface Isgl3dGLView (PrivateMethods)
- (void) drawViewForEventCapture;
- (void) initializeRender;
- (void) render;
- (void) renderForShadowMaps;
- (void) renderForEventCapture;
@end


@implementation Isgl3dGLView

+ (Class) layerClass {
    return [CAEAGLLayer class];
}

- (id) initWithFrame:(CGRect)frame {
	
	if ((self = [super initWithFrame:frame])) {
		
		if (![self initializeContext]) {
			[self release];
			self = nil;
		}
	}

	return self;
}

- (id) initWithCoder:(NSCoder*)coder {    
    if ((self = [super initWithCoder:coder])) {
		if (![self initializeContext]) {
			[self release];
			self = nil;
		}
    }
	
    return self;
}

- (BOOL) initializeContext {
   // Get the layer
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    
    eaglLayer.opaque = TRUE;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

	
	NSString * isglOptionsPath = [[NSBundle mainBundle] pathForResource:@"isgl3d" ofType:@"plist"];

	if (!isglOptionsPath) {
		Isgl3dLog(Error, @"Isgl3dGLView : Failed to load %@", @"isgl3d.plist");
		return NO;
	}
	
	NSDictionary * isglOptions = [NSDictionary dictionaryWithContentsOfFile:isglOptionsPath];
	
	NSNumber * glContextVersionNumber = [isglOptions objectForKey:@"glContextVersion"];
	if (glContextVersionNumber) {
		// Create the context using user-specified value
		int glContextVersion = [glContextVersionNumber integerValue];
		if (glContextVersion == 1) {
			Isgl3dLog(Info, @"GLContext for OpenGL ES 1.X used.");
			_glContext = [[Isgl3dGLContext1 alloc] initWithLayer:eaglLayer];

		} else if (glContextVersion == 2) {
			Isgl3dLog(Info, @"GLContext for OpenGL ES 2.X used.");
			_glContext = [[Isgl3dGLContext2 alloc] initWithLayer:eaglLayer];

		} else {
			Isgl3dLog(Warn, @"Got glcontextversion %i, which is not valid. Reverting to glContext1", glContextVersion);
			_glContext = [[Isgl3dGLContext1 alloc] initWithLayer:eaglLayer];
		}

	} else {
		// Create the context depending on iphone capabilities
		_glContext = [[Isgl3dGLContext2 alloc] initWithLayer:eaglLayer];
		
		if (!_glContext) {
			Isgl3dLog(Info, @"GLContext for OpenGL ES 1.X used.");
			_glContext = [[Isgl3dGLContext1 alloc] initWithLayer:eaglLayer];
		} else {
			Isgl3dLog(Info, @"GLContext for OpenGL ES 2.X used.");
		}
	}
	
	if (!_glContext) {
		return NO;
	}
	
	[self setMultipleTouchEnabled:YES];
	return YES;	
}

- (void) dealloc {
    [_glContext release];
	
    [super dealloc];
}

- (float) defaultAspectRatio {
	return (float)[_glContext backingWidth] / [_glContext backingHeight];
}


- (void) drawView {
// 	GLenum err = glGetError();

	[self updateScene];

	[self initializeRender];

	[self renderForShadowMaps];

    [_glContext initializeRender];

	[_glContext clearBuffer];
	[self render];

/*	err = glGetError();
	if (err != GL_NO_ERROR) {
		Isgl3dLog(Info, @"Error GL_INVALID_ENUM 0x%04X", GL_INVALID_ENUM);
		Isgl3dLog(Info, @"Error GL_INVALID_VALUE 0x%04X", GL_INVALID_VALUE);
		Isgl3dLog(Info, @"Error GL_INVALID_OPERATION 0x%04X", GL_INVALID_OPERATION);
		Isgl3dLog(Info, @"Error  0x%04X", err);
	}
*/
    
//	uncomment to check if event capture drawing ok
//	[self drawViewForEventCapture];
	
	[_glContext finalizeRender];



/*
 	// Performance testing
	NSDate * start = [NSDate date];
 
	NSDate * t1 = [NSDate date];
	[self updateScene];
	_timers[1] += [[NSDate date] timeIntervalSinceDate:t1];

	NSDate * t2 = [NSDate date];
	[self initializeRender];
	_timers[2] += [[NSDate date] timeIntervalSinceDate:t2];
	
	NSDate * t3 = [NSDate date];
	[self renderForShadowMaps];
	_timers[3] += [[NSDate date] timeIntervalSinceDate:t3];

	NSDate * t4 = [NSDate date];
    [_glContext initializeRender];
	_timers[4] += [[NSDate date] timeIntervalSinceDate:t4];

	NSDate * t5 = [NSDate date];
	[_glContext clearBuffer];
	_timers[5] += [[NSDate date] timeIntervalSinceDate:t5];

	NSDate * t6 = [NSDate date];
	[self render];
	_timers[6] += [[NSDate date] timeIntervalSinceDate:t6];


	NSDate * t7 = [NSDate date];
    [_glContext finalizeRender];
	_timers[7] += [[NSDate date] timeIntervalSinceDate:t7];


	_timers[0] += [[NSDate date] timeIntervalSinceDate:start];
	_viewCounter++;
	
	if (_viewCounter == 60) {
		Isgl3dLog(Info, @"Total               : %f\t%f", _timers[0], 1. /(_timers[0] / _viewCounter));
		Isgl3dLog(Info, @"Update Scene        : %f\t%f", _timers[1], _timers[1] / _timers[0] * 100);
		Isgl3dLog(Info, @"Initialize renderer : %f\t%f", _timers[2], _timers[2] / _timers[0] * 100);
		Isgl3dLog(Info, @"Render shadow maps  : %f\t%f", _timers[3], _timers[3] / _timers[0] * 100);
		Isgl3dLog(Info, @"Intialize context   : %f\t%f", _timers[4], _timers[4] / _timers[0] * 100);
		Isgl3dLog(Info, @"Clear buffer        : %f\t%f", _timers[5], _timers[5] / _timers[0] * 100);
		Isgl3dLog(Info, @"Render              : %f\t%f", _timers[6], _timers[6] / _timers[0] * 100);
		Isgl3dLog(Info, @"Finalize render     : %f\t%f", _timers[7], _timers[7] / _timers[0] * 100);
		Isgl3dLog(Info, @"");
		float progPerc = _timers[1] / _timers[0] * 100;
		float isglPerc = 100 - progPerc;
		Isgl3dLog(Info, @"ISGL : %f      PROG : %f", isglPerc, progPerc);
		Isgl3dLog(Info, @"=======================================");
		Isgl3dLog(Info, @"");

		_viewCounter = 0;
		for (int i = 0; i < 10; i++) {
			_timers[i] = 0;
		}
	}
*/
}

- (void) drawViewForEventCapture {

    [_glContext initializeRender];

	[_glContext clearBufferForEventCapture];

    [self renderForEventCapture];
}

- (void) initializeRender {
}

- (void) render {
}

- (void) renderForShadowMaps {
}

- (void) renderForEventCapture {
}

- (void) updateScene {
}

- (void) layoutSubviews {
	[_glContext resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self drawViewForEventCapture];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}


@end
