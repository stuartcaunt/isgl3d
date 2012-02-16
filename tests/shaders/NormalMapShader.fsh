
// Uniforms
uniform lowp vec4 ambientColour;
uniform lowp vec4 diffuseColour;
uniform lowp vec4 specularColour;

uniform sampler2D colourMap; // This is the original texture
uniform sampler2D normalMap; // This is the normal-mapped version of our texture

// Input from our vertex shader
varying lowp vec3 vVaryingNormal;
varying lowp vec3 vVaryingLightDir;
varying highp vec2 vTexCoords;

void main(void)
{ 
	lowp float maxVariance = 0.2; // Mess around with this value to increase/decrease normal perturbation
	lowp float minVariance = maxVariance / 2.0;
    
	// Create a normal which is our standard normal + the normal map perturbation (which is going to be either positive or negative)
	lowp vec3 normalAdjusted = vVaryingNormal + normalize(texture2D(normalMap, vTexCoords.st).rgb * maxVariance - minVariance);
    
	// Calculate diffuse intensity
	lowp float diffuseIntensity = max(0.0, dot(normalize(normalAdjusted), normalize(vVaryingLightDir)));
    
	// Add the diffuse contribution blended with the standard texture lookup and add in the ambient light on top
	lowp vec3 colour = (diffuseIntensity * diffuseColour.rgb) * texture2D(colourMap, vTexCoords.st).rgb + ambientColour.rgb;
    
	// Set the almost final output color as a vec4 - only specular to go!
	lowp vec4 vFragColour = vec4(colour, 1.0);
    
	// Calc and apply specular contribution
	lowp vec3 vReflection        = normalize(reflect(-normalize(normalAdjusted), normalize(vVaryingLightDir)));
	lowp float specularIntensity = max(0.0, dot(normalize(normalAdjusted), vReflection));
    
	// If the diffuse light intensity is over a given value, then add the specular component
	// Only calc the pow function when the diffuseIntensity is high (adding specular for high diffuse intensities only runs faster)
	// Put this as 0 for accuracy, and something high like 0.98 for speed
	if (diffuseIntensity > 0.00098)
	{
		highp float fSpec = pow(specularIntensity, 64.0);
		vFragColour.rgb += vec3(fSpec * specularColour.rgb);
	}
    gl_FragColor = vFragColour;
}