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
 * Easing actions Elastic, Back and Bounce based on code from:
 * http://github.com/NikhilK/silverlightfx/
 * by http://github.com/NikhilK
 * 
 * Others from cocos2d:
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 */

#import "Isgl3dActionEase.h"

#pragma mark Isgl3dActionEase

@implementation Isgl3dActionEase

+ (id) actionWithAction:(Isgl3dActionInterval *)action {
	return [[[self alloc] initWithAction:action] autorelease];
}

- (id)initWithAction:(Isgl3dActionInterval *)action {
	if ((self = [super initWithDuration:action.duration])) {
		_action = [action retain];
	}
	return self;
}

- (void) dealloc {
	[_action release];
	
	[super dealloc];
}

- (id) copyWithZone:(NSZone *)zone {
	Isgl3dAction * copy = [[[self class] allocWithZone:zone] initWithAction:[[_action copy] autorelease]];

	return copy;
}


-(void) startWithTarget:(id)target {
	[super startWithTarget:target];
	[_action startWithTarget:_target];
}

- (void) update:(float)progress {
	// To be over-ridden
	[_action update:progress];
}

@end


#pragma mark Isgl3dActionEaseRate

@implementation Isgl3dActionEaseRate

+ (id) actionWithAction:(Isgl3dActionInterval *)action rate:(float)rate {
	return [[[self alloc] initWithAction:action rate:rate] autorelease];
}

- (id)initWithAction:(Isgl3dActionInterval *)action rate:(float)rate {
	if ((self = [super initWithAction:action])) {
		_rate = rate;
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (id) copyWithZone:(NSZone *)zone {
	Isgl3dAction * copy = [[[self class] allocWithZone:zone] initWithAction:[[_action copy] autorelease] rate:_rate];

	return copy;
}

@end

#pragma mark Isgl3dActionEaseIn

@implementation Isgl3dActionEaseIn
- (void) update:(float)progress {
	[_action update:powf(progress, _rate)];
}
@end

#pragma mark Isgl3dActionEaseOut

@implementation Isgl3dActionEaseOut
- (void) update:(float)progress {
	[_action update:powf(progress, 1.0f/_rate)];
}
@end

#pragma mark Isgl3dActionEaseInOut

@implementation Isgl3dActionEaseInOut
- (void) update:(float)progress {
	int sign = 1;
	int r = (int)_rate;
	
	if (r % 2 == 0) {
		sign = -1;
	}
	
	progress *= 2.0f;
	
	if (progress < 1) { 
		[_action update:0.5f * powf(progress, _rate)];
	} else {
		[_action update:sign * 0.5f * (powf(progress - 2.0f, _rate) + sign * 2.0f)];
	}	
}
@end

#pragma mark Isgl3dActionEaseExponentialIn

@implementation Isgl3dActionEaseExponentialIn
- (void) update:(float)progress {
	[_action update:(progress == 0.0f) ? 0.0f : powf(2.0f, 10.0f * (progress - 1.0f)) - 0.001f];
}
@end

#pragma mark Isgl3dActionEaseExponentialOut

@implementation Isgl3dActionEaseExponentialOut
- (void) update:(float)progress {
	[_action update:(progress == 1.0f) ? 1.0f : (-powf(2.0f, -10.0f * progress) + 1.0f)];
}
@end

#pragma mark Isgl3dActionEaseExponentialInOut

@implementation Isgl3dActionEaseExponentialInOut
- (void) update:(float)progress {
	progress /= 0.5f;
	if (progress < 1) {
		progress = 0.5f * powf(2.0f, 10.0f * (progress - 1.0f));
	} else {
		progress = 0.5f * (-powf(2.0f, -10.0f * (progress - 1.0f) ) + 2.0f);
	}
	
	[_action update:progress];
}
@end

#pragma mark Isgl3dActionEaseSineIn

@implementation Isgl3dActionEaseSineIn
- (void) update:(float)progress {
	[_action update:-1.0f * cosf(0.5f * progress * M_PI) + 1.0f];
}
@end

#pragma mark Isgl3dActionEaseSineOut

@implementation Isgl3dActionEaseSineOut
- (void) update:(float)progress {
	[_action update:sinf(0.5f * progress * M_PI)];
}
@end

#pragma mark Isgl3dActionEaseSineInOut

@implementation Isgl3dActionEaseSineInOut
- (void) update:(float)progress {
	[_action update:-0.5f * (cosf(M_PI * progress) - 1.0f)];
}
@end

#pragma mark Isgl3dActionEaseElastic

@implementation Isgl3dActionEaseElastic

+ (id) actionWithAction:(Isgl3dActionInterval *)action period:(float)period {
	return [[[self alloc] initWithAction:action period:period] autorelease];
}

- (id) initWithAction:(Isgl3dActionInterval *)action {
	return [self initWithAction:action period:0.3f];
}

- (id) initWithAction:(Isgl3dActionInterval *)action period:(float)period {
	if ((self = [super initWithAction:action])) {
		_period = period;
	}
	return self;
}

- (id) copyWithZone:(NSZone *)zone {
	Isgl3dAction * copy = [[[self class] allocWithZone:zone] initWithAction:[[_action copy] autorelease] period:_period];
	return copy;
}

@end

#pragma mark Isgl3dActionEaseElasticIn

@implementation Isgl3dActionEaseElasticIn
- (void) update:(float)progress {
	float newProgress = 0.0f;
	if (progress == 0.0f || progress == 1.0f) {
		newProgress = progress;
	
	} else {
		float s = 0.25f * _period;
		progress = progress - 1.0f;
		newProgress = -powf(2.0f, 10.0f * progress) * sinf((progress - s) * 2.0f * M_PI / _period);
	}
	[_action update:newProgress];
}
@end

#pragma mark Isgl3dActionEaseElasticOut

@implementation Isgl3dActionEaseElasticOut
- (void) update:(float)progress {
	float newProgress = 0.0f;
	if (progress == 0.0f || progress == 1.0f) {
		newProgress = progress;
	
	} else {
		float s = 0.25f * _period;
		newProgress = powf(2.0f, -10.0f * progress) * sinf((progress - s) * 2.0f * M_PI / _period) + 1.0f;
	}
	[_action update:newProgress];
}
@end

#pragma mark Isgl3dActionEaseElasticInOut

@implementation Isgl3dActionEaseElasticInOut
- (void) update:(float)progress {
	float newProgress = 0.0f;
	if (progress == 0.0f || progress == 1.0f) {
		newProgress = progress;
	
	} else {
		progress = progress * 2;
		if(!_period) {
			_period = 0.3f * 1.5f;
		}
		float s = 0.25f * _period;
		
		progress = progress - 1.0f;
		if (progress < 0.0f) {
			newProgress = -0.5f * powf(2.0f, 10.0f * progress) * sinf((progress - s) * 2.0f * M_PI / _period);
		} else {
			newProgress = 0.5f * powf(2.0f, -10.0f * progress) * sinf((progress - s) * 2.0f * M_PI / _period) + 1.0f;
		}
	}
	[_action update:progress];	
}
@end

#pragma mark Isgl3dActionEaseBounce

@implementation Isgl3dActionEaseBounce
- (float) bounceTime:(float)t {
	if (t < 1.0f / 2.75f) {
		return 7.5625f * t * t;
	}
	else if (t < 2.0f / 2.75f) {
		t -= 1.5f / 2.75f;
		return 7.5625f * t * t + 0.75f;
	}
	else if (t < 2.5f / 2.75f) {
		t -= 2.25f / 2.75f;
		return 7.5625f * t * t + 0.9375f;
	}

	t -= 2.625f / 2.75f;
	return 7.5625f * t * t + 0.984375f;
}
@end

#pragma mark Isgl3dActionEaseBounceIn

@implementation Isgl3dActionEaseBounceIn
- (void) update:(float)progress {
	float newProgress = 1.0f - [self bounceTime:1.0f - progress];	
	[_action update:newProgress];
}
@end

#pragma mark Isgl3dActionEaseBounceOut

@implementation Isgl3dActionEaseBounceOut
- (void) update:(float)progress {
	float newProgress = [self bounceTime:progress];	
	[_action update:newProgress];
}
@end

#pragma mark Isgl3dActionEaseBounceInOut

@implementation Isgl3dActionEaseBounceInOut
- (void) update:(float)progress {
	float newProgress = 0.0f;
	if (progress < 0.5f) {
		progress = progress * 2.0f;
		newProgress = (1.0f - [self bounceTime:1.0f - progress] ) * 0.5f;
	
	} else {
		newProgress = [self bounceTime:progress * 2.0f - 1.0f] * 0.5f + 0.5f;
	}
	[_action update:newProgress];
}
@end