extends VBoxContainer

@onready var weaponSlot1 = $weaponSlot1
@onready var weaponSlot2 = $weaponSlot2
@onready var weapon1 = $weaponSlot1/MarginContainer/weapon1
@onready var weapon2 = $weaponSlot2/MarginContainer/weapon2

var current_weapon = 1
var active_slot = 1

var weapon_textures = [{"idle": "res://UITextures/Sword.png", "active": "res://UITextures/SwordAttack.png"},
{"idle": "res://UITextures/Shield.png", "active": "res://UITextures/ShieldBlock.png"},
{"idle": "res://UITextures/Bow.png", "active": "res://UITextures/BowTensioned.png"},
{"idle": "res://UITextures/Magic.png", "active": "res://UITextures/MagicAttack.png"}]
func get_active_weapon(weapon):
	if weapon == 1:
		current_weapon = weapon1
		
func switch_weapon_texture(weapon):
	if active_slot == 1:
		weapon1.texture = weapon_textures[weapon]["idle"]
	else:
		weapon2.testure = weapon_textures[weapon]["idle"]
