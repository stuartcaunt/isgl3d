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

#import "Isgl3dScene3D.h"
#import "Isgl3dNode.h"

@implementation Isgl3dScene3D

+ (id) scene {
	return [[[self alloc] init] autorelease];
}

- (id) init {
    if ((self = [super init])) {
		_alphaNodes = [[NSMutableArray alloc] init];
		_sortedNodes = [[NSMutableArray alloc] init];
    }
	
    return self;
}

- (void) dealloc {
	[_sortedNodes release];
	[_alphaNodes release];

	[super dealloc];
}

- (void) renderZSortedAlphaObjects:(Isgl3dGLRenderer *)renderer viewMatrix:(Isgl3dMatrix4 *)viewMatrix {

	// Collect in array all transparent objects in the scene
	[self collectAlphaObjects:_alphaNodes];
	
	//Isgl3dLog(Info, @"Number of alphas = %i", [_alphaNodes count]);
	
	// Create a sortable nodes for each of them, with the distance of the object origin to the camera
	for (Isgl3dNode * node in _alphaNodes) {
		float distance = [node getZTransformation:viewMatrix];
		Isgl3dSortableNode * sortableNode = [[Isgl3dSortableNode alloc] initWithDistance:distance forNode:node];
		[_sortedNodes addObject:[sortableNode autorelease]];
	}
	
	// Sort the objects, DESCENGING order by distance
	[_sortedNodes sortUsingSelector:@selector(compareDistances:)];
	
	// Render each node, release SortableNode afterwards
	for (Isgl3dSortableNode * sortableNode in _sortedNodes) {
		[sortableNode.node render:renderer opaque:FALSE];
	}
	
	// Clear arrays
	[_alphaNodes removeAllObjects];
	[_sortedNodes removeAllObjects];
}

@end


#pragma mark Isgl3dSortableNode

@implementation Isgl3dSortableNode

@synthesize distance = _distance;
@synthesize node = _node;

- (id) initWithDistance:(float)distance forNode:(Isgl3dNode *)node {
    if ((self = [super init])) {
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
