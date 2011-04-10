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

#import "Isgl3dGLUIButton.h"
#import "Isgl3dPrimitiveFactory.h"
#import "Isgl3dPlane.h"
#import "Isgl3dEventType.h"

@implementation Isgl3dGLUIButton


+ (id) buttonWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height {
	return [[[self alloc] initWithMaterial:material width:width height:height] autorelease];
}

+ (id) buttonWithMaterial:(Isgl3dMaterial *)material {
	return [[[self alloc] initWithMaterial:material] autorelease];
}

- (id) initWithMaterial:(Isgl3dMaterial *)material {
	
	if ((self = [super initWithMesh:[[Isgl3dPrimitiveFactory sharedInstance] UIButtonMesh] andMaterial:material])) {
		[self setWidth:[Isgl3dPrimitiveFactory sharedInstance].UIButtonWidth andHeight:[Isgl3dPrimitiveFactory sharedInstance].UIButtonHeight];
		self.interactive = YES;
	}
	
	return self;	
}

- (id) initWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height {
	
	if ((self = [super initWithMesh:[Isgl3dPlane meshWithGeometry:width height:height nx:2 ny:2] andMaterial:material])) {
		[self setWidth:width andHeight:height];
		self.interactive = YES;
	}
	
	return self;	
}


- (void) dealloc {
	
	[super dealloc];
}

- (Isgl3dEvent3DListener *) addEventListener:(unsigned int)eventType listener:(id)listener handler:(SEL)handler {
	if (eventType == BUTTON_PRESS_EVENT) {
		return [self addEvent3DListener:listener method:handler forEventType:TOUCH_EVENT];
	} else {
		return [self addEvent3DListener:listener method:handler forEventType:RELEASE_EVENT];
	}
	
}

- (void) removeEventListener:(Isgl3dEvent3DListener *)listener {
	return [self removeEvent3DListener:listener];
}

@end
