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
#import <UIKit/UIKit.h>

/**
 * Ths Isgl3dGLTexture encapsulates an OpenGL texture object stored in the GPU. It is created by the Isgl3dGLTextureFactory.
 * This class contains additional information used for rendering the texture including the texture size in pixels and the 
 * content size used if the desired texture is smaller than that created for OpenGL (which must have factor of 2 dimensions).
 */
@interface Isgl3dGLTexture : NSObject {

@private
	unsigned int _textureId;
	
	unsigned int _width;
	unsigned int _height;
	CGSize _contentSize;
	
	BOOL _isHighDefinition;
}

/**
 * Returns the id of the texture used internally by OpenGL.
 */
@property (nonatomic, readonly) unsigned int textureId;

/**
 * Returns the full width of the texture in pixels.
 */
@property (nonatomic, readonly) unsigned int width;

/**
 * Returns the full height of the texture in pixels.
 */
@property (nonatomic, readonly) unsigned int height;

/**
 * Returns the size of the usable content of the texture.
 */
@property (nonatomic, readonly) CGSize contentSize;

/**
 * Returns true if the texture has been created from a high definition (retina display) image
 */
@property (nonatomic) BOOL isHighDefinition;

/**
 * Allocates and initialises (autorelease) an Isgl3dGLTexture for an OpenGL texture object of given width and height.
 * @param textureId The OpenGL texture id.
 * @param width The width of the texture.
 * @param height The height of the texture.
 */
+ (id) textureWithId:(unsigned int)textureId width:(unsigned int)width height:(unsigned int)height;

/**
 * Allocates and initialises (autorelease) an Isgl3dGLTexture for an OpenGL texture object of given width and height and
 * specified content size.
 * @param textureId The OpenGL texture id.
 * @param width The width of the texture.
 * @param height The height of the texture.
 * @param contentSize The size of the content.
 */
+ (id) textureWithId:(unsigned int)textureId width:(unsigned int)width height:(unsigned int)height contentSize:(CGSize)contentSize;

/**
 * Initialises an Isgl3dGLTexture for an OpenGL texture object of given width and height.
 * @param textureId The OpenGL texture id.
 * @param width The width of the texture.
 * @param height The height of the texture.
 */
- (id) initWithId:(unsigned int)textureId width:(unsigned int)width height:(unsigned int)height;

/**
 * Intialises an Isgl3dGLTexture for an OpenGL texture object of given width and height and
 * specified content size.
 * @param textureId The OpenGL texture id.
 * @param width The width of the texture.
 * @param height The height of the texture.
 * @param contentSize The size of the content.
 */
- (id) initWithId:(unsigned int)textureId width:(unsigned int)width height:(unsigned int)height contentSize:(CGSize)contentSize;

@end
