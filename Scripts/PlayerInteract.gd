extends RayCast3D

@onready var prompt = $Prompt
@onready var hand = $"../Hand"
@onready var offhand = $"../Hand2"
@onready var back = $"../Back"

@onready var sword = preload("res://Prefabs/Asset Scenes/placeholder_sword2_hand.tscn")
@onready var staff = preload("res://Prefabs/Asset Scenes/placeholder_staff2_hand.tscn")
@onready var bow = preload("res://Prefabs/Asset Scenes/placeholder_bow2_hand.tscn")
@onready var shield = preload("res://Prefabs/Asset Scenes/placeholder_shield_hand.tscn")

var controller_input_device = false
var weapon

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if controller_input_device != true:
			controller_input_device = true
			print("Switched to controller")
	elif event is InputEventKey or event is InputEventMouse:
		if controller_input_device != false:
			controller_input_device = false
			print("Switched to keyboard/mouse")

func _physics_process(delta: float) -> void:
	swapping_weapons()
	
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
								"Placeholder Sword Hand":
									weapon = sword.instantiate()
									hand.add_child(weapon)
								"Placeholder Staff Hand":
									weapon = staff.instantiate()
									hand.add_child(weapon)
								"Placeholder Bow Hand":
									weapon = bow.instantiate()
									hand.add_child(weapon)
								"Placeholder Shield Hand":
									weapon = shield.instantiate()
									hand.add_child(weapon)
							hitObj.interact(owner)
							GameManager.set_weapon_in_hand()
							GameManager.set_first_weapon(weapon_name)
							#print(GameManager.get_first_weapon())
							#print(GameManager.get_weapon_in_hand())
							#print(1)
							
					# Interaction with only main weapon
					elif GameManager.get_weapon_in_hand() == true and GameManager.get_weapon_on_back() == false:
						# Taking a second weapon
						if hitObj.get_empty_socket() == false:
							var weapon_name = hitObj.get_current_weapon_in_socket()
							
							# If you take a sword and your main weapon is a shield, swap sword to main hand and place shield to offhand
							if GameManager.get_first_weapon() == "Placeholder Shield Hand" and weapon_name == "Placeholder Sword Hand":
								weapon = sword.instantiate()
								var shield_to_offhand = hand.get_child(0)
								hand.remove_child(shield_to_offhand)
								hand.add_child(weapon)
								offhand.add_child(shield_to_offhand)
								hitObj.interact(owner)
								GameManager.set_weapon_on_back()
								GameManager.set_second_weapon(GameManager.get_first_weapon())
								GameManager.set_first_weapon(weapon_name)
								#print(GameManager.get_first_weapon())
								#print(GameManager.get_second_weapon())
								#print(GameManager.get_weapon_in_hand())
								#print(GameManager.get_weapon_on_back())
								#print(2)
								
							else:
								# If you take a shield and your main weapon is a sword, place shield to offhand
								if GameManager.get_first_weapon() == "Placeholder Sword Hand" and weapon_name == "Placeholder Shield Hand":
									weapon = shield.instantiate()
									offhand.add_child(weapon)
									
								# Any other combo of weapons leads to putting the second weapon to back
								else:
									match weapon_name:
										"Placeholder Sword Hand":
											weapon = sword.instantiate()
											back.add_child(weapon)
										"Placeholder Staff Hand":
											weapon = staff.instantiate()
											back.add_child(weapon)
										"Placeholder Bow Hand":
											weapon = bow.instantiate()
											back.add_child(weapon)
										"Placeholder Shield Hand":
											weapon = shield.instantiate()
											back.add_child(weapon)
											
								hitObj.interact(owner)
								GameManager.set_weapon_on_back()
								GameManager.set_second_weapon(weapon_name)
								#print(GameManager.get_first_weapon())
								#print(GameManager.get_weapon_in_hand())
								#print(GameManager.get_second_weapon())
								#print(GameManager.get_weapon_on_back())
								#print(3)
								
						# Returning your main weapon if you only have a main weapon
						else:
							var hand_weapon = hand.get_child(0)
							hand_weapon.queue_free()
							hitObj.interact(owner)
							GameManager.set_first_weapon("")
							GameManager.set_weapon_in_hand()
							#print(GameManager.get_first_weapon())
							#print(GameManager.get_weapon_in_hand())
							#print(4)
							
					# Interaction with main weapon and second weapon
					elif GameManager.get_weapon_in_hand() == true and GameManager.get_weapon_on_back() == true:
						var hand_weapon = hand.get_child(0)
						hand_weapon.queue_free()
						
						# Returning main weapon while having second weapon
						if hitObj.get_empty_socket() == true:
							if GameManager.get_second_weapon() == "Placeholder Shield Hand" and GameManager.get_first_weapon() == "Placeholder Sword Hand":
								var offhand_weapon = offhand.get_child(0)
								offhand_weapon.queue_free()
							else:
								var back_weapon = back.get_child(0)
								back_weapon.queue_free()
								
							match GameManager.get_second_weapon():
								"Placeholder Sword Hand":
									weapon = sword.instantiate()
									hand.add_child(weapon)
								"Placeholder Staff Hand":
									weapon = staff.instantiate()
									hand.add_child(weapon)
								"Placeholder Bow Hand":
									weapon = bow.instantiate()
									hand.add_child(weapon)
								"Placeholder Shield Hand":
									weapon = shield.instantiate()
									hand.add_child(weapon)
									
							hitObj.interact(owner)
							#print(GameManager.get_first_weapon())
							#print(GameManager.get_second_weapon())
							GameManager.set_first_weapon(GameManager.get_second_weapon())
							GameManager.set_weapon_on_back()
							GameManager.set_second_weapon("")
							#print(GameManager.get_first_weapon())
							#print(GameManager.get_weapon_in_hand())
							#print(GameManager.get_second_weapon())
							#print(GameManager.get_weapon_on_back())
							#print(5)
							
						# Swapping main weapon with a socket weapon
						elif hitObj.get_empty_socket() == false:
							var weapon_name = hitObj.get_current_weapon_in_socket()
							
							if GameManager.get_second_weapon() == "Placeholder Sword Hand" and weapon_name == "Placeholder Shield Hand":
								var back_weapon = back.get_child(0)
								back.remove_child(back_weapon)
								hand.add_child(back_weapon)
								weapon = shield.instantiate()
								offhand.add_child(weapon)
								hitObj.interact(owner)
								GameManager.set_first_weapon(GameManager.get_second_weapon())
								GameManager.set_second_weapon(weapon_name)
							
							else:
								if GameManager.get_first_weapon() == "Placeholder Sword Hand" and GameManager.get_second_weapon() == "Placeholder Shield Hand":
									var offhand_weapon = offhand.get_child(0)
									offhand.remove_child(offhand_weapon)
									back.add_child(offhand_weapon)
									match weapon_name:
										"Placeholder Staff Hand":
											weapon = staff.instantiate()
											hand.add_child(weapon)
										"Placeholder Bow Hand":
											weapon = bow.instantiate()
											hand.add_child(weapon)
											
								elif GameManager.get_second_weapon() == "Placeholder Shield Hand" and weapon_name == "Placeholder Sword Hand":
									var back_weapon = back.get_child(0)
									back.remove_child(back_weapon)
									offhand.add_child(back_weapon)
									weapon = sword.instantiate()
									hand.add_child(weapon)
									
								else:
									match weapon_name:
										"Placeholder Sword Hand":
											weapon = sword.instantiate()
											hand.add_child(weapon)
										"Placeholder Staff Hand":
											weapon = staff.instantiate()
											hand.add_child(weapon)
										"Placeholder Bow Hand":
											weapon = bow.instantiate()
											hand.add_child(weapon)
										"Placeholder Shield Hand":
											weapon = shield.instantiate()
											hand.add_child(weapon)
											
								hitObj.interact(owner)
								GameManager.set_first_weapon(weapon_name)
								#print(GameManager.get_first_weapon())
								#print(GameManager.get_weapon_in_hand())
								#print(GameManager.get_second_weapon())
								#print(GameManager.get_weapon_on_back())
								#print(6)
				else:
					hitObj.interact(owner)

func swapping_weapons():
	if Input.is_action_just_pressed("weapon_swap"):
		if GameManager.get_weapon_in_hand() == true and GameManager.get_weapon_on_back() == true:
			if GameManager.get_first_weapon() == "Placeholder Sword Hand" and GameManager.get_second_weapon() == "Placeholder Shield Hand":
				pass
			else:
				var first_weapon = hand.get_child(0)
				var second_weapon = back.get_child(0)
				hand.remove_child(first_weapon)
				back.remove_child(second_weapon)
				hand.add_child(second_weapon)
				back.add_child(first_weapon)
				var first_weapon_game_manager = GameManager.get_first_weapon()
				var second_weapon_game_manager = GameManager.get_second_weapon()
				GameManager.set_first_weapon(second_weapon_game_manager)
				GameManager.set_second_weapon(first_weapon_game_manager)
