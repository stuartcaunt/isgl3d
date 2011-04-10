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

#import "Isgl3dLight.h"
#import "Isgl3dMeshNode.h"
#import "Isgl3dColorUtil.h"
#import "Isgl3dGLRenderer.h"
#import "Isgl3dColorMaterial.h"
#import "Isgl3dSphere.h"
#import "Isgl3dLog.h"
#import "Isgl3dColorUtil.h"

@implementation Isgl3dLight

@synthesize constantAttenuation = _constantAttenuation;
@synthesize linearAttenuation = _linearAttenuation;
@synthesize quadraticAttenuation = _quadraticAttenuation;
@synthesize lightType = _lightType;
@synthesize spotCutoffAngle = _spotCutoffAngle;
@synthesize spotFalloffExponent = _spotFalloffExponent;

+ (id) light {
	return [[[self alloc] init] autorelease];
}

+ (id) lightWithColorArray:(float *)color {
	return [[[self alloc] initWithColorArray:color] autorelease];
}

+ (id) lightWithHexColor:(NSString *)ambientColor diffuseColor:(NSString *)diffuseColor specularColor:(NSString *)specularColor attenuation:(float)attenuation {
	return [[[self alloc] initWithHexColor:ambientColor diffuseColor:diffuseColor specularColor:specularColor attenuation:attenuation] autorelease];
}

- (id) init {
	return [self initWithHexColor:@"000000" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0];
}

- (id) initWithColorArray:(float *)color {
	
	NSString  * colorString = [Isgl3dColorUtil rgbString:color];
	return [self initWithHexColor:@"000000" diffuseColor:colorString specularColor:colorString attenuation:0];
}

- (id) initWithHexColor:(NSString *)ambientColor diffuseColor:(NSString *)diffuseColor specularColor:(NSString *)specularColor attenuation:(float)attenuation {
	
	if ((self = [super init])) {
		_constantAttenuation = 1.0;
		_linearAttenuation = 0.0;
		_quadraticAttenuation = attenuation;
		_color = [diffuseColor retain];

		_lightType = PointLight;
		
		_spotCutoffAngle = 15;
		_spotFalloffExponent = 0;
		_spotDirection[0] = 0;
		_spotDirection[1] = 0;
		_spotDirection[2] = 0;
		
		[Isgl3dColorUtil hexColorStringToFloatArray:ambientColor floatArray:_ambientLight]; 
		[Isgl3dColorUtil hexColorStringToFloatArray:diffuseColor floatArray:_diffuseLight]; 
		[Isgl3dColorUtil hexColorStringToFloatArray:specularColor floatArray:_specularLight];
		
		_renderLight = NO; 
	}
	
	return self;
}

- (void) dealloc {
	[_color release];
	
	[super dealloc];
}

- (float *) ambientLight {
	return _ambientLight;
}

- (float *) diffuseLight {
	return _diffuseLight;
}

- (float *) specularLight {
	return _specularLight;
}

- (Isgl3dVector3) directionAsVector {
	return iv3(-self.x, -self.y, -self.z);
}

- (void) setDirection:(float)x y:(float)y z:(float)z {
	self.x = -x;
	self.y = -y;
	self.z = -z;
}

- (float *) spotDirection {
	return _spotDirection;
}


- (void) setSpotDirection:(float)x y:(float)y z:(float)z {
	float length = sqrt(x*x + y*y + z*z);
	_spotDirection[0] = x / length;
	_spotDirection[1] = y / length;
	_spotDirection[2] = z / length;
}


- (void) renderLights:(Isgl3dGLRenderer *)renderer {
	[renderer addLight:self];
}

- (void) setRenderLight:(BOOL)renderLight {
	if (_lightType == DirectionalLight && renderLight) {
		Isgl3dLog(Warn, @"Light is directional an cannot therefore be rendered on scene");
		return;
	}
	
	if (renderLight != _renderLight) {
		if (!renderLight && _renderedLight != nil) {
			[self removeChild:_renderedLight];
		}
		
		_renderLight = renderLight;
		
		if (_renderLight) {
			Isgl3dColorMaterial * lightColorMaterial = [Isgl3dColorMaterial materialWithHexColors:_color diffuse:_color specular:_color shininess:0.0];
			Isgl3dGLMesh * mesh = [Isgl3dSphere meshWithGeometry:0.1 longs:4 lats:2];
			
			_renderedLight = [self createNodeWithMesh:mesh andMaterial:lightColorMaterial];
			_renderedLight.enableShadowRendering = NO;
		}
	}
}

- (BOOL) renderLight {
	return _renderLight;
}


- (void) setRenderedMesh:(Isgl3dGLMesh *)mesh {
	if (_lightType == DirectionalLight) {
		Isgl3dLog(Warn, @"Light is directional an cannot therefore be rendered on scene");
		return;
	}

	if (_renderedLight) {
		[self removeChild:_renderedLight];
	}

	Isgl3dColorMaterial * lightColorMaterial = [Isgl3dColorMaterial materialWithHexColors:_color diffuse:_color specular:_color shininess:0.0];
	_renderedLight = [self createNodeWithMesh:mesh andMaterial:lightColorMaterial];
	_renderedLight.enableShadowRendering = NO;

	_renderLight = YES;
}



- (void) updateWorldTransformation:(Isgl3dMatrix4 *)parentTransformation {
	// Directional lights are not subject to parent transformations:
	//   their direction remains constant, but the direction is stored as a translation
	//   so copy it from the local transformation
	if (_lightType == DirectionalLight) {
		_worldTransformation.tx = self.x;
		_worldTransformation.ty = self.y;
		_worldTransformation.tz = self.z;
		_worldTransformation.tw = 0.0;
	} else {
		[super updateWorldTransformation:parentTransformation];
	}
}


@end
