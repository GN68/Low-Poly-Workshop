shader_type spatial;
render_mode unshaded;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = COLOR.rgb;
	ALPHA = clamp(COLOR.w,0,1);
}
