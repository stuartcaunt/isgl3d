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

#import "ParticleGeneratorDemoView.h"
#import "Isgl3dDemoCameraController.h"

@implementation ParticleGeneratorDemoView

- (id) init {
	
	if ((self = [super init])) {

		// Enable zsorting
		self.zSortingEnabled = YES;

		// Create and configure touch-screen camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 14;
		_cameraController.theta = 30;
		_cameraController.phi = 30;
		_cameraController.doubleTapEnabled = NO;

		Isgl3dTextureMaterial *  spriteMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"particle.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
	
		Isgl3dParticleSystem * particleSystem = [Isgl3dParticleSystem particleSystem];
		Isgl3dParticleNode * particleNode =  [self.scene createNodeWithParticle:particleSystem andMaterial:spriteMaterial];
		particleNode.transparent = YES;
		[particleNode enableAlphaCullingWithValue:0.5];
		[particleSystem setAttenuation:0.01 linear:0.02 quadratic:0.007];
		
		_fountainParticleGenerator = [[Isgl3dFountainBounceParticleGenerator alloc] initWithParticleSystem:particleSystem andNode:particleNode];
		_fountainParticleGenerator.radius = 5;
		_fountainParticleGenerator.height = 5;
		_fountainParticleGenerator.particleRate = 300;
		_fountainParticleGenerator.maxParticles = 2000;
		_fountainParticleGenerator.randomizeColor = YES;
		_fountainParticleGenerator.randomizeSize = YES;
		_fountainParticleGenerator.size = 10;
		[_fountainParticleGenerator startAnimation];
		_fountainParticleGenerator.time = 2;
		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
	[_cameraController release];

	[_fountainParticleGenerator stopAnimation];
	[_fountainParticleGenerator release];

	[super dealloc];
}

- (void) onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController];
}

- (void) onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

- (void) tick:(float)dt {
	
	// update camera
	[_cameraController update];
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
	Isgl3dView * view = [ParticleGeneratorDemoView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
