shader_type spatial;
render_mode unshaded;

uniform sampler2D DEPTH_TEXTURE: hint_depth_texture;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec2 delta = vec2(1.0) / vec2(VIEWPORT_SIZE);
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	float depth_pos_x = texture(DEPTH_TEXTURE, SCREEN_UV + vec2(1, 0) * delta).x;
	float depth_neg_x = texture(DEPTH_TEXTURE, SCREEN_UV + vec2(-1, 0) * delta).x;
	float depth_pos_y = texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0, 1) * delta).x;
	float depth_neg_y = texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0, -1) * delta).x;
	float line = max(max(depth - depth_pos_x, depth - depth_neg_x), max(depth - depth_pos_y, depth - depth_neg_y));
	ALPHA = depth;
	ALBEDO = vec3(0.0);
}
