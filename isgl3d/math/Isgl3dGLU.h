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

#import <Foundation/Foundation.h>

#import "isgl3dTypes.h"
#import "isgl3dMatrix.h"

/**
 * The Isgl3dGLU class provides some of the functionalities to the OpengGL Utility Library, essentially
 * to construct view and projection matrices for the Isgl3DCamera. 
 */
@interface Isgl3dGLU : NSObject {
	    
@private
}

/**
 * Calculates a view matrix for a given eye position, a look-at position and an up vector.
 * @param eyex The x component of the eye position.
 * @param eyey The y component of the eye position.
 * @param eyez The z component of the eye position.
 * @param centerx The x componenent of the look-at position that is in the center of the view.
 * @param centery The y componenent of the look-at position that is in the center of the view.
 * @param centerz The z componenent of the look-at position that is in the center of the view.
 * @param upx The x componenent of the vector mapped to the y-direction of the view matrix.
 * @param upy The y componenent of the vector mapped to the y-direction of the view matrix.
 * @param upz The z componenent of the vector mapped to the y-direction of the view matrix.
 * @return the calculated view matrix.
 */
+ (Isgl3dMatrix4) lookAt:(float)eyex eyey:(float)eyey eyez:(float)eyez centerx:(float)centerx centery:(float)centery centerz:(float)centerz upx:(float)upx upy:(float)upy upz:(float)upz;

/**
 * Calculates a projection matrix for a perspective view.
 * @param fovy The field of view in the y direction.
 * @param aspect The aspect ratio of the display.
 * @param near The nearest distance along the z-axis for which elements are rendered.
 * @param far the furthest distance along the z-axis for which elements are rendered.
 * @param zoom The zoom factor.
 * @param orientation indicates the rotation (about z) for the projection. 
 */
+ (Isgl3dMatrix4) perspective:(float)fovy aspect:(float)aspect near:(float)near far:(float)far zoom:(float)zoom orientation:(isgl3dOrientation)orientation;

/**
 * Calculates a projection matrix for an orthographic view.
 * @param left The left-most position along the x-axis for which elements are rendered. 
 * @param right The right-most position along the x-axis for which elements are rendered. 
 * @param bottom The bottom-most position along the y-axis for which elements are rendered. 
 * @param top The top-most position along the y-axis for which elements are rendered. 
 * @param near The nearest distance along the z-axis for which elements are rendered.
 * @param far the furthest distance along the z-axis for which elements are rendered.
 * @param zoom The zoom factor.
 * @param orientation indicates the rotation (about z) for the projection. 
 */
+ (Isgl3dMatrix4) ortho:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far zoom:(float)zoom orientation:(isgl3dOrientation)orientation;

@end
