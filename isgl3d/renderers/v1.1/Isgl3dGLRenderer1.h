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

#import <OpenGLES/ES1/gl.h>

#define MAX_LIGHTS 4

#import "Isgl3dGLRenderer.h"

@class Isgl3dGLRenderer1State;

/**
 * __isgl3d_internal__ Internal class of the iSGL3D framework
 */
@interface Isgl3dGLRenderer1 : Isgl3dGLRenderer {


@private
	int _lightCount;

	GLfloat _sceneAmbient[4];
	GLfloat _sceneAmbientAndAlpha[4];
	NSString * _sceneAmbientString;
	
	unsigned int _glLight[8];
	
	GLenum _renderTypes[2];
	
	Isgl3dGLRenderer1State * _currentState;
	Isgl3dGLRenderer1State * _previousState;
	
		
	unsigned int _currentVBOId;
	unsigned int _currentTextureId;
	unsigned int _currentElementBufferId;
}

- (id) init;

@end
