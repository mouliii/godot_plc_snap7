shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform float waterLevel:hint_range(0.0, 1.0, 0.01) = 0.5f;
uniform float density:hint_range(0.0, 1.0, 0.01) = 0.99f;
uniform vec4 color:source_color;

// tank height: 0,9237

void vertex()
{
	VERTEX.y *= waterLevel;
	VERTEX.y += waterLevel;
	// height / 2.0f
	VERTEX.y -= 1.0f;
	
}

void fragment()
{

	ALBEDO = color.rgb;//vec3(1.0f,0.0f,1.0f);
	ALPHA = density;

	METALLIC = 0.0f;
	ROUGHNESS = 1.0f;
}
