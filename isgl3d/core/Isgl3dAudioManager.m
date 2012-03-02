//
//  Isgl3dAudioManager.m
//  isgl3d
//
//  Created by Harishankar Narayanan on 01/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

- (void) setListenerPosition:(Isgl3dMatrix4)mat {
    [OpenALManager sharedInstance].currentContext.listener.position = alpoint(mat.m[12], mat.m[13], mat.m[14]);
    [OpenALManager sharedInstance].currentContext.listener.orientation = alorientation(mat.m[12], mat.m[13], mat.m[14], 0, -1, 0);
}

@end
