shader_type canvas_item;
uniform vec4 bg_color : hint_color;
uniform float bg_darken_val = 0.4;
uniform sampler2D noiseTex;

uniform float starshineOSC = 2f;
uniform float star_amt = 0.999;

//grid stuff:
uniform float battery : hint_range(0.0,1.0) = 1.0;
uniform float anchor : hint_range(-1.0,1.0) = -0.5;
uniform float speed_scale : hint_range(1.0, 10.0) = 1.0;
uniform float fov : hint_range(0.01, 1.0) = 0.2;
uniform vec4 grid_color : hint_color = vec4(1.0, 0.5, 1.0, 1.0);

float grid(vec2 uv, float batt) {
    vec2 size = vec2(uv.y, uv.y * uv.y * 0.2) * 0.01;
    uv += vec2(0.0, TIME * speed_scale * (batt + 0.05));
    uv = abs(fract(uv) - 0.5);
 	vec2 lines = smoothstep(size, vec2(0.0), uv);
 	lines += smoothstep(size * 5.0, vec2(0.0), uv) * 0.4 * batt;
    return clamp(lines.x + lines.y, 0.0, 3.0);
}

float field(vec2 uv) {
	float x = fract(sin(dot(uv, uv)) * 500f);
	float d = x * (0.55 * sin(TIME * (x * starshineOSC)) + 0.55);
	return d;
}

void fragment() {
	//bg_clouds:
	float noiseVal = texture(noiseTex, UV).x;
	float clouds = noiseVal;
	vec4 background_color = mix(bg_color, bg_color - bg_darken_val, clouds);
	//stars:
	float x = fract(dot(SCREEN_UV.xy, SCREEN_UV.xy) * 5000f );
	float color = field(SCREEN_UV.xy) * max(sign(x - star_amt), 0.0);
	
	//grid:
	vec2 uv = UV;
    uv.y = 3.0 / (abs(uv.y + fov) + 0.05);
	uv.x += anchor;
    uv.x *= uv.y * 1.0;
    float gridVal = grid(uv, battery);
    vec4 col = mix(vec4(vec3(color),1.0) + background_color, grid_color, gridVal);
	COLOR = col;
}