extends Node

var weapon_in_hand = false

func get_weapon_in_hand():
	return weapon_in_hand

func set_weapon_in_hand():
	if weapon_in_hand == false:
		weapon_in_hand = true
	else:
		weapon_in_hand = false
