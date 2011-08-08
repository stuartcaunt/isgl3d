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

#import "Isgl3dPVRLoader.h"
#import "Isgl3dLog.h"
#ifdef GL_ES_VERSION_2_0
#import <OpenGLES/ES2/gl.h>
#else
#import <OpenGLES/ES1/gl.h>
#endif
#import "PVRTTextureAPI.h"
#import "PVRTTexture.h"



@implementation Isgl3dPVRLoader

+ (unsigned int) createTextureFromPVR:(NSString *)file outWidth:(unsigned int *)width outHeight:(unsigned int *)height {
	
	unsigned int textureIndex = 0;
	PVR_Texture_Header oldHeader;
	const char *cFileName = [file cStringUsingEncoding:NSUTF8StringEncoding];
	
	if (PVRTTextureLoadFromPVR(cFileName, (GLuint *)&textureIndex, &oldHeader) == PVR_SUCCESS)
	{
		*width = CFSwapInt32LittleToHost(oldHeader.dwWidth);
		*height = CFSwapInt32LittleToHost(oldHeader.dwHeight);
	}			  
	else
	{
		Isgl3dLog(Error, @"Error creating texture from file (%@)", file);
	}
	return textureIndex;
}


@end
