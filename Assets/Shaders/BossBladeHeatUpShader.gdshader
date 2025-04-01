//Boss blade heat up shader
//By: Eluem

shader_type canvas_item;

uniform float heat:hint_range(0.0, 1.0, 0.1);
uniform float startX:hint_range(0.0, 1.0, 0.1);

void fragment()
{
	if(COLOR.a > 0.0)
	{
		COLOR.rgb = mix(COLOR.rgb, mix(vec3(0.5, 0.0, 0.0), vec3(1.0, 0.5, 0.5), UV.x), max(0,UV.x - startX)*heat);
	}
}