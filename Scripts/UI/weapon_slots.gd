extends VBoxContainer

@onready var weaponSlot1 = $weaponSlot1
@onready var weaponSlot2 = $weaponSlot2
@onready var weapon1 = $weaponSlot1/MarginContainer/weapon1
@onready var weapon2 = $weaponSlot2/MarginContainer/weapon2

@onready var first_weapon = GameManager.get_first_weapon()
@onready var second_weapon = GameManager.get_second_weapon()

var weapon_in_slot1 = ""
var weapon_in_slot2 = ""

var slot_one_active = true
var state = "idle" 
var weapon_index = 0

var weapon_textures = [{"idle": "res://UITextures/Weapons/Sword.png", "active": "res://UITextures/Weapons/SwordAttack.png"},
{"idle": "res://UITextures/Weapons/Shield.png", "active": "res://UITextures/Weapons/ShieldBlock.png"},
{"idle": "res://UITextures/Weapons/Bow.png", "active": "res://UITextures/Weapons/BowTensioned.png"},
{"idle": "res://UITextures/Weapons/Magic.png", "active": "res://UITextures/Weapons/MagicAttack.png"}]

func _ready() -> void:
	GameManager.weapons_changed.connect(update_weapons)
	GameManager.attacks.connect(attack)
func update_weapons():
	print("update")
	if GameManager.is_attacking:
		state = "active"
	else:
		state = "idle"
	var new_first_weapon = GameManager.get_first_weapon()
	var new_second_weapon = GameManager.get_second_weapon()
	print(weapon1.get_path())
	if Input.is_action_just_pressed("weapon_swap"):
		var slot_changed = true
		slot_one_active = !slot_one_active
		switch_active_texture()
		first_weapon = GameManager.get_first_weapon()
		second_weapon = GameManager.get_second_weapon()
	if Input.is_action_just_pressed("interact") && (first_weapon != GameManager.get_first_weapon() || second_weapon != GameManager.get_second_weapon()):
		# Case 1: Second weapon was removed and first weapon changed
		# This means the second weapon became the first weapon
		if second_weapon != "" && new_second_weapon == "":
			slot_one_active = false
			switch_weapon_texture(GameManager.get_second_weapon())
			if first_weapon != new_first_weapon && new_first_weapon == second_weapon:
				weapon_in_slot1 = weapon_in_slot2
				weapon_in_slot2 = ""
				slot_one_active = true
				switch_weapon_texture(GameManager.get_first_weapon())
		 # Case 2: New weapon picked up for first slot
		elif first_weapon != new_first_weapon && new_first_weapon != second_weapon:
			weapon_in_slot1 = new_first_weapon
			switch_weapon_texture(GameManager.get_first_weapon())
		# Case 3: New weapon picked up for second slot
		elif second_weapon != new_second_weapon && new_second_weapon != "":
			weapon_in_slot2 = new_second_weapon
			slot_one_active = false
			switch_weapon_texture(new_second_weapon)
			slot_one_active = true
			# Case 4: First weapon was put back (and no second weapon to move)
		elif first_weapon != "" && new_first_weapon == "" && second_weapon == "":
			weapon_in_slot1 = ""
			slot_one_active = true
			switch_weapon_texture(GameManager.get_first_weapon())
		first_weapon = new_first_weapon
		second_weapon = new_second_weapon
		print("signal shot")

func attack():
	check_weapon(GameManager.get_first_weapon())
	if GameManager.is_attacking:
		attack_texture("active")
	else:
		attack_texture("idle")
		
func attack_texture(state):
	if slot_one_active:
		weapon1.texture = load(weapon_textures[weapon_index][state])
	else:
		weapon2.texture = load(weapon_textures[weapon_index][state])
		
func switch_weapon_texture(weapon):
	print(weapon)
	if !weapon.is_empty():
		check_weapon(weapon)
		print(weapon_index)
		if !slot_one_active && weapon2.texture != null:
			weapon2.texture = load(weapon_textures[weapon_index]["idle"])
			slot_one_active = !slot_one_active
		elif !slot_one_active:
			weapon2.texture = load(weapon_textures[weapon_index]["idle"])
		else:
			print("update terxuter 1")
			print(load((weapon_textures[weapon_index]["idle"])))
			weapon1.texture = load(weapon_textures[weapon_index]["idle"])
			print(weapon1.texture)
			switch_active_texture()
	else:
		if !slot_one_active:
			weapon2.texture = null
		else:
			weapon1.texture = null

func check_weapon(weapon):
	print(weapon)
	if "shield" in weapon.to_lower():
		weapon_index = 1
	elif "bow" in weapon.to_lower():
		weapon_index = 2
	elif "staff" in weapon.to_lower():
		weapon_index = 3
	else:
		weapon_index = 0
	print(weapon_index)
func switch_active_texture():
	if slot_one_active:
		weapon1.z_index = 1
		weapon2.z_index = -1
	else:
		weapon2.z_index = 1
		weapon1.z_index = -1
