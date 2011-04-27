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

#import "Isgl3dCube.h"
#import "Isgl3dFloatArray.h"
#import "Isgl3dUShortArray.h"


	
@interface Isgl3dCube (PrivateMethods)
- (int)buildPlaneStartingAtIndice:(int)startingIndice 
							width:(float)width height:(float)height
					   translateX:(float)translateX translateY:(float)translateY translateZ:(float)translateZ
						  normalX:(float)normalX normalY:(float)normalY normalZ:(float)normalZ
						clockwise:(BOOL)clockwisev
					   vertexData:(Isgl3dFloatArray *)vertexData
	   		 	 		  indices:(Isgl3dUShortArray *)indices;

@end
	
	
	
@implementation Isgl3dCube

@synthesize width = _width;
@synthesize height = _height;
@synthesize depth = _depth;

+ (id) meshWithGeometry:(float)width height:(float)height depth:(float)depth nx:(int)nx ny:(int)ny {
	return [[[self alloc] initWithGeometry:width height:height depth:depth nx:nx ny:ny] autorelease];
}

- (id)initWithGeometry:(float)width height:(float)height depth:(float)depth nx:(int)nx ny:(int)ny {
	
	if ((self = [super init])) {
		_width = width;
		_height = height;
		_depth = depth;
		_nx = nx;
		_ny = ny;
		
		[self constructVBOData];
	}
	
	return self;
}

	
- (void) dealloc {
	
    [super dealloc];
}

	
- (void) fillVertexData:(Isgl3dFloatArray *)vertexData andIndices:(Isgl3dUShortArray *)indices {
	
	int indice = 0;
	// Top
	indice = [self buildPlaneStartingAtIndice:indice 
										width:_width height:_height
								   translateX:0.0 translateY:0.0 translateZ:_depth * 0.5 
									  normalX:0.0 normalY:0.0 normalZ:1.0 
									clockwise:NO 
									vertexData:vertexData 
									indices:indices];
	// Bottom
	indice = [self buildPlaneStartingAtIndice:indice 
										width:_width height:_height
								   translateX:0.0 translateY:0.0 translateZ:- _depth * 0.5 
									  normalX:0.0 normalY:0.0 normalZ:- 1.0 
									clockwise:YES
									vertexData:vertexData 
									indices:indices];
	
	// Right
	indice = [self buildPlaneStartingAtIndice:indice 
										width:_height height:_depth
								   translateX:_width * 0.5 translateY:0.0 translateZ:0.0 
									  normalX:1.0 normalY:0.0 normalZ:0.0 
									clockwise:NO 
									vertexData:vertexData 
									indices:indices];
	// Left
	indice = [self buildPlaneStartingAtIndice:indice 
										width:_height height:_depth
								   translateX:- _width * 0.5 translateY:0.0 translateZ:0.0 
									  normalX:- 1.0 normalY:0.0 normalZ:0.0 
									clockwise:YES 
									vertexData:vertexData 
									indices:indices];
	
	// Front
	indice = [self buildPlaneStartingAtIndice:indice 
										width:_depth height:_width
								   translateX:0.0 translateY:_height * 0.5 translateZ:0.0 
									  normalX:0.0 normalY:1.0 normalZ:0.0 
									clockwise:NO 
									vertexData:vertexData 
									indices:indices];
	// Rear
	[self buildPlaneStartingAtIndice:indice 
										width:_depth height:_width
								   translateX:0.0 translateY:- _height * 0.5 translateZ:0.0 
									  normalX:0.0 normalY:-1.0 normalZ:0.0 
									clockwise:YES 
									vertexData:vertexData 
									indices:indices];
}


/**
 * @return the indice of the last inserted vertex. 
 */
- (int)buildPlaneStartingAtIndice:(int)startingIndice
							width:(float)width height:(float)height
					   translateX:(float)translateX translateY:(float)translateY translateZ:(float)translateZ
						  normalX:(float)normalX normalY:(float)normalY normalZ:(float)normalZ
						clockwise:(BOOL)clockwise 
					   vertexData:(Isgl3dFloatArray *)vertexData 
	   		 	 		  indices:(Isgl3dUShortArray *)indices {
	
	for (int i = 0; i <= _nx; i++) {
		float x = -(width * 0.5) + i * (width / _nx);
		float u = 1.0 - (1.0 * i / _nx);
		
		for (int j = 0; j <= _ny; j++) {
			float y = -(height * 0.5) + j * (height / _ny);
			float v = 1.0 * j / _ny;
			
			if (normalZ != 0.0) {
				[vertexData add:translateX + x];
				[vertexData add:translateY + y];
				[vertexData add:translateZ];
			} else if (normalY != 0.0) {
				[vertexData add:translateX + y];
				[vertexData add:translateY];
				[vertexData add:translateZ + x];
			} else {
				[vertexData add:translateX];
				[vertexData add:translateY + x];
				[vertexData add:translateZ + y];
			}
			
			[vertexData add:normalX];
			[vertexData add:normalY];
			[vertexData add:normalZ];
			
			[vertexData add:u];
			[vertexData add:v];
		}
	}
	
	for (int i = 0; i < _nx; i++) {
		for (int j = 0; j < _ny; j++) {
			
			int first = startingIndice + j * (_nx + 1) + i;
			int second = first + (_nx + 1);
			int third = first + 1;
			int fourth = second + 1;
			
			if (clockwise == YES) {
				[indices add:first];
				[indices add:third];
				[indices add:second];
				
				[indices add:third];
				[indices add:fourth];
				[indices add:second];				
			} 
			else {
				[indices add:first];
				[indices add:second];
				[indices add:third];
				
				[indices add:third];
				[indices add:second];
				[indices add:fourth];				
			} 					
		}
	}
	
	return startingIndice + (_nx + 1) * (_ny + 1);
	
}


- (unsigned int) estimatedVertexSize {
	return (_nx + 1) * (_ny + 1) * 6 * 8;
}

- (unsigned int) estimatedIndicesSize {
	return _nx * _ny * 6 * 6;
}

@end
