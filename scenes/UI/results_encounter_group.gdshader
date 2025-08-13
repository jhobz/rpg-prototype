shader_type canvas_item;

uniform float desaturate_strength: hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
	float gray = (tex.r + tex.g + tex.b) / 3.0;
    COLOR.rgb = mix(vec3(gray, gray, gray), tex.rgb, desaturate_strength);
}