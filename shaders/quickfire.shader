shader_type canvas_item;
render_mode unshaded, blend_add;

uniform sampler2D noisetex;
uniform float xstrength;
uniform float ystrength;
uniform sampler2D vignette;
void fragment() {
	vec2 uv = SCREEN_UV;
	//float noise= textureLod
	float noise= texture(noisetex,UV+vec2(TIME*20.5,0)).r;
	vec2 offset = noise * vec2(xstrength,ystrength);
	vec3 vignette_color = texture(vignette, UV).rgb;
	// Screen texture stores gaussian blurred copies on mipmaps.

	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV+offset, (1.0 - vignette_color.r) * 4.0).rgb;
	
	COLOR.b+=0.2;
	//COLOR.b*= sin(TIME*4.5)/1.25;
	COLOR.r*= sin(cos(TIME*3.5))*2.0;
	COLOR.rgb *= texture(vignette, UV).rgb;
}
