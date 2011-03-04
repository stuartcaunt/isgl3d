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

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dGLRenderer1State : NSObject {


@private
	BOOL _vertexEnabled;
	BOOL _colorEnabled;
	BOOL _normalEnabled;
	BOOL _texCoordEnabled;
	BOOL _textureEnabled;

	BOOL _cullingEnabled;
	BOOL _backFaceCulling;
	BOOL _alphaCullingEnabled;
	BOOL _alphaBlendEnabled;

	BOOL _pointSpriteEnabled;
	BOOL _pointSizeEnabled;
	
	BOOL _normalizationEnabled;

	BOOL _matrixPaletteEnabled;
	BOOL _boneIndexEnabled;
	BOOL _boneWeightEnabled;
	
	BOOL _lightingEnabled;
}

- (id) init;
- (void) copyFrom:(Isgl3dGLRenderer1State *)state;
- (void) reset;

@property (nonatomic) BOOL vertexEnabled;
@property (nonatomic) BOOL colorEnabled;
@property (nonatomic) BOOL normalEnabled;
@property (nonatomic) BOOL texCoordEnabled;
@property (nonatomic) BOOL textureEnabled;
@property (nonatomic) BOOL cullingEnabled;
@property (nonatomic) BOOL backFaceCulling;
@property (nonatomic) BOOL alphaCullingEnabled;
@property (nonatomic) BOOL alphaBlendEnabled;
@property (nonatomic) BOOL pointSpriteEnabled;
@property (nonatomic) BOOL pointSizeEnabled;
@property (nonatomic) BOOL normalizationEnabled;
@property (nonatomic) BOOL matrixPaletteEnabled;
@property (nonatomic) BOOL boneIndexEnabled;
@property (nonatomic) BOOL boneWeightEnabled;
@property (nonatomic) BOOL lightingEnabled;


@end
