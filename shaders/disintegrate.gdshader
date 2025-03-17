shader_type canvas_item;

uniform sampler2D noiseSampler: filter_nearest;
uniform float disintegrateAlpha : hint_range(0.0, 1.0, 0.1);

void fragment() {
	if(texture(noiseSampler, UV).r < disintegrateAlpha)
		discard;
}

