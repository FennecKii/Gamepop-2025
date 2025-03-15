shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
    float glow = smoothstep(0.4, 0.5, base_color.a);
    vec4 glow_color = vec4(0.0, 1.0, 1.0, 1.0) * glow;  
    COLOR = base_color + glow_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
