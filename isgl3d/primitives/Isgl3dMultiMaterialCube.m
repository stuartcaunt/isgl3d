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


#import "Isgl3dMultiMaterialCube.h"
#import "Isgl3dUVMap.h"
#import "Isgl3dPlane.h"
#import "Isgl3dMaterial.h"
#import "Isgl3dColorMaterial.h"


@interface Isgl3dMultiMaterialCube (PrivateMethods)
- (void) buildAllFaces:(NSArray *)materialArray uvMapArray:(NSArray *)uvMapArray;
@end


@implementation Isgl3dMultiMaterialCube 

+ (id) cubeWithDimensions:(float)width height:(float)height depth:(float)depth 
		nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth {
	return [[[self alloc] initWithDimensions:width height:height depth:depth 
		nSegmentWidth:nSegmentWidth nSegmentHeight:nSegmentHeight nSegmentDepth:nSegmentDepth] autorelease];
}

+ (id) cubeWithDimensionsAndMaterials:(NSArray *)materialArray uvMapArray:(NSArray *)uvMapArray width:(float)width height:(float)height depth:(float)depth 
		nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth {
	return [[[self alloc] initWithDimensionsAndMaterials:materialArray uvMapArray:uvMapArray width:width height:height depth:depth 
		nSegmentWidth:nSegmentWidth nSegmentHeight:nSegmentHeight nSegmentDepth:nSegmentDepth] autorelease];
}

+ (id) cubeWithDimensionsAndRandomColors:(float)width height:(float)height depth:(float)depth 
		nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth {
	return [[[self alloc] initWithDimensionsAndRandomColors:width height:height depth:depth 
		nSegmentWidth:nSegmentWidth nSegmentHeight:nSegmentHeight nSegmentDepth:nSegmentDepth] autorelease];
}


- (id) initWithDimensions:(float)width height:(float)height depth:(float)depth 
		 nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth {
	
	if ((self = [super init])) {

		_width = width;
		_height = height;
		_depth = depth;
		_nSegmentWidth = nSegmentWidth;
		_nSegmentHeight = nSegmentHeight;
		_nSegmentDepth = nSegmentDepth;
		
	}
	
    return self;
}


- (id) initWithDimensionsAndMaterials:(NSArray *)materialArray uvMapArray:(NSArray *)uvMapArray width:(float)width height:(float)height depth:(float)depth 
		nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth {

	if ((self = [self initWithDimensions:width height:height depth:depth nSegmentWidth:nSegmentWidth nSegmentHeight:nSegmentHeight nSegmentDepth:nSegmentDepth])) {
		[self buildAllFaces:materialArray uvMapArray:uvMapArray];
    }
	
    return self;
}

- (id) initWithDimensionsAndRandomColors:(float)width height:(float)height depth:(float)depth 
		nSegmentWidth:(int)nSegmentWidth nSegmentHeight:(int)nSegmentHeight nSegmentDepth:(int)nSegmentDepth {

	if ((self = [self initWithDimensions:width height:height depth:depth nSegmentWidth:nSegmentWidth nSegmentHeight:nSegmentHeight nSegmentDepth:nSegmentDepth])) {

		[self addFace:FaceIdFront material:nil uvMap:nil];
		[self addFace:FaceIdBack material:nil uvMap:nil];
		[self addFace:FaceIdRight material:nil uvMap:nil];
		[self addFace:FaceIdLeft material:nil uvMap:nil];
		[self addFace:FaceIdTop material:nil uvMap:nil];
		[self addFace:FaceIdBottom material:nil uvMap:nil];

    }
	
    return self;
}

- (void) dealloc {
	[super dealloc];
}

- (void) buildAllFaces:(NSArray *)materialArray uvMapArray:(NSArray *)uvMapArray {
	
	if ([materialArray count] != 6) {
		@throw [NSException exceptionWithName:@"NSException" 
									   reason:@"MultiTextureCube.buildAllFaces() requires 6 materials."
									 userInfo:nil];
	}	
	
	[self addFace:FaceIdFront material:[materialArray objectAtIndex:FaceIdFront] uvMap:[uvMapArray objectAtIndex:FaceIdFront]];
	[self addFace:FaceIdBack material:[materialArray objectAtIndex:FaceIdBack] uvMap:[uvMapArray objectAtIndex:FaceIdBack]];
	[self addFace:FaceIdRight material:[materialArray objectAtIndex:FaceIdRight] uvMap:[uvMapArray objectAtIndex:FaceIdRight]];
	[self addFace:FaceIdLeft material:[materialArray objectAtIndex:FaceIdLeft] uvMap:[uvMapArray objectAtIndex:FaceIdLeft]];
	[self addFace:FaceIdTop material:[materialArray objectAtIndex:FaceIdTop] uvMap:[uvMapArray objectAtIndex:FaceIdTop]];
	[self addFace:FaceIdBottom material:[materialArray objectAtIndex:FaceIdBottom] uvMap:[uvMapArray objectAtIndex:FaceIdBottom]];
}


- (Isgl3dPlane *) addFace:(FaceId)faceId material:(Isgl3dMaterial *)material uvMap:(const Isgl3dUVMap *)uvMap {
	Isgl3dPlane *plane;
	
	// First, create the plane
	switch (faceId) {
		case FaceIdFront:
			plane = [Isgl3dPlane meshWithGeometryAndUVMap:_width height:_height nx:_nSegmentWidth ny:_nSegmentHeight uvMap:uvMap];
			break;
		case FaceIdBack:
			plane = [Isgl3dPlane meshWithGeometryAndUVMap:_width height:_height nx:_nSegmentWidth ny:_nSegmentHeight uvMap:uvMap];
			break;
		case FaceIdRight:
			plane = [Isgl3dPlane meshWithGeometryAndUVMap:_height height:_depth nx:_nSegmentHeight ny:_nSegmentDepth uvMap:uvMap];
			break;
		case FaceIdLeft:
			plane = [Isgl3dPlane meshWithGeometryAndUVMap:_height height:_depth nx:_nSegmentHeight ny:_nSegmentDepth uvMap:uvMap];
			break;
		case FaceIdTop:
			plane = [Isgl3dPlane meshWithGeometryAndUVMap:_width height:_depth nx:_nSegmentWidth ny:_nSegmentDepth uvMap:uvMap];
			break;
		case FaceIdBottom:
			plane = [Isgl3dPlane meshWithGeometryAndUVMap:_width height:_depth nx:_nSegmentWidth ny:_nSegmentDepth uvMap:uvMap];
			break;
		default:
			@throw [NSException exceptionWithName:@"NSException" 
										   reason:@"MultiTextureCube.addFace() Unknown face id."
										 userInfo:nil];			
	}

	// Build the MeshNode	
	Isgl3dMeshNode * node = [self createNodeWithMesh:plane andMaterial:material];	
	
	// Add transformation to each node
	switch (faceId) {
		case FaceIdFront:
			[node setPositionValues:0.0 y:0.0 z:_depth * 0.5];
			break;
		case FaceIdBack:
			[node setPositionValues:0.0 y:0.0 z:- _depth * 0.5];
			[node setRotation:180.0 x:0.0 y:1.0 z:0.0];
			break;
		case FaceIdRight:
			[node setPositionValues:_width * 0.5 y:0.0 z:0.0];
			[node setRotation:90.0 x:0.0 y:1.0 z:0.0];
			[node rotate:90.0 x:1.0 y:0.0 z:0.0];
			break;
		case FaceIdLeft:
			[node setPositionValues:- _width * 0.5 y:0.0 z:0.0];
			[node setRotation:-90.0 x:0.0 y:1.0 z:0.0];
			[node rotate:90.0 x:1.0 y:0.0 z:0.0];
			break;
		case FaceIdTop:
			[node setPositionValues:0.0 y:_height * 0.5 z:0.0];
			[node setRotation:- 90.0 x:1.0 y:0.0 z:0.0];
			break;
		case FaceIdBottom:
			[node setPositionValues:0.0 y:- _height * 0.5 z:0.0];
			[node setRotation:90.0 x:1.0 y:0.0 z:0.0];
			break;
		default:
			@throw [NSException exceptionWithName:@"NSException" 
										   reason:@"MultiTextureCube.addFace() Unknown face id."
										 userInfo:nil];			
	}

	return plane;
}


@end
