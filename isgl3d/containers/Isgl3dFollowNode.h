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

#import "Isgl3dNode.h"
#import "Isgl3dVector.h"

/**
 * The Isgl3dFollowNode is a node designed to follow the movement of a target node.
 * 
 * As the target node moves the direction of movement is calculated. The Isgl3dFollowNode will have
 * the same position in space as the target, but will align itself along the direction of movement.
 * 
 * For example, if a ball is rolling across a surface and a camera should follow then an Isgl3dFollowNode
 * is useful. The ball is rotating so a child node will rotate with it: what is more useful is to follow the
 * direction of movement.  
 */
@interface Isgl3dFollowNode : Isgl3dNode {

@private
	Isgl3dNode * _target;

	Isgl3dVector3 _oldTargetPosition;
	Isgl3dMatrix4 _targetMovementIT;
	
	BOOL _isFirstUpdate;
	
	BOOL _keepHorizontal;
}

/**
 * For targets moving in three dimensions this property can force the z-axis of the node to remain
 * in the horizontal.
 */
@property (nonatomic) BOOL keepHorizontal;

/**
 * Allocates and initialises (autorelease) Isgl3dFollowNode with a target node.
 * @param target The target node.
 */
+ (id) nodeWithTarget:(Isgl3dNode *)target;

/**
 * Initialises the Isgl3dFollowNode with a target node.
 * @param target The target node.
 */
- (id) initWithTarget:(Isgl3dNode *)target;

@end
