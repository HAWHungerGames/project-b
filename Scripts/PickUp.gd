extends RigidBody3D

@onready var sword = $"."

var interactable = true

func interactWeapon(hand: Object):
	if interactable == true:
		interactable = false
		sword.get_parent().remove_child(sword)
		hand.add_child(sword)
		sword.global_transform = hand.global_transform
		sword.collision_layer = 2
		print("hallo")
