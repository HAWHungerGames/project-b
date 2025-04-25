extends RigidBody3D

@export_category("Items")
@export_subgroup("Weapons")
@export_enum("sword", "staff", "bow") var weapon: String = "sword"

@onready var attachment = $"Weapon Slot"
@onready var sword = preload("res://Scenes/Asset Scenes/placeholder_sword2.tscn")
@onready var staff = preload("res://Scenes/Asset Scenes/placeholder_staff2.tscn")
@onready var bow = preload("res://Scenes/Asset Scenes/placeholder_bow.tscn")


func _ready() -> void:
	match weapon:
		"sword":
			var sword_intance = sword.instantiate()
			attachment.add_child(sword_intance)
		"staff":
			var staff_intance = staff.instantiate()
			attachment.add_child(staff_intance)
		"bow":
			var bow_intance = bow.instantiate()
			attachment.add_child(bow_intance)
