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

@class Isgl3dCustomShader;

/**
 * The Isgl3dShaderMaterial allows custom OpenGL shaders (using Isgl3dCustomShader) to be used to render objects in iSGL3D.
 * 
 * Note that this material can only be used when running iSGL3D for OpenGL ES 2.
 * 
 */
@interface Isgl3dShaderMaterial : Isgl3dMaterial {
	
	Isgl3dCustomShader * _shader;
}

/**
 * Sets the Isgl3dCustomShader to be used by the material.
 */
@property (nonatomic, retain) Isgl3dCustomShader * shader;

/**
 * Allocates and initialises (autorelease) an Isgl3dShaderMaterial with the specified Isgl3dCustomShader shader.
 * @param shader The custom shader to be used to render the object.
 */
+ (id) materialWithShader:(Isgl3dCustomShader *)shader;

/**
 * Initialises an Isgl3dShaderMaterial with the specified Isgl3dCustomShader shader.
 * @param shader The custom shader to be used to render the object.
 */
- (id) initWithShader:(Isgl3dCustomShader *)shader;


@end
