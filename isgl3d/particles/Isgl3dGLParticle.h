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

#define PARTICLE_VERTEX_POS_OFFSET 0
#define PARTICLE_VERTEX_COLOR_OFFSET (3 * sizeof(float))
#define PARTICLE_VERTEX_SIZE_OFFSET (7 * sizeof(float))
#define PARTICLE_VBO_STRIDE (8 * sizeof(float))

@class Isgl3dGLVBOData;
@class Isgl3dFloatArray;
@class Isgl3dUShortArray;

/**
 * The Isgl3dGLParticle contains all the data relevant to a particle (or sprite) in OpenGL. To render a particle an Isgl3dParticleNode
 * must be used.
 * 
 * Like Isgl3dGLMeshes, the Isgl3DGLParticle contains vertex and index data. These are raw arrays of data corresponding to each particle
 * and the order in which they are rendered. For a single particle (the case for Isgl3dGLParticle) there is only a single vertex and a single index. 
 * However for Isgl3dParticleSystems a large number of particles can be rendered very quickly by the GPU. Both the Isgl3dGLParticle and the Isgl3dParticleSysyem use 
 * the same data structures and are rendered identically (the particle system extends this class).
 * 
 * Particle vertex data contains the following components:
 * <ul>
 * <li>Position coordinates: 3 values (x, y, z) of GL_FLOATs</li>
 * <li>Color: 4 values (r, g, b, a) of GL_FLOATs</li>
 * <li>Size: 1 value (s) of GL_FLOAT</li>
 * </ul>
 *
 * For information on the structure of the vertex data, an Isgl3dGLVBOData object is associated with the particle (VBO being Virtual Buffer
 * Object). This contains information on what is contained in the vertex data, what is the stride of the data (how many bytes are used 
 * to store the data for a single vertex), the offset of the various elements, etc.
 * 
 * iSGL3D passes interlaced data to the GPU meaning that all the elements of the vertex data (position, color, size)
 * are passed in a single array rather than each one separately.
 * 
 * In OpenGL, particles are rendered face-on to the viewer and are not affected by rotational transformations. The only transformations that
 * can be performed on particles (more specifically, the Isgl3dParticleNode) are translational ones. For this reason, even if the device
 * is in landscape mode, particles will be rendered as if it is portrait (no rotation can be performed, even along the z-axis).
 * 
 * As well as the size and the color properties of a particle, the "attenuation" can be specified also. The attenuation dictates how the particle
 * grows and shrinks in size as it is further from the observer. As mentioned above, the particle does not behave the same as meshes in regards to
 * transformations: this is the same for the projection matrix resulting in particles that do not automatically change size for perspective. The
 * attenuation alows us to counter-act this. The attenuation is specified as constant (ca), linear (la) and quadratic (qa) components, the resulting size
 * of the particle of original size (s) at a given distance (d) from the observer being calculated as s / (ca + la *d + qa * d * d).
 * 
 
 */
@interface Isgl3dGLParticle : NSObject {
	
@private
	
	float _size;
	float _color[4];
	float _attenuation[3];
	float _renderColor[4];
	
	float _x;
	float _y;
	float _z;
	
	unsigned int _indicesBufferId;
	
	float _distanceFromPoint;
	
@protected
	BOOL _dirty;
	Isgl3dFloatArray * _vertexData;
	Isgl3dUShortArray * _indices;

	Isgl3dGLVBOData * _vboData;
}

/**
 * Specifies the size of the particle. Default is 32.
 */
@property (nonatomic) float size;

/*
 * The x position of the particle. Default is 0.
 */
@property (nonatomic) float x;

/*
 * The y position of the particle.Default is 0.
 */
@property (nonatomic) float y; 

/*
 * The z position of the particle. Default is 0.
 */
@property (nonatomic) float z; 

/*
 * Sets the particle as being dirty and positions need to be recalculated.
 * 
 * Note: this is intended for use internall by iSGL3D and should ot be called explicitly.
 */
@property (nonatomic) BOOL dirty;

/**
 * Returns the distance previously calculated from a given point.
 * @return The distance from a given point.
 */
@property (readonly) float distanceFromPoint;

/**
 * Allocates and initialises (autorelease) the particle with default values: position (0, 0, 0), attenuation (1, 0, 0), color (1, 1, 1, 1), size 32. 
 */
+ (id) particle;

/**
 * Initialises the particle with default values: position (0, 0, 0), attenuation (1, 0, 0), color (1, 1, 1, 1), size 32. 
 */
- (id) init;

/**
 * Returns the color of the particle.
 * @return The 4-value float array containing the rgba components of the color.
 */
- (float *) color;

/**
 * Sets the color of the particle.
 * @param r The red component.
 * @param g The green component.
 * @param b The blue component.
 */
- (void) setColor:(float)r g:(float)g b:(float)b;

/**
 * Sets the color of the particle.
 * @param r The red component.
 * @param g The green component.
 * @param b The blue component.
 * @param a The alpha component.
 */
- (void) setColor:(float)r g:(float)g b:(float)b a:(float)a;

/**
 * Sets the attenuation of the particle controlling its appearance with distance from the observer.
 * @param constant The constant attenuation component.
 * @param linear The linear attenuation component.
 * @param quadratic The quadratic attenuation component.
 */
- (void) setAttenuation:(float)constant linear:(float)linear quadratic:(float)quadratic;

/**
 * Returns the current attenuation as a 3-value float array [c, l, q].
 * @return The current attenuation as a 3-value float array [c, l, q].
 */
- (float *) attenuation;

/**
 * Returns the Isgl3dGLVBOData object containing information about the VBO in the GPU.
 * @return the VBO data.
 */
- (Isgl3dGLVBOData *) vboData;

/**
 * Returns the buffer identifier for the index data as it is registered in the GPU.
 * The equivalent Id for the vertex data is available in the Isgl3DGLVBOData object. 
 * This is called internally by iSGL3D.
 */
- (unsigned int) indicesBufferId;

/**
 * Returns the number of particles. For Isgl3dGLParticle this always returns 1 but
 * for an Isgl3dParticleSyste it returns the number of particles in the system.
 */
- (unsigned int) numberOfPoints;


/*
 * The vertex data arrays are updated.
 * This is called internally by iSGL3D and should not be called explictly.
 */
- (void) update;

/*
 * Builds the arrays of vertex and index data.
 * This is called internally by iSGL3D and should not be called explictly.
 */
- (void) buildArrays;


/**
 * Calculates the distance from a given point.
 * @param x The x coordinate of the point;
 * @param y The y coordinate of the point;
 * @param z The z coordinate of the point;
 */
- (void) calculateDistanceFromX:(float)x y:(float)y z:(float)z;

/**
 * Sets the color of the particle to the desired capture color.
 * The original color is stored for after the event capture.
 * Note: This is called internally by iSGL3D and should not be called manually.
 * 
 * @param r red
 * @param g green
 * @param b blue
 */
- (void) prepareForEventCapture:(float)r g:(float)g b:(float)b;

/**
 * Restores the original color of the particle after the event capture has taken place.
 * Note: This is called internally by iSGL3D and should not be called manually.
 */
- (void) restoreRenderColor;

@end
