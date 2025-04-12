shader_type canvas_item;

uniform vec4 darkness_color: source_color = vec4(0.0, 0.0, 0.0, 0.8);
uniform float light_falloff: hint_range(0.0, 10.0) = 2.0;
uniform int light_count;
uniform vec3 lights[100];
uniform vec2 viewport_size;

void fragment() {
    vec2 uv = UV;
    vec2 screen_pixel_size = 1.0 / viewport_size;
    vec4 final_color = darkness_color;

    for (int i = 0; i < light_count; ++i) {
        vec3 light_data = lights[i];
        vec2 light_position_uv = light_data.xy / viewport_size;
        float light_radius_uv = light_data.z / viewport_size.x;
		light_radius_uv = sin(TIME * 5.0) / 100.0 + light_radius_uv;
        vec2 offset_to_light = light_position_uv - uv;
        float distance_squared = dot(offset_to_light, offset_to_light);
        float attenuation = 1.0 - (sqrt(distance_squared) / light_radius_uv);
		attenuation = 1.0 - smoothstep(light_radius_uv - (light_falloff * screen_pixel_size.x * 10.0), light_radius_uv, sqrt(distance_squared));
        final_color = min(final_color, mix(darkness_color, vec4(0.8, 0.8, 1.0, 0.1), attenuation));
    }

    COLOR = final_color;
}