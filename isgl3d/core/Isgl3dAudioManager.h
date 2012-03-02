//
//  Isgl3dAudioManager.h
//  isgl3d
//
//  Created by Harishankar Narayanan on 01/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
+ (Isgl3dAudioManager *) sharedInstance;

/**
 * Resets and deallocates the shared instance.
 */
+ (void) resetInstance;

/**
 * Removes all previously created audio from the dictionary.
 */
- (void) clear;

/**
 * Creates a new instance of an Isgl3dGLTexture from a given file (or reuses an existing one if it already exists) with default precision (Isgl3dTexturePrecisionMedium),
 * without repeating in x and y.
 * @param file The name of the file containing the image information (.png, .jpg, .pvr, etc)
 * @result an autoreleased Isgl3dGLTexture created from image file
 */
- (ALBuffer *) createAudioDataFromFile:(NSString *)file;

- (void) setListenerPosition:(Isgl3dMatrix4)mat;

@end
