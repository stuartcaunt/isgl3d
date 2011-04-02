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

#define TEXTURE_MATERIAL_LOW_PRECISION 0
#define TEXTURE_MATERIAL_MEDIUM_PRECISION 1
#define TEXTURE_MATERIAL_HIGH_PRECISION 2

#import "Isgl3dColorMaterial.h"
#import <CoreGraphics/CoreGraphics.h>

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
 * Initialises the texture material from an image file.
 * @param fileName The name of the image file.
 * @param shininess The shiness of the material.
 * @param precision The precision of the texture material being one of TEXTURE_MATERIAL_LOW_PRECISION, TEXTURE_MATERIAL_MERDIUM_PRECISION and TEXTURE_MATERIAL_HIGH_PRECISION
 * @param repeatX Inidicates whether the material will be repeated (tesselated) across the rendered object in the x-direction.
 * @param repeatY Inidicates whether the material will be repeated (tesselated) across the rendered object in the y-direction.
 */
- (id) initWithTextureFile:(NSString *)fileName shininess:(float)shininess precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * Initialises the texture material with text to be rendered.
 * @param text The text to be rendered.
 * @param fontName The name of the font.
 * @param fontSize The size of the font. 
 */
- (id) initWithText:(NSString *)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;

@end
