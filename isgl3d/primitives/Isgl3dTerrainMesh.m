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

#import "Isgl3dTerrainMesh.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"
#import "Isgl3dLog.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>


@interface Isgl3dTerrainMesh (PrivateMethods) 
- (UIImage *) loadImage:(NSString *)path;
@end


@implementation Isgl3dTerrainMesh

+ (id) meshWithTerrainDataFile:(NSString *)terrainDataFile channel:(unsigned int)channel width:(float)width depth:(float)depth height:(float)height nx:(int)nx nz:(int)nz {
	return [[[self alloc] initWithTerrainDataFile:terrainDataFile channel:channel width:width depth:depth height:height nx:nx nz:nz] autorelease];
}

- (id) initWithTerrainDataFile:(NSString *)terrainDataFile channel:(unsigned int)channel width:(float)width depth:(float)depth height:(float)height nx:(int)nx nz:(int)nz {
	if ((self = [super init])) {
		_terrainDataFile = [terrainDataFile retain];
		_channel = channel;
		
		_width = width;
		_depth = depth;
		_height = height;
		_nx = nx;
		_nz = nz;
		
		[self constructVBOData];
	}
	
	return self;
}

- (void) dealloc {
	[_terrainDataFile release];
	
    [super dealloc];
}

- (void) fillVertexData:(Isgl3dFloatArray *)vertexData andIndices:(Isgl3dUShortArray *)indices {

	// Create UIImage
	UIImage * terrainDataImage = [self loadImage:_terrainDataFile];
	
	// Get raw data from image
	unsigned int imageWidth = terrainDataImage.size.width;  
	unsigned int imageHeight = terrainDataImage.size.height;   
	unsigned char * pixelData = malloc(imageWidth * imageHeight * 4);  
	   
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(pixelData, imageWidth, imageHeight, 8, imageWidth * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	CGContextClearRect(context, CGRectMake(0, 0, imageWidth, imageHeight));
	CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), terrainDataImage.CGImage);  
	CGContextRelease(context);  

	// Create array of heights
	unsigned int heightDataNx = _nx + 1;
	unsigned int heightDataNy = _nz + 1;
	
	float * terrainHeightData = malloc(heightDataNx * heightDataNy * sizeof(float));
	
	// Iterate once to get all terrain data needed in a simple array
	for (int j = 0; j <= _nz; j++) {
		unsigned int pixelY = (j * imageHeight) / _nz;
		if (pixelY >= imageHeight) {
			pixelY = imageHeight - 1;
		}

		for (int i = 0; i <= _nx; i++) {
			unsigned int pixelX = (i * imageWidth) / _nx;
			if (pixelX >= imageWidth) {
				pixelX = imageWidth - 1;
			}
						
			float pixelValue = pixelData[(pixelY * imageWidth + pixelX) * 4 + _channel] / 255.0;
			terrainHeightData[j * heightDataNx + i] = pixelValue * _height;
		}
	}		
	
	float dx = _width / _nx;
	float dz = _depth / _nz;
	
	free (pixelData);
	

	// Iterate again, this time calculating normal values
	for (int i = 0; i <= _nx; i++) {
		float x = -(_width / 2) + i * (_width / _nx);
		float u = 1.0 * i / _nx;	

		for (int j = 0; j <= _nz; j++) {
			float z = -(_depth / 2) + j * (_depth / _nz);
			float v = 1.0 * j / _nz;	
	
			// get height from terrain height data array
			float y = terrainHeightData[j * heightDataNx + i]; 		
						
			[vertexData add:x];
			[vertexData add:y];
			[vertexData add:z];

			// Calculate normal data (simple linear centered difference calculation)
			float hi0;
			float hi1;
			float hj0;
			float hj1;
			if (i > 0) {
				hi0 = terrainHeightData[j * heightDataNx + i - 1];
			} else {
				hi0 = y;
			}
			if (i < _nx) {
				hi1 = terrainHeightData[j * heightDataNx + i + 1];
			} else {
				hi1 = y;
			}
			if (j > 0) {
				hj0 = terrainHeightData[(j - 1) * heightDataNx + i];
			} else {
				hj0 = y;
			}
			if (j < _nz) {
				hj1 = terrainHeightData[(j + 1) * heightDataNx + i];
			} else {
				hj1 = y;
			}

			float nx = hi0 - hi1;
			float ny = 2 * (dx + dz);
			float nz = hj0 - hj1;
			float nLength = sqrt(nx * nx + ny * ny + nz * nz);
			nx = nx / nLength;
			ny = ny / nLength;
			nz = nz / nLength;
			
			[vertexData add:nx];
			[vertexData add:ny];
			[vertexData add:nz];

			[vertexData add:u];
			[vertexData add:v];
		}
	}
	
	for (int i = 0; i < _nx; i++) {
		for (int j = 0; j < _nz; j++) {
			
			int first = i * (_nz + 1) + j;			
			int second = first + (_nz + 1);
			int third = first + 1;
			int fourth = second + 1;
			
			[indices add:first];
			[indices add:third];
			[indices add:second];
				
			[indices add:third];
			[indices add:fourth];
			[indices add:second];
		}
	}


	free (terrainHeightData);

}

- (unsigned int) estimatedVertexSize {
	return (_nx + 1) * (_nz + 1) * 8;
}

- (unsigned int) estimatedIndicesSize {
	return _nx * _nz * 6;
}

- (UIImage *) loadImage:(NSString *)path {
	// cut filename into name and extension
	NSString * extension = [path pathExtension];
	NSString * fileName = [path stringByDeletingPathExtension];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
	if (!filePath) {
		Isgl3dLog(Error, @"Failed to load %@", path);
		return nil;
	}
	
	NSData * imageData = [[NSData alloc] initWithContentsOfFile:filePath];
    UIImage * image = [[UIImage alloc] initWithData:imageData];
   	[imageData release];
    
	if (image == nil) {
		Isgl3dLog(Error, @"Failed to load %@", path);
	}

	return [image autorelease];	
}
@end
