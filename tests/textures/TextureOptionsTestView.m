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

- (id) init {
	
	if ((self = [super init])) {

		_planeAngle = 0;
		_cameraDistanceAngle = 0;

		Isgl3dTextureMaterial *  textureMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"rock_mipmap_4.pvr" shininess:0 precision:Isgl3dTexturePrecisionHigh repeatX:NO repeatY:NO];
		Isgl3dTextureMaterial *  textureMaterial2 = [Isgl3dTextureMaterial materialWithTextureFile:@"rock_mipmap_4.pvr" shininess:0 precision:Isgl3dTexturePrecisionLow repeatX:NO repeatY:NO];
	
		Isgl3dGLMesh * planeMesh = [Isgl3dPlane meshWithGeometry:10.0 height:10.0 nx:10 ny:10]; 
		
		_plane1 = [self.scene createNodeWithMesh:planeMesh andMaterial:textureMaterial];
		[_plane1 setRotation:-90 x:1 y:0 z:0];
		[_plane1 setTranslation:0 y:-0.5 z:0];
	
		_plane2 = [self.scene createNodeWithMesh:planeMesh andMaterial:textureMaterial2];
		[_plane2 setRotation:90 x:1 y:0 z:0];
		[_plane2 setTranslation:0 y:0.5 z:0];
		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {

	[super dealloc];
}


- (void) tick:(float)dt {
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
	[self.camera setTranslation:0 y:0.15 * sin(_cameraDistanceAngle * M_PI / 90) z:2 + 1.9 * sin(_cameraDistanceAngle * M_PI / 180)];
	
}

@end



#pragma mark AppDelegate

/*
 * Implement principal class: simply override the createViews method to return the desired demo view.
 */
@implementation AppDelegate

- (void) createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;

	// Create view and add to Isgl3dDirector
	Isgl3dView * view = [TextureOptionsTestView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
