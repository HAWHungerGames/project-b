shader_type spatial;
render_mode unshaded, cull_back, blend_mix;

void fragment() {
    // Calculate distance from center of quad (UVs go from 0 to 1)
    float dist = distance(UV, vec2(0.5));
    float circle = smoothstep(0.5, 0.48, dist); // Soft edge, adjust as needed

    ALBEDO = COLOR.rgb;          // Use particle color
    ALPHA = COLOR.a * circle;    // Fully transparent outside the circle
}
