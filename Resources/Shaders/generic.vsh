#define MAX_LIGHTS 4
#define MAX_BONES 4

struct Light {
	vec4 position;
	vec4 ambientColor;
	vec4 diffuseColor;
	vec4 specularColor;
	vec3 attenuation;
	float spotCutoffAngle;
	vec3 spotDirection;
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

uniform mat4 u_mvpMatrix;
uniform mat4 u_mvMatrix;
uniform mat3 u_normalMatrix;

uniform vec4 u_sceneAmbientColor;

uniform Material u_material;
uniform Light u_light[MAX_LIGHTS];
uniform bool u_lightEnabled[MAX_LIGHTS];

uniform bool u_includeSpecular;
uniform bool u_lightingEnabled;

varying lowp vec4 v_color;
varying lowp vec4 v_specular;


#ifdef TEXTURE_MAPPING_ENABLED
attribute vec2 a_texCoord;

varying mediump vec2 v_texCoord;
#endif


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


vec3 ecPosition3;
vec3 normal;
vec3 eye;
vec4 vertexPosition;
vec3 vertexNormal;


void pointLight(const in Light light,
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
	if (light.position.w != 0.0) {
		// Vector between light position and vertex
		VP = vec3(light.position.xyz - ecPosition3);
		
		// Distance between the two
		d = length(VP);
		
		// Normalise
		VP = normalize(VP);
		
		// Calculate attenuation
		vec3 attDist = vec3(1.0, d, d * d);
		attenuation = 1.0 / dot(light.attenuation, attDist);
        
		// Calculate spot lighting effects
		if (light.spotCutoffAngle > 0.0) {
			float spotFactor = dot(-VP, light.spotDirection);
			if (spotFactor >= cos(radians(light.spotCutoffAngle))) {
				spotFactor = pow(spotFactor, light.spotFalloffExponent);
                
			} else {
				spotFactor = 0.0;
			}
			attenuation *= spotFactor;
		}
	} else {
		attenuation = 1.0;
		VP = light.position.xyz;
	}
    
	// angle between normal and light-vertex vector
	nDotVP = max(0.0, dot(VP, normal));
	
 	ambient += light.ambientColor * attenuation;
	if (nDotVP > 0.0) {
		diffuse += light.diffuseColor * (nDotVP * attenuation);
        
		if (u_includeSpecular) {
			// reflected vector					
			reflectVector = normalize(reflect(-VP, normal));
			
			// angle between eye and reflected vector
			eDotRV = max(0.0, dot(eye, reflectVector));
			eDotRV = pow(eDotRV, 16.0);
            
			pf = pow(eDotRV, u_material.shininess);
			specular += light.specularColor * (pf * attenuation);
		}
	}
	
}

void doLighting() {
	vec4 amb = vec4(0.0);
	vec4 diff = vec4(0.0);
	vec4 spec = vec4(0.0);
    
	if (u_lightingEnabled) {
        
		ecPosition3 = vec3(u_mvMatrix * vertexPosition);
        
		eye = -normalize(ecPosition3);
        
		normal = u_normalMatrix * vertexNormal;
		normal = normalize(normal);
        
       if (u_lightEnabled[0]) {
           pointLight(u_light[0], amb, diff, spec);
       }
       if (u_lightEnabled[1]) {
           pointLight(u_light[1], amb, diff, spec);
       }
       if (u_lightEnabled[2]) {
           pointLight(u_light[2], amb, diff, spec);
       }
       if (u_lightEnabled[3]) {
           pointLight(u_light[3], amb, diff, spec);
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
        int j;
        
		vertexPosition = boneMatrix * a_vertex * boneWeights.x;
		vertexNormal = normalMatrix * a_normal * boneWeights.x;
		j = 1;
        
		for (int i=1; i<MAX_BONES; i++) {
			if (j >= u_boneCount)
                break;
            
            // "rotate" the vector components
			boneIndex = boneIndex.yzwx;
			boneWeights = boneWeights.yzwx;
            
			boneMatrix = u_boneMatrixArray[boneIndex.x];
			normalMatrix = u_boneMatrixArrayIT[boneIndex.x];
            
			vertexPosition += boneMatrix * a_vertex * boneWeights.x;
			vertexNormal += normalMatrix * a_normal * boneWeights.x;
            
            j++;
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
	if (nDotVP < 0.0) {
		v_shadowCoord = vec4(0.0, 0.0, 0.0, 1.0);
	}
#endif
	
	gl_Position = u_mvpMatrix * vertexPosition;
}
