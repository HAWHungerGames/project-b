extends VBoxContainer

@onready var weaponSlot1 = $weaponSlot1
@onready var weaponSlot2 = $weaponSlot2
@onready var weapon1 = $weaponSlot1/MarginContainer/weapon1
@onready var weapon2 = $weaponSlot2/MarginContainer/weapon2

@onready var first_weapon = GameManager.get_first_weapon()
@onready var second_weapon = GameManager.get_second_weapon()

var active_slot = 0

var weapon_textures = [{"idle": "res://UITextures/Sword.png", "active": "res://UITextures/SwordAttack.png"},
{"idle": "res://UITextures/Shield.png", "active": "res://UITextures/ShieldBlock.png"},
{"idle": "res://UITextures/Bow.png", "active": "res://UITextures/BowTensioned.png"},
{"idle": "res://UITextures/Magic.png", "active": "res://UITextures/MagicAttack.png"}]

func _ready():
	GameManager.weapons_changed.connect(update_weapons)

func update_weapons():
	print("Updating weapons")
	print("init1 ", first_weapon)
	print("init2 ", second_weapon)
	print("wep 1 ", GameManager.get_first_weapon())
	print("wep 2 ", GameManager.get_second_weapon())
	var slot_changed = false

	if active_slot == 0 && first_weapon == GameManager.get_second_weapon() && second_weapon == GameManager.get_first_weapon():
		print("weapons changed to 1")
		active_slot = 1
		slot_changed = true
	elif active_slot == 1 && first_weapon == GameManager.get_first_weapon() && second_weapon == GameManager.get_second_weapon():
		print("weapons changed to 0")
		active_slot = 0
		slot_changed = true
	elif first_weapon != GameManager.get_first_weapon() && first_weapon != GameManager.get_second_weapon() && !GameManager.get_second_weapon().is_empty():
		print("updatin first weapon")
		first_weapon = GameManager.get_first_weapon()
	elif second_weapon != GameManager.get_first_weapon() && second_weapon != GameManager.get_second_weapon() && !GameManager.get_second_weapon().is_empty():
		print("updatin second weapon")
		second_weapon = GameManager.get_first_weapon()
	
	if first_weapon.is_empty() && second_weapon.is_empty() && !GameManager.get_first_weapon().is_empty():
		print("init first")
		first_weapon = GameManager.get_first_weapon()
	elif !first_weapon.is_empty() && second_weapon.is_empty() && !GameManager.get_first_weapon().is_empty():
		print("init second")
		second_weapon = GameManager.get_first_weapon()
		active_slot = 1
	switch_weapon_texture(GameManager.get_first_weapon(), slot_changed)
		
func switch_weapon_texture(weapon, slot_change):
	if slot_change:
		if active_slot == 1:
			weapon2.move_to_front()
			weapon1.z_index = -1
			return
		else:
			weapon1.move_to_front()
			weapon2.z_index = -1
			return
	var weapon_index = 0
	print("weapon: ", weapon)
	if !weapon.is_empty():
		if "shield" in weapon.to_lower():
			weapon_index = 1
		elif "bow" in weapon.to_lower():
			weapon_index = 2
		elif "staff" in weapon.to_lower():
			weapon_index = 3
		print("index: ", weapon_index)
	
		if active_slot == 1:
			weapon2.texture = load(weapon_textures[weapon_index]["idle"])
		else:
			weapon1.texture = load(weapon_textures[weapon_index]["idle"])
	else:
		if active_slot == 1:
			weapon2.texture = null
		else:
			weapon1.texture = null
