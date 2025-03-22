shader_type canvas_item;


void fragment() {
	vec2 uv = UV;
	uv.y += cos((TIME * 0.5) + uv.x) * 0.25;
	COLOR = texture(TEXTURE, uv);
	COLOR.a = 0.7;
}
