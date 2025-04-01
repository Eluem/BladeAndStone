//Boss beam charging VFX shader
//By: Eluem

shader_type canvas_item;

uniform vec2 resolution = vec2(1024,1024);
uniform float ringCount = 1.0;
uniform float ringSpeed = 1.0;
uniform float ringTimeOffset = 0.0;
uniform float ringSmoothing1 = 0.1;
uniform float ringSmoothing2 = 1.0;

const vec3 WHITE = vec3(1.0,1.0,1.0);
void fragment()
{
	if(COLOR.a > 0.0)
	{
		vec3 color = vec3(0.0);
		float d = 0.0;
		vec2 st = UV.xy;
		//st.y-=0.5;
		st.y/=1.5;
		//st.y = sin(-TIME+st.y);
		// Remap the space to -1. to 1.
		//st = st *2.-1.;
		// Make the distance field
		
		d = length( abs(st)-.5 );
		d = sin(ringTimeOffset+d*ringCount+TIME*ringSpeed);
		// d = length( min(abs(st)-.3,0.) );
		// d = length( max(abs(st)-.3,0.) );
		// Visualize the distance field
		//COLOR.rgba = vec4(vec3(fract(d*10.0)),1.0);
		// Drawing with the distance field
		// gl_FragColor = vec4(vec3( step(.3,d) ),1.0);
		// gl_FragColor = vec4(vec3( step(.3,d) * step(d,.4)),1.0);
		//COLOR.a = 1.0-length(UV.xy-0.5);
		//COLOR.a = 1.0;
		//COLOR.a *= 1.0 - (smoothstep(.1,.2,d) * smoothstep(.1,.4,d));
		float smoothed = smoothstep(ringSmoothing1,ringSmoothing2,d);
		//COLOR.rgb = vec3(smoothstep(ringSmoothing1,ringSmoothing2,d));
		COLOR.a *= smoothed;
	}
}