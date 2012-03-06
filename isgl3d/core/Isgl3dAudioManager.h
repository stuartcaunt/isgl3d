/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2012 Harishankar Narayanan
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
#import "Isgl3dVector3.h"


@class Isgl3dAudioData;
@class ALBuffer;
@class ALDevice;
@class ALContext;


@interface Isgl3dAudioManager : NSObject {
    NSMutableDictionary * _audioDatas;
}

/**
 * Returns the the shader Isgl3dGLTextureFactory instance.
 */
+ (Isgl3dAudioManager *)sharedInstance;

/**
 * Resets and deallocates the shared instance.
 */
+ (void)resetInstance;

/**
 * Removes all previously created audio from the dictionary.
 */
- (void)clear;

/**
 * Creates a new instance of an Isgl3dGLTexture from a given file (or reuses an existing one if it already exists) with default precision (Isgl3dTexturePrecisionMedium),
 * without repeating in x and y.
 * @param file The name of the file containing the image information (.png, .jpg, .pvr, etc)
 * @result an autoreleased Isgl3dGLTexture created from image file
 */
- (ALBuffer *)createAudioDataFromFile:(NSString *)file;

- (void)setListenerPosition:(Isgl3dVector3)position;

@end
