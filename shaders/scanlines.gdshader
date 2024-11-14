//---CRT Shader---
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float scanline_count : hint_range(0, 1800) = 50.0;


void fragment()
{	
	float r = texture(SCREEN_TEXTURE, SCREEN_UV, 0.0).r;
	float g = texture(SCREEN_TEXTURE, SCREEN_UV, 0.0).g;
	float b = texture(SCREEN_TEXTURE, SCREEN_UV, 0.0).b;
		
	//If you dont want scanlines you can just delete this part
	float s = sin(SCREEN_UV.y * scanline_count * PI * 2.0);
	s = (s * 0.2 + 0.2) * 0.5 + 1.1; // last value is scanline brightness. Default: 0.9
	vec4 scan_line = vec4(vec3(pow(s, 0.25)), 1.0);
	
	
	COLOR = vec4(r, g, b, 1.0) * scan_line;
}
