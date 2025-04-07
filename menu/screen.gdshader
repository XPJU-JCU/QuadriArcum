shader_type canvas_item;
render_mode blend_mix;

// Uniforms for customization
uniform float curvature_amount : hint_range(0.0, 0.1) = 0.02;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.4;
uniform float scanline_count : hint_range(50.0, 500.0) = 200.0;
uniform float brightness : hint_range(0.5, 2.0) = 1.3;
uniform float contrast : hint_range(0.5, 2.0) = 1.2;
uniform float color_bleed : hint_range(0.0, 1.0) = 0.4;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.5;
uniform vec3 tint_color : source_color = vec3(0.85, 1.0, 0.75);
uniform float opacity : hint_range(0.0, 1.0) = 0.9;
uniform float flicker_speed : hint_range(0.0, 5.0) = 1.0;
uniform float flicker_amount : hint_range(0.0, 0.5) = 0.1;
uniform float phosphor_trail : hint_range(0.0, 1.0) = 0.3;
uniform float horizontal_wobble : hint_range(0.0, 0.1) = 0.01;
uniform float wobble_speed : hint_range(0.0, 5.0) = 2.0;
uniform float noise_amount : hint_range(0.0, 0.2) = 0.05;
uniform float glow_amount : hint_range(0.0, 1.0) = 0.3;
uniform float aberration_amount : hint_range(0.0, 0.02) = 0.005;
uniform float aberration_edge_strength : hint_range(0.0, 5.0) = 2.0;

// Noise function for additional effects
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Time-based effects
    float time = TIME;
    
    // Get normalized coordinates with wobble effect
    vec2 uv = UV;
    uv.x += sin(uv.y * 30.0 + time * wobble_speed) * horizontal_wobble;
    
    // Apply screen curvature effect
    vec2 centered_uv = uv * 2.0 - 1.0;
    float dist = length(centered_uv);
    vec2 distorted_uv = uv + (centered_uv * dist * dist) * curvature_amount;
    
    // Initialize color with transparency
    vec4 tex_color = vec4(0.0);
    
    // Only apply effects if we're inside the curved screen area
    if (distorted_uv.x >= 0.0 && distorted_uv.x <= 1.0 && distorted_uv.y >= 0.0 && distorted_uv.y <= 1.0) {
        // Calculate chromatic aberration offset (stronger at edges)
        float aberration_dist = pow(dist, aberration_edge_strength);
        vec2 aberration_offset_r = vec2(aberration_amount * aberration_dist, 0.0);
        vec2 aberration_offset_b = vec2(-aberration_amount * aberration_dist, 0.0);
        
        // Sample with chromatic aberration
        vec4 col_r = texture(TEXTURE, distorted_uv + aberration_offset_r);
        vec4 col_g = texture(TEXTURE, distorted_uv);
        vec4 col_b = texture(TEXTURE, distorted_uv + aberration_offset_b);
        
        // Combine with phosphor trail effect
        vec4 previous_r = texture(TEXTURE, distorted_uv + aberration_offset_r - vec2(0.0, 0.002));
        vec4 previous_g = texture(TEXTURE, distorted_uv - vec2(0.0, 0.002));
        vec4 previous_b = texture(TEXTURE, distorted_uv + aberration_offset_b - vec2(0.0, 0.002));
        
        col_r = mix(col_r, previous_r, phosphor_trail);
        col_g = mix(col_g, previous_g, phosphor_trail);
        col_b = mix(col_b, previous_b, phosphor_trail);
        
        // Combine color channels
        tex_color = vec4(col_r.r, col_g.g, col_b.b, col_g.a);
    
        // Apply additional color bleed
        float bleed_offset = color_bleed * 0.01;
        vec4 bleed_r = texture(TEXTURE, distorted_uv + vec2(bleed_offset, 0.0));
        vec4 bleed_b = texture(TEXTURE, distorted_uv - vec2(bleed_offset, 0.0));
        tex_color.r = mix(tex_color.r, bleed_r.r, 0.7);
        tex_color.b = mix(tex_color.b, bleed_b.b, 0.7);
        
        // Apply scanlines with subtle variation
        float scanline_var = 1.0 + (rand(vec2(floor(uv.y * scanline_count), time)) - 0.5) * 0.1;
        float scanline = sin(distorted_uv.y * scanline_count * 3.141592) * 0.5 + 0.5;
        scanline = mix(1.0, scanline * scanline_var, scanline_opacity);
        tex_color.rgb *= scanline;
        
        // Apply brightness/contrast with random flicker
        float flicker = 1.0 + (sin(time * flicker_speed * 10.0) * 0.5 + 0.5) * flicker_amount;
        tex_color.rgb = (tex_color.rgb - 0.5) * contrast * flicker + 0.5;
        tex_color.rgb *= brightness * flicker;
        
        // Apply tint
        tex_color.rgb *= tint_color;
        
        // Add subtle noise
        tex_color.rgb += (rand(uv * time) - 0.5) * noise_amount;
        
        // Apply glow effect
        vec3 blurred = texture(TEXTURE, distorted_uv).rgb;
        blurred += texture(TEXTURE, distorted_uv + vec2(0.002, 0.0)).rgb;
        blurred += texture(TEXTURE, distorted_uv - vec2(0.002, 0.0)).rgb;
        blurred += texture(TEXTURE, distorted_uv + vec2(0.0, 0.002)).rgb;
        blurred += texture(TEXTURE, distorted_uv - vec2(0.0, 0.002)).rgb;
        blurred /= 5.0;
        tex_color.rgb = mix(tex_color.rgb, blurred, glow_amount);
        
        // Apply vignette
        float vignette = 1.0 - dist * vignette_strength;
        tex_color.rgb *= vignette;
        
        // Apply opacity
        tex_color.a *= opacity;
    }
    
    // Output final color (transparent outside the screen area)
    COLOR = tex_color;
}