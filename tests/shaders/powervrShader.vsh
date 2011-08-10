attribute vec3	myVertex;
attribute vec3	myNormal;
attribute vec2	myUV;

uniform mat4	myMVPMatrix;
uniform mat3	myModelViewIT;

uniform mediump vec3	myLightDirection;
uniform highp float fAnim;

varying float	fDiffuse;
varying lowp   vec2 fTexCoord;
varying lowp   vec2 fTexCoord2;

varying highp vec3  fPosition;
varying highp float fBurn;

void main(void)
{
	gl_Position = myMVPMatrix * vec4(myVertex,1);
	
	fDiffuse = 0.1 * dot(myModelViewIT * myNormal, myLightDirection) + 0.9;
	
	fPosition =  myVertex * 0.05;
	
	highp float fOffset = fract(0.999 * fAnim) * 2.1;
	fBurn = fOffset - 0.53 * (fPosition.y + 0.2);	
    fBurn = clamp(fBurn, 0.0, 1.0);
    
    fTexCoord = myUV;
    fTexCoord2 = vec2(fPosition.x + fPosition.z * fPosition.z, fPosition.y + 0.5 * fPosition.z + 0.5 * fPosition.x * fPosition.x);
}
