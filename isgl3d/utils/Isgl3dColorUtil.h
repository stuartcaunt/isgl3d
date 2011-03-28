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
 * A utility class for converting colors between float arrays and hexadecimal strings.
 */
@interface Isgl3dColorUtil : NSObject

/**
 * Converts the rgb value hex string into a 4-value float array (rgba) with alpha set to 1.
 * The rgb values are between 0 and 1.
 * @param inColorString The hexadecimal color string, eg "ab3f2e".
 * @param floatArray A 4-value float array into which the rgba components are stored.
 */
+ (void) hexColorStringToFloatArray:(NSString*)inColorString floatArray:(float *)floatArray;

/**
 * Returns a random hex value for a color.
 * @result (autorelease) NSString containing hex value of a random RGB color
 */
+ (NSString *) randomHexColor;

/**
 * Returns the hex string equivalent for a color
 * @param color a 3-value float array of rgb values between 0 and 1.
 * @result (autorelease) NSString containing hex value of given color
 */
+ (NSString *) rgbString:(float *)color;

/**
 * Returns the hex string equivalent for a color
 * @param color a 4-value float array of rgba values between 0 and 1.
 * @result (autorelease) NSString containing hex value of given color
 */
+ (NSString *) rgbaString:(float *)color;

@end
