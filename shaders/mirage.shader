shader_type canvas_item;
render_mode unshaded;
uniform float frequency = 60;
uniform float depth = 0.005;
uniform sampler2D vignette;
uniform float time_multiplier=1;
uniform sampler2D noise;


void fragment() {
	vec2 uv = SCREEN_UV;
	if ((sin(uv.y) == 0.0) || (sin(uv.y) == 0.5))
	{
	uv.x += sin(uv.y * (frequency*(TIME/2.0)) + (TIME*time_multiplier)) * (depth/1000.0);
	uv.y = clamp(uv.y, 0.0, 1.0);
	}
	vec3 c = texture(SCREEN_TEXTURE, uv).rgb;
	COLOR.rgb = c;
	COLOR *= texture(vignette, uv);
	vec2 noiseUV = uv;
	noiseUV.x += TIME; 
	//COLOR += texture(noise, noiseUV)/2.0;
}
