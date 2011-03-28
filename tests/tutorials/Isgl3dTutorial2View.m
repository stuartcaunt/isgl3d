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

#import "Isgl3dTutorial2View.h"
#define LIGHT_RADIUS 4

@implementation Isgl3dTutorial2View

- (void) dealloc {
	// Release scene
	[_scene release];

	// Release the lights
	[_blueLight release];
	[_redLight release];
	[_greenLight release];
	
	[super dealloc];
}

- (void) initView {
	// Prepare the view with the background color.
	float clearColor[4] = {0.05, 0.05, 0.05, 1};
	[self prepareView:clearColor];

	// Create the root scene graph object and set it active in the view.
	_scene = [[Isgl3dScene3D alloc] init];
	[self setActiveScene:_scene];

	// Create a standard camera in the scene and set it active in the view.
	Isgl3dCamera * camera = [_scene createCameraNodeWithView:self];
	[self setActiveCamera:camera];

	// Translate the camera.
	[camera setTranslation:2 y:8 z:5];
	
	// Set the device in landscape mode.
	self.isLandscape = YES;
}

- (void) initScene {

	// Create a white color material (with grey ambient color)
	Isgl3dColorMaterial * colorMaterial = [[Isgl3dColorMaterial alloc] initWithHexColors:@"444444" diffuse:@"FFFFFF" specular:@"FFFFFF" shininess:0.7];
	
	// Create a torus primitive
	Isgl3dTorus * torus = [[Isgl3dTorus alloc] initWithGeometry:3.0 tubeRadius:1.0 ns:32 nt:20];
	
	// Create a mesh node in the scene using torus primitive and color material
	_torusNode = [_scene createNodeWithMesh:[torus autorelease] andMaterial:[colorMaterial autorelease]];

	// Create red light (producing white specular light), with rendering, and add to scene
	_redLight = [[Isgl3dLight alloc] initWithHexColor:@"FF0000" diffuseColor:@"FF0000" specularColor:@"FFFFFF" attenuation:0.02];
	_redLight.renderLight = YES;
	[_scene addChild:_redLight];
	
	// Create green light (producing white specular light), with rendering, and add to scene
	_greenLight = [[Isgl3dLight alloc] initWithHexColor:@"00FF00" diffuseColor:@"00FF00" specularColor:@"FFFFFF" attenuation:0.02];
	_greenLight.renderLight = YES;
	[_scene addChild:_greenLight];

	// Create blue light (producing white specular light), with rendering, and add to scene
	_blueLight = [[Isgl3dLight alloc] initWithHexColor:@"0000FF" diffuseColor:@"0000FF" specularColor:@"FFFFFF" attenuation:0.02];
	_blueLight.renderLight = YES;
	[_scene addChild:_blueLight];
	
	// Set the scene ambient color
	[self setSceneAmbient:@"444444"];
}

- (void) updateScene {
	// Rotate the torus
	[_torusNode rotate:1 x:0 y:0 z:1];
	
	// Move the lights
	[_redLight setTranslation:LIGHT_RADIUS * sin(_lightAngle * M_PI / 30) y:LIGHT_RADIUS * cos(_lightAngle * M_PI / 30) z:0];
	[_greenLight setTranslation:LIGHT_RADIUS * -cos(_lightAngle * M_PI / 60) y:LIGHT_RADIUS * sin(_lightAngle * M_PI / 60) z:LIGHT_RADIUS * cos(_lightAngle * M_PI / 60)];
	[_blueLight setTranslation:LIGHT_RADIUS * sin(_lightAngle * M_PI / 45) y:LIGHT_RADIUS * cos(_lightAngle * M_PI / 45) z:LIGHT_RADIUS * sin(_lightAngle * M_PI / 45)];

	// Update the light angle
	_lightAngle = _lightAngle + 0.5;
}

@end

#pragma mark AppDelegate

/*
 * Implement principal class: simply override the viewWithFrame method to return the desired demo view.
 */
@implementation AppDelegate

- (Isgl3dView3D *) viewWithFrame:(CGRect)frame {
	return [[[Isgl3dTutorial2View alloc] initWithFrame:frame] autorelease];
}
@end
