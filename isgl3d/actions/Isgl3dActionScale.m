/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2011 Stuart Caunt
 * 
 * This class is inspired from equivalent functionality provided by cocos2d :
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
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

#import "Isgl3dActionScale.h"
#import "Isgl3dNode.h"

#pragma mark Isgl3dActionScaleTo

@implementation Isgl3dActionScaleTo


+ (id) actionWithDuration:(float)duration scale:(float)scale {
	return [[[self alloc] initWithDuration:duration scale:scale] autorelease];
}

- (id) initWithDuration:(float)duration scale:(float)scale {
	if ((self = [super initWithDuration:duration])) {
		_finalScale = iv3(scale, scale, scale);
	}
	
	return self;
}

+ (id) actionWithDuration:(float)duration scaleX:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ {
	return [[[self alloc] initWithDuration:duration scaleX:scaleX scaleY:scaleY scaleZ:scaleZ] autorelease];
}

- (id) initWithDuration:(float)duration scaleX:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ {
	if ((self = [super initWithDuration:duration])) {
		_finalScale = iv3(scaleX, scaleY, scaleZ);
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionScaleTo * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration scaleX:_finalScale.x scaleY:_finalScale.y scaleZ:_finalScale.z];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	Isgl3dNode * node = (Isgl3dNode *)target;
	
	_initialScale = iv3(node.scaleX, node.scaleY, node.scaleZ);
	_vector = iv3(_finalScale.x - _initialScale.x, _finalScale.y - _initialScale.y, _finalScale.z - _initialScale.z);
}

- (void) update:(float)progress {
	[_target setScale:_initialScale.x + progress * _vector.x scaleY:_initialScale.y + progress * _vector.y scaleZ:_initialScale.z + progress * _vector.z];
}

@end

#pragma mark Isgl3dActionScaleBy

@implementation Isgl3dActionScaleBy


+ (id) actionWithDuration:(float)duration scale:(float)scale {
	return [[[self alloc] initWithDuration:duration scale:scale] autorelease];
}

- (id) initWithDuration:(float)duration scale:(float)scale {
	if ((self = [super initWithDuration:duration])) {
		_finalScaling = iv3(scale, scale, scale);
	}
	
	return self;
}

+ (id) actionWithDuration:(float)duration scaleX:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ {
	return [[[self alloc] initWithDuration:duration scaleX:scaleX scaleY:scaleY scaleZ:scaleZ] autorelease];
}

- (id) initWithDuration:(float)duration scaleX:(float)scaleX scaleY:(float)scaleY scaleZ:(float)scaleZ {
	if ((self = [super initWithDuration:duration])) {
		_finalScaling = iv3(scaleX, scaleY, scaleZ);
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionScaleBy * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration scaleX:_finalScaling.x scaleY:_finalScaling.y scaleZ:_finalScaling.z];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	Isgl3dNode * node = (Isgl3dNode *)target;
	
	_initialScale = iv3(node.scaleX, node.scaleY, node.scaleZ);
	Isgl3dVector3 finalScale = iv3(_initialScale.x * _finalScaling.x, _initialScale.y * _finalScaling.y, _initialScale.z * _finalScaling.z);
	_vector = iv3(finalScale.x - _initialScale.x, finalScale.y - _initialScale.y, finalScale.z - _initialScale.z);
}

- (void) update:(float)progress {
	[_target setScale:_initialScale.x + progress * _vector.x scaleY:_initialScale.y + progress * _vector.y scaleZ:_initialScale.z + progress * _vector.z];
}

@end
