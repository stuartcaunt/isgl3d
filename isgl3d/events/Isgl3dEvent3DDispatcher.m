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

#import "Isgl3dEvent3DDispatcher.h"
#import "Isgl3dEvent3DListener.h"
#import "Isgl3dEvent3D.h"

@implementation Isgl3dEvent3DDispatcher

- (id) init {

	if ((self = [super init])) {
		_listeners = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void) dealloc {

	[_listeners release];
		
    [super dealloc];
}

- (Isgl3dEvent3DListener *) addEvent3DListener:(id)object method:(SEL)method forEventType:(NSString *)eventType {
	if ([_listeners objectForKey:eventType] == nil) {
		[_listeners setObject:[[[NSMutableArray alloc] init] autorelease] forKey:eventType];
	}
	NSMutableArray * array = [_listeners objectForKey:eventType];
	
	Isgl3dEvent3DListener * listener = [[Isgl3dEvent3DListener alloc] initWithObject:object method:method];
	
	[array addObject:listener];
	
	return [listener autorelease];
}

- (void) removeEvent3DListenerForObject:(id)object method:(SEL)method forEventType:(NSString *)eventType {
	if ([_listeners objectForKey:eventType] == nil) {
		return;
	}
	NSMutableArray * array = [_listeners objectForKey:eventType];
	
	for (Isgl3dEvent3DListener * listener in array) {
		if (listener.object == object && listener.method == method) {
			[array removeObject:listener];
			break;
		}
	}
}

- (void) removeEvent3DListener:(Isgl3dEvent3DListener *)listener {

	for (NSString * eventType in _listeners) {
		NSMutableArray * array = [_listeners objectForKey:eventType];
		if ([array containsObject:listener]) {
			[array removeObject:listener];
			break;
		}
	}	
	
}

- (void) dispatchEvent:(NSSet *)touches forEventType:(NSString *)eventType {
	if ([_listeners objectForKey:eventType] != nil) {
		
		Isgl3dEvent3D * event = [[Isgl3dEvent3D alloc] initWithObject:self forTouches:touches];

		NSArray * array = [_listeners objectForKey:eventType];

		int currentNumberOfListeners = [array count];
		Isgl3dEvent3DListener *listener;
		for (int i = 0; i < currentNumberOfListeners; i ++) {
			listener = [array objectAtIndex:i];
			[listener handleEvent:event];
			if (currentNumberOfListeners != [array count]) {
				// This listener has been removed from the array list
				i--;
				currentNumberOfListeners = [array count];
			}
		}		

		[event release];
	}
}

@end
