
struct Point {
	float minSize;
	float maxSize;

	float constantAttenuation;
	float linearAttenuation;
	float quadraticAttenuation;
};

attribute vec4 a_vertex;
attribute vec4 a_vertexColor;
attribute float a_pointSize;

uniform mat4 u_mvpMatrix;
uniform mat4 u_mvMatrix;

uniform Point u_point;

varying lowp vec4 v_color;

const float	c_zero = 0.0;
const float	c_one = 1.0;


void main(void) {
	vec4 ecPosition3 = u_mvMatrix * a_vertex;

	v_color = a_vertexColor;
	
	float dist = distance(ecPosition3, vec4(c_zero, c_zero, c_zero, c_one));
	float att = sqrt(c_one / (u_point.constantAttenuation +
							(u_point.linearAttenuation +
							u_point.quadraticAttenuation * dist) * dist));
	float size = clamp(a_pointSize * att, u_point.minSize, u_point.maxSize);
	gl_PointSize = size;
		
	gl_Position = u_mvpMatrix * a_vertex;
}
