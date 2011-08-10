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

#import "Isgl3dInternalShader.h"
#import "Isgl3dGLProgram.h"
#import "Isgl3dGLVBOData.h"
#import "Isgl3dArray.h"
#import "Isgl3dGLTexture.h"
#import "Isgl3dLog.h"

@interface Isgl3dInternalShader ()
- (void) getAttributeAndUniformLocations;
@end

@implementation Isgl3dInternalShader

- (id) initWithVertexShaderName:(NSString *)vertexShaderName fragmentShaderName:(NSString *)fragmentShaderName vsPreProcHeader:(NSString *)vsPreProcHeader fsPreProcHeader:(NSString *)fsPreProcHeader {
	
	if ((self = [super initWithVertexShaderName:vertexShaderName fragmentShaderName:fragmentShaderName vsPreProcHeader:vsPreProcHeader fsPreProcHeader:fsPreProcHeader])) {
        
		[self getAttributeAndUniformLocations];
	
		_whiteAndAlpha[0] = 1.0;	
		_whiteAndAlpha[1] = 1.0;	
		_whiteAndAlpha[2] = 1.0;	
		_whiteAndAlpha[3] = 1.0;
		_blackAndAlpha[0] = 0.0;	
		_blackAndAlpha[1] = 0.0;	
		_blackAndAlpha[2] = 0.0;	
		_blackAndAlpha[3] = 1.0;

	}
	
	return self;
}


- (void) dealloc {

	[super dealloc];
}


- (void) getAttributeAndUniformLocations {
}

- (void) setTexture:(Isgl3dGLTexture *)texture {
}

- (void) setMaterialData:(float *)ambientColor diffuseColor:(float *)diffuseColor specularColor:(float *)specularColor withShininess:(float)shininess {
}

- (void) enableLighting:(BOOL)lightingEnabled {
}

- (void) setShadowCastingMVPMatrix:(Isgl3dMatrix4 *)mvpMatrix {
}

- (void) setShadowCastingLightPosition:(Isgl3dVector3 *)position viewMatrix:(Isgl3dMatrix4 *)viewMatrix {
}

- (void) setShadowMap:(Isgl3dGLTexture *)texture {
}

- (void) setPlanarShadowsActive:(BOOL)planarShadowsActive shadowAlpha:(float)shadowAlpha {
}

- (void) setCaptureColor:(float *)color {
}


@end
