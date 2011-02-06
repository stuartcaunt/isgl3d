varying highp vec4 v_position;

const highp vec4 packFactors = vec4(256.0 * 256.0 * 256.0, 256.0 * 256.0, 256.0, 1.0);
const highp vec4 bitMask = vec4(1.0/256.0, 1.0/256.0, 1.0/256.0, 1.0/256.0);

void main(void) {
	
	highp float normalizedDistance  = v_position.z / v_position.w;
	normalizedDistance = (normalizedDistance + 1.0) / 2.0;

	highp vec4 packedValue = vec4(fract(packFactors * normalizedDistance));
	packedValue -= packedValue.xxyz * bitMask;

	gl_FragColor = packedValue;
}

			