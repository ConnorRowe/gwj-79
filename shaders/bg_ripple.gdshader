shader_type canvas_item;

uniform bool ripple_x = false;
uniform float alpha : hint_range(0.0, 1.0) = 0.7;

void fragment() {
	vec2 uv = UV;
	if (ripple_x)
	{
		uv.x += cos((TIME * 0.5) + uv.y) * 0.25;
	}
	else
	{
		uv.y += cos((TIME * 0.5) + uv.x) * 0.25;
	}
	COLOR = texture(TEXTURE, uv);
	COLOR.a = alpha;
}
