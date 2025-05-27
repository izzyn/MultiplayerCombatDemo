shader_type spatial;

// --- Uniforms --- //
uniform float resolution: hint_range(0.0, 256.0, 1.0) = 32.0;
uniform sampler2D albedo_texture;
uniform bool enable_effect;
uniform float time : hint_range(0.0, 256.0, 1.0) = 1.0;
// --- Functions --- //
void fragment() {
	if (enable_effect){
		vec4 tex = texture(albedo_texture, round(UV * (resolution/(time+1.0) + 1.0) - (UV - 0.5)) / (resolution/(time+1.0) + 1.0));
		ALBEDO.rgb = tex.rgb;
		ALPHA = tex.a/sqrt(0.05*time+1.0);
	}
	else {
		ALBEDO.rgb = texture(albedo_texture, UV).rgb;
		ALPHA = texture(albedo_texture, UV).a;
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
