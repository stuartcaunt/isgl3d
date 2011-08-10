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

#import "Isgl3dShaderMaterial.h"
#import "Isgl3dCustomShader.h"
#import "Isgl3dDirector.h"
#import "Isgl3dGLRenderer2.h"

@implementation Isgl3dShaderMaterial

+ (id) materialWithShader:(Isgl3dCustomShader *)shader {
	return [[[self alloc] initWithShader:shader] autorelease];
}

- (id) initWithShader:(Isgl3dCustomShader *)shader {
	
	if ((self = [super init])) {
		self.shader = shader;
		
	}
	return self;
}


- (void) dealloc {
	if (_shader) {
		[_shader release];
	}
	
	[super dealloc];

}

- (id) copyWithZone:(NSZone *)zone {
	Isgl3dShaderMaterial * copy = [super copyWithZone:zone];
	
	copy.shader = _shader;

	return copy;
}


- (Isgl3dCustomShader *) shader {
	return _shader;
}

- (void) setShader:(Isgl3dCustomShader *)shader {
	if (_shader != shader) {
		[_shader release];
		_shader = nil;
	}
	
	if (shader) {
		// Register shader with renderer
		if ([[Isgl3dDirector sharedInstance] registerCustomShader:shader]) {
			_shader = [shader retain];
		}	
	}
}

- (void) prepareRenderer:(Isgl3dGLRenderer *)renderer requirements:(unsigned int)requirements alpha:(float)alpha node:(Isgl3dNode *)node {
	// Requirements don't count here - shader is custom/independent
	
	// Pass current node to shader if it needs it
	_shader.activeNode = node;
	
	// Recast renderer as ES2 renderer
	Isgl3dGLRenderer2 * es2Renderer = (Isgl3dGLRenderer2 *)renderer;
	
	// set active shader
	[es2Renderer setShaderActive:_shader];
}

@end
