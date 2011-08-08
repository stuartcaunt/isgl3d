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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Isgl3dNode;

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dTouchedObject3D : NSObject {
	    
@private
	Isgl3dNode * _object;
	NSMutableSet * _previousLocations;
	NSMutableSet * _newTouches;
}
@property (nonatomic, readonly) Isgl3dNode *object;

- (id) initWithObject:(Isgl3dNode *)object;
- (void) addTouch:(UITouch *)touch;
- (void) removeTouch:(UITouch *)touch;
- (void) moveTouch:(UITouch *)touch;

- (BOOL) respondsToObject:(Isgl3dNode *)object;
- (BOOL) respondsToLocation:(NSString *)location;
- (BOOL) hasNoTouches;

- (void) startEventCycle;
- (void) fireEventForType:(NSString *)eventType;

@end
