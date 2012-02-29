varying lowp vec4 v_color;
varying lowp vec4 v_specular;

#ifdef TEXTURE_MAPPING_ENABLED
varying mediump vec2 v_texCoord;

uniform sampler2D s_texture;
#endif

#ifdef NORMAL_MAPPING_ENABLED
uniform sampler2D s_nm_texture;
varying lowp vec3 v_normal;
varying lowp vec3 v_lightDir;
#endif

#ifdef ALPHA_TEST_ENABLED
uniform lowp float u_alphaTestValue;
#endif

#ifdef SHADOW_MAPPING_ENABLED
varying highp vec4 v_shadowCoord;

uniform sampler2D s_shadowMap;
const highp vec4 unpackFactors = vec4(1.0 / (256.0 * 256.0 * 256.0), 1.0 / (256.0 * 256.0), 1.0 / 256.0, 1.0);
#endif

void main() {
	lowp vec4 specular = v_specular;

#ifdef TEXTURE_MAPPING_ENABLED
	lowp vec4 color = texture2D(s_texture, v_texCoord) * v_color;
#else
	lowp vec4 color = v_color;
#endif

#ifdef ALPHA_TEST_ENABLED
	if (color.a <= u_alphaTestValue) {
		discard;
	}
#endif
    
#ifdef NORMAL_MAPPING_ENABLED
    lowp float maxVariance = 0.2;
	lowp float minVariance = maxVariance / 2.0;
	lowp vec3 normalAdjusted = v_normal + normalize(texture2D(s_nm_texture, v_texCoord.st).rgb * maxVariance - minVariance);
	lowp float diffuseIntensity = max(0.0, dot(normalize(normalAdjusted), normalize(v_lightDir)));
    
	lowp vec3 colour = diffuseIntensity * color.rgb;
	lowp vec4 vFragColour = vec4(colour, 1.0);
    
	lowp vec3 vReflection        = normalize(reflect(-normalize(normalAdjusted), normalize(v_lightDir)));
	lowp float specularIntensity = max(0.0, dot(normalize(normalAdjusted), vReflection));
    
	if (diffuseIntensity > 0.00098)
	{
		highp float fSpec = pow(specularIntensity, 64.0);
		vFragColour.rgb += vec3(fSpec);
	}
    color = vFragColour;
#endif

#ifdef SHADOW_MAPPING_ENABLED
	lowp float shadow = 1.0;
	highp vec4 shadowCoordinateWdivide = v_shadowCoord / v_shadowCoord.w;
	shadowCoordinateWdivide.z -= 0.0005;
			
	highp vec4 shadowMapData = texture2D(s_shadowMap, shadowCoordinateWdivide.st);

 	if (v_shadowCoord.w > 0.0) {

		highp float distanceFromLight = dot(shadowMapData, unpackFactors); 
		if (distanceFromLight < shadowCoordinateWdivide.z) {
	 		shadow = 0.5;
	 		specular = vec4(0.0);
		}
 	}
	color = vec4(shadow * (color.rgb + specular.rgb), color.a);
#else
	color = vec4(color.rgb + specular.rgb, color.a);
#endif

	gl_FragColor = color;
}
 
	
