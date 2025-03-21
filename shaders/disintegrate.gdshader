shader_type canvas_item;

uniform sampler2D noiseSampler: filter_nearest, repeat_enable;
uniform float disintegrateAlpha: hint_range(0.0, 1.0);
uniform int framesX = 1;
uniform vec4 deadColour: source_color;
uniform float deadColourAlpha: hint_range(0.0, 1.0);

void fragment() {
	vec2 adjustedUV = UV;
	adjustedUV.x *= float(framesX);
	if(texture(noiseSampler, adjustedUV).r < disintegrateAlpha)
		discard;
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = mix(COLOR.rgb, deadColour.rgb, deadColourAlpha);
}
