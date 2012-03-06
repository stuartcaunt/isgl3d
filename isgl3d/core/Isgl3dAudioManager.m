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

#import "Isgl3dAudioManager.h"
#import "Isgl3dAudioData.h"
#import "ObjectAL.h"

static Isgl3dAudioManager *_instance = nil;

@implementation Isgl3dAudioManager

- (id) init {
	NSLog(@"Isgl3dAudioManager::init should not be called on singleton. Instance should be accessed via sharedInstance");
	
	return nil;
}

- (id) initSingleton {
	
	if ((self = [super init])) {
        [OALSimpleAudio sharedInstance];
		[OALSimpleAudio sharedInstance].allowIpod = NO;
		[OALSimpleAudio sharedInstance].honorSilentSwitch = YES;
        [OpenALManager sharedInstance].currentContext.distanceModel = AL_LINEAR_DISTANCE;

		_audioDatas = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	[_audioDatas release];
    
	[super dealloc];
}


+ (Isgl3dAudioManager *) sharedInstance {
    
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dAudioManager alloc] initSingleton];
		}
	}
    
	return _instance;

}

+ (void) resetInstance {
  	if (_instance) {
		[_instance release];
		_instance = nil;
	}
}

- (void) clear {
    [_audioDatas removeAllObjects];
}

- (ALBuffer *) createAudioDataFromFile:(NSString *)file {
    ALBuffer *audioBuffer = [_audioDatas objectForKey:file];
    if (audioBuffer)
        return audioBuffer;

    audioBuffer = [[[OpenALManager sharedInstance] bufferFromFile:file reduceToMono:YES] retain];
    [_audioDatas setObject:audioBuffer forKey:file];
    return audioBuffer;
}

- (void) setListenerPosition:(Isgl3dVector3)position {
    [OpenALManager sharedInstance].currentContext.listener.position = alpoint(position.x, position.y, position.z);
    [OpenALManager sharedInstance].currentContext.listener.orientation = alorientation(position.x, position.y, position.z, 0.0f, -1.0f, 0.0f);
}

@end
