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

#import "Isgl3dSortableNode.h"
#import "Isgl3dNode.h"

@implementation Isgl3dSortableNode

@synthesize distance = _distance;
@synthesize node = _node;

- (id) initWithDistance:(float)distance forNode:(Isgl3dNode *)node {
    if (self = [super init]) {
    	_distance = distance;
    	
    	_node = [node retain];
    }
	
    return self;
}

- (void) dealloc {
	[_node release];

	[super dealloc];
}

- (NSComparisonResult) compareDistances:(Isgl3dSortableNode *)node {
	NSComparisonResult retVal = NSOrderedSame;
	if (_distance < node.distance) {
		retVal = NSOrderedAscending;
	} else if (_distance > node.distance) { 
		retVal = NSOrderedDescending;
	}
	return retVal;
}

@end
