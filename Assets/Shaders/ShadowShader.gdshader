//Experimental blur shader concept using boundry expanding from https://godotshaders.com/shader/2d-topdown-shadow-that-goes-out-of-bounds/ By: Bettiold
//By: Eluem

shader_type canvas_item;

const float fullRot = 2.0*PI; //Maybe just 6.283 to be more efficient?

uniform float maxBounds = 3.0;
uniform float radius:hint_range(1.0, 50.0) = 20.0; /**Radius to mix*/
uniform float radStep:hint_range(0.1, 0.5) = 0.1; /**Distance from center to step*/
uniform float rotStep:hint_range(0.017, 10.0) = 0.1; /**Rotational step in radians*/
uniform float mixMultiplier:hint_range(0.01, 10) = 1.0; /**Amount that each fragment oconsidered should have their alpha boosted*/
uniform float distMultiplier:hint_range(1.0, 100.0) = 1.0; /**Multiplier added to distance to soften effect*/
uniform float distBooster:hint_range(0.0, 400.0) = 0.0; /**Value added to distance to soften effect*/

void vertex()
{
	VERTEX.xy *= maxBounds;
}

void fragment()
{
	mat2 scale_matrix = mat2(vec2(1.0, 0.0),vec2(0.0, TEXTURE_PIXEL_SIZE.x/TEXTURE_PIXEL_SIZE.y));
	vec2 uv = (((UV * 2.0 - 1.0)*maxBounds+1.0)/2.0-vec2(0.5))*scale_matrix;
	vec2 uv_normal = uv * inverse(scale_matrix) + vec2(0.5);

	vec4 shadow = vec4(0,0,0,0);
	vec4 real = vec4(0,0,0,0);

	vec2 offset;
	for(float r = radStep; r <= radius; r += radStep) // Iterate over the radius by radStep
	{
		for(float a = 0.0; a < fullRot; a += rotStep) // Iterate the angle from 0 to 360 by rotStep (in radians)
		{
			offset = vec2(sin(a), cos(a)) * r * TEXTURE_PIXEL_SIZE;

			if((offset.x > 0.0 || offset.x < 0.0 || offset.y > 0.0 || offset.y < 0.0) && uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0)
			{
				vec4 c = texture(TEXTURE, uv);
				//shadow = vec4(0.,0.,0.,c.a-0.6);
				shadow += (texture(TEXTURE, UV + offset).a / ((distBooster + r)*distMultiplier)) * mixMultiplier;
			}
		}
	}

	if(uv_normal.x >= 0.0 && uv_normal.x <= 1.0 && uv_normal.y >= 0.0 && uv_normal.y <= 1.0)
	{
		real = texture(TEXTURE,uv_normal);
	}
	COLOR = mix(shadow,real,real.a);
	COLOR.rgba = vec4(1.0, 1.0, 1.0, 1.0);
}
