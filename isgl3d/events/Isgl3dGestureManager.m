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

#import "Isgl3dGestureManager.h"
#import "Isgl3dObject3DGrabber.h"
#import "Isgl3dLog.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@interface Isgl3dDirector (Isgl3dGestureManager)
- (void) renderForEventCapture;
@end


@interface Isgl3dGestureManager () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) Isgl3dDirector *director;
- (Isgl3dNode *)getTouchedObject:(CGPoint)touchPoint;
- (void)removeGestureRecognizerFromView:(UIGestureRecognizer *)gestureRecognizer;
- (void)removeGestureRecognizerDelegate:(UIGestureRecognizer *)gestureRecognizer;
@end


@implementation Isgl3dGestureManager

@synthesize director=_director;
@dynamic delegate;


#pragma mark -
#
- (id)initWithTarget:(id)target action:(SEL)action
{
	return nil;
}

- (id)initWithIsgl3dDirector:(Isgl3dDirector *)aDirector
{
	if (self = [super initWithTarget:nil action:nil])
	{
		self.cancelsTouchesInView = NO;
		self.delaysTouchesBegan = NO;
		self.delaysTouchesEnded = NO;
		
		self.delegate = self;
		self.director = aDirector;
		[[_director openGLView] addGestureRecognizer:self];
		
		_gestureRecognizers = [[NSMutableArray alloc] initWithCapacity:1];
		_recognizerDelegates = [[NSMutableDictionary alloc] initWithCapacity:1];
		_trackedNodes = [[NSMutableDictionary alloc] initWithCapacity:1];
		
		_touchRecognizersDictionary = [[NSMutableDictionary alloc] initWithCapacity:4];
		_touchNodes = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	return self;
}

- (void)dealloc
{
	for (UIGestureRecognizer *gestureRecognizer in _gestureRecognizers)
		[[_director openGLView] removeGestureRecognizer:gestureRecognizer];
	[[_director openGLView] removeGestureRecognizer:self];
	
	[_gestureRecognizers release];
	_gestureRecognizers = nil;
	[_recognizerDelegates release];
	_recognizerDelegates = nil;
	[_trackedNodes release];
	_trackedNodes = nil;
	
	[_touchRecognizersDictionary release];
	_touchRecognizersDictionary = nil;
	[_touchNodes release];
	_touchNodes = nil;
	
	[super dealloc];
}

- (id<UIGestureRecognizerDelegate>)delegateForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
	id<UIGestureRecognizerDelegate> recognizerDelegate = nil;
	if (gestureRecognizer != nil)
	{
		NSNumber *recognizerHash = [NSNumber numberWithUnsignedInteger:[gestureRecognizer hash]];
		recognizerDelegate = [_recognizerDelegates objectForKey:recognizerHash];
	}
	return recognizerDelegate;
}

- (void)setGestureRecognizerDelegate:(id<UIGestureRecognizerDelegate>)aDelegate forGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
	if (aDelegate == nil)
	{
		[self removeGestureRecognizerDelegate:gestureRecognizer];
	}
	else
	{
		NSNumber *recognizerHash = [NSNumber numberWithUnsignedInteger:[gestureRecognizer hash]];		
		[_recognizerDelegates setObject:aDelegate forKey:recognizerHash];
	}
}

- (NSArray *)gestureRecognizersForNode:(Isgl3dNode *)node
{
	NSArray *nodeRecognizers = nil;
	
	id nodeKey;	
	if (node == nil)
	{
		nodeKey = [NSNull null];
	}
	else
	{
		nodeKey = [NSNumber numberWithUnsignedInteger:[node hash]];
	}	
	nodeRecognizers = [_trackedNodes objectForKey:nodeKey];
		
	return nodeRecognizers;
}

- (void)removeGestureRecognizerDelegate:(UIGestureRecognizer *)gestureRecognizer
{
	NSNumber *recognizerHash = [NSNumber numberWithUnsignedInteger:[gestureRecognizer hash]];		
	[_recognizerDelegates removeObjectForKey:recognizerHash];
}

- (Isgl3dNode *)getTouchedObject:(CGPoint)touchPoint
{
	unsigned int eventX = (unsigned int)touchPoint.x * _director.contentScaleFactor;
	unsigned int eventY = (unsigned int)touchPoint.y * _director.contentScaleFactor;
	
	// Get pixel color associated with touch
	NSString *colorString = [_director getPixelString:eventX y:eventY];
	
	// Get object associated with pixel colour (if one exists)
	Isgl3dNode *touchedObject = [[Isgl3dObject3DGrabber sharedInstance] getObjectWithColorString:colorString];
	return touchedObject;
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer forNode:(Isgl3dNode *)node
{
	if (!gestureRecognizer)
		return;
	
	id nodeKey;	
	if (node == nil)
	{
		nodeKey = [NSNull null];
	}
	else
	{
		nodeKey = [NSNumber numberWithUnsignedInteger:[node hash]];
	}
	
	NSArray *nodeRecognizers = [_trackedNodes objectForKey:nodeKey];
	
	// check if this is the first gesture recognizer for this node
	if (nodeRecognizers == nil)
	{
		nodeRecognizers = [[NSArray alloc] initWithObjects:gestureRecognizer, nil];
	}
	else
	{
		// skip adding the recognizer if it was already added for this node
		if ([nodeRecognizers indexOfObject:gestureRecognizer] != NSNotFound)
			return;
		
		// add the gesture recognizer to the list for the node
		NSMutableArray *newNodeRecognizers = [[NSMutableArray alloc] initWithArray:nodeRecognizers];
		[newNodeRecognizers addObject:gestureRecognizer];
		nodeRecognizers = [[NSArray alloc] initWithArray:newNodeRecognizers];
		[newNodeRecognizers release];
	}		
	[_trackedNodes setObject:nodeRecognizers forKey:nodeKey];
	[nodeRecognizers release];
	
	// in contrast to the UIGestureRecgonizer class it is allowed to add a gesture recognizer
	// multiple times for different nodes
	if ([_gestureRecognizers indexOfObject:gestureRecognizer] != NSNotFound)
		return;
	
	// proxy the gesture recognizer delegation and save original gesture recognizer delegate
	if (gestureRecognizer.delegate != nil)
		[self setGestureRecognizerDelegate:gestureRecognizer.delegate forGestureRecognizer:gestureRecognizer];
	gestureRecognizer.delegate = self;
	
	[[_director openGLView] addGestureRecognizer:gestureRecognizer];
	[_gestureRecognizers addObject:gestureRecognizer];
}

- (void)removeGestureRecognizerFromView:(UIGestureRecognizer *)gestureRecognizer
{
	// remove us as the proxy delegate from the gesture recognizer
	gestureRecognizer.delegate = [self delegateForGestureRecognizer:gestureRecognizer];
	[self removeGestureRecognizerDelegate:gestureRecognizer];
	
	[[_director openGLView] removeGestureRecognizer:gestureRecognizer];
	[_gestureRecognizers removeObject:gestureRecognizer];
}

- (void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer fromNode:(Isgl3dNode *)node
{
	if (!gestureRecognizer)
		return;
	
	NSUInteger index = [_gestureRecognizers indexOfObject:gestureRecognizer];
	if (index == NSNotFound)
		return;
	
	id nodeKey;	
	if (node == nil)
	{
		nodeKey = [NSNull null];
	}
	else
	{
		nodeKey = [NSNumber numberWithUnsignedInteger:[node hash]];
	}
	
	NSArray *nodeRecognizers = [_trackedNodes objectForKey:nodeKey];
	
	// nothing to do if this gesture recognizer isn't associated to the specified node
	if (nodeRecognizers == nil)
		return;
	
	index = [nodeRecognizers indexOfObject:gestureRecognizer];
	if (index != NSNotFound)
	{
		// remove the gesture recognizer from the dictionary of gesture recognizers for the node
		NSMutableArray *newNodeRecognizers = [[NSMutableArray alloc] initWithArray:nodeRecognizers];
		[newNodeRecognizers removeObjectAtIndex:index];
		nodeRecognizers = [[NSArray alloc] initWithArray:newNodeRecognizers];
		[newNodeRecognizers release];
		[_trackedNodes setObject:nodeRecognizers forKey:nodeKey];
		[nodeRecognizers release];
	}
	
	// check if this gesture recognizer is still part of other nodes
	for (NSNumber *trackedNodeKey in _trackedNodes)
	{
		nodeRecognizers = [_trackedNodes objectForKey:trackedNodeKey];
		if ([nodeRecognizers indexOfObject:gestureRecognizer] != NSNotFound)
			return;
	}
	
	// finally completely remove the gesture recognizer
	[self removeGestureRecognizerFromView:gestureRecognizer];
}

- (void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
	if (!gestureRecognizer)
		return;
	
	NSUInteger index = [_gestureRecognizers indexOfObject:gestureRecognizer];
	if (index == NSNotFound)
		return;
	
	// remove the gesture recognizer from all tracked nodes
	NSArray *trackedNodeKeys = [_trackedNodes allKeys];
	for (NSNumber *nodeKey in trackedNodeKeys)
	{
		NSArray *nodeRecognizers = [_trackedNodes objectForKey:nodeKey];
		NSUInteger index = [nodeRecognizers indexOfObject:gestureRecognizer];
		if (index != NSNotFound)
		{
			NSMutableArray *newNodeRecognizers = [[NSMutableArray alloc] initWithArray:nodeRecognizers];
			[newNodeRecognizers removeObjectAtIndex:index];
			nodeRecognizers = [[NSArray alloc] initWithArray:newNodeRecognizers];
			[newNodeRecognizers release];
			[_trackedNodes setObject:nodeRecognizers forKey:nodeKey];
			[nodeRecognizers release];
		}
	}
	
	// completely remove this gesture recognizer from the view
	[self removeGestureRecognizerFromView:gestureRecognizer];
}

- (Isgl3dNode *)nodeForTouch:(UITouch *)touch
{
	Isgl3dNode *node = nil;
	if (touch != nil)
	{
		NSNumber *touchHash = [NSNumber numberWithUnsignedInteger:[touch hash]];
		node = [_touchNodes objectForKey:touchHash];
	}
	return node;
}


#pragma mark -
#pragma mark UIGestureRecognizer subclass implementations
#
- (void)reset
{
	[super reset];
	
	[_touchRecognizersDictionary removeAllObjects];
	[_touchNodes removeAllObjects];
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
	//BOOL prevent = [super canPreventGestureRecognizer:preventedGestureRecognizer];
	//return prevent;
	return NO;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
	//BOOL prevent = [super canBePreventedByGestureRecognizer:preventingGestureRecognizer];
	//return prevent;
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	if (self.state == UIGestureRecognizerStateFailed)
		return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	self.state = UIGestureRecognizerStateRecognized;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	
	self.state = UIGestureRecognizerStateFailed;
}


#pragma mark -
#pragma mark UIGestureRecognizerDelegate methods to handle all delegate messages intended for the recognizers we own
#
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	BOOL shouldReceive = (gestureRecognizer == self);
	
	// Check if we've already processed / hit tested this touch
	NSNumber *touchHash = [NSNumber numberWithUnsignedInteger:[touch hash]];
	NSArray *touchRecognizers = [_touchRecognizersDictionary objectForKey:touchHash];
	
	if (touchRecognizers == nil)
	{
		//Isgl3dLog(Debug, @" ++++  getting touched object for touch %X", [touchHash unsignedIntegerValue]);
		
		[_director.openGLView switchToStandardBuffers];
		
		// render for the event capturing
		[_director renderForEventCapture];
		
		CGPoint touchPoint = [touch locationInView:touch.view];
		Isgl3dNode *touchedNode = [self getTouchedObject:touchPoint];

		[_director.openGLView switchToMsaaBuffers];
		
		if (touchedNode != nil)
		{	
			// get the gesture recognizers for this node
			NSNumber *touchedNodeHash = [NSNumber numberWithUnsignedInteger:[touchedNode hash]];
			NSArray *nodeGestureRecognizers = [_trackedNodes objectForKey:touchedNodeHash];
			touchRecognizers = nodeGestureRecognizers;
			
			[_touchNodes setObject:touchedNode forKey:touchHash];
		}
		else
		{
			// get the gesture recognizers which handle touches without a node involved
			touchRecognizers = [_trackedNodes objectForKey:[NSNull null]];
		}
		
		if (touchRecognizers == nil)
			touchRecognizers = [NSArray array];
		
		[_touchRecognizersDictionary setObject:touchRecognizers forKey:touchHash];
	}
	
	// check if the gesture recognizer is valid for the current touch
	if ([touchRecognizers indexOfObject:gestureRecognizer] != NSNotFound)
	{
		shouldReceive = YES;
		
		id<UIGestureRecognizerDelegate> recognizerDelegate = [self delegateForGestureRecognizer:gestureRecognizer];
		if ((recognizerDelegate != nil) && [recognizerDelegate respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)])
			shouldReceive = [recognizerDelegate gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
	}
	
	return shouldReceive;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	BOOL shouldRecognize = YES;
	
	id<UIGestureRecognizerDelegate> recognizerDelegate = [self delegateForGestureRecognizer:gestureRecognizer];
	if ((recognizerDelegate != nil) && ([recognizerDelegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]))
		shouldRecognize = [recognizerDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
	
	return shouldRecognize;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	BOOL shouldBegin = YES;
	
	id<UIGestureRecognizerDelegate> recognizerDelegate = [self delegateForGestureRecognizer:gestureRecognizer];
	if ((recognizerDelegate != nil) && ([recognizerDelegate respondsToSelector:@selector(gestureRecognizerShouldBegin:)]))
		shouldBegin = [recognizerDelegate gestureRecognizerShouldBegin:gestureRecognizer];
	
	return shouldBegin;
}


@end

