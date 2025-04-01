//Ripple boss beam shader
//By: Eluem

shader_type canvas_item;
const vec3 WHITE = vec3(1.0,1.0,1.0);
void fragment()
{
	if(COLOR.a > 0.0)
	{
		//Symmetrical over width 0-1-0
		float symY = 2.0*(0.5 - abs(0.5 - UV.y));
		//float smoothEdgeAlpha = max(0, (2.0*(symY - 0.2)) * (UV.x-0.1));
		//float smoothEdgeAlpha = max(0, (2.0*(symY - 0.2)) * min(1, (UV.x*2.0)));
		//float smoothEdgeAlpha = max(0, (2.0*(symY - 0.2)) * (1.0 / (1.0+pow(UV.x / (1.0 - UV.x), -3))));
		float smoothEdgeAlpha = max(0, (2.0*(symY - 0.2)) - (1.0 - UV.x)) * min(1.0, UV.x*5.0);
		//float w2 = max(0,(8.0*(0.5 - abs(0.5 - UV.y) - 0.4)) * (UV.x-0.1));
		//float w2 = max(0,(4.0*(0.5 - abs(0.5 - UV.y) - 0.3)) * (UV.x-0.1));
		float w2 = max(0.0, pow(symY,5)-0.2) * (UV.x-0.1);
		COLOR.rgb = mix(COLOR.rgb, WHITE, w2);
		//rippleEdge = max(0,symY-0.2*sin(TIME*12.0+UV.x*PI*10.0));
		//rippleEdge = max(0,symY-max(-1000.0,min(100.0, 0.5*abs(sin(TIME*12.0+UV.x*PI*10.0)))));
		//rippleEdge = (smoothEdgeAlpha) * (symY-5000.*sin(UV.x*PI*20.0));
		float rippleEdge = (symY-(0.1*sin(TIME*7.0+UV.x*PI*5.0)-0.8));
		//float rippleEdge2 = rippleEdge - 1.0;
		float alphaStart = 1.0 - pow(UV.x, 15);
		
		COLOR.a *= smoothEdgeAlpha * rippleEdge * alphaStart;// * rippleEdge2;
		//COLOR.a *= 2.0;
		
		//COLOR.a = sin(TIME*TIME*smoothEdgeAlpha); //Trippy
		//COLOR.a *= sin((TIME*5.0)+1.0*UV.x);
		//COLOR.a *= sin(UV.x*2.0)*symY;
	}
}