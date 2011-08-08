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

#import "Isgl3dGLTextureFactoryState.h"


@implementation Isgl3dGLTextureFactoryState

- (id) init {
	
	if ((self = [super init])) {
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (unsigned int) createTextureFromPVR:(NSString *)file outWidth:(unsigned int *)width outHeight:(unsigned int *)height {
	return 0;
}

- (unsigned int) createTextureFromRawData:(void *)data width:(int)width height:(int)height mipmap:(BOOL)mipmap precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	return 0;
}

- (unsigned int) createCubemapTextureFromRawData:(void *)data width:(int)width mipmap:(BOOL)mipmap precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	return 0;
}

- (unsigned int) createTextureFromCompressedTexImageData:(NSArray *)imageData format:(unsigned int)format width:(uint32_t)width height:(uint32_t)height precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	return 0;
}

- (unsigned int) compressionFormatFromString:(NSString *)format {
	return 0;
}

- (void) deleteTextureId:(unsigned int)textureId {
}

- (Isgl3dGLDepthRenderTexture *) createDepthRenderTexture:(int)width height:(int)height {
	return nil;	
}


@end
