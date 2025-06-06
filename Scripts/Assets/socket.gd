extends Interactable
class_name Socket

@export_category("Items")
@export_subgroup("Weapons")
@export_enum("sword", "staff", "bow", "shield", "nothing") var weapon: String = "sword"

@onready var attachment = $"Weapon Slot"

# Placeholders
#@onready var sword = preload("res://Prefabs/Asset Scenes/placeholder_sword2_hand.tscn")
#@onready var staff = preload("res://Prefabs/Asset Scenes/placeholder_staff2_hand.tscn")
#@onready var bow = preload("res://Prefabs/Asset Scenes/placeholder_bow2_hand.tscn")
#@onready var shield = preload("res://Prefabs/Asset Scenes/placeholder_shield_hand.tscn")

#var sword_name = "Placeholder Sword Hand"
#var shield_name = "Placeholder Shield Hand"
#var staff_name = "Placeholder Staff Hand"
#var bow_name = "Placeholder Bow Hand"

# Models
@onready var sword = preload("res://Prefabs/Asset Scenes/Weapons/sword.tscn")
@onready var shield = preload("res://Prefabs/Asset Scenes/Weapons/shield.tscn")
@onready var staff = preload("res://Prefabs/Asset Scenes/Weapons/staff.tscn")
@onready var bow = preload("res://Prefabs/Asset Scenes/Weapons/bow.tscn")

var sword_name = "Sword"
var shield_name = "Shield"
var staff_name = "Staff"
var bow_name = "Bow"

var sword_intance
var staff_intance
var bow_intance
var shield_intance

var empty_socket = true
var current_weapon_in_socket = ""

func _ready() -> void:
	sword_intance = sword.instantiate()
	staff_intance = staff.instantiate()
	bow_intance = bow.instantiate()
	shield_intance = shield.instantiate()
	
	match weapon:
		"sword":
			attachment.add_child(sword_intance)
			empty_socket = false
			#current_weapon_in_socket = sword_intance.get_name()
			current_weapon_in_socket = sword_name
		"staff":
			attachment.add_child(staff_intance)
			empty_socket = false
			current_weapon_in_socket = staff_name
		"bow":
			attachment.add_child(bow_intance)
			empty_socket = false
			current_weapon_in_socket = bow_name
		"shield":
			attachment.add_child(shield_intance)
			empty_socket = false
			current_weapon_in_socket = shield_name

func _on_interacted(body: Variant) -> void:
	#$AudioStreamPlayer3D.play()
	if empty_socket == false and GameManager.get_weapon_in_hand() == false:
		var attachment_weapon = attachment.get_child(0)
		attachment.remove_child(attachment_weapon)
		current_weapon_in_socket = ""
		empty_socket = true
		#print(11)
		
	elif empty_socket == true and GameManager.get_weapon_in_hand() == true:
		var player_weapon = GameManager.get_first_weapon()
		match player_weapon:
			sword_name:
				attachment.add_child(sword_intance)
				current_weapon_in_socket = sword_intance.get_name()
			staff_name:
				attachment.add_child(staff_intance)
				current_weapon_in_socket = staff_intance.get_name()
			bow_name:
				attachment.add_child(bow_intance)
				current_weapon_in_socket = bow_intance.get_name()
			shield_name:
				attachment.add_child(shield_intance)
				current_weapon_in_socket = shield_intance.get_name()
		empty_socket = false
		#print(22)
		
	elif empty_socket == false and GameManager.get_weapon_in_hand() == true and GameManager.get_weapon_on_back() == false:
		var attachment_weapon = attachment.get_child(0)
		attachment.remove_child(attachment_weapon)
		current_weapon_in_socket = ""
		empty_socket = true
		#print(33)
		
	elif empty_socket == false and GameManager.get_weapon_in_hand() == true and GameManager.get_weapon_on_back() == true:
		var attachment_weapon = attachment.get_child(0)
		attachment.remove_child(attachment_weapon)
		var player_weapon = GameManager.get_first_weapon()
		match player_weapon:
			sword_name:
				attachment.add_child(sword_intance)
				current_weapon_in_socket = sword_intance.get_name()
			staff_name:
				attachment.add_child(staff_intance)
				current_weapon_in_socket = staff_intance.get_name()
			bow_name:
				attachment.add_child(bow_intance)
				current_weapon_in_socket = bow_intance.get_name()
			shield_name:
				attachment.add_child(shield_intance)
				current_weapon_in_socket = shield_intance.get_name()
		empty_socket = false
		#print(44)

func get_current_weapon_in_socket():
	return current_weapon_in_socket

func get_empty_socket():
	return empty_socket
