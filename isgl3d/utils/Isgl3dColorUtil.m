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

#import "Isgl3dColorUtil.h"
#import "Isgl3dLog.h"

#import <stdlib.h>
#import <time.h>

@implementation Isgl3dColorUtil

- (id)init {
	srandom(time(NULL));

	return [super init];
}

+ (void) hexColorStringToFloatArray:(NSString*)inColorString floatArray:(float *)floatArray {
	if ([inColorString length] > 2) {
		if ([inColorString hasPrefix:@"0x"] || [inColorString hasPrefix:@"0X"]) {
			inColorString = [inColorString substringFromIndex:2];
		}
	}
		
	if ([inColorString length] != 6 && [inColorString length] != 8) {
		Isgl3dLog(Error, @"Input string is not a valid color: %s", inColorString);
		return;
	}

	unsigned colorCode = 0;
	unsigned char redByte;
	unsigned char greenByte;
	unsigned char blueByte;
	unsigned char alphaByte;
 
	if (inColorString != nil) {
		NSScanner* scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode];
	}
	
	if ([inColorString length] == 8) {
		redByte   = (unsigned char)(colorCode >> 24);
		greenByte = (unsigned char)(colorCode >> 16);
		blueByte  = (unsigned char)(colorCode >> 8);
		alphaByte  = (unsigned char)(colorCode);
		
	} else {
		redByte   = (unsigned char)(colorCode >> 16);
		greenByte = (unsigned char)(colorCode >> 8);
		blueByte  = (unsigned char)(colorCode);
		alphaByte = 255;
	}

	floatArray[0] = (float)redByte / 255.0f;
	floatArray[1] = (float)greenByte / 255.0f;
	floatArray[2] = (float)blueByte / 255.0f;
	floatArray[3] = (float)alphaByte / 255.0f;
}

+ (NSString *) randomHexColor {
	return [NSString stringWithFormat:@"%02x%02x%02x", lroundf(255.0 * random() / RAND_MAX), lroundf(255.0 * random() / RAND_MAX), lroundf(255.0 * random() / RAND_MAX)];
}

+ (NSString *) rgbString:(float *)color {
	return [NSString stringWithFormat:@"%02x%02x%02x", lroundf(255.0 * color[0]), lroundf(255.0 * color[1]), lroundf(255.0 * color[2])];
}

+ (NSString *) rgbaString:(float *)color {
	return [NSString stringWithFormat:@"%02x%02x%02x%02x", lroundf(255.0 * color[0]), lroundf(255.0 * color[1]), lroundf(255.0 * color[2]), lroundf(255.0 * color[3])];
}

- (void) dealloc {
	[super dealloc];
}

@end
