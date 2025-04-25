extends Interactable

@export_category("Items")
@export_subgroup("Weapons")
@export_enum("sword", "staff", "nothing") var weapon: String = "sword"

@onready var attachment = $"Weapon Slot"
@onready var sword = preload("res://Scenes/Asset Scenes/placeholder_sword2_hand.tscn")
@onready var staff = preload("res://Scenes/Asset Scenes/placeholder_staff2_hand.tscn")

var empty_socket = true

func _ready() -> void:
	match weapon:
		"sword":
			var sword_intance = sword.instantiate()
			attachment.add_child(sword_intance)
			empty_socket = false
		"staff":
			var staff_intance = staff.instantiate()
			attachment.add_child(staff_intance)
			empty_socket = false

func _on_interacted(body: Variant) -> void:
	if empty_socket == true:
		pass
