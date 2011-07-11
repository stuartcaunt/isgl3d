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

/**
 * Device and viewport orientations
 */
typedef enum {
	Isgl3dOrientation0 = 0,	
    Isgl3dOrientation90Clockwise,
    Isgl3dOrientation180,
    Isgl3dOrientation90CounterClockwise,
    
    Isgl3dOrientationPortrait = Isgl3dOrientation0,
    Isgl3dOrientationLandscapeRight = Isgl3dOrientation90Clockwise,
    Isgl3dOrientationPortraitUpsideDown = Isgl3dOrientation180,
    Isgl3dOrientationLandscapeLeft = Isgl3dOrientation90CounterClockwise
} isgl3dOrientation;

/**
 * Auto-rotation strategy
 */
typedef enum {
	Isgl3dAutoRotationNone = 0,
	Isgl3dAutoRotationByIsgl3dDirector,
	Isgl3dAutoRotationByUIViewController
} isgl3dAutoRotationStrategy;

/**
 * Allowed auto rotations
 */
typedef enum {
	Isgl3dAllowedAutoRotationsAll = 0,
	Isgl3dAllowedAutoRotationsPortraitOnly,
	Isgl3dAllowedAutoRotationsLandscapeOnly
} isgl3dAllowedAutoRotations;

/**
 * Shadow rendering methods
 */
typedef enum {
	Isgl3dShadowNone = 0,
	Isgl3dShadowPlanar,
	Isgl3dShadowMaps
} isgl3dShadowType;


/**
 * Texture precision
 */
typedef enum {
	Isgl3dTexturePrecisionLow = 0,
	Isgl3dTexturePrecisionMedium,
	Isgl3dTexturePrecisionHigh
} Isgl3dTexturePrecision;

/**
 * Occlusion modes
 */
typedef enum {
	Isgl3dOcclusionQuadDistanceAndAngle = 0,
	Isgl3dOcclusionDistanceAndAngle,
	Isgl3dOcclusionQuadDistance,
	Isgl3dOcclusionDistance,
	Isgl3dOcclusionAngle
} Isgl3dOcclusionMode;

