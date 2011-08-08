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

#import <UIKit/UIKit.h>
#import "Isgl3dDirector.h"
#import "Isgl3dNode.h"


@interface Isgl3dGestureManager : UIGestureRecognizer
{
@private
	Isgl3dDirector *_director;
	
	NSMutableArray *_gestureRecognizers;
	// dictionary of delegates for which we act as a proxy
	NSMutableDictionary *_recognizerDelegates;
	// dictionary for the relation of nodes to their gesture recognizers
	NSMutableDictionary *_trackedNodes;
	
	// dictionary of active touches and the nodes belonging to them
	NSMutableDictionary *_touchRecognizersDictionary;
	// dictionary of touches and the nodes they belong to
	NSMutableDictionary *_touchNodes;
}
- (id)initWithIsgl3dDirector:(Isgl3dDirector *)aDirector;

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer forNode:(Isgl3dNode *)node;
- (void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer fromNode:(Isgl3dNode *)node;
- (void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (id<UIGestureRecognizerDelegate>)delegateForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (void)setGestureRecognizerDelegate:(id<UIGestureRecognizerDelegate>)aDelegate forGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

- (NSArray *)gestureRecognizersForNode:(Isgl3dNode *)node;

- (Isgl3dNode *)nodeForTouch:(UITouch *)touch;

@end
