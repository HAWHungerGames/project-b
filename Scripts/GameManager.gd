extends Node

var weapon_in_hand = false
var weapon_on_back = false
var first_weapon = ""
var second_weapon = ""

var bow_attack_timer

var is_attacking = false
signal weapons_changed
signal attacks

func get_weapon_in_hand():
	return weapon_in_hand

func set_weapon_in_hand():
	if !weapon_in_hand:
		weapon_in_hand = true
	else:
		weapon_in_hand = false
		
func get_weapon_on_back():
	return weapon_on_back

func set_weapon_on_back():
	if !weapon_on_back:
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
	
func get_bow_attack_timer():
	return bow_attack_timer
	
func set_bow_attack_timer(timer):
	bow_attack_timer = round(timer*10)/10
	print(bow_attack_timer)
	
func get_is_attacking():
	return is_attacking

func set_is_attacking(check):
	is_attacking = check
	GameManager.attacks.emit()

func weapons_updated():
	weapons_changed.emit()

func get_child_by_name(parent, name: String):
	for child in parent.get_children():
		if child.name == name:
			return child
			
func reset_child_to_root(parent, child):
		var pos = child.global_position
		parent.remove_child(child)
		get_tree().current_scene.add_child(child)
		child.global_position = pos
