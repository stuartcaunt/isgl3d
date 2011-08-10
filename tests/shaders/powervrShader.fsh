varying highp float	fDiffuse;
varying lowp vec2	fTexCoord;
varying lowp vec2  fTexCoord2;

uniform sampler2D sampler2d;
uniform sampler2D Noise;

varying highp float fBurn;

highp vec3 reflect (void)
{	
	return texture2D(sampler2d,fTexCoord).rgb * fDiffuse;
}

void main (void)
{
    highp vec4  noisevec;
    highp vec3  color;
    highp float intensity;

    noisevec = texture2D(Noise, fTexCoord2);
 
    intensity = 0.6 * (noisevec.x + noisevec.y + noisevec.z + noisevec.w);
    intensity = abs(intensity - 1.0);
    intensity = clamp(intensity, 0.0, 1.0);

    if (intensity < fBurn)
		color = vec3(0.0);
    else if(intensity < 1.5 * fBurn)
		color = vec3(0.1);
    else if(intensity < 1.7 * fBurn)
		color = vec3(1.0, 10.0 * (-intensity + 1.7 * fBurn) ,0.0);
    else
		color = reflect();

    gl_FragColor = vec4(color, 1);
}
