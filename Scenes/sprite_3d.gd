extends Sprite3D

@onready var enemy = get_parent()

func _process(delta):
	update_health_bar_position()

func update_health_bar_position():
	var enemy_pos = enemy.global_position
	var camera = get_viewport().get_camera_3d()
	
	# Convert to screen coordinates and round to nearest pixel
	var screen_pos = camera.unproject_position(enemy_pos)
	screen_pos = Vector2(round(screen_pos.x), round(screen_pos.y))
	
	# Convert back to world position
	var world_pos = camera.project_position(screen_pos, enemy_pos.distance_to(camera.global_position))
	global_position = world_pos + Vector3(0, 2, 0)
