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

#import "Isgl3dActionTween.h"
#import "Isgl3dLog.h"

#pragma mark Isgl3dActionTweenTo

@implementation Isgl3dActionTweenTo

+ (id) actionWithDuration:(float)duration property:(NSString *)property value:(float)value {
	return [[[self alloc] initWithDuration:duration property:property value:value] autorelease];
}

- (id) initWithDuration:(float)duration property:(NSString *)property value:(float)value {
	if ((self = [super initWithDuration:duration])) {
		_property = property;
		_finalValue = value;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionTweenTo * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration property:_property value:_finalValue];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	if (![[_target valueForKey:_property] isKindOfClass:[NSNumber class]]) {
		Isgl3dLog(Error, @"Isgl3dActionTweenTo: property %@ cannot be used for tween. Only NSNumber properties can be used", _property);
		_initialValue = _finalValue;
		_delta = 0.0f;
		
	} else {
		NSNumber * initialValue = [_target valueForKey:_property];
		_initialValue = [initialValue floatValue];
		_delta = _finalValue - _initialValue;
	}
}

- (void) update:(float)progress {
	[_target setValue:[NSNumber numberWithFloat:_initialValue + progress * _delta] forKey:_property];
}

@end

#pragma mark Isgl3dActionTweenBy

@implementation Isgl3dActionTweenBy

+ (id) actionWithDuration:(float)duration property:(NSString *)property value:(float)value {
	return [[[self alloc] initWithDuration:duration property:property value:value] autorelease];
}

- (id) initWithDuration:(float)duration property:(NSString *)property value:(float)value {
	if ((self = [super initWithDuration:duration])) {
		_property = property;
		_delta = value;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone*)zone {
	Isgl3dActionTweenBy * copy = [[[self class] allocWithZone:zone] initWithDuration:_duration property:_property value:_delta];

	return copy;
}

-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	if (![[_target valueForKey:_property] isKindOfClass:[NSNumber class]]) {
		Isgl3dLog(Error, @"Isgl3dActionTweenTo: property %@ cannot be used for tween. Only NSNumber properties can be used", _property);
		_initialValue = 0.0f;
		
	} else {
		NSNumber * initialValue = [_target valueForKey:_property];
		_initialValue = [initialValue floatValue];
	}
}

- (void) update:(float)progress {
	[_target setValue:[NSNumber numberWithFloat:_initialValue + progress * _delta] forKey:_property];
}

@end
