#define MAX_LIGHTS 4

struct Light {
	vec4 position;
	vec4 ambientColor;
	vec4 diffuseColor;
	vec4 specularColor;
	float constantAttenuation;
	float linearAttenuation;
	float quadraticAttenuation;
	vec3 spotDirection;
	float spotCutoffAngle;
	float spotFalloffExponent;
};

struct Material {
	vec4 ambientColor;
	vec4 diffuseColor;
	vec4 specularColor;
	float shininess;
};

attribute vec4 a_vertex;
attribute vec3 a_normal;

#ifdef TEXTURE_MAPPING_ENABLED
attribute vec2 a_texCoord;

varying mediump vec2 v_texCoord;
#endif

uniform mat4 u_mvpMatrix;
uniform mat4 u_mvMatrix;
uniform mat3 u_normalMatrix;


#ifdef SHADOW_MAPPING_ENABLED
varying highp vec4 v_shadowCoord;
uniform vec4 u_shadowCastingLightPosition;
uniform mat4 u_mcToLightMatrix;
#endif


#ifdef SKINNING_ENABLED
attribute mediump vec4 a_boneIndex;
attribute mediump vec4 a_boneWeights;
uniform mediump	int u_boneCount;
uniform highp mat4 u_boneMatrixArray[8];
uniform highp mat3 u_boneMatrixArrayIT[8];
#endif

uniform vec4 u_sceneAmbientColor;

uniform Material u_material;
uniform Light u_light[MAX_LIGHTS];
uniform int u_lightEnabled[MAX_LIGHTS];

uniform bool u_includeSpecular;
uniform bool u_lightingEnabled;

varying lowp vec4 v_color;
varying lowp vec4 v_specular;

const float	c_zero = 0.0;
const float	c_one = 1.0;

vec3 ecPosition3;
vec3 normal;
vec3 eye;
vec4 vertexPosition;
vec3 vertexNormal;


void pointLight(in int lightIndex,
				inout vec4 ambient,
				inout vec4 diffuse,
				inout vec4 specular) {

	float nDotVP;
	float eDotRV;
	float pf;
	float attenuation;
	float d;
	vec3 VP;
	vec3 reflectVector;


	// Check if light source is directional
	if (u_light[lightIndex].position.w != c_zero) {
		// Vector between light position and vertex
		VP = vec3(u_light[lightIndex].position.xyz - ecPosition3);
		
		// Distance between the two
		d = length(VP);
		
		// Normalise
		VP = normalize(VP);
		
		// Calculate attenuation
		attenuation = c_one / (	u_light[lightIndex].constantAttenuation + 
								u_light[lightIndex].linearAttenuation * d + 
								u_light[lightIndex].quadraticAttenuation * d * d);
								
		// Calculate spot lighting effects						
		if (u_light[lightIndex].spotCutoffAngle < 180.0) {
			float spotFactor = dot(-VP, u_light[lightIndex].spotDirection);
			if (spotFactor >= cos(radians(u_light[lightIndex].spotCutoffAngle))) {
				spotFactor = pow(spotFactor, u_light[lightIndex].spotFalloffExponent);

			} else {
				spotFactor = c_zero;
			}
			attenuation *= spotFactor;
		}
		
	} else {
		attenuation = c_one;
		VP = u_light[lightIndex].position.xyz;
	}
		
	// angle between normal and light-vertex vector
	nDotVP = max(c_zero, dot(VP, normal));
	
 	ambient += u_light[lightIndex].ambientColor * attenuation;
	if (nDotVP > c_zero) {
		diffuse += u_light[lightIndex].diffuseColor * (nDotVP * attenuation);
	
		if (u_includeSpecular) {
			// reflected vector					
			reflectVector = normalize(reflect(-VP, normal));
			
			// angle between eye and reflected vector
			eDotRV = max(c_zero, dot(eye, reflectVector));
			eDotRV = pow(eDotRV, 16.0);
		
			pf = pow(eDotRV, u_material.shininess);
			specular += u_light[lightIndex].specularColor * (pf * attenuation);
		}
	}
	
}

void doLighting() {
	int i;
	vec4 amb = vec4(c_zero);
	vec4 diff = vec4(c_zero);
	vec4 spec = vec4(c_zero);

	if (u_lightingEnabled) {

		ecPosition3 = vec3(u_mvMatrix * vertexPosition);
	
		eye = -normalize(ecPosition3);
	
		normal = u_normalMatrix * vertexNormal;
		normal = normalize(normal);

		for (i = int(c_zero); i < MAX_LIGHTS; i++) {
			if (u_lightEnabled[i] == 1) {
				pointLight(i, amb, diff, spec);
			} 	
		}

		v_color.rgb = (u_sceneAmbientColor.rgb + amb.rgb) * u_material.ambientColor.rgb + diff.rgb * u_material.diffuseColor.rgb;
		v_color.a = u_material.diffuseColor.a;
		
		v_color = clamp(v_color, 0.0, 1.0);
		v_specular.rgb = spec.rgb * u_material.specularColor.rgb;
		v_specular.a = u_material.specularColor.a;
		
	} else {
		v_color = u_material.diffuseColor;
		v_specular = spec;
	}
}

#ifdef SKINNING_ENABLED
void doSkinning() {
	
	mediump ivec4 boneIndex = ivec4(a_boneIndex);
	mediump vec4 boneWeights = a_boneWeights;
	
	if (u_boneCount > 0) {
		highp mat4 boneMatrix = u_boneMatrixArray[boneIndex.x];
		mediump mat3 normalMatrix = u_boneMatrixArrayIT[boneIndex.x];
	
		vertexPosition = boneMatrix * a_vertex * boneWeights.x;
		vertexNormal = normalMatrix * a_normal * boneWeights.x;
		
		for (lowp int i = 1; i < u_boneCount; ++i) {
			// "rotate" the vector components
			boneIndex = boneIndex.yzwx;
			boneWeights = boneWeights.yzwx;
		
			boneMatrix = u_boneMatrixArray[boneIndex.x];
			normalMatrix = u_boneMatrixArrayIT[boneIndex.x];

			vertexPosition += boneMatrix * a_vertex * boneWeights.x;
			vertexNormal += normalMatrix * a_normal * boneWeights.x;
		}	
	}	
}
#endif



void main(void) {
	
#ifdef SKINNING_ENABLED
	doSkinning();
#else
	vertexPosition = a_vertex;
	vertexNormal = a_normal;
#endif
	
	doLighting();

#ifdef TEXTURE_MAPPING_ENABLED
	v_texCoord = a_texCoord;
#endif
	
#ifdef SHADOW_MAPPING_ENABLED
	// Vector between shadow casting light position and vertex
	vec3 VP = u_shadowCastingLightPosition.xyz - ecPosition3;
	
	// Normalise
	VP = normalize(VP);
	
	// angle between normal and light-vertex vector
	float nDotVP = dot(VP, normal);

	v_shadowCoord = u_mcToLightMatrix * vertexPosition;
	if (nDotVP < c_zero) {
		v_shadowCoord = vec4(0.0, 0.0, 0.0, 1.0);
	}
#endif
	
	gl_Position = u_mvpMatrix * vertexPosition;
}
