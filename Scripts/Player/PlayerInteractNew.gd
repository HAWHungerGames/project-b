extends RayCast3D

@onready var prompt = $Prompt
@onready var hand = $"../Player/Armature/Skeleton3D/RightWeaponHand"
@onready var offhand = $"../Player/Armature/Skeleton3D/LeftWeaponHand"
@onready var back = $"../Player/Armature/Skeleton3D/BackWeapon"


# Placeholders
#@onready var sword = preload("res://Prefabs/Asset Scenes/Placeholders/placeholder_sword2_hand.tscn")
#@onready var staff = preload("res://Prefabs/Asset Scenes/Placeholders/placeholder_staff2_hand.tscn")
#@onready var bow = preload("res://Prefabs/Asset Scenes/Placeholders/placeholder_bow2_hand.tscn")
#@onready var shield = preload("res://Prefabs/Asset Scenes/Placeholders/placeholder_shield_hand.tscn")

#var sword_name = "Placeholder Sword Hand"
#var shield_name = "Placeholder Shield Hand"

# Models
#@onready var sword = preload("res://Prefabs/Asset Scenes/Weapons/sword.tscn")
#@onready var shield = preload("res://Prefabs/Asset Scenes/Weapons/shield.tscn")
#@onready var staff = preload("res://Prefabs/Asset Scenes/Weapons/staff.tscn")
#@onready var bow = preload("res://Prefabs/Asset Scenes/Weapons/bow.tscn")

# ------- Main Hand -------
@onready var sword_main = $"../Player/Armature/Skeleton3D/RightWeaponHand/Sword"
@onready var shield_main = $"../Player/Armature/Skeleton3D/RightWeaponHand/Shield"
@onready var bow_main = $"../Player/Armature/Skeleton3D/RightWeaponHand/Bow"
@onready var staff_main = $"../Player/Armature/Skeleton3D/RightWeaponHand/Staff"

# ------- Offhand -------
@onready var shield_offhand = $"../Player/Armature/Skeleton3D/LeftWeaponHand/Shield"
@onready var bow_offhand = $"../Player/Armature/Skeleton3D/LeftWeaponHand/Bow"

# ------- Back -------
@onready var sword_back = $"../Player/Armature/Skeleton3D/BackWeapon/Sword"
@onready var shield_back = $"../Player/Armature/Skeleton3D/BackWeapon/Shield"
@onready var bow_back = $"../Player/Armature/Skeleton3D/BackWeapon/Bow"
@onready var staff_back = $"../Player/Armature/Skeleton3D/BackWeapon/Staff"

var sword_name = "Sword"
var shield_name = "Shield"
var staff_name = "Staff"
var bow_name = "Bow"


# ------- Main Hand -------
var sword_idle_position = Vector3(0.95, 0.26, 0.9)
var sword_idle_rotation = Vector3(-11.5, -33, -111)
var sword_idle_scale = Vector3(5, 5, 5)

var bow_idle_position = Vector3(0.11, 0.46, 0.22)
var bow_idle_rotation = Vector3(4, 52, -66.5)
var bow_idle_scale = Vector3(2, 2, 2)

var staff_idle_position = Vector3(1.5, 0.37, 1.27)
var staff_idle_rotation = Vector3(47, -49.5, -111)
var staff_idle_scale = Vector3(4, 4, 4)

var shield_idle_position = Vector3(0.5, 0.24, 0.1)
var shield_idle_rotation = Vector3(-5, -41, -106)
var shield_idle_scale = Vector3(4, 4, 4)

# ------- Offhand -------
var shield_idle_position_offhand = Vector3(-0.5, 0.24, 0.1)
var shield_idle_rotation_offhand = Vector3(5, 41, 106)
var shield_idle_scale_offhand = Vector3(4, 4, 4)

# ------- Back -------
var sword_idle_position_back = Vector3(-1.24, 0.84, -1.67)
var sword_idle_rotation_back = Vector3(-19, -1, -129)
var sword_idle_scale_back = Vector3(5, 5, 5)

var bow_idle_position_back = Vector3(0, -0.07, -1.12)
var bow_idle_rotation_back = Vector3(46, 75, 67)
var bow_idle_scale_back = Vector3(2, 2, 2)

var staff_idle_position_back = Vector3(-0.06, 0.12, -1.72)
var staff_idle_rotation_back = Vector3(-19, -1, 48)
var staff_idle_scale_back = Vector3(4, 4, 4)

var shield_idle_position_back = Vector3(0.04, -0.07, -1.35)
var shield_idle_rotation_back = Vector3(-19, -0.2, 28)
var shield_idle_scale_back = Vector3(4, 4, 4)



var controller_input_device = false
var weapon

func _ready() -> void:
	change_transform_of_weapon_main_hand(sword_main, sword_idle_position, sword_idle_rotation, sword_idle_scale)
	change_transform_of_weapon_main_hand(shield_main, shield_idle_position, shield_idle_rotation, shield_idle_scale)
	change_transform_of_weapon_main_hand(staff_main, staff_idle_position, staff_idle_rotation, staff_idle_scale)
	change_transform_of_weapon_main_hand(bow_main, bow_idle_position, bow_idle_rotation, bow_idle_scale)
	
	change_transform_of_weapon_back(sword_back, sword_idle_position_back, sword_idle_rotation_back, sword_idle_scale_back)
	change_transform_of_weapon_back(staff_back, staff_idle_position_back, staff_idle_rotation_back, staff_idle_scale_back)
	change_transform_of_weapon_back(bow_back, bow_idle_position_back, bow_idle_rotation_back, bow_idle_scale_back)
	change_transform_of_weapon_back(shield_back, shield_idle_position_back, shield_idle_rotation_back, shield_idle_scale_back)
	
	change_transform_of_weapon_off_hand(shield_offhand, shield_idle_position_offhand, shield_idle_rotation_offhand, shield_idle_scale_offhand)
	# bow off as well later <-----------------------------------------------------

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if controller_input_device != true:
			controller_input_device = true
			print("Switched to controller")
	elif event is InputEventKey or event is InputEventMouse:
		if controller_input_device != false:
			controller_input_device = false
			print("Switched to keyboard/mouse")

func playholder():
	change_transform_of_weapon_main_hand(0, sword_idle_position, sword_idle_rotation, sword_idle_scale)
	change_transform_of_weapon_main_hand(0, shield_idle_position, shield_idle_rotation, shield_idle_scale)
	change_transform_of_weapon_main_hand(0, staff_idle_position, staff_idle_rotation, staff_idle_scale)
	change_transform_of_weapon_main_hand(0, bow_idle_position, bow_idle_rotation, bow_idle_scale)
	
	change_transform_of_weapon_back(0, sword_idle_position_back, sword_idle_rotation_back, sword_idle_scale_back)
	change_transform_of_weapon_back(0, staff_idle_position_back, staff_idle_rotation_back, staff_idle_scale_back)
	change_transform_of_weapon_back(0, bow_idle_position_back, bow_idle_rotation_back, bow_idle_scale_back)
	change_transform_of_weapon_back(0, shield_idle_position_back, shield_idle_rotation_back, shield_idle_scale_back)
	
	change_transform_of_weapon_off_hand(0, shield_idle_position_offhand, shield_idle_rotation_offhand, shield_idle_scale_offhand)
	
	print("---hallo---")
	print(hand.get_child(0))
	print("---bye---")
	
	pass


func _physics_process(delta: float) -> void:
	swapping_weapons()
	interacting_with_world()
	

func swapping_weapons():
	if Input.is_action_just_pressed("weapon_swap") and !GameManager.get_is_attacking():
		if GameManager.get_weapon_in_hand() == true and GameManager.get_weapon_on_back() == true:
			if GameManager.get_first_weapon() == sword_name and GameManager.get_second_weapon() == shield_name:
				pass
			else:
				match GameManager.get_second_weapon():
					sword_name:
						sword_main.visible = true
						sword_back.visible = false
					staff_name:
						staff_main.visible = true
						staff_back.visible = false
					bow_name:
						bow_main.visible = true
						bow_back.visible = false
					shield_name:
						shield_main.visible = true
						shield_back.visible = false
						
				match GameManager.get_first_weapon():
					sword_name:
						sword_back.visible = true
						sword_main.visible = false
					staff_name:
						staff_back.visible = true
						staff_main.visible = false
					bow_name:
						bow_back.visible = true
						bow_main.visible = false
					shield_name:
						shield_back.visible = true
						shield_main.visible = false
				var first_weapon_game_manager = GameManager.get_first_weapon()
				var second_weapon_game_manager = GameManager.get_second_weapon()
				GameManager.set_first_weapon(second_weapon_game_manager)
				GameManager.set_second_weapon(first_weapon_game_manager)
				GameManager.weapons_updated()


func change_transform_of_weapon_main_hand(child_node, new_position, new_rotation, new_scale):
	child_node.position = new_position
	child_node.rotation_degrees = new_rotation
	child_node.scale = new_scale

func change_transform_of_weapon_off_hand(child_node, new_position, new_rotation, new_scale):
	child_node.position = new_position
	child_node.rotation_degrees = new_rotation
	child_node.scale = new_scale

func change_transform_of_weapon_back(child_node, new_position, new_rotation, new_scale):
	child_node.position = new_position
	child_node.rotation_degrees = new_rotation
	child_node.scale = new_scale

func interacting_with_world():
	prompt.text = ""
	
	if is_colliding():
		var hitObj = get_collider()
		
		if hitObj is Interactable:
			
			if hitObj is Socket and hitObj.get_empty_socket() == true and GameManager.get_weapon_in_hand() == false:
				pass
			else:
				prompt.text = hitObj.get_prompt(controller_input_device)
			
			if Input.is_action_just_pressed(hitObj.prompt_input):
				
				if hitObj is Socket:
					# Taking a Weapon
					if GameManager.get_weapon_in_hand() == false:
						if hitObj.get_empty_socket() == false:
							var weapon_name = hitObj.get_current_weapon_in_socket()
							match weapon_name:
								sword_name:
									sword_main.visible = true
								staff_name:
									staff_main.visible = true
								bow_name:
									bow_main.visible = true
								shield_name:
									shield_main.visible = true
							hitObj.interact(owner)
							GameManager.set_weapon_in_hand()
							GameManager.set_first_weapon(weapon_name)
							GameManager.weapons_updated()
							#print(GameManager.get_first_weapon())
							#print(GameManager.get_weapon_in_hand())
							#print(1)
							
					# Interaction with only main weapon
					elif GameManager.get_weapon_in_hand() == true and GameManager.get_weapon_on_back() == false:
						# Taking a second weapon
						if hitObj.get_empty_socket() == false:
							var weapon_name = hitObj.get_current_weapon_in_socket()
							
							# If you take a sword and your main weapon is a shield, swap sword to main hand and place shield to offhand
							if GameManager.get_first_weapon() == shield_name and weapon_name == sword_name:
								#weapon = sword.instantiate()
								shield_main.visible = false
								shield_offhand.visible = true
								sword_main.visible = true
								hitObj.interact(owner)
								GameManager.set_weapon_on_back()
								GameManager.set_second_weapon(GameManager.get_first_weapon())
								GameManager.weapons_updated()
								GameManager.set_first_weapon(weapon_name)
								GameManager.weapons_updated()
								#print(GameManager.get_first_weapon())
								#print(GameManager.get_second_weapon())
								#print(GameManager.get_weapon_in_hand())
								#print(GameManager.get_weapon_on_back())
								#print(2)
								
							else:
								# If you take a shield and your main weapon is a sword, place shield to offhand
								if GameManager.get_first_weapon() == sword_name and weapon_name == shield_name:
									shield_offhand.visible = true
								# Any other combo of weapons leads to putting the second weapon to back
								else:
									match weapon_name:
										sword_name:
											sword_back.visible = true
										staff_name:
											staff_back.visible = true
										bow_name:
											bow_back.visible = true
										shield_name:
											shield_back.visible = true
											
								hitObj.interact(owner)
								GameManager.set_weapon_on_back()
								GameManager.set_second_weapon(weapon_name)
								GameManager.weapons_updated()
								#print(GameManager.get_first_weapon())
								#print(GameManager.get_weapon_in_hand())
								#print(GameManager.get_second_weapon())
								#print(GameManager.get_weapon_on_back())
								#print(3)
								
						# Returning your main weapon if you only have a main weapon
						else:
							match GameManager.get_first_weapon():
								sword_name:
									sword_main.visible = false
								staff_name:
									staff_main.visible = false
								bow_name:
									bow_main.visible = false
								shield_name:
									shield_main.visible = false
							hitObj.interact(owner)
							GameManager.set_first_weapon("")
							GameManager.set_weapon_in_hand()
							GameManager.weapons_updated()
							#print(GameManager.get_first_weapon())
							#print(GameManager.get_weapon_in_hand())
							#print(4)
							
					# Interaction with main weapon and second weapon
					elif GameManager.get_weapon_in_hand() == true and GameManager.get_weapon_on_back() == true:
						match GameManager.get_first_weapon():
							sword_name:
								sword_main.visible = false
							staff_name:
								staff_main.visible = false
							bow_name:
								bow_main.visible = false
							shield_name:
								shield_main.visible = false
						# Returning main weapon while having second weapon
						if hitObj.get_empty_socket() == true:
							if GameManager.get_second_weapon() == shield_name and GameManager.get_first_weapon() == sword_name:
								shield_offhand.visible = false
							else:
								match GameManager.get_second_weapon():
									sword_name:
										sword_back.visible = false
									staff_name:
										staff_back.visible = false
									bow_name:
										bow_back.visible = false
									shield_name:
										shield_back.visible = false
								
							match GameManager.get_second_weapon():
								sword_name:
									sword_main.visible = true
								staff_name:
									staff_main.visible = true
								bow_name:
									bow_main.visible = true
								shield_name:
									shield_main.visible = true
									
							hitObj.interact(owner)
							#print(GameManager.get_first_weapon())
							#print(GameManager.get_second_weapon())
							GameManager.set_first_weapon(GameManager.get_second_weapon())
							GameManager.set_second_weapon("")
							GameManager.set_weapon_on_back()
							GameManager.weapons_updated()
							#print(GameManager.get_first_weapon())
							#print(GameManager.get_weapon_in_hand())
							#print(GameManager.get_second_weapon())
							#print(GameManager.get_weapon_on_back())

						# Swapping main weapon with a socket weapon
						elif hitObj.get_empty_socket() == false:
							var weapon_name = hitObj.get_current_weapon_in_socket()
							
							if GameManager.get_second_weapon() == sword_name and weapon_name == shield_name:
								shield_offhand.visible = true
								sword_back.visible = false
								sword_main.visible = true
								
								GameManager.set_first_weapon(GameManager.get_second_weapon())
								GameManager.set_second_weapon(weapon_name)
								GameManager.weapons_updated()
							
							else:
								if GameManager.get_first_weapon() == sword_name and GameManager.get_second_weapon() == shield_name:
									shield_offhand.visible = false
									shield_back.visible = true
									
									match weapon_name:
										staff_name:
											staff_main.visible = true
										bow_name:
											bow_main.visible = true
											
								elif GameManager.get_second_weapon() == shield_name and weapon_name == sword_name:
									shield_offhand.visible = true
									shield_back.visible = false
									sword_main.visible = true
									
								else:
									match weapon_name:
										sword_name:
											sword_main.visible = true
										staff_name:
											staff_main.visible = true
										bow_name:
											bow_main.visible = true
										shield_name:
											shield_main.visible = true
											
								hitObj.interact(owner)
								GameManager.set_first_weapon(weapon_name)
								GameManager.weapons_updated()
								#print(GameManager.get_first_weapon())
								#print(GameManager.get_weapon_in_hand())
								#print(GameManager.get_second_weapon())
								#print(GameManager.get_weapon_on_back())
								#print(6)
				else:
					hitObj.interact(owner)
