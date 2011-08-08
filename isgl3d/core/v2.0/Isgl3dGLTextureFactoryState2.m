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

#import "Isgl3dGLTextureFactoryState2.h"
#import "Isgl3dGLDepthRenderTexture2.h"
#import "Isgl3dGLTexture.h"
#import "Isgl3dLog.h"
#import "Isgl3dPVRLoader.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


@interface Isgl3dGLTextureFactoryState2 (PrivateMethods)
- (unsigned int) createTextureFromRawData:(void *)data width:(int)width height:(int)height mipmap:(BOOL)mipmap precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;
- (unsigned int) createTextureForDepthRender:(int)width height:(int)height;
- (void) handleParameters:(GLenum)target precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;
@end

@implementation Isgl3dGLTextureFactoryState2

- (id) init {
	
	if ((self = [super init])) {
		
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (unsigned int) createTextureFromPVR:(NSString *)file outWidth:(unsigned int *)width outHeight:(unsigned int *)height {
	return [Isgl3dPVRLoader createTextureFromPVR:file outWidth:width outHeight:height];
}

- (unsigned int) createTextureFromRawData:(void *)data width:(int)width height:(int)height mipmap:(BOOL)mipmap precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	
	unsigned int textureIndex;
	glGenTextures(1, &textureIndex);
	glBindTexture(GL_TEXTURE_2D, textureIndex);
	
	[self handleParameters:GL_TEXTURE_2D precision:precision repeatX:repeatX repeatY:repeatY];
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
	
	
	if (mipmap) {
		glGenerateMipmap(GL_TEXTURE_2D);
	}
	
	GLenum err = glGetError();
	if (err != GL_NO_ERROR) {
		Isgl3dGLErrLog(Error, err, @"Error creating texture %i. glError: 0x%04X", textureIndex, err);
	}
	
	return textureIndex;
}

- (unsigned int) createTextureFromCompressedTexImageData:(NSArray *)imageData format:(unsigned int)format width:(uint32_t)width height:(uint32_t)height precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	
	unsigned int textureIndex;
	
	glGenTextures(1, &textureIndex);
	glBindTexture(GL_TEXTURE_2D, textureIndex);
	
	int index = 0;
	for (NSData * data in imageData) {	
		
		glCompressedTexImage2D(GL_TEXTURE_2D, index, format, width, height, 0, [data length], [data bytes]);
		
		GLenum err = glGetError();
		if (err != GL_NO_ERROR) {
			Isgl3dGLErrLog(Error, err, @"Error uploading compressed texture level: %d (format 0x%X, %ux%u, %u bytes). glError: 0x%04X", index, format, width, height, [data length], err);
		}
		
		[self handleParameters:GL_TEXTURE_2D precision:precision repeatX:repeatX repeatY:repeatY];
		
		width = MAX(width >> 1, 1);
		height = MAX(height >> 1, 1);
		index++;
	}
	
	if ([imageData count] == 1) {
		[self handleParameters:GL_TEXTURE_2D precision:precision repeatX:repeatX repeatY:repeatY];
		
		glGenerateMipmap(GL_TEXTURE_2D);
	}
	
	
	return textureIndex;
}


- (unsigned int) createCubemapTextureFromRawData:(void *)data width:(int)width mipmap:(BOOL)mipmap precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	
	unsigned int textureIndex;
	glGenTextures(1, &textureIndex);
	glBindTexture(GL_TEXTURE_CUBE_MAP, textureIndex);
	
	unsigned int stride = width * width * 4;
	unsigned int offset = 0;
	
	glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGBA, width, width, 0, GL_RGBA, GL_UNSIGNED_BYTE, data + offset);
	offset += stride;
	glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGBA, width, width, 0, GL_RGBA, GL_UNSIGNED_BYTE, data + offset);
	offset += stride;
	glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGBA, width, width, 0, GL_RGBA, GL_UNSIGNED_BYTE, data + offset);
	offset += stride;
	glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGBA, width, width, 0, GL_RGBA, GL_UNSIGNED_BYTE, data + offset);
	offset += stride;
	glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGBA, width, width, 0, GL_RGBA, GL_UNSIGNED_BYTE, data + offset);
	offset += stride;
	glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGBA, width, width, 0, GL_RGBA, GL_UNSIGNED_BYTE, data + offset);
	
	[self handleParameters:GL_TEXTURE_CUBE_MAP precision:precision repeatX:repeatX repeatY:repeatY];
	
	if (mipmap) {
		glGenerateMipmap(GL_TEXTURE_CUBE_MAP);
	}
	
	GLenum err = glGetError();
	if (err != GL_NO_ERROR) {
		Isgl3dGLErrLog(Error, err, @"Error creating cubemap texture. glError: 0x%04X", err);
	}
	
	return textureIndex;
}

- (Isgl3dGLDepthRenderTexture *) createDepthRenderTexture:(int)width height:(int)height {
	unsigned int textureIndex = [self createTextureForDepthRender:width height:height];
	
	return [Isgl3dGLDepthRenderTexture2 textureWithId:textureIndex width:width height:height];
}

- (void) deleteTextureId:(unsigned int)textureId {
	glDeleteTextures(1, &textureId);
}

- (unsigned int) compressionFormatFromString:(NSString *)format {
	if ([format isEqualToString:@"GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG"]) {
		return GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;
		
	} else if ([format isEqualToString:@"GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG"]) {
		return GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG;
	}
	
	return 0;
}




- (unsigned int) createTextureForDepthRender:(int)width height:(int)height {
	unsigned int textureIndex;
	glGenTextures(1, &textureIndex);
	glBindTexture(GL_TEXTURE_2D, textureIndex);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, nil);
	//	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, nil);
	
	// LINEAR or NEAREST ? 
	//	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	//	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	return textureIndex;
}

- (void) handleParameters:(GLenum)target precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	if (precision == Isgl3dTexturePrecisionHigh) {
		glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
		glTexParameteri(target, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		
	} else if (precision == Isgl3dTexturePrecisionMedium) {
		glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
		glTexParameteri(target, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		
	} else {
		glTexParameteri(target, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);
		glTexParameteri(target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	}
	
	if (repeatX) {
		glTexParameteri(target, GL_TEXTURE_WRAP_S, GL_REPEAT);
		
	} else {
		glTexParameteri(target, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	}
	
	if (repeatY) {
		glTexParameteri(target, GL_TEXTURE_WRAP_T, GL_REPEAT);
		
	} else {
		glTexParameteri(target, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	}
}

@end
