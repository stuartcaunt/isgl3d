/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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

#import "Isgl3dTutorial1View.h"


@interface Isgl3dTutorial1View ()
@end


#pragma mark -
@implementation Isgl3dTutorial1View

+ (id<Isgl3dCamera>)createDefaultSceneCameraForViewport:(CGRect)viewport {
    Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"creating default camera with perspective projection. Viewport size = %@", NSStringFromCGSize(viewport.size));
    
    CGSize viewSize = viewport.size;
    float fovyRadians = Isgl3dMathDegreesToRadians(45.0f);
    Isgl3dPerspectiveProjection *perspectiveLens = [[Isgl3dPerspectiveProjection alloc] initFromViewSize:viewSize fovyRadians:fovyRadians nearZ:1.0f farZ:10000.0f];
    
    Isgl3dVector3 cameraPosition = Isgl3dVector3Make(0.0f, 0.0f, 10.0f);
    Isgl3dVector3 cameraLookAt = Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
    Isgl3dVector3 cameraLookUp = Isgl3dVector3Make(0.0f, 1.0f, 0.0f);
    Isgl3dLookAtCamera *standardCamera = [[Isgl3dLookAtCamera alloc] initWithLens:perspectiveLens
                                                                             eyeX:cameraPosition.x eyeY:cameraPosition.y eyeZ:cameraPosition.z
                                                                          centerX:cameraLookAt.x centerY:cameraLookAt.y centerZ:cameraLookAt.z
                                                                              upX:cameraLookUp.x upY:cameraLookUp.y upZ:cameraLookUp.z];
    [perspectiveLens release];
    return [standardCamera autorelease];
}


#pragma mark -
- (id)init {
	
	if (self = [super init]) {
		
		// Translate the camera
        Isgl3dLookAtCamera *standardCamera = (Isgl3dLookAtCamera *)self.defaultCamera;
		standardCamera.eyePosition = Isgl3dVector3Make(0.0f, 3.0f, 8.0f);

		// Create an Isgl3dMultiMaterialCube with random colors.
		_cube = [Isgl3dMultiMaterialCube cubeWithDimensionsAndRandomColors:3 height:3 depth:3 nSegmentWidth:2 nSegmentHeight:2 nSegmentDepth:2];
		
		// Add the cube to the scene.
		[self.scene addChild:_cube];
		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void)tick:(float)dt {
	// Rotate the cube by 1 degree about its y-axis
	_cube.rotationY += 1;
}

@end


#pragma mark AppDelegate
/*
 * Implement principal class: simply override the createViews method to return the desired demo view.
 */
@implementation AppDelegate

- (void)createViews {
	// Create view and add to Isgl3dDirector
	Isgl3dView *view = [Isgl3dTutorial1View view];
    view.displayFPS = YES;
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
