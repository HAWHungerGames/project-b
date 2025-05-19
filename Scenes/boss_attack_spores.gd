extends MultiMeshInstance3D

@export var player: Node3D
@export var particle_count := 100
@export var emission_radius := 5.0
@export var homing_strength := 2.0
@export var max_lifetime := 3.0

var particles_data := []

func _ready():
	# Set up the multimesh
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = SphereMesh.new() # Or your preferred mesh
	multimesh.mesh.radius = 0.1
	multimesh.mesh.height = 0.2
	multimesh.instance_count = particle_count
	
	# Initialize particle data
	for i in particle_count:
		particles_data.append({
			"position": Vector3.ZERO,
			"velocity": Vector3.ZERO,
			"lifetime": 0.0,
			"active": false
		})

func emit_particles(position: Vector3, count: int):
	for i in count:
		var index = find_inactive_particle()
		if index != -1:
			# Initialize particle
			particles_data[index].position = position + Vector3(
				randf_range(-emission_radius, emission_radius),
				randf_range(-emission_radius, emission_radius),
				randf_range(-emission_radius, emission_radius)
			)
			particles_data[index].velocity = Vector3(
				randf_range(-1, 1),
				randf_range(-1, 1),
				randf_range(-1, 1)
			).normalized() * randf_range(1, 3)
			particles_data[index].lifetime = max_lifetime
			particles_data[index].active = true

func find_inactive_particle() -> int:
	for i in particle_count:
		if not particles_data[i].active:
			return i
	return -1

func _process(delta):
	for i in particle_count:
		if particles_data[i].active:
			# Update lifetime
			particles_data[i].lifetime -= delta
			if particles_data[i].lifetime <= 0:
				particles_data[i].active = false
				continue
				
			# Calculate direction to player
			var dir = (player.global_position - particles_data[i].position).normalized()
			
			# Update velocity (homing effect)
			particles_data[i].velocity += dir * homing_strength * delta
			
			# Update position
			particles_data[i].position += particles_data[i].velocity * delta
			
			# Update multimesh transform
			var transform = Transform3D()
			transform.origin = particles_data[i].position
			multimesh.set_instance_transform(i, transform)
