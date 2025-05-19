shader_type particles;

uniform vec3 player_pos;
uniform float attract_strength = 2.0;

void particle() {
    // Calculate direction to player
    vec3 dir = normalize(player_pos - );
    
    // Adjust velocity (homing force)
    VELOCITY += dir * attract_strength * DELTA;
}