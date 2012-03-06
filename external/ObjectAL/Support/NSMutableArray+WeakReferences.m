//
//  MutableArray-WeakReferences.m
//
//  Created by Karl Stenerud on 05/12/09.
//

#import "NSMutableArray+WeakReferences.h"

@implementation NSMutableArray (WeakReferences)

+ (id) newMutableArrayUsingWeakReferencesWithCapacity:(NSUInteger) capacity
{
	CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
	return (__bridge_transfer id)(CFArrayCreateMutable(0, (CFIndex)capacity, &callbacks));
}

+ (id) newMutableArrayUsingWeakReferences
{
	return [self newMutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id) mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger) capacity
{
    id result = [self newMutableArrayUsingWeakReferencesWithCapacity:capacity];
#if !__has_feature(objc_arc)
    [result autorelease];
#endif
    return result;
}

+ (id) mutableArrayUsingWeakReferences
{
	return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

@end

