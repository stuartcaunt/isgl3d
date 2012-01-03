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

#import "Isgl3dPrimitive.h"


@class Isgl3dUVMap;

/**
 * The Isgl3dPlane constructs a planar mesh centered in the x-y plane, with z equal to 0.
 * 
 * An Isgl3dUVMap can be added to the plane to fine-tune the rendering of texture maps.
 * 
 * Total number of vertices = (nx + 1) * (ny + 1). 
 */
@interface Isgl3dPlane : Isgl3dPrimitive {
	    
	float _width;
	float _height; 
	
@private
	int _nx;
	int _ny;
	
	Isgl3dUVMap * _uvMap;
}


/**
 * Allocates and initialises (autorelease) plane with the specified geometry.
 * @param width The width of the plane in the x-direction.
 * @param height The height of the plane in the y-direction.
 * @param nx The number of segments along the x-axis.
 * @param ny The number of segments along the y-axis.
 */
+ (id) meshWithGeometry:(float)width height:(float)height nx:(int)nx ny:(int)ny;

/**
 * Allocates and initialises (autorelease) plane with the specified geometry and with a specific UV mapping.
 * Examples of use:
 * <ul>
 * <li>Default UV mapping
 * <p>UVMap *uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:1.0 vB:0.0 uC:0.0 vC:1.0];</p>
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:material width:_width height:_height nx:_nx ny:_ny uvMap:uvMap];</p></li>
 * <li>Default UV mapping without specifying a UV map
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometry:material width:_width height:_height nx:_nx ny:_ny];</p></li>
 * <li>UV map with 90 degree rotation
 * <p>UVMap *uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:0.0 vB:1.0 uC:1.0 vC:0.0];</p>
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:material width:_width height:_height nx:_nx ny:_ny uvMap:uvMap];</p></li>
 * <li>UV map with inverted Y axis
 * <p>UVMap *uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:1.0 uB:1.0 vB:1.0 uC:0.0 vC:0.0];</p>
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:material width:_width height:_height nx:_nx ny:_ny uvMap:uvMap];</p></li>
 * <li>UV map with 50% of the texture displayed
 * <p>UVMap *uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:0.5 vB:0.0 uC:0.0 vC:0.5];</p>
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:material width:_width height:_height nx:_nx ny:_ny uvMap:uvMap];</p></li>
 * </ul>
 * 
 * @param width The width of the plane in the x-direction.
 * @param height The height of the plane in the y-direction.
 * @param nx The number of segments along the x-axis.
 * @param ny The number of segments along the y-axis.
 * @param uvMap The Isgl3dUVMap for mapping a texture material.
 */
+ (id) meshWithGeometryAndUVMap:(float)width height:(float)height nx:(int)nx ny:(int)ny uvMap:(const Isgl3dUVMap *)uvMap;

/**
 * Initialises the plane with the specified geometry.
 * @param width The width of the plane in the x-direction.
 * @param height The height of the plane in the y-direction.
 * @param nx The number of segments along the x-axis.
 * @param ny The number of segments along the y-axis.
 */
- (id) initWithGeometry:(float)width height:(float)height nx:(int)nx ny:(int)ny;

/**
 * Initialises the plane with the specified geometry and with a specific UV mapping.
 * Examples of use:
 * <ul>
 * <li>Default UV mapping
 * <p>UVMap *uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:1.0 vB:0.0 uC:0.0 vC:1.0];</p>
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:material width:_width height:_height nx:_nx ny:_ny uvMap:uvMap];</p></li>
 * <li>Default UV mapping without specifying a UV map
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometry:material width:_width height:_height nx:_nx ny:_ny];</p></li>
 * <li>UV map with 90 degree rotation
 * <p>UVMap *uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:0.0 vB:1.0 uC:1.0 vC:0.0];</p>
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:material width:_width height:_height nx:_nx ny:_ny uvMap:uvMap];</p></li>
 * <li>UV map with inverted Y axis
 * <p>UVMap *uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:1.0 uB:1.0 vB:1.0 uC:0.0 vC:0.0];</p>
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:material width:_width height:_height nx:_nx ny:_ny uvMap:uvMap];</p></li>
 * <li>UV map with 50% of the texture displayed
 * <p>UVMap *uvMap = [Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:0.5 vB:0.0 uC:0.0 vC:0.5];</p>
 * <p>Isgl3dPlane *plane = [[Isgl3dPlane alloc] initWithGeometryAndUVMap:material width:_width height:_height nx:_nx ny:_ny uvMap:uvMap];</p></li>
 * </ul>
 * 
 * @param width The width of the plane in the x-direction.
 * @param height The height of the plane in the y-direction.
 * @param nx The number of segments along the x-axis.
 * @param ny The number of segments along the y-axis.
 * @param uvMap The Isgl3dUVMap for mapping a texture material.
 */
- (id) initWithGeometryAndUVMap:(float)width height:(float)height nx:(int)nx ny:(int)ny uvMap:(const Isgl3dUVMap *)uvMap;

@end
