#define MAX_BONES 4

attribute vec4 a_vertex;

uniform mat4 u_mvpMatrix;

varying mediump vec4 v_position;

#ifdef SKINNING_ENABLED
attribute mediump vec4 a_boneIndex;
attribute mediump vec4 a_boneWeights;
uniform mediump	int u_boneCount;
uniform highp mat4 u_boneMatrixArray[8];
#endif

void main(void) {

#ifdef SKINNING_ENABLED
	mediump ivec4 boneIndex = ivec4(a_boneIndex);
	mediump vec4 boneWeights = a_boneWeights;
	
	if (u_boneCount > 0) {
		highp mat4 boneMatrix = u_boneMatrixArray[boneIndex.x];
        int j;
	
		vec4 vertexPosition = boneMatrix * a_vertex * boneWeights.x;
		j = 1;
		
		for (int i=1; i<MAX_BONES; i++) {
			if (j >= u_boneCount)
                break;

			// "rotate" the vector components
			boneIndex = boneIndex.yzwx;
			boneWeights = boneWeights.yzwx;
		
			boneMatrix = u_boneMatrixArray[boneIndex.x];

			vertexPosition += boneMatrix * a_vertex * boneWeights.x;

            j++;
		}	
		v_position = u_mvpMatrix * vertexPosition;
		gl_Position = v_position;

	} else {
		v_position = u_mvpMatrix * a_vertex;
		gl_Position = v_position;
	}

#else
	v_position = u_mvpMatrix * a_vertex;
	gl_Position = v_position;
#endif

}
