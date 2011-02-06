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

#import "Isgl3dTextureMaterial.h"
#import "Isgl3dMaterial.h"
#import "Isgl3dPrimitive.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dGLTexture.h"
#import "Isgl3dGLTextureFactory.h"

@interface Isgl3dTextureMaterial (PrivateMethods)
- (id) initWithCubemapTextureFiles:(NSArray *)pathArray shininess:(float)shininess precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;
- (int) convertPrecision:(int)materialPrecision;
@end

@implementation Isgl3dTextureMaterial


- (id) initWithTextureFile:(NSString *)fileName shininess:(float)shininess precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	
	NSString * specular = (shininess > 0) ? @"FFFFFF" : @"000000";
	
	if (self = [super initWithHexColors:@"FFFFFF" diffuse:@"FFFFFF" specular:specular shininess:shininess]) {

		_texture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromFile:fileName precision:precision repeatX:repeatX repeatY:repeatY] retain];
	}
	
	return self;
}

- (id) initWithCubemapTextureFiles:(NSArray *)texturePathArray shininess:(float)shininess precision:(int)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	
	NSString * specular = (shininess > 0) ? @"FFFFFF" : @"000000";
	
	if (self = [super initWithHexColors:@"FFFFFF" diffuse:@"FFFFFF" specular:specular shininess:shininess]) {

		_texture = [[[Isgl3dGLTextureFactory sharedInstance] createCubemapTextureFromFiles:texturePathArray precision:precision repeatX:repeatX repeatY:repeatY] retain];
	}
	
	return self;
}

- (id)initWithText:(NSString *)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize {
	
	if (self = [super initWithHexColors:@"FFFFFF" diffuse:@"FFFFFF" specular:@"000000" shininess:0]) {
		_texture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromText:text fontName:fontName fontSize:fontSize] retain];
	}
	
	return self;
}


- (void) dealloc {
	[_texture release];

	[super dealloc];
}

- (void) prepareRenderer:(Isgl3dGLRenderer *)renderer alpha:(float)alpha {
	[super prepareRenderer:renderer alpha:alpha];

	[renderer setTexture:[_texture textureId]];
}


- (unsigned int) getRendererRequirements {
	return [super getRendererRequirements] | TEXTURE_MAPPING_ON;
}

- (unsigned int) width {
	return _texture.width;
}

- (unsigned int) height {
	return _texture.height;
}

- (CGSize) contentSize {
	return _texture.contentSize;
}

- (int) convertPrecision:(int)materialPrecision {
	if (materialPrecision == TEXTURE_MATERIAL_LOW_PRECISION) {
		return GLTEXTURE_LOW_PRECISION;
	}
	if (materialPrecision == TEXTURE_MATERIAL_MEDIUM_PRECISION) {
		return GLTEXTURE_MEDIUM_PRECISION;
	}
	if (materialPrecision == TEXTURE_MATERIAL_HIGH_PRECISION) {
		return GLTEXTURE_HIGH_PRECISION;
	}
	
	return GLTEXTURE_MEDIUM_PRECISION;
}


@end
