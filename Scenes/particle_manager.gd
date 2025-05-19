extends Node3D

@export var player: Node3D
@export var particle_scene: PackedScene
@export var max_particles := 100

var particle_pool := []
var active_particles := []

func _ready():
	# Pre-instantiate particles
	for i in max_particles:
		var particle = particle_scene.instantiate()
		particle.visible = false
		add_child(particle)
		particle_pool.append(particle)

func emit_particles(position: Vector3, count: int):
	for i in count:
		if particle_pool.size() > 0:
			var particle = particle_pool.pop_back()
			particle.global_position = position + Vector3(
				randf_range(-1, 1),
				randf_range(-1, 1),
				randf_range(-1, 1)
			)
			particle.visible = true
			active_particles.append(particle)

func _process(delta):
	var particles_to_remove := []
	
	for particle in active_particles:
		# Calculate direction to player
		var dir = (player.global_position - particle.global_position).normalized()
		
		# Move toward player
		particle.global_position += dir * 5.0 * delta
		
		# Check if particle reached player
		if particle.global_position.distance_to(player.global_position) < 0.5:
			particle.visible = false
			particle_pool.append(particle)
			particles_to_remove.append(particle)
	
	# Remove collected particles
	for particle in particles_to_remove:
		active_particles.erase(particle)
