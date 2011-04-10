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

#import "Isgl3dGLUIProgressBar.h"
#import "Isgl3dPlane.h"
#import "Isgl3dUVMap.h"

@interface Isgl3dGLUIProgressBar (PrivateMethods)
/**
 * @result (autorelease) Plane with desired width and height reduced by factor proportional to progress
 */
- (Isgl3dPlane *) createProgressBarPlane:(float)width height:(float)height progress:(float)progress vertical:(BOOL)isVertical;
@end

@implementation Isgl3dGLUIProgressBar

@synthesize progressStepSize = _progressStepSize;
@synthesize isSwapped = _isSwapped;

+ (id) progressBarWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height vertical:(BOOL)isVertical {
	return [[[self alloc] initWithMaterial:material width:width height:height vertical:isVertical] autorelease];
}

- (id) initWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height vertical:(BOOL)isVertical {
	
	if ((self = [super initWithMesh:nil andMaterial:material])) {
		[self setWidth:width andHeight:height];
		
		_fullWidth = width;
		_fullHeight = height;
		_progress = 0;
		_isVertical = isVertical;
		_isSwapped = NO;
		
		_progressStepSize = 5;
	}
	
	return self;	
}


- (void) dealloc {
	
	[super dealloc];
}

- (void) setProgress:(float)progress {
	if (progress > 100) {
		progress = 100;
	}

	if (progress <= 0) {
		progress = 0;
	}
	
	if (fabs(_progress - progress) > _progressStepSize || (_progress != progress && progress == 0) || (_progress != progress && progress == 100)) {
		_progress = progress;
		
		[self setMesh:[self createProgressBarPlane:_fullWidth height:_fullHeight progress:progress vertical:_isVertical]];
		if (_isVertical) {
			float height = _fullHeight * _progress / 100.0;
			[self setWidth:_fullWidth andHeight:height];
			if (_isSwapped) {
				[super setX:_originalX andY:_originalY + _fullHeight - height];
			}
		} else {
			float width = _fullWidth * _progress / 100.0;
			[self setWidth:width andHeight:_fullHeight];
			if (_isSwapped) {
				[super setX:_originalX + _fullWidth - width andY:_originalY];
			}
		}
	}
	
}

- (float) progress {
	return _progress;
}

- (void) setX:(unsigned int)x andY:(unsigned int)y {
	[super setX:x andY:y];
	_originalX = x;
	_originalY = y;
}

- (Isgl3dPlane *) createProgressBarPlane:(float)width height:(float)height progress:(float)progress vertical:(BOOL)isVertical {
	if (progress <= 0) {
		return nil;
	}
	
	float reduc = progress * 0.01;
	if (isVertical) {
		if (_isSwapped) {
			return [Isgl3dPlane meshWithGeometryAndUVMap:width height:height*reduc nx:2 ny:2 uvMap:[Isgl3dUVMap uvMapWithUA:0 vA:reduc uB:1 vB:reduc uC:0 vC:0]];
		} else {
			return [Isgl3dPlane meshWithGeometryAndUVMap:width height:height*reduc nx:2 ny:2 uvMap:[Isgl3dUVMap uvMapWithUA:0 vA:0 uB:1 vB:0 uC:0 vC:reduc]];
		}
	} else {
		if (_isSwapped) {
			return [Isgl3dPlane meshWithGeometryAndUVMap:width*reduc height:height nx:2 ny:2 uvMap:[Isgl3dUVMap uvMapWithUA:reduc vA:0 uB:0 vB:0 uC:reduc vC:1]];
		} else {
			return [Isgl3dPlane meshWithGeometryAndUVMap:width*reduc height:height nx:2 ny:2 uvMap:[Isgl3dUVMap uvMapWithUA:0 vA:0 uB:reduc vB:0 uC:0 vC:1]];
		}
	}
}

- (void) setIsSwapped:(BOOL)isSwapped {
	_isSwapped = isSwapped;
	if (isSwapped) {
		self.fixLeft = NO;
	} else {
		self.fixLeft = YES;
	}
	
	// Force re-rendering of progress bar
	float oldProgress = _progress;
	_progress = -1;
	self.progress = oldProgress;
}
@end
