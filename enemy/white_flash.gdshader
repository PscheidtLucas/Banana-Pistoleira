shader_type canvas_item;

uniform float flash_strength : hint_range(0.0,1.0) = 0.0; // branco
uniform float red_strength   : hint_range(0.0,1.0) = 0.0; // vermelho

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// começa com a cor original
	vec3 col = tex.rgb;

	// mistura com branco
	col = mix(col, vec3(1.0), flash_strength);

	// mistura com vermelho
	col = mix(col, vec3(1.0,0.0, 0.0), red_strength);

	COLOR.rgb = col;
	COLOR.a = tex.a;
}
