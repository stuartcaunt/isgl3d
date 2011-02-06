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

#import "Isgl3dTouchScreen.h"
#import "Isgl3dTouchScreenResponder.h"
#import "Isgl3dView3D.h"

static Isgl3dTouchScreen * _instance = nil;

@implementation Isgl3dTouchScreen

- (id) init {

	if (self = [super init]) {
		_responders = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	if (_view) {
		[_view release];
		_view = nil;
	}
	
	[_responders release];
    [super dealloc];
}

+ (Isgl3dTouchScreen *) sharedInstance {
	
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dTouchScreen alloc] init];
		}
	}
		
	return _instance;
}

+ (void) resetInstance {
	if (_instance) {
		[_instance release];
		_instance = nil;
	}
}

- (void) setupWithView:(Isgl3dView3D *)view {
	if (_view != view) {
		if (_view) {
			[_view release];
			_view = nil;
		}
		
		if (view) {
			_view = [view retain];
		}
	} 
}

- (void) addResponder:(id <Isgl3dTouchScreenResponder>)responder {
	[_responders addObject:responder];
}

- (void) removeResponder:(id <Isgl3dTouchScreenResponder>)responder {
	[_responders removeObject:responder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	for (id <Isgl3dTouchScreenResponder> responder in _responders) {
		[responder touchesBegan:touches withEvent:event];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	for (id <Isgl3dTouchScreenResponder> responder in _responders) {
		[responder touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (id <Isgl3dTouchScreenResponder> responder in _responders) {
		[responder touchesEnded:touches withEvent:event];
	}
}

- (CGPoint) locationInView:(UITouch *)touch {
	return [touch locationInView:_view];
}


@end
