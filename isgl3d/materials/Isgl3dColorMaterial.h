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

#import "Isgl3dMaterial.h"

/**
 * The Isgl3dColorMaterial is the most basic type of material available in iSGL3D. Colors are specified for the three
 * material properties: ambient, diffuse and specular allowing for a high level of freedom of interaction with a light
 * source (see Isgl3dLight).
 * 
 * For example, considering just diffuse lighting, a color material with red diffuse color illuminated by a light with white diffuse
 * lighting will appear red. However the same material with a blue diffuse light source will be black.
 * 
 * Associated with specular lighting, the material can be given an amount of shininess modifying the amount of specular light
 * rendered. For a value of 0, no specular light is rendered.
 * 
 */
@interface Isgl3dColorMaterial : Isgl3dMaterial {
	
@private

	float _ambientColor[4];
	float _diffuseColor[4];
	float _specularColor[4];

	float _shininess;
}

@property (nonatomic) float * ambientColor;
@property (nonatomic) float * diffuseColor;
@property (nonatomic) float * specularColor;
@property (nonatomic) float shininess;

/**
 * Allocates and initialises (autorelease) material with a random color. The same color is used for all three material properties. The material has
 * zero shininess.
 */
+ (id) material;

/**
 * Allocates and initialises (autorelease) material with user-defined values.
 * @param ambient The ambient color property of the material specified as a hex color value.
 * @param diffuse The diffuse color property of the material specified as a hex color value.
 * @param specular The specular color property of the material specified as a hex color value.
 * @param shininess The shiness of the material.
 */
+ (id) materialWithHexColors:(NSString *)ambient diffuse:(NSString *)diffuse specular:(NSString *)specular shininess:(float)shininess;

/**
 * Initialises the material with a random color. The same color is used for all three material properties. The material has
 * zero shininess.
 */
- (id) init;

/**
 * Initialises the material with user-defined values.
 * @param ambient The ambient color property of the material specified as a hex color value.
 * @param diffuse The diffuse color property of the material specified as a hex color value.
 * @param specular The specular color property of the material specified as a hex color value.
 * @param shininess The shiness of the material.
 */
- (id) initWithHexColors:(NSString *)ambient diffuse:(NSString *)diffuse specular:(NSString *)specular shininess:(float)shininess;

/**
 * Returns the float array containing the ambient color
 * @return the ambient color
 */
- (float *) ambientColor;

/**
 * Sets the ambient color property of the material.
 * @param color Float array containing the rgb values of the ambient material color.
 */
- (void) setAmbientColor:(float *)color;

/**
 * Returns the float array containing the diffuse color
 * @return the diffuse color
 */
- (float *) diffuseColor;

/**
 * Sets the diffuse color property of the material.
 * @param color Float array containing the rgb values of the diffuse material color.
 */
- (void) setDiffuseColor:(float *)color;

/**
 * Returns the float array containing the specular color
 * @return the specular color
 */
- (float *) specularColor;

/**
 * Sets the specular color property of the material.
 * @param color Float array containing the rgb values of the specular material color.
 */
- (void) setSpecularColor:(float *)color;

/**
 * Returns the shininess
 * @return the shininess
 */
- (float) shininess;

/**
 * Sets the shininess of the material.
 * @param shininess The shininess of the material.
 */
- (void) setShininess:(float)shininess;

/**
 * Sets the ambient color property of the material.
 * @param colorString Hexidecimel string value for the rgb values of the ambient material color.
 */
- (void) setAmbientColorAsString:(NSString *)colorString;

/**
 * Sets the diffuse color property of the material.
 * @param colorString Hexidecimel string value for the rgb values of the diffuse material color.
 */
- (void) setDiffuseColorAsString:(NSString *)colorString;

/**
 * Sets the specular color property of the material.
 * @param colorString Hexidecimel string value for the rgb values of the specular material color.
 */
- (void) setSpecularColorAsString:(NSString *)colorString;

@end
