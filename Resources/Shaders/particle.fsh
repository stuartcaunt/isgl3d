varying lowp vec4 v_color;

#ifdef TEXTURE_MAPPING_ENABLED
uniform sampler2D s_texture;
#endif

#ifdef ALPHA_TEST_ENABLED
uniform lowp float u_alphaTestValue;
#endif

void main() {

#ifdef TEXTURE_MAPPING_ENABLED
	lowp vec4 color = texture2D(s_texture, gl_PointCoord) * v_color;
#else
	lowp vec4 color = v_color;
#endif


#ifdef ALPHA_TEST_ENABLED
	if (color.a <= u_alphaTestValue) {
		discard;
	}
#endif
	
	gl_FragColor = color;
}
 
	
