//Used to force a solid color
shader_type canvas_item;

uniform vec4 sample_color:source_color;

void fragment()
{
	if(COLOR.a > 0.0)
	{
		COLOR.rgba = sample_color;
	}
}