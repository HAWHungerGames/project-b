extends Node

var weapon_in_hand = false
var current_weapon = ""

func get_weapon_in_hand():
	return weapon_in_hand

func set_weapon_in_hand():
	if weapon_in_hand == false:
		weapon_in_hand = true
	else:
		weapon_in_hand = false

func get_current_weapon():
	return current_weapon
	
func set_current_weapon(weapon):
	current_weapon = weapon
