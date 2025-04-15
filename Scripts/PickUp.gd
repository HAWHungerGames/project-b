extends RigidBody3D

@onready var weapon = $"."

var interactable = true

func interactWeapon(hand: Object):
	if interactable == true:
		interactable = false
		weapon.get_parent().remove_child(weapon)
		hand.add_child(weapon)
		weapon.global_transform = hand.global_transform
		weapon.collision_layer = 2
		print("hallo")
