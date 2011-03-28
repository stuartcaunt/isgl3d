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

#import "Isgl3dTween.h"
#import <objc/runtime.h>
#import "Isgl3dLog.h"

@interface Isgl3dTween (PrivateMethods)
- (void) handleParameters:(NSDictionary *)parameters;
- (float) tweenFunc:(float)progression;
- (float) easeOutBounce:(float)progression;
- (float) easeOutThrow:(float)progression;
@end

@implementation Isgl3dTween

@synthesize object = _object;

- (id)init {
	return [super init];
}

- (id) initWithObject:(id)object forParameters:(NSDictionary *)parameters {
	if ((self = [super init])) {
		_object = object;
		_startTime = [[NSDate alloc] init];
		_isCompleted = NO;

		_initialValues = [[NSMutableDictionary alloc] init];
		_finalValues = [[NSMutableDictionary alloc] init];
		
		[self handleParameters:parameters];
	}
	return self;
}

- (void) dealloc {
	
	[_initialValues release];
	[_finalValues release];
	[_transition release];
	
	[_startTime release];
	
	if (_onCompleteTarget) {
		[_onCompleteTarget release];
	}
	
	[super dealloc];
}


- (void) handleParameters:(NSDictionary *)parameters {
	for (NSString * key in parameters) {
		if ([key isEqualToString:TWEEN_DURATION]) {
			// Verify that time is a NSNumber
			if (![[parameters objectForKey:key] isKindOfClass:[NSNumber class]]) {
				Isgl3dLog(Error, @"Tweener: value passed for time property must be NSNumber");
				
			} else {
				_duration = [[parameters objectForKey:key] floatValue];
			}
		
		} else if ([key isEqualToString:TWEEN_TRANSITION]) {
			// Verify that transistion is a NSString
			if (![[parameters objectForKey:key] isKindOfClass:[NSString class]]) {
				Isgl3dLog(Error, @"Tweener: value passed for transition property must be NSString");
				
			} else {
				_transition = [[parameters objectForKey:key] retain];
			}		
		
		} else if ([key isEqualToString:TWEEN_ON_COMPLETE_TARGET]) {
			_onCompleteTarget = [[parameters objectForKey:key] retain];
		
		} else if ([key isEqualToString:TWEEN_ON_COMPLETE_SELECTOR]) {
			// Verify that transistion is a NSString
			if (![[parameters objectForKey:key] isKindOfClass:[NSString class]]) {
				Isgl3dLog(Error, @"Tweener: value passed for onCompleteSelector property must be NSString");
				
			} else {
				_onCompleteSelector = NSSelectorFromString([parameters objectForKey:key]);
			}
		
		} else {
			@try {
				
				// Verify that property value is an NSNumber
				if (![[_object valueForKey:key] isKindOfClass:[NSNumber class]]) {
					Isgl3dLog(Error, @"Tweener: propety %@ cannot be used for tween. Only NSNumber properties can be used", key);
					
				} else {
					NSNumber * initialValue = [_object valueForKey:key];
				
					[_initialValues setObject:initialValue forKey:key];
					[_finalValues setObject:[parameters objectForKey:key] forKey:key];
				}
				
			
			} 
			@catch (NSException * e) {
				Isgl3dLog(Error, @"Tweener: unknown property: %@ for object of type %s", key, object_getClassName(_object));
			}
			
		}
		
	}
}

- (BOOL) isCompleted {
	return _isCompleted;
}

- (NSArray *) properties {
	return [_finalValues allKeys];
}

- (void) removeProperty:(NSString *)property {
	[_finalValues removeObjectForKey:property];
	[_initialValues removeObjectForKey:property];
}

- (BOOL) isEmpty {
	return [_finalValues count] == 0;
	
}

- (void) update:(NSDate *)currentTime {
	NSTimeInterval timeInterval = [currentTime timeIntervalSinceDate:_startTime];
	
	// Check to see if this is the last tween
	if (timeInterval >= _duration) {
		timeInterval = _duration;
		
		_isCompleted = YES;
	}
	
	// Iterate over all properties and apply tween
	for (NSString * key in _initialValues) {
		float initialValue = [[_initialValues objectForKey:key] floatValue];
		float finalValue = [[_finalValues objectForKey:key] floatValue];
		
		float newValue;
		if (_isCompleted) {
			newValue = finalValue;	
		} else {
			newValue = initialValue + (finalValue - initialValue) * [self tweenFunc:timeInterval / _duration];
		}
		
		if (_object) {
			[_object setValue:[NSNumber numberWithFloat:newValue] forKey:key];
		}
	} 
	
}

- (void) onComplete {
	
	if (_onCompleteTarget != nil) {
		if ([_onCompleteTarget respondsToSelector:_onCompleteSelector]) {
			[_onCompleteTarget performSelector:_onCompleteSelector withObject:_object];
		} else {
			Isgl3dLog(Error, @"Tween: Cannot perform onComplete as %s does not respond to %@", object_getClassName(_onCompleteTarget), NSStringFromSelector(_onCompleteSelector));
		}
	} 
}

/**
 * Calculate the tween function from progression [0..1]
 */
- (float) tweenFunc:(float)progression {
	
	if ([_transition isEqualToString:TWEEN_FUNC_LINEAR]) {
		return progression;
		
	} else if ([_transition isEqualToString:TWEEN_FUNC_EASEINSINE]) {
		return 1.0 - cos(progression * M_PI / 2.0);

	} else if ([_transition isEqualToString:TWEEN_FUNC_EASEOUTSINE]) {
		return sin(progression * M_PI / 2.0);

	} else if ([_transition isEqualToString:TWEEN_FUNC_EASEINOUTSINE]) {
		return 0.5 * (1.0 + sin(1.5 * M_PI + progression * M_PI));

	} else if ([_transition isEqualToString:TWEEN_FUNC_EASEOUTBOUNCE]) {
		return [self easeOutBounce:progression];

	} else if ([_transition isEqualToString:TWEEN_FUNC_EASEINBOUNCE]) {
		return 1.0 - [self easeOutBounce:1.0 - progression];

	} else if ([_transition isEqualToString:TWEEN_FUNC_EASEOUTTHROW]) {
		return [self easeOutThrow:progression];

	} else if ([_transition isEqualToString:TWEEN_FUNC_EASEINTHROW]) {
		return 1.0 - [self easeOutThrow:1.0 - progression];

	} 
	
	
	return progression;
}

- (float) easeOutBounce:(float)progression {
	// calculted with rebound speed = f * incoming speed
	float f = 0.7;
	float t1 = 1.0 / (2.0*f*f*f + 2.0*f*f + 2.0*f + 1.0);
	float t2 = t1 * (1.0 + 2 * f);
	float t3 = t1 * (1.0 + 2*f + 2*f*f);

	float g = 2.0 / (t1*t1);
	
	float v1 = g * t1;
	float v2 = f * v1;
	float v3 = f * v2;
	float v4 = f * v3;
	
	if (progression < t1) {
		return 0.5 * g * progression * progression;
		
	} else if (progression < t2) {
		float dt = progression - t1;
		return 1.0 - (v2 * dt - 0.5 * g * dt * dt);
		
	} else if (progression < t3) {
		float dt = progression - t2;
		return 1.0 - (v3 * dt - 0.5 * g * dt * dt);
		
	} else {
		float dt = progression - t3;
		return 1.0 - (v4 * dt - 0.5 * g * dt * dt);
	}
}

- (float) easeOutThrow:(float)progression {
	float f = 0.2;
	float g = 2 * (1.0 + 2 * f + 2 * sqrt(f * (1 + f)));
	float v0 = sqrt(2 * g * (1 + f));
	
	return v0 * progression - 0.5 * g * progression * progression;
}

@end
