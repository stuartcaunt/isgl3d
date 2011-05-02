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

/**
 * The Isgl3dTerrainMesh creates a 3-dimensional terrain mesh (elevations in the y-direction) centered on the origin
 * on the x-z plane, using image data as the elevation data.
 * 
 * An image file is passed to the Isgl3dTerrainMesh object along with a color channel to use (0 = red, 1 = green 2 = blue, 3 = alpha). The
 * pixel value (between 0 and 255) is then converted into an elevation (the maximum being passed during the initialisation).
 * 
 * Only certain points on the image are used to determine the elevation: this is determined by the nx and ny parameters set during the initialisation.
 * 
 * Total number of vertices = (nx + 1) * (ny + 1). 
 */
@interface Isgl3dTerrainMesh : Isgl3dPrimitive {
	
@private
	float _width;
	float _depth; 
	float _height; 
	
	int _nx;
	int _nz;
	
	unsigned int _channel;
	
	NSString * _terrainDataFile;
}

/**
 * Allocates and initialises (autorelease) Isgl3dTerrainMesh with a specified geometry and terrain data file.
 * @param terrainDataFile The file name of the image containing the terrain data.
 * @param channel The color channel of the image to use to obtain the data.
 * @param width The width of the resulting terrain in the x-direction.
 * @param depth The depth of the resulting terrain in the z-direction.
 * @param height The maximum height of the resulting terrain in the y-direction. All color values coming from the image file are scaled between 0 and this value.
 * @param nx The number of segments along the x-axis.
 * @param nz The number of segments along the z-axis.
 */
+ (id) meshWithTerrainDataFile:(NSString *)terrainDataFile channel:(unsigned int)channel width:(float)width depth:(float)depth height:(float)height nx:(int)nx nz:(int)nz;

/**
 * Initialises the Isgl3dTerrainMesh with a specified geometry and terrain data file.
 * @param terrainDataFile The file name of the image containing the terrain data.
 * @param channel The color channel of the image to use to obtain the data.
 * @param width The width of the resulting terrain in the x-direction.
 * @param depth The depth of the resulting terrain in the z-direction.
 * @param height The maximum height of the resulting terrain in the y-direction. All color values coming from the image file are scaled between 0 and this value.
 * @param nx The number of segments along the x-axis.
 * @param nz The number of segments along the z-axis.
 */
- (id) initWithTerrainDataFile:(NSString *)terrainDataFile channel:(unsigned int)channel width:(float)width depth:(float)depth height:(float)height nx:(int)nx nz:(int)nz;

@end
