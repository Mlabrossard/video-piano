shader_type spatial;
render_mode unshaded, cull_disabled, blend_add, depth_draw_never;

uniform vec3 glow_color : source_color = vec3(0.0, 0.8, 1.0);
uniform float glow_intensity : hint_range(0.0, 3.0) = 1.5;
uniform float pulse_speed : hint_range(0.0, 5.0) = 1.5;

void fragment() {
	float pulse = sin(TIME * pulse_speed) * 0.15 + 0.85;
	float fresnel = pow(1.0 - abs(dot(NORMAL, VIEW)), 2.0);
	
	ALBEDO = glow_color * glow_intensity * pulse * fresnel;
	EMISSION = glow_color * glow_intensity * 2.0 * pulse;
	ALPHA = fresnel * 0.8;
}