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

#import "Isgl3dAnimatedTextureMaterial.h"
#import "Isgl3dMaterial.h"
#import "Isgl3dPrimitive.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dGLTextureFactory.h"

@implementation Isgl3dAnimatedTextureMaterial

@synthesize animationName = _animationName;
@synthesize isRunning = _isRunning;
@synthesize numberOfFrames = _numberOfFrames;
@synthesize currentFrameID = _currentFrameID;
@synthesize frameRate = _frameRate;

+ (id) materialWithTextureFiles:(NSArray *)textureFilenameList animationName:(NSString *)animationName 
					shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	return [[[self alloc] initWithTextureFiles:textureFilenameList animationName:animationName shininess:shininess 
					precision:precision repeatX:repeatX repeatY:repeatY] autorelease];	
}

+ (id) materialWithTextureFilenameFormat:(NSString *)textureFilenameFormat textureFirstID:(int)textureFirstID textureLastID:(int)textureLastID
					animationName:(NSString *)animationName 
					shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	return [[[self alloc] initWithTextureFilenameFormat:textureFilenameFormat textureFirstID:textureFirstID textureLastID:textureLastID
	  				animationName:animationName shininess:shininess precision:precision repeatX:repeatX repeatY:repeatY] autorelease];	
}


- (id) initWithTextureFiles:(NSArray *)textureFilenameList animationName:(NSString *)animationName 
			 shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	
	if ([textureFilenameList count] > 0 &&
		(self = [super initWithTextureFile:[textureFilenameList objectAtIndex:0] shininess:shininess precision:precision repeatX:repeatX repeatY:repeatY])) {
		
		_animationName = [animationName retain];
		_textureFilenameList = [textureFilenameList retain];
		_textureList = [[NSMutableArray array] retain];
		_date = [[NSDate date] retain];
		_lastFrameChangeTimestamp = -1;
		
		_numberOfFrames = [_textureFilenameList count];
		_isRunning = YES;
		_frameRate = 24;	// In number of frames per second.



		NSEnumerator *enumerator = [_textureFilenameList objectEnumerator];
		NSString *textureFilename;
		while ((textureFilename = [enumerator nextObject])) {
			_texture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromFile:textureFilename precision:precision repeatX:repeatX repeatY:repeatY] retain];
			if (_texture == nil) {
				@throw [NSException exceptionWithName:@"NSException" 
											   reason:[[[@"Bad texture file '" stringByAppendingString:textureFilename] stringByAppendingString:@"' for AnimatedTextureMaterial"] stringByAppendingString:_animationName]
											 userInfo:nil];  
			}
			[_textureList addObject:_texture];
		}
		if ([_textureList count] != [_textureFilenameList count]) {
			@throw [NSException exceptionWithName:@"NSException" 
										   reason:[@"Bad texture files for AnimatedTextureMaterial" stringByAppendingString:_animationName]
										 userInfo:nil]; 
		}
		
		[self gotoAnimationFrame:0];
	}
	
	return self;
}

- (id) initWithTextureFilenameFormat:(NSString *)textureFilenameFormat textureFirstID:(int)textureFirstID textureLastID:(int)textureLastID
			  animationName:(NSString *)animationName 
			 shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	
	NSMutableArray *textureFileNameList = [NSMutableArray array];
	NSString *fileName;
	for (int i = textureFirstID; i <= textureLastID; i++) {
		fileName = [NSString stringWithFormat:textureFilenameFormat, i];
		[textureFileNameList addObject:fileName];
	}
	self = [self initWithTextureFiles:textureFileNameList animationName:animationName shininess:shininess precision:precision repeatX:repeatX repeatY:repeatY];
	return self;
}
				
- (void) dealloc {
	[_animationName release];
	[_textureFilenameList release];
	[_textureList release];
	[_date release];
	
	_textureList = nil;
	_animationName = nil;
    _textureFilenameList = nil;
	_date = nil;
	
	[super dealloc];		
}
				

- (void) prepareRenderer:(Isgl3dGLRenderer *)renderer requirements:(unsigned int)requirements alpha:(float)alpha node:(Isgl3dNode *)node {

	// Control animation
	if (_isRunning == YES) {
		NSTimeInterval timePassed = [_date timeIntervalSinceNow] * -1000.0;		// Time interval between now and _date creation, in milli-secs.
		if (_lastFrameChangeTimestamp != -1) {
			int newFrameID = fmod(_currentFrameID + (timePassed - _lastFrameChangeTimestamp) * 0.001 * _frameRate, _numberOfFrames);
			
			if (newFrameID != _currentFrameID) {
				_lastFrameChangeTimestamp = timePassed;
				_currentFrameID = newFrameID;
				_texture = [_textureList objectAtIndex:_currentFrameID];
			}
	
//			// Display animation at max CPU speed
//			_currentFrameID ++;
//			if (_currentFrameID >= _numberOfFrames) {
//				_currentFrameID = 0;
//			}
//			_lastFrameChangeTimestamp = timePassed;
//			_texture = [_textureList objectAtIndex:_currentFrameID];
		} 
		else {	
			// Force first frame to be displayed when begining the animation 
			_lastFrameChangeTimestamp = timePassed;
		}
		
	}
	
	[super prepareRenderer:renderer requirements:requirements alpha:alpha node:node];
}


#pragma mark Animation control methods

- (void) startAnimation {
	[self gotoAnimationFrame:0];
	_isRunning = YES;
}

- (void) stopAnimation {
	_isRunning = NO;
}

- (void) resumeAnimation {
	_isRunning = YES;
}

- (BOOL) gotoAnimationFrame:(unsigned int)frameID {
	if (frameID < _numberOfFrames) {
		_currentFrameID = frameID;

		_texture = [_textureList objectAtIndex:_currentFrameID];
		
		if (frameID == 0) {
			_lastFrameChangeTimestamp = -1;
		}		
		return YES;
	}
	return NO;
}

- (void) setFrameRate:(float)frameRate {
	_frameRate = frameRate;
}



@end
