uniform sampler2D Tex;

float WIDTH = 1680, HEIGHT = 1024;
const float colorstep =  1.0 / 256.0;

uniform float redness;

void main(void)
{
	float ones = 1.0 / WIDTH;		
	float onet = 1.0 / HEIGHT;		
	
	
	vec2 others[8];
	others[0] = vec2(0.0,onet);	
	others[1] = vec2(ones,onet);	
	others[2] = vec2(ones,0.0);	
	others[3] = vec2(ones,-onet);	
	others[4] = vec2(0.0,-onet);	
	others[5] = vec2(-ones,-onet);	
	others[6] = vec2(-ones,0.0);	
	others[7] = vec2(-ones,onet);	
			 
	int neighbours = 0;
	int i;
	
	if ( texture2D(Tex, gl_TexCoord[0]+others[0]).b > 0.9)
		neighbours ++;
	if ( texture2D(Tex, gl_TexCoord[0]+others[1]).b > 0.9)
		neighbours ++;
	if ( texture2D(Tex, gl_TexCoord[0]+others[2]).b > 0.9)
		neighbours ++;
	if ( texture2D(Tex, gl_TexCoord[0]+others[3]).b > 0.9)
		neighbours ++;
	if ( texture2D(Tex, gl_TexCoord[0]+others[4]).b > 0.9)
		neighbours ++;
	if ( texture2D(Tex, gl_TexCoord[0]+others[5]).b > 0.9)
		neighbours ++;
	if ( texture2D(Tex, gl_TexCoord[0]+others[6]).b > 0.9)
		neighbours ++;
	if ( texture2D(Tex, gl_TexCoord[0]+others[7]).b > 0.9)
		neighbours ++;
	
	vec4 color = texture2D(Tex, gl_TexCoord[0]);
	  
	if (color.b > 0.9) {							
		if (neighbours < 2 || neighbours > 3)		
			color = vec4(0.0, 0.0, 0.8, 1.0);		
		else if (color.b > 0.0)						
			color.b = color.b - colorstep;	
			
	} else {										
		if (neighbours == 3)						
			color = vec4( 0.0, 0.0 , 1.0, 1.0);		
		else if (color.b > 0.0)
			color.b = color.b - colorstep;			
	}		
	

	if (color.b < 1.0)
	{
		color.r = (gl_TexCoord[0]/1.5) + neighbours/16.0;
		color.g = ((1-gl_TexCoord[0])/1.5) + neighbours/16.0;
   }
	if (neighbours == 1)
	{
	   if (gl_TexCoord[0].s < 0.5)
	   {
	   	   color.r = 1-gl_TexCoord[0];
	   }
	   else
	   {
		   color.g = gl_TexCoord[0] - 0.2;
	   }
	}
    
	
	
	
	
	gl_FragColor = color;

}
