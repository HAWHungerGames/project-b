extends Node

var weapon_in_hand = false
var weapon_on_back = false
var first_weapon = ""
var second_weapon = ""

signal weapons_changed

func get_weapon_in_hand():
	return weapon_in_hand

func set_weapon_in_hand():
	if weapon_in_hand == false:
		weapon_in_hand = true
	else:
		weapon_in_hand = false
		
func get_weapon_on_back():
	return weapon_on_back

func set_weapon_on_back():
	if weapon_on_back == false:
		weapon_on_back = true
	else:
		weapon_on_back = false

func get_first_weapon():
	return first_weapon
	
func set_first_weapon(weapon):
	first_weapon = weapon

func get_second_weapon():
	return second_weapon
	
func set_second_weapon(weapon):
	second_weapon = weapon
	
func weapons_updated():
	weapons_changed.emit()
