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


/**
 * The Isgl3DUVMap defines a general mapping for UV coordinates typically used for mapping textures to Isgl3dPlanes where
 * the coordinates of the UV map are not from 0 to 1 along both axes. This can for example provide mapping of a 
 * part of a texture or transformed part of the texture.
 * 
 * The UV map is specified by three points: the bottom left coordinate, the bottom right coordinate
 * and the top left coordinate. 
 */
@interface Isgl3dUVMap : NSObject {
	
@private
	float _uA; 
	float _vA; 
	
	float _uB; 
	float _vB; 
	
	float _uC; 
	float _vC; 
}

/**
 * Produces a UV map with specified coordinates.
 * @param uA the u componenent of the bottom left coordinate.
 * @param vA the v componenent of the bottom left coordinate.
 * @param uB the u componenent of the bottom right coordinate.
 * @param vB the v componenent of the bottom right coordinate.
 * @param uC the u componenent of the top left coordinate.
 * @param vC the v componenent of the top left coordinate.
 * @result (autorelease) UV map with specified coordinates.
 */
+ (Isgl3dUVMap *) uvMapWithUA:(float)uA vA:(float)vA uB:(float)uB vB:(float)vB  uC:(float)uC vC:(float)vC;

/**
 * Contains the default UV map using the full texture.
 */
+ (const Isgl3dUVMap *) standardUVMap;

/**
 * Contains the u componenent of the bottom left coordinate.
 */
@property float uA;

/**
 * Contains the v componenent of the bottom left coordinate.
 */
@property float vA;

/**
 * Contains the u componenent of the bottom right coordinate.
 */
@property float uB;

/**
 * Contains the v componenent of the bottom right coordinate.
 */
@property float vB;

/**
 * Contains the u componenent of the top left coordinate.
 */
@property float uC;

/**
 * Contains the v componenent of the top left coordinate.
 */
@property float vC;

@end


