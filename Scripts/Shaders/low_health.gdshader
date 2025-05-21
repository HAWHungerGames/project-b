shader_type canvas_item;

uniform bool low_health;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	if (low_health == true) {
		COLOR = vec4(1.0, 0.3, 0.3, tex_color.a);
	} else {
		COLOR = tex_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
