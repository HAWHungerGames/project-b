extends RayCast3D

@onready var hand = $"../Hand"
var weaponInHand = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var hitObj = get_collider()
		if hitObj.has_method("interactWeapon") && Input.is_action_just_pressed("interact") && weaponInHand == false:
			hitObj.interactWeapon(hand)
			weaponInHand = true
