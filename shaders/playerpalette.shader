shader_type canvas_item;

const  vec4 u_jacket_shader = vec4(0.4, 1.0, 0.0, 1.0);
const  vec4 u_jacket2_shader = vec4(0.96, 0.0, 1.0, 1.0);
const vec4 u_shirt_shader = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 u_pants = vec4(0.94, 1.0, 0.0, 1.0);
const vec4 u_shoes = vec4(0.44, 0.98, 1.0, 1.0);

uniform vec4 Jacket: hint_color;
uniform vec4 Jacket2: hint_color;
uniform vec4 shirt: hint_color;
uniform vec4 Pants: hint_color;
uniform vec4 Shoes: hint_color;
uniform float u_tolerance;

void fragment() {
    // Get color from the sprite texture at the current pixel we are rendering
    vec4 original_color = texture(TEXTURE, UV);
    vec3 col = original_color.rgb;
    // Get a rough degree of difference between the texture color and the color key
    vec3 diff3 = col - u_shirt_shader.rgb;
    float m = max(max(abs(diff3.r), abs(diff3.g)), abs(diff3.b));
    // Change color of pixels below tolerance threshold, while keeping shades if any (a bit naive, there may better ways)
    float brightness = length(col);
    col = mix(col, shirt.rgb * brightness, step(m, u_tolerance));
	 diff3 = col - u_jacket_shader.rgb;
     m = max(max(abs(diff3.r), abs(diff3.g)), abs(diff3.b));
     col = mix(col, Jacket.rgb * brightness, step(m, u_tolerance));	
	 diff3 = col - u_jacket2_shader.rgb;
     m = max(max(abs(diff3.r), abs(diff3.g)), abs(diff3.b));
     col = mix(col, Jacket2.rgb * brightness, step(m, u_tolerance));	
	diff3 = col - u_pants.rgb;
     m = max(max(abs(diff3.r), abs(diff3.g)), abs(diff3.b));
     col = mix(col, Pants.rgb * brightness, step(m, u_tolerance));	
	diff3 = col - u_shoes.rgb;
     m = max(max(abs(diff3.r), abs(diff3.g)), abs(diff3.b));
     col = mix(col, Shoes.rgb * brightness, step(m, u_tolerance));		
	 COLOR = vec4(col.rgb, original_color.a);
}