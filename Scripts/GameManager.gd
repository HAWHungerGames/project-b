extends Node

var weapon_in_hand: bool = false
var weapon_on_back: bool = false
var first_weapon: String = ""
var second_weapon: String = ""

var bow_attack_timer: float
var attack_loading_value: float = bow_attack_timer
var is_attacking: bool = false
var is_blocking: bool = false

signal weapons_changed
signal attacks
signal blocks
signal attack_loading_updated

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
	bow_attack_timer = max(round(timer*100)/100,1)
	#print(bow_attack_timer)
	set_attack_loading_value(bow_attack_timer)

func get_attack_loading_value():
	return attack_loading_value
	
func set_attack_loading_value(val):
	attack_loading_value = val
	attack_loading_updated.emit()
	
func get_is_attacking():
	return is_attacking

func set_is_attacking(check):
	is_attacking = check
	GameManager.attacks.emit()
	
func get_is_blocking():
	return is_blocking

func set_is_blocking(check):
	is_blocking = check
	GameManager.blocks.emit()

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

func get_mouse_ground_position_fixed(object) -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	
	var origin = camera.project_ray_origin(mouse_pos)
	var direction = camera.project_ray_normal(mouse_pos)
	
	var ground_y = object.global_position.y
	
	if direction.y != 0:
		var t = (ground_y - origin.y) / direction.y
		var world_pos = origin + direction * t
		return world_pos
	
	return object.global_position
