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

#import "GesturesDemoView.h"
#import "Isgl3dDemoCameraController.h"


@interface GesturesDemoView () <UIGestureRecognizerDelegate>
- (void)sceneTap:(UITapGestureRecognizer *)gestureRecognizer;
- (void)nodeTap:(UITapGestureRecognizer *)gestureRecognizer;
- (void)pinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer;
- (void)rotationGesture:(UIRotationGestureRecognizer *)gestureRecognizer;
@end


@implementation GesturesDemoView

- (id) init {
	
	if ((self = [super init])) {
        
        // Create tap recognizer handling all none node-taps        
        _rotationActive = YES;
        _sceneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sceneTap:)];
        _sceneTapGestureRecognizer.delegate = self;
        [[Isgl3dDirector sharedInstance] addGestureRecognizer:_sceneTapGestureRecognizer forNode:nil];

        // Create the node specific gesture recognizers
        _selected = NO;
        _nodeTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nodeTap:)];
        _nodeTapGestureRecognizer.delegate = self;

        _objectScale = 1.0;
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        _pinchGestureRecognizer.delegate = self;
        
        _objectZRotation = 0.0;
        _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];
        _rotationGestureRecognizer.delegate = self;
        
		// Create and configure touch-screen camera controller
		_container = [[self.scene createNode] retain];
		
		// Create the primitive
        float selectedColor[4] = { (237.0/255.0), (250.0/255.0), (0.0/255.0), 1.0 };
        
        _standardMaterial = [[Isgl3dTextureMaterial alloc] initWithTextureFile:@"red_checker.png" shininess:0.9];
        _selectedMaterial = [_standardMaterial copy];
        _selectedMaterial.diffuseColor = selectedColor;
        _selectedMaterial.specularColor = selectedColor;
	
		Isgl3dTorus * torusMesh = [Isgl3dTorus meshWithGeometry:2 tubeRadius:1 ns:32 nt:32];
		_torus = [_container createNodeWithMesh:torusMesh andMaterial:_standardMaterial];
		_torus.position = iv3(0, 0, 0);
        _torus.rotationX = 45.0;
        
        _torus.interactive = YES;
        [_torus addGestureRecognizer:_nodeTapGestureRecognizer];
        [_torus addGestureRecognizer:_pinchGestureRecognizer];
        [_torus addGestureRecognizer:_rotationGestureRecognizer];

		// Add light
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
		light.position = iv3(5, 15, 15);
		[self.scene addChild:light];
		
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	
	return self;
}

- (void) dealloc {
    [_standardMaterial release];
    _standardMaterial = nil;
    
    [_selectedMaterial release];
    _selectedMaterial = nil;
    
    [_sceneTapGestureRecognizer release];
    _sceneTapGestureRecognizer = nil;
    
    [_nodeTapGestureRecognizer release];
    _nodeTapGestureRecognizer = nil;
    [_pinchGestureRecognizer release];
    _pinchGestureRecognizer = nil;
    [_rotationGestureRecognizer release];
    _rotationGestureRecognizer = nil;
    
	[super dealloc];
}

- (void) onActivated {
}

- (void) onDeactivated {
}

- (void) tick:(float)dt {
    if (_rotationActive) {
        _containerRotation += 0.2;
        
        _container.rotationY = _containerRotation;
        _torus.rotationY = _containerRotation;
    }
}


#pragma mark UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    if ((gestureRecognizer == _rotationGestureRecognizer) || (otherGestureRecognizer == _rotationGestureRecognizer))
        return NO;
    
    return YES;
}


#pragma mark GestureRecognizer action methods
- (void)sceneTap:(UITapGestureRecognizer *)gestureRecognizer {
    _rotationActive = !_rotationActive;
}

- (void)nodeTap:(UITapGestureRecognizer *)gestureRecognizer {
    _selected = !_selected;
    if (_selected) {
        _torus.material = _selectedMaterial;
    } else {
        _torus.material = _standardMaterial;
    }
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged)
	{
        _objectScale *= gestureRecognizer.scale;
        [_torus setScale:_objectScale];
        [gestureRecognizer setScale:1];
	}
}

- (void)rotationGesture:(UIRotationGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        _objectZRotation += (gestureRecognizer.rotation * 180.0 / M_PI);
        [_torus setRotationZ:_objectZRotation];
        [gestureRecognizer setRotation:0];
    }
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
	Isgl3dView * view = [GesturesDemoView view];
	[[Isgl3dDirector sharedInstance] addView:view];
}

@end
