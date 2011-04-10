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

#import "Isgl3dGLUILabel.h"
#import "Isgl3dNode.h"
#import "Isgl3dTextureMaterial.h"
#import "Isgl3dPrimitiveFactory.h"


@interface Isgl3dGLCharacter : NSObject {
@private
	Isgl3dTextureMaterial * _material;
	Isgl3dGLMesh * _mesh;
}

@property (nonatomic, retain) Isgl3dTextureMaterial * material;
@property (nonatomic, retain) Isgl3dGLMesh * mesh;

@end

@implementation Isgl3dGLCharacter

@synthesize material = _material;
@synthesize mesh = _mesh;

- (void) dealloc {
	[_material release];
	[_material release];
	[super dealloc];
}

@end



@implementation Isgl3dGLUILabel

+ (id) labelWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize {
	return [[[self alloc] initWithText:text fontName:fontName fontSize:fontSize] autorelease];
}

+ (id) labelWithTextCharacterSet:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize {
	return [[[self alloc] initWithTextCharacterSet:text fontName:fontName fontSize:fontSize] autorelease];
}

- (id) initWithText:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize {
	if ((self = [super initWithMesh:nil andMaterial:nil])) {
		
		_fontName = [fontName retain];
		_size = fontSize;
		
		[self setText:text];
	}
	return self;
}

- (id) initWithTextCharacterSet:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize {
	_useCharacterSet = YES;
	_characters = [[NSMutableDictionary alloc] init];
	_characterNodes = [[NSMutableArray alloc] init];
	if ((self = [self initWithText:text fontName:fontName fontSize:fontSize])) {
		
//	} else{
//		[_characters release];
//		[_characterNodes release];
	}
	
	return self;
}

- (void) dealloc {
	if (_characters) {
		[_characters release];
	}
	if (_characterNodes) {
		[_characterNodes release];
	}
	
	[super dealloc];
}

- (void) setText:(NSString *)text {
	if (text && ![text isEqualToString:_text]) {
		[_text release];
		_text = [text retain];
		
		if (_useCharacterSet) {
			// Remove all previous character nodes
			[self clearAll];
			
			unsigned int width = 0;
			unsigned int offset = 0;
			unsigned int height = 0;
			
			// Iterate over characters 
			for (int i = 0; i < text.length; i++) {
				NSRange range = {i, 1};
				NSString * character = [text substringWithRange:range];
				
				// See if character mesh and texture exist already, create if not
				Isgl3dGLCharacter * glCharacter = [_characters objectForKey:character];
				if (!glCharacter) {
					Isgl3dTextureMaterial * textureMaterial = [Isgl3dTextureMaterial materialWithText:character fontName:_fontName fontSize:_size];
					Isgl3dGLMesh * mesh = [[Isgl3dPrimitiveFactory sharedInstance] UILabelMeshWithWidth:textureMaterial.width height:textureMaterial.height contentSize:textureMaterial.contentSize];
					
					glCharacter = [[Isgl3dGLCharacter alloc] init];
					glCharacter.mesh = mesh;
					glCharacter.material = textureMaterial;
					
					//characterNode = [self createNodeWithMesh:mesh andMaterial:textureMaterial];
					[_characters setObject:[glCharacter autorelease] forKey:character];
				}

				// Re-use mesh node if enough exist, otherwise create a new one
				Isgl3dMeshNode * characterNode;
				if ([_characterNodes count] <= i) {
					characterNode = [Isgl3dMeshNode nodeWithMesh:nil andMaterial:nil];
					characterNode.lightingEnabled = NO;
					[_characterNodes addObject:characterNode];
				}
				characterNode = [_characterNodes objectAtIndex:i];
				
				// Set the character mesh and material
				characterNode.mesh = glCharacter.mesh;
				characterNode.material = glCharacter.material;
				[self addChild:characterNode];

				// Calculate the dimensions of the text
				Isgl3dTextureMaterial * textureMaterial = glCharacter.material;

				if (i > 0) {
					offset += 0.5 * textureMaterial.contentSize.width;
				}
				
				// Offset the character
				characterNode.x = offset;
				width += textureMaterial.contentSize.width;
				offset += 0.5 * textureMaterial.contentSize.width;
				
				// Store the maximum height of the text
				unsigned int texHeight = textureMaterial.contentSize.height;
				height = height > texHeight ? height : texHeight;
				
				// Add character child
				[self addChild:characterNode];
			}

			[self setWidth:width andHeight:height];
			
		} else {
			Isgl3dTextureMaterial * textureMaterial = [Isgl3dTextureMaterial materialWithText:_text fontName:_fontName fontSize:_size];
			Isgl3dGLMesh * mesh = [[Isgl3dPrimitiveFactory sharedInstance] UILabelMeshWithWidth:textureMaterial.width height:textureMaterial.height contentSize:textureMaterial.contentSize];
		
			[self setMesh:mesh];
			[self setMaterial:textureMaterial];
			[self setWidth:textureMaterial.contentSize.width andHeight:textureMaterial.contentSize.height];
		}
		
	}
	
}

- (void) render:(Isgl3dGLRenderer *)renderer opaque:(BOOL)opaque {
	
	if (!_useCharacterSet) {
		[super render:renderer opaque:opaque];
	} else {
		if (_text) {
			for (Isgl3dNode * node in self.children) {
				[node render:renderer opaque:opaque];
		    }
		}
	}
}



@end

	