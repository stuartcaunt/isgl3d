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

#import "Isgl3dNode.h"
#import "Isgl3dVector.h"

/**
 * The different types of lighting available.
 */
typedef enum {
	PointLight = 0,
	DirectionalLight,
	SpotLight
} Isgl3dLightType;

/**
 * The Isgl3dLight provides a light source to the scene.
 * 
 * There are three components to a light source:
 * <ul>
 * <li>Ambient light: lighting that is provided to parts of the scene that are not facing towards the light.</li>
 * <li>Diffuse light: lighting that is diffracted off the surface of objects that are illuminated. The amount of diffuse lighting
 * depends on the normal to the surface - if it points towards the light then the diffuse lighting is at its maximum.</li>
 * <li>Specular light: a reflective componenent of the light that depends on the light position, the veiw position and the normal to the surface.</li>
 * </ul>
 * 
 * Each of these componenents can have a different color and therefore interact differently with the materials on the scene. This allows for
 * a highl amount of flexibility when it comes to lighting a scene. For example we could have a blue diffuse component and a white specular one: rendered
 * on a a white material the material will be predominantly blue with white reflections.
 * 
 * Three types of light sources are possible:
 * <ul>
 * <li>Point light: the light source has a specific point in space and light radiates out in all directions.</li>
 * <li>Directional light: the light source is assumed to be at infinity and all rays of light are parallel.</li>
 * <li>Spot light: the light source has a specific point in space and a given direction. Light forms a cone along the direction.</li>
 * </ul>
 * 
 * For point and spot lights, we can add an additional distance attenuation to fine tune how the intensity of light drops off further from the
 * origin of the source. It is possible to set constant (ca), linear (la) and quadratic attenuation (qa) relative to the distance (d). The intensity of light is 
 * calculate as 1 / (ca + la * d + qa * d * d).
 * 
 * The Isgl3dLight inherits from Isgl3dNode: it therefore behaves like all other 3D objects on the scene and can be moved around or added to other
 * nodes in the scene. It also alows for other nodes to be added as children, for example to render the light, and has for convenience and debugging 
 * a simple means of automatically rendering it on the scene.
 * 
 */
@interface Isgl3dLight : Isgl3dNode {
	    
@private
	NSString * _color;
	
	float _ambientLight[4];
	float _diffuseLight[4];
	float _specularLight[4];
	
	float _linearAttenuation;
	float _constantAttenuation;
	float _quadraticAttenuation;

	float _spotDirection[3];
	float _spotCutoffAngle;
	float _spotFalloffExponent;

	BOOL _renderLight;
	Isgl3dNode * _renderedLight;

	Isgl3dLightType _lightType;
	
}

/**
 * Specifies the constant attenuation of the light with distance. The default value is 1.
 */
@property (nonatomic) float constantAttenuation;

/**
 * Specifies the linear attenuation of the light with distance. The default value is 0.
 */
@property (nonatomic) float linearAttenuation;

/**
 * Specifies the quadratic attenuation of the light with distance. The default value is 0.
 */
@property (nonatomic) float quadraticAttenuation;

/**
 * Contains the type of light that is in use. Possible values are PointLight (0), DirectionalLight (1) and SpotLight (2).
 * By default the light is a point light source. 
 */
@property (nonatomic) Isgl3dLightType lightType;

/**
 * Specifies whether the light should be rendered or not. A simple sphere reprensents the light source and can be
 * useful for debugging. For directional light this is not an option. By default this is false.
 */
@property (nonatomic) BOOL renderLight;

/**
 * The cutoff angle of the cone of light produced by a spot light. Rays of light outside of this angle have no effect on the scene.
 * The default is 15 degrees.
 */
@property (nonatomic) float spotCutoffAngle;

/**
 * Specifis the amount by which light falls off towards the edges of the cone of light for a spot light. The default is 0 implying a 
 * constant cone of light.
 */
@property (nonatomic) float spotFalloffExponent;

/**
 * Allocates and initialises (autorelease) light source with default values: white diffuse and specular, no ambient and no attenuation.
 */
+ (id) light;

/**
 * Allocates and initialises (autorelease) light source with a float array (r, g, b) used for both diffuse and specular light colors. The ambient color is black
 * and no attenuation is used.
 * @param color Float array of colors (three values: red, green and blue) used for diffuse and specular light colors.
 */
+ (id) lightWithColorArray:(float *)color;

/**
 * Allocates and initialises (autorelease) light source with all color components and attenuation.
 * @param ambientColor Hex string containing ambient component of the light source.
 * @param diffuseColor Hex string containing diffuse component of the light source.
 * @param specularColor Hex string containing specular component of the light source.
 * @param attenuation The attenuation of the light source.
 */
+ (id) lightWithHexColor:(NSString *)ambientColor diffuseColor:(NSString *)diffuseColor specularColor:(NSString *)specularColor attenuation:(float)attenuation;

/**
 * Initialises the light source with default values: white diffuse and specular, no ambient and no attenuation.
 */
- (id) init;

/**
 * Initialises the light source with a float array (r, g, b) used for both diffuse and specular light colors. The ambient color is black
 * and no attenuation is used.
 * @param color Float array of colors (three values: red, green and blue) used for diffuse and specular light colors.
 */
- (id) initWithColorArray:(float *)color;

/**
 * Initialises the light source with all color components and attenuation.
 * @param ambientColor Hex string containing ambient component of the light source.
 * @param diffuseColor Hex string containing diffuse component of the light source.
 * @param specularColor Hex string containing specular component of the light source.
 * @param attenuation The attenuation of the light source.
 */
- (id) initWithHexColor:(NSString *)ambientColor diffuseColor:(NSString *)diffuseColor specularColor:(NSString *)specularColor attenuation:(float)attenuation;

/**
 * Returns the current ambient light color as an rgba array of floats.
 * @return the ambient light color as an rgba array of floats.
 */
- (float *) ambientLight;

/**
 * Returns the current diffuse light color as an rgba array of floats.
 * @return the diffuse light color as an rgba array of floats.
 */
- (float *) diffuseLight;

/**
 * Returns the current specular light color as an rgba array of floats.
 * @return the specular light color as an rgba array of floats.
 */
- (float *) specularLight;

/**
 * For directional lights only, returns the light direction as a vector.
 * @return the light direction.
 */
- (Isgl3dVector3) directionAsVector;

/**
 * For directional lights only, sets the direction of the light.
 * @param x The x-component of the direction.
 * @param y The y-component of the direction.
 * @param z The z-component of the direction.
 */
- (void) setDirection:(float)x y:(float)y z:(float)z;

/**
 * For spot lights only, returns the direction of the spot light as an array of 3 float values
 * representing x, y and z.
 * @return The spot light direction.
 */
- (float *) spotDirection;

/**
 * For spot lights only, sets the direction of the spot light.
 * @param x The x-component of the spot light direction.
 * @param y The y-component of the spot light direction.
 * @param z The z-component of the spot light direction.
 */
- (void) setSpotDirection:(float)x y:(float)y z:(float)z;


/**
 * Replaces the default mesh used to render the light (for debugging) with another one. A simple 
 * color material is added to the mesh with the same color as the diffuse light component.
 * @param mesh The mesh to be rendered.
 */
- (void) setRenderedMesh:(Isgl3dGLMesh *)mesh;


@end
