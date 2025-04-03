shader_type canvas_item;
uniform float radius:hint_range(-0.1, 1.1, 0.001) = 0.5;
uniform float thickness:hint_range(0.0, 1.0, 0.001) = 0.1;
uniform float edgeSmoothing:hint_range(0.0, 1.0, 0.001) = 0.1;


//Found circle and ring here:
//https://www.shadertoy.com/view/cdXGDS
//float circle(in vec2 _st, in float _radius)
//{
    //vec2 dist = _st-vec2(0.5);
	//return 1.-smoothstep(_radius-(_radius*edgeSmoothing),
                         //_radius+(_radius*edgeSmoothing),
                         //dot(dist,dist)*4.0);
//}
//float ring( vec2 st, float scale, float halfThickness )
//{
//
    //float d1 = circle( st, scale + halfThickness );
    //float d2 = circle( st, scale - halfThickness );
    //
    //return d1 * ( 1.0 - d2 );   
//}


void fragment()
{
	//float scaledRadius = (1.2*radius)-0.1;
	float scaledRadius = (1.05*radius)-0.05;
	scaledRadius = scaledRadius*0.5;
	float halfThickness = thickness/2.0;
	//COLOR.a = ring(UV.xy, radius, halfThickness);
	
	
	// Shaping function that modulate the distance
	float d = length(UV.yx-0.5);
	float innerRadius = scaledRadius-halfThickness;
	float outerRadius = scaledRadius+halfThickness;
	float dInner = smoothstep(innerRadius-edgeSmoothing, innerRadius+edgeSmoothing, d);
	float dOuter = smoothstep(outerRadius+edgeSmoothing, outerRadius-edgeSmoothing, d);
	//float dMin = 1.0 - smoothstep(halfThickness+edgeSmoothing, halfThickness-edgeSmoothing, d);
	//float dMax = 1.0-smoothstep(0.4, 0.469, d);
	float dMax = 1.0-smoothstep(0.4, 0.47, d);
	COLOR.a *= pow(dOuter * dInner * dMax, 1.0);
	//COLOR.a = dMin;
	//COLOR.a = dInner;
	//COLOR.a = dOuter;
	//COLOR.a = dMax;
	//float testOuter = length(UV.xy-0.5)-radius+0.005;
	//float testInner = length(UV.xy-0.5)-0.1;
	//COLOR.a = pow(ring(UV.xy, 1.0, 0.1), 0.2);
	//if(COLOR.a > 0.0){COLOR.a = 1.0;}
}