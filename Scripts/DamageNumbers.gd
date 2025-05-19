extends Node3D

func display_number(value: int, position_of_number: Vector3):
	var number = Label3D.new()
	number.position = position_of_number
	number.text = str(value)
	number.billboard = BaseMaterial3D.BILLBOARD_ENABLED  # Makes it face the camera
	number.top_level = true  # Prevents inheriting transforms
	

	number.font_size = 128
	number.modulate = Color(1, 1, 1)  # white text
	
	call_deferred("add_child", number)

	await get_tree().process_frame  # Wait a frame to ensure size & layout is ready
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y + 0.5, 0.5
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "scale", Vector3.ZERO, 0.3
	).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
