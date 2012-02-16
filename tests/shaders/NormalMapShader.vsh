// Incoming per-vertex attribute values
attribute vec4 vVertex;
attribute vec2 vTexture;
attribute vec3 vNormal;

uniform mat4 mvpMatrix;
uniform mat4 mvMatrix;
uniform mat3 normalMatrix;
uniform vec3 vLightPosition;

// Outgoing normal and light direction to fragment shader
varying vec3 vVaryingNormal;
varying vec3 vVaryingLightDir;
varying vec2 vTexCoords;

void main(void) 
{
    
    // Get surface normal in eye coordinates and pass them through to the fragment shader
    vVaryingNormal = normalMatrix * vNormal;
    
    // Get vertex position in eye coordinates
    vec4 vPosition4 = mvMatrix * vVertex;
    vec3 vPosition3 = vPosition4.xyz / vPosition4.w;
    
    // Get vector to light source
    vVaryingLightDir = normalize(vLightPosition - vPosition3);
    
    // Pass the texture coordinates through the vertex shader so they get smoothly interpolated
    vTexCoords = vTexture.st;
    
    // Transform the geometry through the modelview-projection matrix
    gl_Position = mvpMatrix * vVertex;
}

