extends VBoxContainer

@onready var weaponSlot1 = $weaponSlot1
@onready var weaponSlot2 = $weaponSlot2
@onready var weapon1 = $weaponSlot1/MarginContainer/weapon1
@onready var weapon2 = $weaponSlot2/MarginContainer/weapon2

@onready var initial_first_weapon = GameManager.get_first_weapon()
@onready var initial_second_weapon = GameManager.get_second_weapon()

var active_slot = 0

var weapon_textures = [{"idle": "res://UITextures/Sword.png", "active": "res://UITextures/SwordAttack.png"},
{"idle": "res://UITextures/Shield.png", "active": "res://UITextures/ShieldBlock.png"},
{"idle": "res://UITextures/Bow.png", "active": "res://UITextures/BowTensioned.png"},
{"idle": "res://UITextures/Magic.png", "active": "res://UITextures/MagicAttack.png"}]

func _ready():
	GameManager.weapons_changed.connect(update_weapons)

func update_weapons():
	if initial_first_weapon.is_empty():
		initial_first_weapon = GameManager.get_first_weapon()
	if initial_second_weapon.is_empty():
		initial_second_weapon = GameManager.get_second_weapon()
	if initial_first_weapon == GameManager.get_second_weapon() && initial_second_weapon == GameManager.get_first_weapon():
		active_slot = 1
	elif initial_first_weapon != GameManager.get_first_weapon() && initial_first_weapon != GameManager.get_second_weapon():
		initial_first_weapon = GameManager.get_first_weapon()
		switch_weapon_texture(initial_first_weapon)
	elif initial_second_weapon != GameManager.get_first_weapon() && initial_second_weapon != GameManager.get_second_weapon():
		initial_second_weapon = GameManager.get_first_weapon()
		switch_weapon_texture(initial_second_weapon)
	else:
		active_slot = 0
	
		
func switch_weapon_texture(weapon):
	var weapon_index = 0
	if "shield" in weapon:
		weapon_index = 1
	elif "bow" in weapon:
		weapon_index = 2
	elif "staff" in weapon:
		weapon_index = 3
		
	if active_slot == 1:
		weapon1.texture = weapon_textures[weapon_index]["idle"]
	else:
		weapon2.testure = weapon_textures[weapon_index]["idle"]
