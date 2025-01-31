shader_type spatial;
render_mode unshaded;

uniform float alpha = 0.5;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(1,1,1);
	ALPHA = clamp(alpha * COLOR.x,0,1);
}

