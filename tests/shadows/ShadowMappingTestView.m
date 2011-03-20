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

#import "ShadowMappingTestView.h"

@implementation ShadowMappingTestView

- (void) dealloc {
	
	[_sphere release];
	[_littleSphere release];

	[_light release];
		
	[super dealloc];
}

- (void) initView {
	[super initView];

	[_camera setTranslation:5 y:5 z:6];
//	[_camera setTranslation:7 y:10 z:9];
		
	self.isLandscape = YES;
//	view3D.shadowRenderingMethod = SHADOW_RENDERING_MAPS;
	self.shadowRenderingMethod = SHADOW_RENDERING_PLANAR;
	self.shadowAlpha = 0.5;
	
	_sphereAngle = 0;
	_littleSphereAngle = 25;
	_lightAngle = 0;	
}

- (void) initScene {
	[super initScene];
	
	Isgl3dColorMaterial * colorMaterial = [[Isgl3dColorMaterial alloc] initWithHexColors:@"FFFFFF" diffuse:@"FFFFFF" specular:@"FFFFFF" shininess:0.7];
	Isgl3dTextureMaterial *  isglLogo = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"isgl3d_logo.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dTextureMaterial *  textureMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"mars.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];
	Isgl3dTextureMaterial *  hostel = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"hostel.png" shininess:0.9 precision:TEXTURE_MATERIAL_MEDIUM_PRECISION repeatX:NO repeatY:NO];

	Isgl3dGLMesh * sphereMesh = [[Isgl3dSphere alloc] initWithGeometry:1.0 longs:16 lats:16];
	_sphere = [[_scene createNodeWithMesh:[sphereMesh autorelease] andMaterial:textureMaterial] retain];
	[_sphere setTranslation:-1 y:0 z:3];
	_sphere.enableShadowCasting = YES;

	Isgl3dGLMesh * littleSphereMesh = [[Isgl3dSphere alloc] initWithGeometry:0.3 longs:16 lats:16];
	_littleSphere = [[_scene createNodeWithMesh:[littleSphereMesh autorelease] andMaterial:textureMaterial] retain];
	_littleSphere.enableShadowCasting = YES;

	Isgl3dGLMesh * cubeMesh = [[Isgl3dCube alloc] initWithGeometry:2 height:2 depth:2 nx:4 ny:4];
	Isgl3dMeshNode * cube = [_scene createNodeWithMesh:[cubeMesh autorelease] andMaterial:isglLogo];
	[cube setTranslation:2 y:-1 z:-3];
	cube.enableShadowCasting = YES;

	Isgl3dGLMesh * buildingMesh = [[Isgl3dPlane alloc] initWithGeometry:2.0 height:2.0 nx:4 ny:4];
	Isgl3dMeshNode * building = [_scene createNodeWithMesh:[buildingMesh autorelease] andMaterial:[hostel autorelease]];
	[building setTranslation:0 y:-1 z:0];
	building.enableShadowCasting = YES;
	building.transparent = YES;
	building.doubleSided = YES;



	Isgl3dPlane * planeMesh = [[Isgl3dPlane alloc] initWithGeometry:12.0 height:12.0 nx:10 ny:10];
	Isgl3dMeshNode * plane = [_scene createNodeWithMesh:planeMesh andMaterial:isglLogo];
	[plane setRotation:-90 x:1 y:0 z:0];
	[plane setTranslation:0 y:-2 z:0];

	Isgl3dMeshNode * plane2 = [_scene createNodeWithMesh:planeMesh andMaterial:colorMaterial];
	[plane2 setTranslation:0 y:1 z:-6];
	//plane2.enableShadowRendering = NO;

	Isgl3dMeshNode * plane3 = [_scene createNodeWithMesh:planeMesh andMaterial:colorMaterial];
	[plane3 setRotation:90 x:0 y:1 z:0];
	[plane3 setTranslation:-6 y:1 z:0];
	//plane3.enableShadowRendering = NO;
	
	[planeMesh release];
	[textureMaterial release];
	[colorMaterial release];
	[isglLogo release];


	_light  = [[Isgl3dShadowCastingLight alloc] initWithHexColor:@"111111" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.05];
	[_scene addChild:_light];
	_light.renderLight = YES;
	_light.planarShadowsNode = plane;

	[self setSceneAmbient:@"444444"];
}

- (void) updateScene {
	[super updateScene];

	[_sphere setRotation:_sphereAngle x:0 y:1 z:0];
	_sphereAngle = _sphereAngle - 1;
	
	float x = 3 * sin(_lightAngle * M_PI / 180.);
	float z = 3 * cos(_lightAngle * M_PI / 180.);
	[_light setTranslation:x y:3 z:z];

	_lightAngle += 1;

	x = 0.9 * sin(_littleSphereAngle * M_PI / 180.);
	z = 0.9 * cos(_littleSphereAngle * M_PI / 180.);
	[_littleSphere setTranslation:x y:1.2 z:z];
	
	_littleSphereAngle += 2;
}


@end



#pragma mark AppController

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppController

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[ShadowMappingTestView alloc] initWithFrame:frame] autorelease];
}

@end
