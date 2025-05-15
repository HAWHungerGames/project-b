shader_type canvas_item;

uniform vec4 pulse_color : source_color = vec4(1.0, 0.0, 0.0,0.5); // Red
uniform float pulse_speed : hint_range(0.0, 10.0, 0.1) = 2.0; // Pulse speed
uniform float intensity : hint_range(0.0, 0.5, 0.01) = 0.5; // Max blend amount

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
    float pulse = abs(sin(TIME * pulse_speed)) * intensity;
    // Blend from original color (black) to red
    COLOR = mix(tex_color, pulse_color, pulse) * tex_color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
