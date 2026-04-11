shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, depth_test_disabled, cull_disabled;

void fragment() {
    ALBEDO = vec3(1.0);
    ALPHA = 0.05;
}