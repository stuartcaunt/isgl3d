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

#import "Isgl3dGLRenderer1State.h"

@implementation Isgl3dGLRenderer1State

@synthesize vertexEnabled = _vertexEnabled;
@synthesize colorEnabled = _colorEnabled;
@synthesize normalEnabled = _normalEnabled;
@synthesize texCoordEnabled = _texCoordEnabled;
@synthesize textureEnabled = _textureEnabled;
@synthesize cullingEnabled = _cullingEnabled;
@synthesize backFaceCulling = _backFaceCulling;
@synthesize alphaCullingEnabled = _alphaCullingEnabled;
@synthesize alphaBlendEnabled = _alphaBlendEnabled;
@synthesize pointSpriteEnabled = _pointSpriteEnabled;
@synthesize pointSizeEnabled = _pointSizeEnabled;
@synthesize normalizationEnabled = _normalizationEnabled;
@synthesize matrixPaletteEnabled = _matrixPaletteEnabled;
@synthesize boneIndexEnabled = _boneIndexEnabled;
@synthesize boneWeightEnabled = _boneWeightEnabled;
@synthesize lightingEnabled = _lightingEnabled;

- (id) init {
	
	if ((self = [super init])) {
		[self reset];
		
	}
	
	return self;
}

- (void) dealloc {

	[super dealloc];
}

- (void) copyFrom:(Isgl3dGLRenderer1State *)state {
	_vertexEnabled = state.vertexEnabled;
	_colorEnabled = state.colorEnabled;
	_normalEnabled = state.normalEnabled;
	_texCoordEnabled = state.texCoordEnabled;
	_textureEnabled = state.textureEnabled;
	_cullingEnabled = state.cullingEnabled;
	_backFaceCulling = state.backFaceCulling;
	_alphaCullingEnabled = state.alphaCullingEnabled;
	_alphaBlendEnabled = state.alphaBlendEnabled;
	_pointSpriteEnabled = state.pointSpriteEnabled;
	_pointSizeEnabled = state.pointSizeEnabled;
	_normalizationEnabled = state.normalizationEnabled;
	_matrixPaletteEnabled = state.matrixPaletteEnabled;
	_boneIndexEnabled = state.boneIndexEnabled;
	_boneWeightEnabled = state.boneWeightEnabled;
	_lightingEnabled = state.lightingEnabled;
}

- (void) reset {
	_vertexEnabled = false;
	_colorEnabled = false;
	_normalEnabled = false;
	_texCoordEnabled = false;
	_textureEnabled = false;

	_cullingEnabled = false;
	_backFaceCulling = true;
	_alphaCullingEnabled = false;
	_alphaBlendEnabled = false;
	
	_pointSpriteEnabled = false;
	_pointSizeEnabled = false;
	
	_normalizationEnabled = false;

	_matrixPaletteEnabled = false;
	_boneIndexEnabled = false;
	_boneWeightEnabled = false;
	_lightingEnabled = false;
}


@end
