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

#define SHADOW_MAP_HEIGHT 256.0
#define SHADOW_MAP_WIDTH 256.0

#import "Isgl3dLight.h"

@class Isgl3dGLDepthRenderTexture;

/**
 * The Isgl3dShadowCastingLight is used as a light source for casting shadows onto the scene.
 * 
 * It inherits directly from Isgl3dLight and has exactly the same characteristics, the only difference being is 
 * that it is used during the render process to generate shadows from its location: it is therefore behaves like
 * a point light rather than directional.
 * 
 * Only one Isgl3dShadowCastingLight can be added to the scene.
 */
@interface Isgl3dShadowCastingLight : Isgl3dLight {
	    
@private
	Isgl3dGLDepthRenderTexture * _shadowRenderTexture;

	Isgl3dMatrix4 _viewMatrix;
	
	Isgl3dNode * _planarShadowsNode;
	Isgl3dVector3 _planarShadowsNodeNormal;
}

/**
 * For use with planar shadows only, this contains the node onto which shadows are rendered.
 */
@property (nonatomic, retain) Isgl3dNode * planarShadowsNode;

/**
 * For use with planar shadows only, this contains the vector representation of the plane on which shadows are rendered.
 * Even if the node is not a plane, shadows are generated only in a single plane.
 */
@property (nonatomic) Isgl3dVector3 planarShadowsNodeNormal;

@end
