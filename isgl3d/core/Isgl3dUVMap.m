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


#import "Isgl3dUVMap.h"


@implementation Isgl3dUVMap


@synthesize uA = _uA;
@synthesize vA = _vA;
@synthesize uB = _uB;
@synthesize vB = _vB;
@synthesize uC = _uC;
@synthesize vC = _vC;


static Isgl3dUVMap *theStandardUVMap = nil;


- (id) initWithUA:(float)uA vA:(float)vA uB:(float)uB vB:(float)vB  uC:(float)uC vC:(float)vC {
	if ((self = [super init])) {
		_uA = uA;
		_vA = vA;
		_uB = uB;
		_vB = vB;
		_uC = uC;
		_vC = vC;
	}
	
	return self;
}	


+ (Isgl3dUVMap *) uvMapWithUA:(float)uA vA:(float)vA uB:(float)uB vB:(float)vB  uC:(float)uC vC:(float)vC {
	return [[[Isgl3dUVMap alloc] initWithUA:uA vA:vA uB:uB vB:vB uC:uC vC:vC] autorelease];
}


+ (const Isgl3dUVMap *) standardUVMap {
	if (theStandardUVMap == nil) {
		theStandardUVMap = [[Isgl3dUVMap uvMapWithUA:0.0 vA:0.0 uB:1.0 vB:0.0 uC:0.0 vC:1.0] retain];
	}
	return theStandardUVMap;
}
	
	

@end
