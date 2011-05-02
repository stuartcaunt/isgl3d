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

#import "Isgl3dGLUIComponent.h"

/**
 * The Isgl3dGLUILabel is used to render text labels onto the Isgl3dGLUI user interface.
 */
@interface Isgl3dGLUILabel : Isgl3dGLUIComponent {
	
@private
	NSString * _text;
	NSString * _fontName;
	CGFloat _size;
	
	
	BOOL _useCharacterSet;
	NSMutableDictionary * _characters;
	NSMutableArray * _characterNodes;
}

/**
 * Allocates and initialises (autorelease) label with text, a font and a font size.
 * @param text The text to be displayed.
 * @param fontName The name of the font.
 * @param fontSize The size of the font.
 */
+ (id) labelWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize;

/**
 * Allocates and initialises (autorelease) label with text, a font and a font size.
 * Intialising the label in this way aims to improve the performance of an application for which the label
 * has rapidly changing text. Using a character set, the label maintains a dictionary of characters that can
 * be re-rendered multiple times. Each character has an associated texture material and a mesh. A full string
 * is created by rendering each character next to each other.
 * 
 * Note: this is very experimental.
 * @param text The text to be displayed.
 * @param fontName The name of the font.
 * @param fontSize The size of the font.
 */
+ (id) labelWithTextCharacterSet:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;

/**
 * Initialises the label with text, a font and a font size.
 * @param text The text to be displayed.
 * @param fontName The name of the font.
 * @param fontSize The size of the font.
 */
- (id) initWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize;

/**
 * Initialises the label with text, a font and a font size.
 * Intialising the label in this way aims to improve the performance of an application for which the label
 * has rapidly changing text. Using a character set, the label maintains a dictionary of characters that can
 * be re-rendered multiple times. Each character has an associated texture material and a mesh. A full string
 * is created by rendering each character next to each other.
 * 
 * Note: this is very experimental.
 * @param text The text to be displayed.
 * @param fontName The name of the font.
 * @param fontSize The size of the font.
 */
- (id) initWithTextCharacterSet:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;

/**
 * Modifies the text to be shown on the label.
 * @param text The text to be displayed.
 */
- (void) setText:(NSString *)text;

@end
