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

#import "Isgl3dGLTextureFactory.h"
#import "Isgl3dGLTextureFactoryState.h"
#import "Isgl3dGLTexture.h"
#import "Isgl3dLog.h"
#import "Isgl3dDirector.h"

#define PVR_TEXTURE_FLAG_TYPE_MASK	0xff

static Isgl3dGLTextureFactory * _instance = nil;
static char gPVRTexIdentifier[4] = "PVR!";

enum {
	kPVRTextureFlagTypePVRTC_2 = 24,
	kPVRTextureFlagTypePVRTC_4
};

typedef struct _PVRTexHeader {
	uint32_t headerLength;
	uint32_t height;
	uint32_t width;
	uint32_t numMipmaps;
	uint32_t flags;
	uint32_t dataLength;
	uint32_t bpp;
	uint32_t bitmaskRed;
	uint32_t bitmaskGreen;
	uint32_t bitmaskBlue;
	uint32_t bitmaskAlpha;
	uint32_t pvrTag;
	uint32_t numSurfs;
} PVRTexHeader;


@interface Isgl3dGLTextureFactory (PrivateMethods)
/**
 * @result (autorelease) GLTexture created from compressed image file
 */
- (Isgl3dGLTexture *) createTextureFromCompressedFile:(NSString *)file precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * @result (autorelease) UIImage from specified path
 */
- (UIImage *) loadImage:(NSString *)path;
- (void) copyImage:(UIImage *)image toRawData:(void *)data;

/**
 * @result (autorelease) NSArray with image data
 */
- (NSArray *) unpackPVRData:(NSData *)data width:(unsigned int)width height:(unsigned int)height;

/**
 * @result (autorelease) NSString with texture key
 */
- (NSString *) textureKeyForFile:(NSString *)file precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;
@end

@implementation Isgl3dGLTextureFactory

- (id) init {
	
	if ((self = [super init])) {
		_textures = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	if (_state) {
		[_state release]; 
	}
	
	[_textures release];
	
	[super dealloc];
}

+ (Isgl3dGLTextureFactory *) sharedInstance {
	
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dGLTextureFactory alloc] init];
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

- (void) setState:(Isgl3dGLTextureFactoryState *)state {

	if (state != _state) {
		if (_state) {
			[_state release];
			_state = nil;
		}
		
		if (state) {
			_state = [state retain];
		}
	}
}

- (void) clear {
	[_textures removeAllObjects];
}

- (Isgl3dGLTexture *) createTextureFromFile:(NSString *)file precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	NSString * extension = [file pathExtension];
	if ([extension isEqualToString:@"pvr"]) {
		return [self createTextureFromCompressedFile:file precision:precision repeatX:repeatX repeatY:repeatY];
	}
	
	if (_state) {
		NSString * textureKey = [self textureKeyForFile:file precision:precision repeatX:repeatX repeatY:repeatY];
		Isgl3dGLTexture * texture = [_textures objectForKey:textureKey];
		if (texture) {
			return texture;
		}
	
		
		UIImage * image = [self loadImage:file];
		if (!image) {
			Isgl3dLog(Error, @"Isgl3dGLTextureFactory: image %@ cannot be loaded", file);
			return nil;
		}
		
		unsigned int width = CGImageGetWidth(image.CGImage);
		unsigned int height = CGImageGetHeight(image.CGImage);
	
		void * data = malloc(width * height * 4);
		[self copyImage:image toRawData:data];
		unsigned int textureId = [_state createTextureFromRawData:data width:width height:height mipmap:YES precision:precision repeatX:repeatX repeatY:repeatY];
		free(data);
		
		// Create texture and store in dictionary
		texture = [[Isgl3dGLTexture alloc] initWithId:textureId width:width height:height];
		[_textures setObject:texture forKey:textureKey];
		
		return [texture autorelease];		
	}

	Isgl3dLog(Error, @"Isgl3dGLTextureFactory.createTextureFromFile: not initialised with factory state");
	return nil;
}

- (Isgl3dGLTexture *) createTextureFromText:(NSString *)text fontName:(NSString*)name fontSize:(CGFloat)size repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	if (_state) {
		if ([text length] == 0) {
			return nil;
		}
		
		
		CGSize dimensions = [text sizeWithFont:[UIFont fontWithName:name size:size]];
		CGSize contentSize = CGSizeMake(dimensions.width, dimensions.height);
		
		UITextAlignment alignment = UITextAlignmentCenter;
		
		unsigned int i;
		unsigned int width = dimensions.width;
		if ((width != 1) && (width & (width - 1))) {
			i = 1;
			while (i < width) {
				i *= 2;
			}
			width = i;
		}
		unsigned int height = dimensions.height;
		if ((height != 1) && (height & (height - 1))) {
			i = 1;
			while (i < height) {
				i *= 2;
			}
			height = i;
		}
		
		void * data = malloc(width * height * 4);
		memset(data, 0, (int)(width * height * 4));
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
		CGColorSpaceRelease(colorSpace);
	
		CGContextTranslateCTM(context, 0.0f, height);
		CGContextScaleCTM(context, 1.0f, -1.0f);
		UIGraphicsPushContext(context);
//		CGContextSetGrayFillColor(context, 0.5f, 1.0f);
//		CGContextFillRect(context, CGRectMake (0.0, 0.0, dimensions.width, dimensions.height));
		CGContextSetGrayFillColor(context, 1.0f, 1.0f);
	
		UIFont * uiFont = [UIFont fontWithName:name size:size];
	    [text drawInRect:CGRectMake(0, 0, dimensions.width, dimensions.height) withFont:uiFont lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
		
		if (!uiFont) {
			Isgl3dLog(Error, @"GLTextureFactory: Font '%@' not found", name);
		}
		UIGraphicsPopContext();
		
		unsigned int textureId = [_state createTextureFromRawData:data width:width height:height mipmap:YES precision:GLTEXTURE_MEDIUM_PRECISION repeatX:repeatX repeatY:repeatY];
		
		CGContextRelease(context);
		free(data);

		return [[[Isgl3dGLTexture alloc] initWithId:textureId width:width height:height contentSize:contentSize] autorelease];		

	}

	Isgl3dLog(Error, @"GLTextureFactory.createTextureFromText: not initialised with factory state");
	return nil;
}

- (Isgl3dGLTexture *) createTextureFromText:(NSString *)text fontName:(NSString*)name fontSize:(CGFloat)size {
	return [self createTextureFromText:text fontName:name fontSize:size repeatX:NO repeatY:NO];
}


- (Isgl3dGLTexture *) createTextureFromCompressedFile:(NSString *)file precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	if (_state) {
		NSString * textureKey = [self textureKeyForFile:file precision:precision repeatX:repeatX repeatY:repeatY];
		Isgl3dGLTexture * texture = [_textures objectForKey:textureKey];
		if (texture) {
			return texture;
		}

		// cut filename into name and extension
		NSString * extension = [file pathExtension];
		NSString * origFileName = [file stringByDeletingPathExtension];

		NSString * fileName = origFileName;
		if ([Isgl3dDirector sharedInstance].retinaDisplayEnabled) {
			fileName = [origFileName stringByAppendingString:@"-hd"];
		}
	

		NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];  
		NSData * data = [NSData dataWithContentsOfFile:filePath];

		if ([data bytes] == 0) {
			Isgl3dLog(Error, @"Error loading compressed image file %@.%@", fileName, extension);
			
			
			if ([Isgl3dDirector sharedInstance].retinaDisplayEnabled) {
				Isgl3dLog(Info, @"Trying %@...", file);

				fileName = origFileName;
				filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];  
				data = [NSData dataWithContentsOfFile:filePath];

				if ([data bytes] == 0) {
					Isgl3dLog(Error, @"Error loading compressed image file %@", file);

					return nil;
				}
			}
		}

		PVRTexHeader * header = (PVRTexHeader *)[data bytes];
		unsigned int width = CFSwapInt32LittleToHost(header->width);
		unsigned int height = CFSwapInt32LittleToHost(header->height);
				
		uint32_t flags = CFSwapInt32LittleToHost(header->flags);
		uint32_t formatFlags = flags & PVR_TEXTURE_FLAG_TYPE_MASK;
		
		if (formatFlags == kPVRTextureFlagTypePVRTC_4 || formatFlags == kPVRTextureFlagTypePVRTC_2) {

			unsigned int internalFormat;
			if (formatFlags == kPVRTextureFlagTypePVRTC_4) {
				internalFormat = [_state compressionFormatFromString:@"GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG"];
			} else if (formatFlags == kPVRTextureFlagTypePVRTC_2) {
				internalFormat = [_state compressionFormatFromString:@"GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG"];
			}

			NSArray * imageData = [self unpackPVRData:data width:width height:height];
			if ([imageData count] > 0) {
				
				unsigned int textureId = [_state createTextureFromCompressedTexImageData:imageData format:internalFormat width:width height:height precision:precision repeatX:repeatX repeatY:repeatY];

				// Create texture and store in dictionary
				texture = [[Isgl3dGLTexture alloc] initWithId:textureId width:width height:height];
				[_textures setObject:texture forKey:textureKey];
				
				return [texture autorelease];		
			
			} else {
				Isgl3dLog(Error, @"PVR file%@.%@ contains no image data", fileName, extension);
			}
		
		} else {
				Isgl3dLog(Error, @"File %@.%@ is not of a recognised PVR format", fileName, extension);
		}
		
	} else {
		Isgl3dLog(Error, @"Isgl3dGLTextureFactory.createTextureFromCompressedFile: not initialised with factory state");
	}

	return nil;	
}


- (Isgl3dGLTexture *) createCubemapTextureFromFiles:(NSArray *)files precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {

	if (_state) {
		NSMutableArray * images = [[NSMutableArray alloc] init];

		BOOL compressed = NO;

		for (NSString * file in files) {
			[images addObject:[self loadImage:file]];

			NSString * extension = [file pathExtension];
			if ([extension isEqualToString:@"pvr"]) {
				compressed = YES;
			}
		}

		if (compressed) {
			Isgl3dLog(Error, @"Cubemaps using compressed images is not yet available");
			[images release];
			return nil;
		}


		if ([images count] != 6) {
			Isgl3dLog(Error, @"Generation of cubmap texture requires 6 images: only %i given", [images count]);
			[images release];
			return nil;
		}
	
		UIImage * posXImage = [images objectAtIndex:0];
		UIImage * negXImage = [images objectAtIndex:1];
		UIImage * posYImage = [images objectAtIndex:2];
		UIImage * negYImage = [images objectAtIndex:3];
		UIImage * posZImage = [images objectAtIndex:4];
		UIImage * negZImage = [images objectAtIndex:5];
	
		unsigned int width = CGImageGetWidth(posXImage.CGImage);
		unsigned int height = CGImageGetHeight(posXImage.CGImage);
		
		if (height != width) {
			Isgl3dLog(Error, @"Generation of cubmap texture requires images of equal width and height");
			[images release];
			return nil;
		}
		
		if (CGImageGetWidth(negXImage.CGImage) != width ||
			CGImageGetHeight(negXImage.CGImage) != width ||
			CGImageGetWidth(posYImage.CGImage) != width ||
			CGImageGetHeight(posYImage.CGImage) != width ||
			CGImageGetWidth(negYImage.CGImage) != width ||
			CGImageGetHeight(negYImage.CGImage) != width ||
			CGImageGetWidth(posZImage.CGImage) != width ||
			CGImageGetHeight(posZImage.CGImage) != width ||
			CGImageGetWidth(negZImage.CGImage) != width ||
			CGImageGetHeight(negZImage.CGImage) != width) {
			Isgl3dLog(Error, @"Generation of cubmap texture requires all images to be the same size");
			[images release];
			return nil;
		}
		
		
		unsigned int stride = width * height * 4; 
		void * data = malloc(stride * 6);
		unsigned int offset = 0;
	
		[self copyImage:posXImage toRawData:data + offset];
		offset += stride;
		[self copyImage:negXImage toRawData:data + offset];
		offset += stride;
		[self copyImage:posYImage toRawData:data + offset];
		offset += stride;
		[self copyImage:negYImage toRawData:data + offset];
		offset += stride;
		[self copyImage:posZImage toRawData:data + offset];
		offset += stride;
		[self copyImage:negZImage toRawData:data + offset];
	
		unsigned int textureId = [_state createCubemapTextureFromRawData:data width:width mipmap:YES precision:precision repeatX:repeatX repeatY:repeatY];
		
		free(data);
		[images release];
		
		return [[[Isgl3dGLTexture alloc] initWithId:textureId width:width height:height] autorelease];		
	}

	Isgl3dLog(Error, @"Isgl3dGLTextureFactory.createCubemapTextureFromFiles: not initialised with factory state");
	return nil;
}

- (Isgl3dGLDepthRenderTexture *) createDepthRenderTexture:(int)width height:(int)height {
	if (_state) {
		return [_state createDepthRenderTexture:width height:height];
	}

	Isgl3dLog(Error, @"Isgl3dGLTextureFactory.createDepthRenderTexture: not initialised with factory state");
	return nil;
}



- (void) deleteTexture:(Isgl3dGLTexture *)texture {
	if (_state) {
		[_state deleteTextureId:texture.textureId];
	} else {
		Isgl3dLog(Error, @"Isgl3dGLTextureFactory.deleteTexture: not initialised with factory state");
	}
}




- (UIImage *) loadImage:(NSString *)path {
	// cut filename into name and extension
	NSString * extension = [path pathExtension];
	NSString * origFileName = [path stringByDeletingPathExtension];
	
	NSString * fileName = origFileName;
	if ([Isgl3dDirector sharedInstance].retinaDisplayEnabled) {
		fileName = [origFileName stringByAppendingString:@"-hd"];
	}
	
	NSData *texData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:extension]];
    UIImage *image = [[UIImage alloc] initWithData:texData];
   	[texData release];
    
	if (image == nil) {
		Isgl3dLog(Error, @"Failed to load %@.%@", fileName, extension);
		
		if ([Isgl3dDirector sharedInstance].retinaDisplayEnabled) {
			Isgl3dLog(Info, @"Trying %@...", path);
			[image release];
            
			texData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:origFileName ofType:extension]];
		    image = [[UIImage alloc] initWithData:texData];
		   	[texData release];
			
			if (image == nil) {
				Isgl3dLog(Error, @"Failed to load %@.%@", origFileName, extension);
			}
				
		}
		
	}
    return [image autorelease];	

}

- (void) copyImage:(UIImage *)image toRawData:(void *)data {
	int width = CGImageGetWidth(image.CGImage);
	int height = CGImageGetHeight(image.CGImage);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	CGContextClearRect(context, CGRectMake(0, 0, width, height));
	CGContextTranslateCTM(context, 0, height - height);
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
	CGContextRelease(context);
}


- (NSArray *) unpackPVRData:(NSData *)data width:(unsigned int)width height:(unsigned int)height {

	uint32_t dataLength = 0, dataOffset = 0, dataSize = 0;
	uint32_t blockSize = 0, widthBlocks = 0, heightBlocks = 0;
	uint32_t bpp = 4;
	
	PVRTexHeader *header = (PVRTexHeader *)[data bytes];
	uint32_t pvrTag = CFSwapInt32LittleToHost(header->pvrTag);

	if (gPVRTexIdentifier[0] != ((pvrTag >>  0) & 0xff) ||
		gPVRTexIdentifier[1] != ((pvrTag >>  8) & 0xff) ||
		gPVRTexIdentifier[2] != ((pvrTag >> 16) & 0xff) ||
		gPVRTexIdentifier[3] != ((pvrTag >> 24) & 0xff)) {
			return nil;
	}
	
	uint32_t flags = CFSwapInt32LittleToHost(header->flags);
	uint32_t formatFlags = flags & PVR_TEXTURE_FLAG_TYPE_MASK;
	
	NSMutableArray * imageData = [[NSMutableArray alloc] initWithCapacity:10];
		
	dataLength = CFSwapInt32LittleToHost(header->dataLength);
	
	uint8_t * bytes = ((uint8_t *)[data bytes]) + sizeof(PVRTexHeader);
	
	// Calculate the data size for each texture level and respect the minimum number of blocks
	while (dataOffset < dataLength) {
		if (formatFlags == kPVRTextureFlagTypePVRTC_4) {
			blockSize = 4 * 4; // Pixel by pixel block size for 4bpp
			widthBlocks = width / 4;
			heightBlocks = height / 4;
			bpp = 4;
		} else {
			blockSize = 8 * 4; // Pixel by pixel block size for 2bpp
			widthBlocks = width / 8;
			heightBlocks = height / 4;
			bpp = 2;
		}
		
		// Clamp to minimum number of blocks
		if (widthBlocks < 2) {
			widthBlocks = 2;
		}
		if (heightBlocks < 2) {
			heightBlocks = 2;
		}

		dataSize = widthBlocks * heightBlocks * ((blockSize  * bpp) / 8);
		
		[imageData addObject:[NSData dataWithBytes:bytes+dataOffset length:dataSize]];
		
		dataOffset += dataSize;
		
		width = MAX(width >> 1, 1);
		height = MAX(height >> 1, 1);
	}
				  
	
	return [imageData autorelease];
}


- (NSString *) textureKeyForFile:(NSString *)file precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	return [NSString stringWithFormat:@"%@%i%i%i", file, precision, repeatX, repeatY];
}


@end
