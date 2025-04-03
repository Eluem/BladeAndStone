//Boss beam charging VFX shader
//By: Eluem

shader_type canvas_item;

const vec3 WHITE = vec3(1.0,1.0,1.0);
//#define TWO_PI 6.28318530718
const float r = 2.09439510239;
void fragment()
{
	vec2 st = UV.xy;
	
	// Remap the space to -1. to 1.
	float timeOffset = 0.1*sin(TIME*3.0);
	st = st *2.0-1.0;
	st.x += 0.05;
	vec2 st2 = st;
	st2.x += 0.4+timeOffset;
	
	// Number of sides of your shape
	//int N = 3;
	
	// Angle and radius from the current pixel
	float a = atan(st.x,st.y)+PI*0.5;
	float a2 = atan(st2.x,st2.y)+PI*0.5;
	//float r = TWO_PI/float(N);
	
	// Shaping function that modulate the distance
	float d = cos(floor(0.5+a/r)*r-a)*length(st);
	float d2 = cos(floor(0.5+a2/r)*r-a2)*length(st2);
	//d = d/d2;
	
	//COLOR.a = 1.0-(smoothstep(0.2,0.6,d));
	//COLOR.a = 1.0-(smoothstep(0.2,0.6,d2));
	float ds = 1.0-smoothstep(0.2,0.6,d);
	float ds2 = 1.0-smoothstep(0.2,0.6,d2);
	//COLOR.a = 1.0-(smoothstep(0.2,0.6,d));
	//COLOR.rgb = vec3((smoothstep(0.2,0.6,d2)));
	//COLOR.rgb = vec3(1.0-(smoothstep(0.2,0.6,d2)));
	//COLOR.a = 1.0-d;
	//COLOR.a = 1.0-(smoothstep(0.2,0.6,d) / smoothstep(0.2,0.6,d2));
	
	
	//COLOR.a = ds2;
	//COLOR.a = ds;
	//COLOR.rgb = vec3(ds2);
	//COLOR.r = ds;
	//COLOR.g = ds2;
	
	
	COLOR.a *= (ds-ds*ds2)*1.5;
}