extends GPUParticles3D

@export var boss: Node3D

func activate_death_particles():
	self.emitting = true
	await get_tree().create_timer(3).timeout
	queue_free()
