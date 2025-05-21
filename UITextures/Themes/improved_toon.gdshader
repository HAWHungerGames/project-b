shader_type spatial;

uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D albedo_texture : source_color;
uniform int cuts : hint_range(1, 8) = 3;
uniform float wrap : hint_range(-2.0, 2.0) = 0.0;
uniform float steepness : hint_range(1.0, 8.0) = 1.0;
uniform bool use_attenuation = true;

void fragment() {
    ALBEDO = albedo.rgb * texture(albedo_texture, UV).rgb;
}

void light() {
    // Attenuation
    float attenuation = 1.0;
    if (use_attenuation) {
        attenuation = ATTENUATION;
    }
    
    // Diffuse lighting with toon steps
    float NdotL = dot(NORMAL, LIGHT);
    float diffuse_amount = NdotL + wrap;
    diffuse_amount *= steepness;
    
    // Create sharp steps for toon effect
    float cuts_inv = 1.0 / float(cuts);
    float diffuse_stepped = clamp(diffuse_amount + mod(1.0 - diffuse_amount, cuts_inv), 0.0, 1.0);
    
    // Apply diffuse result
    vec3 diffuse = ALBEDO.rgb * LIGHT_COLOR / PI;
    diffuse *= diffuse_stepped;
    
    // Apply attenuation for shadows
    diffuse *= attenuation;
    
    DIFFUSE_LIGHT += diffuse;
}