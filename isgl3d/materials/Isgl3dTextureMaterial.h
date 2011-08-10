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


#import "Isgl3dColorMaterial.h"
#import "isgl3dTypes.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@class Isgl3dGLTexture;

/**
 * The Isgl3dTextureMaterial is used to render objects in the scene with textures created from image files or text.
 * 
 * It inherits all the properties from Isgl3dColorMaterial implying that the rendering of the material can be fine
 * tuned with color modifications.
 * 
 * Image file dimensions must be exact powers of 2 (for example 32 x 128).
 * 
 * Standard image files (eg .png, .jpg, .bmp) are supported, as well as POWERVR pvr compressed images. iSGL3D determines if 
 * the image is compressed simply by its filename, so it must be name .pvr.
 * 
 * When text is rendered to a texture, the full texture size may be somewhat larger that the text (due to the the restriction
 * on powers of 2). To determine the real dimensions of the rendered text the property contentSize can be used. This is
 * useful, for example, when create Isgl3dUVMaps to remove the borders of the unused texture.
 */
@interface Isgl3dTextureMaterial : Isgl3dColorMaterial {
	
@protected
	Isgl3dGLTexture * _texture;
	
	BOOL _isHighDefinition;
}

/**
 * The width of the texture.
 */
@property (readonly) unsigned int width;

/**
 * The height of the texture.
 */
@property (readonly) unsigned int height;

/**
 * The dimensions taken up by content in the texture. For text rendered to a texture, the content size will usually
 * be smaller than the dimensions of the full texture.
 */
@property (readonly) CGSize contentSize;

/**
 * Used for retina display textures. Returns tru if the image file has come from a -hd resource. Can be set manually
 * if needed but has no effect on the texture.
 */
@property (nonatomic) BOOL isHighDefinition;

/**
 * Gets/sets the Isgl3dGLTexture associated with the material.
 */
@property (nonatomic, retain) Isgl3dGLTexture *texture;

/**
 * Allocates and initialises (autorelease) texture material from an image file.
 * @param fileName The name of the image file.
 * @param shininess The shiness of the material.
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the material will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the material will be repeated (tesselated) across the rendered object in the y-direction.
 */
+ (id) materialWithTextureFile:(NSString *)fileName shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Allocates and initialises (autorelease) texture material from an image file using default values of 0 shininess, Isgl3dTexturePrecisionMedium precision and no repeats.
 * @param fileName The name of the image file.
 */
+ (id) materialWithTextureFile:(NSString *)fileName;

/**
 * Allocates and initialises (autorelease) texture material from an image file and a given shininess, using default values Isgl3dTexturePrecisionMedium precision and no repeats.
 * @param fileName The name of the image file.
 * @param shininess The shiness of the material.
 */
+ (id) materialWithTextureFile:(NSString *)fileName shininess:(float)shininess;

/**
 * Allocates and initialises (autorelease) texture material from an UIImage object.
 * @param image UIImage object for the new texture.
 * @param key The key of the image object.
 * @param shininess The shiness of the material.
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the material will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the material will be repeated (tesselated) across the rendered object in the y-direction.
 */
+ (id) materialWithTextureUIImage:(UIImage *)image key:(NSString *)key shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Allocates and initialises (autorelease) texture material from an UIImage object using default values of 0 shininess, Isgl3dTexturePrecisionMedium precision and no repeats.
 * @param image UIImage object for the new texture.
 * @param key The key of the image object.
 */
+ (id) materialWithTextureUIImage:(UIImage *)image key:(NSString *)key;

/**
 * Allocates and initialises (autorelease) texture material from an UIImage object and a given shininess, using default values Isgl3dTexturePrecisionMedium precision and no repeats.
 * @param image UIImage object for the new texture.
 * @param key The key of the image object.
 * @param shininess The shiness of the material.
 */
+ (id) materialWithTextureUIImage:(UIImage *)image key:(NSString *)key shininess:(float)shininess;

/**
 * Allocates and initialises (autorelease) texture material with text to be rendered.
 * @param text The text to be rendered.
 * @param fontName The name of the font.
 * @param fontSize The size of the font. 
 */
+ (id) materialWithText:(NSString *)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;

/**
 * Initialises the texture material from an image file.
 * @param fileName The name of the image file.
 * @param shininess The shiness of the material.
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the material will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the material will be repeated (tesselated) across the rendered object in the y-direction.
 */
- (id) initWithTextureFile:(NSString *)fileName shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Initialises the texture material from an image file using default values of 0 shininess, Isgl3dTexturePrecisionMedium precision and no repeats.
 * @param fileName The name of the image file.
 */
- (id) initWithTextureFile:(NSString *)fileName;

/**
 * Initialises the texture material from an image file and a given shininess, using default values Isgl3dTexturePrecisionMedium precision and no repeats.
 * @param fileName The name of the image file.
 * @param shininess The shiness of the material.
 */
- (id) initWithTextureFile:(NSString *)fileName shininess:(float)shininess;

/**
 * Initialises the texture material from an UIImage object.
 * @param image UIImage object
 * @param key The key of the image object.
 * @param shininess The shiness of the material.
 * @param precision The precision of the texture material being one of Isgl3dTexturePrecisionLow, Isgl3dTexturePrecisionMedium and Isgl3dTexturePrecisionHigh
 * @param repeatX Inidicates whether the material will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the material will be repeated (tesselated) across the rendered object in the y-direction.
 */
- (id) initWithTextureUIImage:(UIImage *)image key:(NSString *)key shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Initialises the texture material from an UIImage object using default values of 0 shininess, Isgl3dTexturePrecisionMedium precision and no repeats.
 * @param image UIImage object
 * @param key The key of the image object.
 */
- (id) initWithTextureUIImage:(UIImage *)image key:(NSString *)key;

/**
 * Initialises the texture material from an UIImage object and a given shininess, using default values Isgl3dTexturePrecisionMedium precision and no repeats.
 * @param image UIImage object
 * @param key The key of the image object.
 * @param shininess The shiness of the material.
 */
- (id) initWithTextureUIImage:(UIImage *)image key:(NSString *)key shininess:(float)shininess;


/**
 * Initialises the texture material with text to be rendered.
 * @param text The text to be rendered.
 * @param fontName The name of the font.
 * @param fontSize The size of the font. 
 */
- (id) initWithText:(NSString *)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;

@end
