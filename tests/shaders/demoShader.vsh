attribute vec4 a_vertex;

uniform mat4 u_mvpMatrix;
uniform float u_minHeight;
uniform float u_maxHeight;
uniform float u_factor;

varying lowp vec4 v_color;

void main(void) {

	float value = 0.0;
	float height = a_vertex.y;
	
	if (height >= u_maxHeight) {
		value = 1.0;
		
	} else if (height < u_maxHeight && height > u_minHeight) {
		value = (height - u_minHeight) / (u_maxHeight - u_minHeight);
	}

	v_color = vec4(value, u_factor, 1.0 - value, 1.0);

	gl_Position = u_mvpMatrix * a_vertex;
}
