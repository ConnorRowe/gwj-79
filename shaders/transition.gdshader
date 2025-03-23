shader_type canvas_item;

uniform float fade : hint_range(0.0, 1.0) = 0.5;
uniform vec4 colour : source_color;

void fragment() {
	if (texture(TEXTURE, UV).r >= fade)
		discard;
	COLOR = colour;
}
