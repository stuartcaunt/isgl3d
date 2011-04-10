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

#import "Isgl3dTextureMaterial.h"

/**
 * The Isgl3dAnimatedTextureMaterial is used to render animations on to a mesh or particle. The animation is generated
 * through a series of images (each one used to create a texture in the GPU).
 * 
 * The running of the animation and the framerate are configurable.
 */
@interface Isgl3dAnimatedTextureMaterial : Isgl3dTextureMaterial {
	
@private
	NSMutableArray * _textureList;
	NSArray * _textureFilenameList;
	
	NSString *_animationName;
	unsigned int _numberOfFrames;
	unsigned int _currentFrameID;
	BOOL _isRunning;
	float _frameRate;
	
	NSTimeInterval _lastFrameChangeTimestamp;
	NSDate *_date;
}

/**
 * Returns the name of the animation.
 */
@property (readonly) NSString *animationName;

/**
 * Returns the number of frames contained in the animation.
 */
@property (readonly) unsigned int numberOfFrames;

/**
 * Current animation frame ID. First index is 0.
 */
@property (readonly) unsigned int currentFrameID;

/**
 * Returns the status of the animation, whether it is running or not. Default value is YES.
 */
@property (readonly) BOOL isRunning;

/**
 * Frame rate in number of images per second. Default value is 24.
 */
@property (readonly) float frameRate;


/**
 * Allocates and initialises (autorelease) material with an array of texture file names, each file producing a new frame in the animation.
 * Note that all texture files for this animation must have the same format (compression, shininess and precision, etc).
 *
 * @param textureFilenameList List of texture file names for each animation frame (NSString instances).
 * @param animationName The name for the animation.
 * @param shininess The shiness of the material.
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the material will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the material will be repeated (tesselated) across the rendered object in the y-direction.
 */
+ (id) materialWithTextureFiles:(NSArray *)textureFilenameList animationName:(NSString *)animationName 
			 shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Allocates and initialises (autorelease) material with a format for the file names and a start and end index, each file produces a new frame in the animation.
 * The file names are generated automatically given the format and indices for example a format of "bird-animation-%2d.pvr" with first index 0 
 * and last index 2 produces the following file names: bird-animation-00.pvr, bird-animation-01.pvr and bird-animation-02.pvr.
 * Note that all texture files for this animation must have the same format (compression, shininess and precision, etc).
 *
 * @param textureFilenameFormat The format for the file names.
 * @param textureFirstID The first index of the file names.
 * @param textureLastID The last index of the file names.
 * @param animationName The name for the animation.
 * @param shininess The shiness of the material.
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the material will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the material will be repeated (tesselated) across the rendered object in the y-direction.
 * 
 */
+ (id) materialWithTextureFilenameFormat:(NSString *)textureFilenameFormat textureFirstID:(int)textureFirstID textureLastID:(int)textureLastID
						   animationName:(NSString *)animationName 
						  shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Initialises the material with an array of texture file names, each file producing a new frame in the animation.
 * Note that all texture files for this animation must have the same format (compression, shininess and precision, etc).
 *
 * @param textureFilenameList List of texture file names for each animation frame (NSString instances).
 * @param animationName The name for the animation.
 * @param shininess The shiness of the material.
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the material will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the material will be repeated (tesselated) across the rendered object in the y-direction.
 */
- (id) initWithTextureFiles:(NSArray *)textureFilenameList animationName:(NSString *)animationName 
			 shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Initialises the material with a format for the file names and a start and end index, each file produces a new frame in the animation.
 * The file names are generated automatically given the format and indices for example a format of "bird-animation-%2d.pvr" with first index 0 
 * and last index 2 produces the following file names: bird-animation-00.pvr, bird-animation-01.pvr and bird-animation-02.pvr.
 * Note that all texture files for this animation must have the same format (compression, shininess and precision, etc).
 *
 * @param textureFilenameFormat The format for the file names.
 * @param textureFirstID The first index of the file names.
 * @param textureLastID The last index of the file names.
 * @param animationName The name for the animation.
 * @param shininess The shiness of the material.
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the material will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the material will be repeated (tesselated) across the rendered object in the y-direction.
 * 
 */
- (id) initWithTextureFilenameFormat:(NSString *)textureFilenameFormat textureFirstID:(int)textureFirstID textureLastID:(int)textureLastID
						   animationName:(NSString *)animationName 
						  shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

#pragma mark Animation control methods

/**
 * Starts the animation at frame 0 and loops when last frame is reached.
 */
- (void) startAnimation;

/**
 * Stops the animation.
 */
- (void) stopAnimation;

/**
 * Resumes the animation from the last frame number before stopAnimation being called.
 */
- (void) resumeAnimation;

/**
 * Goes to a specific frame in the animation.
 * @param frameID The desired frame index. 
 * @return YES if the passed frameID is valid.
 */
- (BOOL) gotoAnimationFrame:(unsigned int)frameID;

/**
 * Sets the frame rate for the animation in frames per second. The default value is 24.
 * @param frameRate Frame rate in number of frames per second. 
 */
- (void) setFrameRate:(float)frameRate;

@end
