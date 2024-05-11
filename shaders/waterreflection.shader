shader_type canvas_item;
render_mode unshaded;

uniform float frequency = 60;
uniform float depth = 0.005;
uniform float blur = 0.0;
uniform float blur2 = 0.002;
uniform float freq2 = 60;
uniform float yoffset;
uniform float xoffset;
uniform float speed;
uniform sampler2D noisetex;
uniform float xstrength;
uniform float ystrength;
void fragment(){

    vec2 uv = SCREEN_UV;
    float y = 1.0-uv.y;
	float noise= texture(noisetex,UV+vec2(TIME/16.0,0)).r;
	vec2 offset = noise * vec2(xstrength,ystrength);
	y += sin(uv.x * frequency + TIME*speed) * depth;
	y += sin((uv.x)/(uv.y) * freq2 + TIME*speed) * blur2;
	uv.x = clamp(uv.x, 0.0, 1.0);
	float y2=clamp(y,0.0,1.0);
	
//    COLOR = vec4(texture(SCREEN_TEXTURE, vec2(uv.x, y2)));
//
	COLOR=vec4(textureLod(SCREEN_TEXTURE,vec2(uv.x+xoffset+offset.x-xstrength/2.0,y2+yoffset+offset.y-ystrength/2.0),blur))*texture(TEXTURE,UV+offset);
} 
