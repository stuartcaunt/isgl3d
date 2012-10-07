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

#import "Isgl3dGLUIProgressBar.h"
#import "Isgl3dPlane.h"
#import "Isgl3dUVMap.h"

@implementation Isgl3dGLUIProgressBar

@synthesize progressStepSize = _progressStepSize;
@synthesize isSwapped = _isSwapped;

+ (id)progressBarWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height vertical:(BOOL)isVertical {
	return [[[self alloc] initWithMaterial:material width:width height:height vertical:isVertical] autorelease];
}

- (id)initWithMaterial:(Isgl3dMaterial *)material width:(unsigned int)width height:(unsigned int)height vertical:(BOOL)isVertical {
	
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


- (void)dealloc {
	
	[super dealloc];
}

- (void)setProgress:(float)progress {
	if (progress > 100.0) {
		progress = 100.0;
	}

	if (progress < 0.0) {
		progress = 0.0;
	}
    
    // If nothing has changed, we have nothing to do.
    if (progress == _progress) {
        return;
    }
	
	if (fabs(_progress - progress) >= _progressStepSize || (progress == 0.0) || (progress == 100.0)) {
		_progress = progress;
		
        float reduc = progress / 100.0;
        Isgl3dPlane* plane = nil;
        
		if (_isVertical) {
            // Find the height of the component in full pixels.  Once we have that, find out
            // what the screen reduction is, and use that to scale the UV mapping.  This avoids
            // the texture jitter.
			unsigned int height = _fullHeight * reduc;
			[super setWidth:_fullWidth andHeight:height];
            reduc = (float)height / _fullHeight;
            
            Isgl3dUVMap* uvmap = nil;
			if (_isSwapped) {
				[super setX:_originalX andY:_originalY + _fullHeight - height];
                uvmap = [Isgl3dUVMap uvMapWithUA:0 vA:0 uB:1 vB:0 uC:0 vC:reduc];
            } else {
                uvmap = [Isgl3dUVMap uvMapWithUA:0 vA:1-reduc uB:1 vB:1-reduc uC:0 vC:1];
            }
            plane = [Isgl3dPlane meshWithGeometryAndUVMap:_fullWidth height:height nx:2 ny:2 offsetx:(float)_fullWidth/2 offsety:(float)height/2 uvMap:uvmap];
		} else {
            // Find the width of the component in full pixels.  Once we have that, find out
            // what the screen reduction is, and use that to scale the UV mapping.  This avoids
            // the texture jitter.
			unsigned int width = _fullWidth * reduc;
			[super setWidth:width andHeight:_fullHeight];
            reduc = (float)width / _fullWidth;
            
            Isgl3dUVMap* uvmap = nil;
			if (_isSwapped) {
				[super setX:_originalX + _fullWidth - width andY:_originalY];
                uvmap = [Isgl3dUVMap uvMapWithUA:1-reduc vA:0 uB:1 vB:0 uC:1-reduc vC:1];
			} else {
                uvmap = [Isgl3dUVMap uvMapWithUA:0 vA:0 uB:reduc vB:0 uC:0 vC:1];
            }
            plane = [Isgl3dPlane meshWithGeometryAndUVMap:width height:_fullHeight nx:2 ny:2 offsetx:(float)width/2 offsety:(float)_fullHeight/2 uvMap:uvmap];
		}
        
        [self setMesh:plane];
	}
	
}

- (float) progress {
	return _progress;
}

- (void)setX:(unsigned int)x andY:(unsigned int)y {
	[super setX:x andY:y];
	_originalX = x;
	_originalY = y;
}

- (void)setWidth:(unsigned int)width andHeight:(unsigned int)height {
    _fullWidth = width;
    _fullHeight = height;
    [self setProgress:_progress];
}

- (void)setIsSwapped:(BOOL)isSwapped {
	_isSwapped = isSwapped;
	
	// Force re-rendering of progress bar
	float oldProgress = _progress;
	_progress = -1;
	self.progress = oldProgress;
}

@end
