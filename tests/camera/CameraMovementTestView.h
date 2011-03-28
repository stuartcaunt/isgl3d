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

#import "isgl3d.h"
#import "Isgl3dDemoView.h"

@interface CameraMovementTestView : Isgl3dDemoView <Isgl3dTouchScreenResponder> {
	float _theta;

	float _lastTouchX;
	float _lastTouchY;
	
	float _dFocus;
	float _dZoom;
	BOOL _moving;
	
	float _focus;
	float _zoom;
}

@end


/*
 * Principal class to be instantiated in main.h. 
 * The window and view are created in Isgl3dAppDelegate, the demo view is returned from viewWithFrame.
 */
#import "Isgl3dAppDelegate.h"
@interface AppDelegate : Isgl3dAppDelegate
- (Isgl3dView3D *) viewWithFrame:(CGRect)frame;
@end


