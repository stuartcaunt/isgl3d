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
@class Isgl3dSkeletonNode;

/**
 * The Isgl3dAnimationController provides support to automatically animate Isgl3dSkeletonNodes.
 * With start, stop and pause controls, the skeleton can be animated for a given frame rate 
 * (default at 30fps) over a specified number of frames. Once the start method has been called
 * an NSTimer will automatically increase the frame number and update the transformation of the
 * skeleton (meshes and/or bones). The animation can be repeated automatically if desired. 
 * 
 * Manual changes in the frame can also be achieved if desired (either explicitly set or incremented).
 * Pausing the animation will retain the current frame number for the next start command. Stopping the
 * animationg will reset the frame number to 0.
 */
@interface Isgl3dAnimationController : NSObject {

@private
	Isgl3dSkeletonNode * _skeleton;
	unsigned int _currentFrame;
	unsigned int _numberOfFrames;

	BOOL _repeat;
	float _frameRate;
	BOOL _animating;
	
    NSTimer * _animationTimer;
	
}

/**
 * Specifies whether the animation should be repeated or not. 
 * The default value is true.
 */
@property (nonatomic) BOOL repeat;

/**
 * Specifies the desired frame rate for the animation. 
 * The default value is 30fps. 
 */
@property (nonatomic) float frameRate;


/**
 * Allocates and initialises (autorelease) animation controller with a given skeleton and specifies the number of frames.
 * @param skeleton The skeleton to be animated (containing Isgl3dBoneNodes and/or Isgl3dAnimatedMeshes).
 * @param numberOfFrames The number of frames contained in the animation sequence.
 */
+ (id) controllerWithSkeleton:(Isgl3dSkeletonNode *)skeleton andNumberOfFrames:(unsigned int)numberOfFrames;

/**
 * Initialises the animation controller with a given skeleton and specifies the number of frames.
 * @param skeleton The skeleton to be animated (containing Isgl3dBoneNodes and/or Isgl3dAnimatedMeshes).
 * @param numberOfFrames The number of frames contained in the animation sequence.
 */
- (id) initWithSkeleton:(Isgl3dSkeletonNode *)skeleton andNumberOfFrames:(unsigned int)numberOfFrames;

/**
 * Explicitly sets the current frame number and updates the skeleton.
 * If the frame number is greater or equal to the number of frames (0 being the first frame) then
 * the value is ignored.
 * @param frame The desired frame number (between 0 and numberOfFrames - 1)
 */
- (void) setFrame:(unsigned int)frame;

/**
 * Increments the current frame number.
 * If the next frame number is equal to the number of frames (ie at the end of the animation) then either
 * the frame number is set to zero (if repeating animation has been chosen) or it stays at the last frame
 * and the animation stops.
 */
- (void) nextFrame;

/**
 * Starts the animation (if it is not already started). 
 * An NSTimer automatically calls nextFrame for the desired frame rate. 
 */
- (void) start;

/**
 * Stops the animation.
 * The NSTimer (used for automatic animation) is destroyed and the current frame is set to zero.
 */
- (void) stop;

/**
 * Pauses the animation.
 * The NSTimer (used for automatic animation) is destroyed but the current frame number is retained.
 */
- (void) pause;

@end
