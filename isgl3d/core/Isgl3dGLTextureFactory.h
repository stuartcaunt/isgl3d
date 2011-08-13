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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "isgl3dTypes.h"

@class Isgl3dGLTexture;
@class Isgl3dGLDepthRenderTexture;
@class Isgl3dGLTextureFactoryState;

/**
 * The Isgl3dGLTextureFactory is a singleton class used to create Isgl3dGLTextures for both OpenGL ES1 and ES2.
 * 
 * Textures can be created from standard image files (eg png, jpg, etc), compressed images (pvr format) or text.
 * 
 * Textures are stored in the shared instance in a dictionary avoiding duplication of identical textures. These can be
 * removed by calling the clear method. 
 */
@interface Isgl3dGLTextureFactory : NSObject {

@private
	Isgl3dGLTextureFactoryState * _state;
	
	NSMutableDictionary * _textures;
}

/**
 * Returns the the shader Isgl3dGLTextureFactory instance.
 */
+ (Isgl3dGLTextureFactory *) sharedInstance;

/**
 * Resets and deallocates the shared instance.
 */
+ (void) resetInstance;

/**
 * Sets the state of the Isgl3dGLTextureFactoryState for either OpenGL ES1 or ES2.
 * Note that this is called internally by iSGL3D and should not be called otherwise.
 */
- (void) setState:(Isgl3dGLTextureFactoryState *)state;

/**
 * Removes all previously created textures from the dictionary.
 */
- (void) clear;

/**
 * Creates a new instance of an Isgl3dGLTexture from a given file (or reuses an existing one if it already exists) with default precision (Isgl3dTexturePrecisionMedium),
 * without repeating in x and y.
 * @param file The name of the file containing the image information (.png, .jpg, .pvr, etc)
 * @result an autoreleased Isgl3dGLTexture created from image file
 */
- (Isgl3dGLTexture *) createTextureFromFile:(NSString *)file;

/**
 * Creates a new instance of an Isgl3dGLTexture from a given file (or reuses an existing one if it already exists) with specified precision and repeating behaviour.
 * @param file The name of the file containing the image information (.png, .jpg, .pvr, etc)
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the texture will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the texture will be repeated (tesselated) across the rendered object in the y-direction.
 * @result an autoreleased Isgl3dGLTexture created from image file
 */
- (Isgl3dGLTexture *) createTextureFromFile:(NSString *)file precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Creates a new instance of an Isgl3dGLTexture from a UIImage (or reuses an existing one if it already exists) with default precision (Isgl3dTexturePrecisionMedium),
 * without repeating in x and y.
 * @param image The UIImage to be converted into a texture
 * @param key a unique identifier for the texture to avoid duplicating it for identical UIImages
 * @result an autoreleased Isgl3dGLTexture created from image a UIImage
 */
- (Isgl3dGLTexture *) createTextureFromUIImage:(UIImage *)image key:(NSString *)key;

/**
 * Creates a new instance of an Isgl3dGLTexture from a UIImage (or reuses an existing one if it already exists) with specified precision and repeating behaviour.
 * @param image The UIImage to be converted into a texture
 * @param key a unique identifier for the texture to avoid duplicating it for identical UIImages
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatY Inidicates whether the texture will be repeated (tesselated) across the rendered object in the y-direction.
 * @param repeatX Inidicates whether the texture will be repeated (tesselated) across the rendered object in the x-direction.
 * @result an autoreleased Isgl3dGLTexture created from image a UIImage
 */
- (Isgl3dGLTexture *) createTextureFromUIImage:(UIImage *)image key:(NSString *)key  precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Creates a new instance of an Isgl3dGLTexture from text with a given font name and size with default repeating behaviour (no repeating). 
 * Note that these textures are not stored in the dictionary.
 * @param text The text to be rendered
 * @param name The name of the font
 * @param size The size of the font
 * @result an autoreleased Isgl3dGLTexture created from the text
 */
- (Isgl3dGLTexture *) createTextureFromText:(NSString *)text fontName:(NSString*)name fontSize:(CGFloat)size;


/**
 * Creates a new instance of an Isgl3dGLTexture from text with a given font name and size with specified precision and repeating behaviour. 
 * Note that these textures are not stored in the dictionary.
 * @param text The text to be rendered
 * @param name The name of the font
 * @param size The size of the font
 * @param repeatX Inidicates whether the texture will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the texture will be repeated (tesselated) across the rendered object in the y-direction.
 * @result an autoreleased Isgl3dGLTexture created from the text
 */
- (Isgl3dGLTexture *) createTextureFromText:(NSString *)text fontName:(NSString*)name fontSize:(CGFloat)size repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;


/**
 * Creates a new instance of an Isgl3dGLTexture containing a cubemap texture (** OpenGL ES2 only **) from a given set of files with specified precision and repeating behaviour.
 * @param files An array of files containing the image information (.png, .jpg, .pvr, etc) for the different cube sides.
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the texture will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the texture will be repeated (tesselated) across the rendered object in the y-direction.
 * @result an autoreleased Isgl3dGLTexture for a cubemap texture created from a set of image files
 * 
 * Warning : highly experimental !
 */
- (Isgl3dGLTexture *) createCubemapTextureFromFiles:(NSArray *)files precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Creates an Isgl3dGLDepthRenderTexture render texture to render depth values onto.
 * @param width The width of the render texture.
 * @param height The height of the render texture.
 * @result an autoreleased Isgl3dGLDepthRenderTexture depending on OpenGL version
 * 
 * Note : This is used internall by iSGL3D.
 */
- (Isgl3dGLDepthRenderTexture *) createDepthRenderTexture:(int)width height:(int)height;

/**
 * Deletes a given texture in OpenGL as well as remove it from the shared instance dictionary.
 * @param texture The texture to be deleted.
 */
- (void) deleteTexture:(Isgl3dGLTexture *)texture;


@end

