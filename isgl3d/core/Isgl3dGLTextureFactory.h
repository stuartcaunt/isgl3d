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
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dGLTextureFactory : NSObject {

@private
	Isgl3dGLTextureFactoryState * _state;
	
	NSMutableDictionary * _textures;
}

- (id) init;

+ (Isgl3dGLTextureFactory *) sharedInstance;
+ (void) resetInstance;

- (void) setState:(Isgl3dGLTextureFactoryState *)state;
- (void) clear;

/**
 * @result (autorelease) Isgl3dGLTexture created from image file
 */
- (Isgl3dGLTexture *) createTextureFromFile:(NSString *)file precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * @result (autorelease) Isgl3dGLTexture created from UIImage
 */
- (Isgl3dGLTexture *) createTextureFromUIImage:(UIImage *)image key:(NSString *)key  precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * @result (autorelease) Isgl3dGLTexture created from text
 */
- (Isgl3dGLTexture *) createTextureFromText:(NSString *)text fontName:(NSString*)name fontSize:(CGFloat)size;

/**
 * @result (autorelease) Isgl3dGLTexture created from text
 */
- (Isgl3dGLTexture *) createTextureFromText:(NSString *)text fontName:(NSString*)name fontSize:(CGFloat)size repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * @result (autorelease) Isgl3dGLTexture for cubemap created from image files
 */
- (Isgl3dGLTexture *) createCubemapTextureFromFiles:(NSArray *)files precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;

/**
 * @result (autorelease) Isgl3dGLDepthRenderTexture depending on OpenGL version
 */
- (Isgl3dGLDepthRenderTexture *) createDepthRenderTexture:(int)width height:(int)height;

- (void) deleteTexture:(Isgl3dGLTexture *)texture;


@end

