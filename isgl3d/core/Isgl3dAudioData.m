/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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

#import "Isgl3dAudioData.h"
#import "ALSource.h"
#import "ALBuffer.h"
#import "OpenALManager.h"

@implementation Isgl3dAudioData

- (id) initWithALBuffer:(ALBuffer*)buffer {
    if ((self = [super init])) {
        _audioSource = [[ALSource source] retain];
        _audioSource.minGain = 0;
        _audioBuffer = buffer;
    }
    return self;
}

- (void) setReferenceDistance:(float)rDist {
    _audioSource.referenceDistance = rDist;
}

- (void) setMaxDistance:(float)maxDist {
    _audioSource.maxDistance = maxDist;
}

- (void) setPosition:(Isgl3dVector3)position {
    _audioSource.position = alpoint(position.x, position.y, position.z);
}

- (void) playAudio:(BOOL)loop {
    [_audioSource play:_audioBuffer loop:loop];
}

@end
