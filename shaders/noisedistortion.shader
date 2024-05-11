shader_type canvas_item;
render_mode unshaded;
uniform float frequency = 60;
uniform float depth = 0.005;
uniform sampler2D noisetex;
uniform float xstrength;
uniform float ystrength;

void fragment() {
	vec2 uv = SCREEN_UV;
	//float noise= textureLod
	float noise= texture(noisetex,UV+vec2(TIME/16.0,0)).r;
	vec2 offset = noise * vec2(xstrength,ystrength);
	uv.x = clamp(uv.x, 0.0, 1.0);
	COLOR = texture(TEXTURE, UV+offset) + texture(SCREEN_TEXTURE,vec2(-UV.x,UV.y));
	
}
