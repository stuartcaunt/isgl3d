/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
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

precision highp float;


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

#ifdef SPECULAR_MAPPING_ENABLED
uniform sampler2D s_sm_texture;
#endif

#ifdef ALPHA_TEST_ENABLED
uniform lowp float u_alphaTestValue;
#endif

#ifdef SHADOW_MAPPING_ENABLED
varying highp vec4 v_shadowCoord;
uniform sampler2D s_shadowMap;
const highp vec4 unpackFactors = vec4(1.0 / (256.0 * 256.0 * 256.0), 1.0 / (256.0 * 256.0), 1.0 / 256.0, 1.0);
#endif

#ifdef SHADOW_MAPPING_DEPTH_ENABLED
varying highp vec4 v_shadowCoord;
uniform sampler2D s_shadowMap;
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
	lowp vec3 normalAdjusted = normalize(texture2D(s_nm_texture, v_texCoord.st).rgb * 2.0 - 1.0 + v_normal);
	lowp float diffuseIntensity = max(0.0, dot(normalAdjusted, v_lightDir));
	lowp vec3 vReflection        = normalize(reflect(-normalAdjusted, v_lightDir));
	lowp float specularIntensity = max(0.0, dot(normalAdjusted, vReflection));
    
	if (diffuseIntensity > 0.98) {
		highp float fSpec = pow(specularIntensity, 64.0);
		color.rgb = color.rgb + vec3(fSpec);
	}
    color.rgb = color.rgb * diffuseIntensity;
#endif
    
    lowp float shadowFactor = 1.0;

#ifdef SHADOW_MAPPING_ENABLED
    if (v_shadowCoord.w > 0.0){
        highp vec4 shadowTextureCoordinate = v_shadowCoord / v_shadowCoord.w;
        shadowTextureCoordinate = (shadowTextureCoordinate + 1.0) / 2.0;
        
        const float bias = 0.0005;
        
        highp vec4 packedZValue = texture2D(s_shadowMap, shadowTextureCoordinate.st);
        highp float unpackedZValue = dot(packedZValue,unpackFactors);
        
        if ((unpackedZValue+bias) < shadowTextureCoordinate.z)
        {
            shadowFactor = 0.5;
            specular = vec4(0.0);
        }
    }
#endif
    
#ifdef SHADOW_MAPPING_DEPTH_ENABLED
    if (v_shadowCoord.w > 0.0){
        highp vec4 shadowTextureCoordinate = v_shadowCoord / v_shadowCoord.w;
        shadowTextureCoordinate = (shadowTextureCoordinate + 1.0) / 2.0;
        
        float distanceFromLight = texture2D(s_shadowMap, shadowTextureCoordinate.st).z;
        
        const float bias = 0.0005;
        
        if ((distanceFromLight+bias) < shadowTextureCoordinate.z)
        {
            shadowFactor = 0.5;
            specular = vec4(0.0);
        }
    }
#endif

#ifdef SPECULAR_MAPPING_ENABLED
    specular = specular * texture2D(s_sm_texture, v_texCoord);
#endif

	color = vec4(shadowFactor * (color.rgb + specular.rgb), color.a);
    color = clamp(color, 0.0, 1.0);
    
	gl_FragColor = color;
}
 
	
