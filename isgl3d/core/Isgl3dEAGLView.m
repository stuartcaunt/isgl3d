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

#import "Isgl3dEAGLView.h"
#import "v2.0/Isgl3dGLContext2.h"
#import "v1.1/Isgl3dGLContext1.h"
#import "Isgl3dDirector.h"
#import "Isgl3dLog.h"

@interface Isgl3dEAGLView ()
- (BOOL) initContextForOpenGLES1;
- (BOOL) initContextForOpenGLES2;
- (BOOL) initContextForLatestOpenGLES;
- (BOOL) initContextFromPlist;
@end

@implementation Isgl3dEAGLView

@synthesize isgl3dTouchDelegate = _touchDelegate;

+ (Class) layerClass {
    return [CAEAGLLayer class];
}

+ (id) viewWithFrame:(CGRect)frame {
	return [[[self alloc] initWithFrame:frame] autorelease];
}

+ (id) viewWithFrameFromPlist:(CGRect)frame {
	return [[[self alloc] initWithFrameFromPlist:frame] autorelease];
}

+ (id) viewWithFrameForES1:(CGRect)frame {
	return [[[self alloc] initWithFrameForES1:frame] autorelease];
}

+ (id) viewWithFrameForES2:(CGRect)frame {
	return [[[self alloc] initWithFrameForES2:frame] autorelease];
}



- (id) initWithFrame:(CGRect)frame {
	
	if ((self = [super initWithFrame:frame])) {
		
		if (![self initContextForLatestOpenGLES]) {
			[self release];
			self = nil;
		}
	}

	return self;
}

- (id) initWithFrameFromPlist:(CGRect)frame {
	
	if ((self = [super initWithFrame:frame])) {
		
		if (![self initContextFromPlist]) {
			[self release];
			self = nil;
		}
	}

	return self;
}

- (id) initWithFrameForES1:(CGRect)frame {
	
	if ((self = [super initWithFrame:frame])) {
		
		if (![self initContextForOpenGLES1]) {
			[self release];
			self = nil;
		}
	}

	return self;
}

- (id) initWithFrameForES2:(CGRect)frame {
	
	if ((self = [super initWithFrame:frame])) {
		
		if (![self initContextForOpenGLES2]) {
			[self release];
			self = nil;
		}
	}

	return self;
}

- (id) initWithCoder:(NSCoder*)coder {    
    if ((self = [super initWithCoder:coder])) {
		
		if (![self initContextFromPlist]) {
			[self release];
			self = nil;
		}
    }
	
    return self;
}

- (void) dealloc {
	if (_glContext) {
	    [_glContext release];
	}
	
    [super dealloc];
}

- (BOOL) initContextForOpenGLES1 {
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

	eaglLayer.opaque = TRUE;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[	NSNumber numberWithBool:FALSE], 
																				kEAGLDrawablePropertyRetainedBacking, 
																				kEAGLColorFormatRGBA8, 
																				kEAGLDrawablePropertyColorFormat, 
																				nil];

	_glContext = [[Isgl3dGLContext1 alloc] initWithLayer:eaglLayer];
	if (_glContext) {
		[self setMultipleTouchEnabled:YES];
		
		_size.width = [_glContext backingWidth];
		_size.height = [_glContext backingHeight];
		
		Isgl3dLog(Info, @"Isgl3dEAGLView : GLContext for OpenGL ES 1.X used.");
		return YES;
	}
	return NO;
}

- (BOOL) initContextForOpenGLES2 {
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

	eaglLayer.opaque = TRUE;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[	NSNumber numberWithBool:FALSE], 
																				kEAGLDrawablePropertyRetainedBacking, 
																				kEAGLColorFormatRGBA8, 
																				kEAGLDrawablePropertyColorFormat, 
																				nil];

	_glContext = [[Isgl3dGLContext2 alloc] initWithLayer:eaglLayer];
	if (_glContext) {
		[self setMultipleTouchEnabled:YES];
		
		_size.width = [_glContext backingWidth];
		_size.height = [_glContext backingHeight];
		
		Isgl3dLog(Info, @"Isgl3dEAGLView : GLContext for OpenGL ES 2.X used.");
		return YES;
	}
	return NO;
}

- (BOOL) initContextForLatestOpenGLES {
	// Create the context depending on iphone capabilities
	if (![self initContextForOpenGLES2]) {
		[self initContextForOpenGLES1];
	}
	
	return (_glContext != nil);
}

- (BOOL) initContextFromPlist {
	NSString * isglOptionsPath = [[NSBundle mainBundle] pathForResource:@"isgl3d" ofType:@"plist"];
	NSDictionary * isglOptions = [NSDictionary dictionaryWithContentsOfFile:isglOptionsPath];
	
	NSNumber * glContextVersionNumber = [isglOptions objectForKey:@"glContextVersion"];
	if (glContextVersionNumber) {
		// Create the context using user-specified value
		int glContextVersion = [glContextVersionNumber integerValue];
		if (glContextVersion == 1) {
			return [self initContextForOpenGLES1];
			
		} else if (glContextVersion == 2) {
			return [self initContextForOpenGLES2];

		} else {
			Isgl3dLog(Warn, @"Isgl3dEAGLView : Got glcontextversion %i, which is not valid. Reverting to glContext1", glContextVersion);
			return [self initContextForOpenGLES1];
		}
	}
	
	Isgl3dLog(Warn, @"Isgl3dEAGLView : glcontextversion not found in isgl3d.plist");
	return [self initContextForLatestOpenGLES];
	
}

- (Isgl3dGLRenderer *) createRenderer {
	return [_glContext createRenderer];
}

- (void) prepareRender {
	[_glContext prepareRender];
}

- (void) finalizeRender {
	[_glContext finalizeRender];
}


- (void) layoutSubviews {
	CGRect bounds = self.bounds;
	
	if ((roundf(bounds.size.width) != _size.width) || (roundf(bounds.size.height) != _size.height)) {
		[_glContext resizeFromLayer:(CAEAGLLayer*)self.layer];
		
		[[Isgl3dDirector sharedInstance] onResizeFromLayer];
		
		_size.width = [_glContext backingWidth];
		_size.height = [_glContext backingHeight];
	}
}

- (NSString *) getPixelString:(unsigned int)x y:(unsigned int)y {
	return [_glContext getPixelString:x y:y];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_touchDelegate) {
		[_touchDelegate touchesBegan:touches withEvent:event];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_touchDelegate) {
		[_touchDelegate touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_touchDelegate) {
		[_touchDelegate touchesEnded:touches withEvent:event];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_touchDelegate) {
		[_touchDelegate touchesCancelled:touches withEvent:event];
	}
}

- (void)switchToStandardBuffers
{
	[_glContext switchToStandardBuffers];
}

- (void)switchToMsaaBuffers
{
	[_glContext switchToMsaaBuffers];
}

- (BOOL)msaaAvailable {
    return _glContext.msaaAvailable;
}

- (BOOL)msaaEnabled {
    return _glContext.msaaEnabled;
}

- (void)setMsaaEnabled:(BOOL)value {
    _glContext.msaaEnabled = value;
}

@end
