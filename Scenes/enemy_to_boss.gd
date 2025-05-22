extends GPUParticles3D

@export var boss: Node3D

func activate_particles_to_boss():
	var material = process_material
	var boss_pos = boss.global_position
	material.direction =	(boss_pos - global_position).normalized()
	self.emitting = true 
