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


@interface Isgl3dTextureMaterial ()
- (id) initWithCubemapTextureFiles:(NSArray *)pathArray shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY;
@end


@implementation Isgl3dTextureMaterial

@synthesize texture=_texture;

+ (id) materialWithTextureFile:(NSString *)fileName shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	return [[[self alloc] initWithTextureFile:fileName shininess:shininess precision:precision repeatX:repeatX repeatY:repeatY] autorelease];
}

+ (id) materialWithTextureFile:(NSString *)fileName {
	return [[[self alloc] initWithTextureFile:fileName] autorelease];
}

+ (id) materialWithTextureFile:(NSString *)fileName shininess:(float)shininess {
	return [[[self alloc] initWithTextureFile:fileName shininess:shininess] autorelease];
}

+ (id) materialWithTextureUIImage:(UIImage *)image key:(NSString *)key shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	return [[[self alloc] initWithTextureUIImage:image key:key shininess:shininess precision:precision repeatX:repeatX repeatY:repeatY] autorelease];
}

+ (id) materialWithTextureUIImage:(UIImage *)image key:(NSString *)key {
	return [[[self alloc] initWithTextureUIImage:image key:key] autorelease];
}

+ (id) materialWithTextureUIImage:(UIImage *)image key:(NSString *)key shininess:(float)shininess {
	return [[[self alloc] initWithTextureUIImage:image key:key shininess:shininess] autorelease];
}

+ (id) materialWithText:(NSString *)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize {
	return [[[self alloc] initWithText:text fontName:fontName fontSize:fontSize] autorelease];
}


- (id) initWithTextureFile:(NSString *)fileName shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	
	NSString * specular = (shininess > 0) ? @"FFFFFF" : @"000000";
	
	if ((self = [super initWithHexColors:@"FFFFFF" diffuse:@"FFFFFF" specular:specular shininess:shininess])) {

		_texture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromFile:fileName precision:precision repeatX:repeatX repeatY:repeatY] retain];
	}
	
	return self;
}

- (id) initWithTextureFile:(NSString *)fileName {
	return [self initWithTextureFile:fileName shininess:0.0f precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
}

- (id) initWithTextureFile:(NSString *)fileName shininess:(float)shininess {
	return [self initWithTextureFile:fileName shininess:shininess precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
}

- (id) initWithCubemapTextureFiles:(NSArray *)texturePathArray shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
	
	NSString * specular = (shininess > 0) ? @"FFFFFF" : @"000000";
	
	if ((self = [super initWithHexColors:@"FFFFFF" diffuse:@"FFFFFF" specular:specular shininess:shininess])) {

		_texture = [[[Isgl3dGLTextureFactory sharedInstance] createCubemapTextureFromFiles:texturePathArray precision:precision repeatX:repeatX repeatY:repeatY] retain];
	}
	
	return self;
}

- (id) initWithTextureUIImage:(UIImage *)image key:(NSString *)key shininess:(float)shininess precision:(Isgl3dTexturePrecision)precision repeatX:(BOOL)repeatX repeatY:(BOOL)repeatY {
    
	NSString * specular = (shininess > 0) ? @"FFFFFF" : @"000000";

	if ((self = [super initWithHexColors:@"FFFFFF" diffuse:@"FFFFFF" specular:specular shininess:shininess])) {
		_texture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromUIImage:image key:key precision:precision repeatX:repeatX repeatY:repeatY] retain];
	}
	
	return self;   
}

- (id) initWithTextureUIImage:(UIImage *)image key:(NSString *)key {
	return [self initWithTextureUIImage:image key:key shininess:0.0f precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
}

- (id) initWithTextureUIImage:(UIImage *)image key:(NSString *)key shininess:(float)shininess {
	return [self initWithTextureUIImage:image key:key shininess:shininess precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
}

- (id)initWithText:(NSString *)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize {
	
	if ((self = [super initWithHexColors:@"FFFFFF" diffuse:@"FFFFFF" specular:@"000000" shininess:0])) {
		_texture = [[[Isgl3dGLTextureFactory sharedInstance] createTextureFromText:text fontName:fontName fontSize:fontSize] retain];
	}
	
	return self;
}


- (void) dealloc {
	[_texture release];
	_texture = nil;

	[super dealloc];
}

- (id) copyWithZone:(NSZone *)zone {
	Isgl3dTextureMaterial * copy = [super copyWithZone:zone];
	
	copy.texture = _texture;
	copy.isHighDefinition = _isHighDefinition;
	
	return copy;
}

- (void) prepareRenderer:(Isgl3dGLRenderer *)renderer requirements:(unsigned int)requirements alpha:(float)alpha node:(Isgl3dNode *)node {
	requirements |= TEXTURE_MAPPING_ON;
	[super prepareRenderer:renderer requirements:requirements alpha:alpha node:node];

	// Enable point sprites if necessary
	if (requirements & PARTICLES_ON) {
		[renderer enablePointSprites:YES];
	}

	[renderer setTexture:_texture];
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

- (BOOL) isHighDefinition {
	return _texture.isHighDefinition;
}

- (void) setIsHighDefinition:(BOOL)isHighDefinition {
	_texture.isHighDefinition = isHighDefinition;
}


@end
