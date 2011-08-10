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
#import "Isgl3dMaterial.h"
#import "Isgl3dColorUtil.h"
#import "Isgl3dPrimitive.h"
#import "Isgl3dGLRenderer.h"

@implementation Isgl3dColorMaterial

+ (void) initialize {
	srandom(time(NULL));
}

+ (id) material {
	return [[[self alloc] init] autorelease];
}

+ (id) materialWithHexColors:(NSString *)ambient diffuse:(NSString *)diffuse specular:(NSString *)specular shininess:(float)shininess {
	return [[[self alloc] initWithHexColors:ambient diffuse:diffuse specular:specular shininess:shininess] autorelease];
}


- (id) init {
	if ((self = [super init])) {

		NSString * hexColor = [Isgl3dColorUtil randomHexColor];
		[Isgl3dColorUtil hexColorStringToFloatArray:hexColor floatArray:_ambientColor]; 
		[Isgl3dColorUtil hexColorStringToFloatArray:hexColor floatArray:_diffuseColor]; 
		[Isgl3dColorUtil hexColorStringToFloatArray:hexColor floatArray:_specularColor]; 

		_shininess = 0.0; 
	}
	
	return self;
}

- (id) initWithHexColors:(NSString *)ambient diffuse:(NSString *)diffuse specular:(NSString *)specular shininess:(float)shininess {
	
	if ((self = [super init])) {
		[Isgl3dColorUtil hexColorStringToFloatArray:ambient floatArray:_ambientColor]; 
		[Isgl3dColorUtil hexColorStringToFloatArray:diffuse floatArray:_diffuseColor]; 
		[Isgl3dColorUtil hexColorStringToFloatArray:specular floatArray:_specularColor]; 

		_shininess = shininess; 
	}
	
	return self;
}


- (void) dealloc {
	
	[super dealloc];

}

- (id) copyWithZone:(NSZone *)zone {
	Isgl3dColorMaterial * copy = [super copyWithZone:zone];
	
	copy.ambientColor = _ambientColor;
	copy.diffuseColor = _diffuseColor;
	copy.specularColor = _specularColor;
	copy.shininess = _shininess;
	
	return copy;
}

- (float *) ambientColor {
	return _ambientColor;
}

- (void) setAmbientColor:(float *)color {
	memcpy(_ambientColor, color, sizeof(float) * 3);
}

- (float *) diffuseColor {
	return _diffuseColor;
}

- (void) setDiffuseColor:(float *)color {
	memcpy(_diffuseColor, color, sizeof(float) * 3);
}

- (float *) specularColor {
	return _specularColor;
}

- (void) setSpecularColor:(float *)color {
	memcpy(_specularColor, color, sizeof(float) * 3);
}

- (float) shininess {
	return _shininess;
}

- (void) setShininess:(float)shininess {
	_shininess = shininess;
}

- (void) setAmbientColorAsString:(NSString *)colorString {
	[Isgl3dColorUtil hexColorStringToFloatArray:colorString floatArray:_ambientColor]; 
}

- (void) setDiffuseColorAsString:(NSString *)colorString {
	[Isgl3dColorUtil hexColorStringToFloatArray:colorString floatArray:_diffuseColor]; 
}

- (void) setSpecularColorAsString:(NSString *)colorString {
	[Isgl3dColorUtil hexColorStringToFloatArray:colorString floatArray:_specularColor]; 
}


- (void) prepareRenderer:(Isgl3dGLRenderer *)renderer requirements:(unsigned int)requirements alpha:(float)alpha node:(Isgl3dNode *)node {
	[super prepareRenderer:renderer requirements:requirements alpha:alpha node:node];
	
	float ambient[4];
	float diffuse[4];
	float specular[4];

	memcpy(ambient, _ambientColor, sizeof(float) * 3);
	memcpy(diffuse, _diffuseColor, sizeof(float) * 3);
	memcpy(specular, _specularColor, sizeof(float) * 3);

	ambient[3] = alpha;
	diffuse[3] = alpha;
	specular[3] = alpha;

//	[renderer enableLighting];

	[renderer setMaterialData:ambient diffuseColor:diffuse specularColor:specular withShininess:_shininess];
}

@end
