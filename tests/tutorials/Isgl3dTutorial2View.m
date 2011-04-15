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

- (id) init {
	
	if ((self = [super init])) {

		// Translate the camera.
		self.camera.position = iv3(2, 8, 10);

		// Create a white color material (with grey ambient color)
		Isgl3dColorMaterial * colorMaterial = [Isgl3dColorMaterial materialWithHexColors:@"444444" diffuse:@"FFFFFF" specular:@"FFFFFF" shininess:0.7];
		
		// Create a torus primitive
		Isgl3dTorus * torus = [Isgl3dTorus meshWithGeometry:3.0 tubeRadius:1.0 ns:32 nt:20];
		
		// Create a mesh node in the scene using torus primitive and color material
		_torusNode = [self.scene createNodeWithMesh:torus andMaterial:colorMaterial];
	
		// Create red light (producing white specular light), with rendering, and add to scene
		_redLight = [Isgl3dLight lightWithHexColor:@"FF0000" diffuseColor:@"FF0000" specularColor:@"FFFFFF" attenuation:0.02];
		_redLight.renderLight = YES;
		[self.scene addChild:_redLight];
		
		// Create green light (producing white specular light), with rendering, and add to scene
		_greenLight = [Isgl3dLight lightWithHexColor:@"00FF00" diffuseColor:@"00FF00" specularColor:@"FFFFFF" attenuation:0.02];
		_greenLight.renderLight = YES;
		[self.scene addChild:_greenLight];
	
		// Create blue light (producing white specular light), with rendering, and add to scene
		_blueLight = [Isgl3dLight lightWithHexColor:@"0000FF" diffuseColor:@"0000FF" specularColor:@"FFFFFF" attenuation:0.02];
		_blueLight.renderLight = YES;
		[self.scene addChild:_blueLight];
		
		// Set the scene ambient color
		[self setSceneAmbient:@"444444"];

		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (void) tick:(float)dt {
	// Rotate the torus
	_torusNode.rotationZ += 1;
	
	// Move the lights
	_redLight.position = iv3(LIGHT_RADIUS * sin(_lightAngle * M_PI / 30), LIGHT_RADIUS * cos(_lightAngle * M_PI / 30), 0);
	_greenLight.position = iv3(LIGHT_RADIUS * -cos(_lightAngle * M_PI / 60), LIGHT_RADIUS * sin(_lightAngle * M_PI / 60), LIGHT_RADIUS * cos(_lightAngle * M_PI / 60));
	_blueLight.position = iv3(LIGHT_RADIUS * sin(_lightAngle * M_PI / 45), LIGHT_RADIUS * cos(_lightAngle * M_PI / 45), LIGHT_RADIUS * sin(_lightAngle * M_PI / 45));

	// Update the light angle
	_lightAngle = _lightAngle + 0.5;
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
	Isgl3dView * view = [Isgl3dTutorial2View view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
