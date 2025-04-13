extends RayCast3D

@onready var hand = $"../Hand"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var hitObj = get_collider()
		if hitObj.is_in_group("weapons") && Input.is_action_just_pressed("interact"):
			hitObj.global_position = hand.global_position
			hitObj.global_rotation = hand.global_rotation
