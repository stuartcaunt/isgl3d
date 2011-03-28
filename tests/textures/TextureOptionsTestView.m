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

#import "TextureOptionsTestView.h"

@implementation TextureOptionsTestView

- (void) dealloc {
	[_plane1 release];
	[_plane2 release];

	[super dealloc];
}

- (void) initView {
	[super initView];

	self.isLandscape = YES;

	_planeAngle = 0;
	_cameraDistanceAngle = 0;
		
}

- (void) initScene {
	[super initScene];
	
	Isgl3dTextureMaterial *  textureMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"rock_mipmap_4.pvr" shininess:0 precision:TEXTURE_MATERIAL_HIGH_PRECISION repeatX:NO repeatY:NO];
	Isgl3dTextureMaterial *  textureMaterial2 = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"rock_mipmap_4.pvr" shininess:0 precision:TEXTURE_MATERIAL_LOW_PRECISION repeatX:NO repeatY:NO];

	Isgl3dGLMesh * planeMesh = [[Isgl3dPlane alloc] initWithGeometry:10.0 height:10.0 nx:10 ny:10]; 
	
	_plane1 = [[_scene createNodeWithMesh:planeMesh andMaterial:[textureMaterial autorelease]] retain];
	[_plane1 setRotation:-90 x:1 y:0 z:0];
	[_plane1 setTranslation:0 y:-0.5 z:0];

	_plane2 = [[_scene createNodeWithMesh:planeMesh andMaterial:[textureMaterial2 autorelease]] retain];
	[_plane2 setRotation:90 x:1 y:0 z:0];
	[_plane2 setTranslation:0 y:0.5 z:0];
			   
	[planeMesh release];
}

- (void) updateScene {
	[super updateScene];

	_planeAngle += 1;
	if (_planeAngle > 360) {
		_planeAngle -= 360;
	}
	
	_cameraDistanceAngle += 0.5;
	if (_cameraDistanceAngle > 360) {
		_cameraDistanceAngle -= 360;
	}

	[_plane1 rotate:0.3 x:0 y:1 z:0];	
	[_plane2 rotate:0.3 x:0 y:1 z:0];	
	[_camera setTranslation:0 y:0.15 * sin(_cameraDistanceAngle * M_PI / 90) z:2 + 1.9 * sin(_cameraDistanceAngle * M_PI / 180)];
}


@end



#pragma mark AppDelegate

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppDelegate

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[TextureOptionsTestView alloc] initWithFrame:frame] autorelease];
}

@end
