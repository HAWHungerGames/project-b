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

var weapon_textures = [{"idle": "res://UITextures/Sword.png", "active": "res://UITextures/SwordAttack.png"},
{"idle": "res://UITextures/Shield.png", "active": "res://UITextures/ShieldBlock.png"},
{"idle": "res://UITextures/Bow.png", "active": "res://UITextures/BowTensioned.png"},
{"idle": "res://UITextures/Magic.png", "active": "res://UITextures/MagicAttack.png"}]

func _ready() -> void:
	GameManager.weapons_changed.connect(update_weapons)
func update_weapons():
	var new_first_weapon = GameManager.get_first_weapon()
	var new_second_weapon = GameManager.get_second_weapon()
	
	print("Current UI state:")
	print("- first_weapon: ", first_weapon)
	print("- weapon_in_slot1: ", weapon_in_slot1)
	print("- weapon_in_slot2: ", weapon_in_slot2)
	print("- second_weapon: ", second_weapon)
	print("New GameManager state:")
	print("- new_first: ", new_first_weapon)
	print("- new_second: ", new_second_weapon)

	if Input.is_action_just_pressed("weapon_swap"):
		print("swapped")
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
				print("Moving second weapon to first slot")
				weapon_in_slot1 = weapon_in_slot2
				weapon_in_slot2 = ""
				slot_one_active = true
				switch_weapon_texture(GameManager.get_first_weapon())
		 # Case 2: New weapon picked up for first slot
		elif first_weapon != new_first_weapon && new_first_weapon != second_weapon:
			print("New first weapon picked up")
			weapon_in_slot1 = new_first_weapon
			switch_weapon_texture(GameManager.get_first_weapon())
		# Case 3: New weapon picked up for second slot
		elif second_weapon != new_second_weapon && new_second_weapon != "":
			print("Second weapon changed")
			weapon_in_slot2 = new_second_weapon
			slot_one_active = false
			switch_weapon_texture(new_second_weapon)
			slot_one_active = true
			# Case 4: First weapon was put back (and no second weapon to move)
		elif first_weapon != "" && new_first_weapon == "" && second_weapon == "":
			print("first weapon put back")
			weapon_in_slot1 = ""
			slot_one_active = true
			switch_weapon_texture(GameManager.get_first_weapon())
		first_weapon = new_first_weapon
		second_weapon = new_second_weapon
		#var current_weapon = GameManager.get_first_weapon()
		#if !GameManager.get_weapon_on_back() && !weapon_in_slot2.is_empty():
				#weapon_in_slot1 = weapon_in_slot2
				#weapon_in_slot2 = ""
				#current_weapon = GameManager.get_second_weapon()
				#slot_one_active = false
				#print("first change")
		#elif first_weapon != GameManager.get_first_weapon():
			#print("first changed")
			#weapon_in_slot1 = GameManager.get_first_weapon()
			#first_weapon = GameManager.get_first_weapon()
			#print(!GameManager.get_weapon_on_back())
		#elif second_weapon != GameManager.get_second_weapon():
			#print("second changed")
			#if second_weapon.is_empty():
				#current_weapon = GameManager.get_second_weapon()
				#slot_one_active = false
			#weapon_in_slot2 = GameManager.get_second_weapon()
			#second_weapon = GameManager.get_second_weapon()
		#switch_weapon_texture(current_weapon)
		
func switch_weapon_texture(weapon):
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
	
		if !slot_one_active && weapon2.texture != null:
			weapon2.texture = load(weapon_textures[weapon_index]["idle"])
			slot_one_active = !slot_one_active
		elif !slot_one_active:
			weapon2.texture = load(weapon_textures[weapon_index]["idle"])
		else:
			weapon1.texture = load(weapon_textures[weapon_index]["idle"])
			switch_active_texture()
	else:
		if !slot_one_active:
			weapon2.texture = null
		else:
			weapon1.texture = null

func switch_active_texture():
	if slot_one_active:
		weapon1.z_index = 1
		weapon2.z_index = -1
	else:
		weapon2.z_index = 1
		weapon1.z_index = -1
