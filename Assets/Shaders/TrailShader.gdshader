//Used to eliminate color artifacts caused by the Line2D overlapping itself
//and rendering multiple times in overlapping fragments
//Code and idea of manually mixing with the background color from rh6615 on Discord
shader_type canvas_item;

uniform sampler2D background:hint_screen_texture, source_color;

void fragment()
{
    vec4 background_colour = texture(background, SCREEN_UV);
    COLOR.rgb = mix(background_colour.rgb, COLOR.rgb, COLOR.a);
    COLOR.a = 1.0;
}