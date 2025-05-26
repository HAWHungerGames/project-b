extends GPUParticles3D

@onready var boss = get_tree().current_scene.find_child("Boss Room")

func activate_particles_to_boss():
	var material = process_material
	var boss_pos = boss.global_position
	var direction = (boss_pos - global_position).normalized()
	material.direction = direction
	material.gravity = direction
	self.emitting = true
	await get_tree().create_timer(15).timeout
	queue_free()
