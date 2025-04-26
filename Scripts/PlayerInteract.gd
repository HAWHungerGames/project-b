extends RayCast3D

@onready var prompt = $Prompt
@onready var hand = $"../Hand"

@onready var sword = preload("res://Scenes/Asset Scenes/placeholder_sword2_hand.tscn")
@onready var staff = preload("res://Scenes/Asset Scenes/placeholder_staff2_hand.tscn")
@onready var bow = preload("res://Scenes/Asset Scenes/placeholder_bow2_hand.tscn")

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
							hitObj.interact(owner)
							GameManager.set_weapon_in_hand()
							GameManager.set_current_weapon(weapon_name)
							print(GameManager.get_current_weapon())
							print(GameManager.get_weapon_in_hand())
							print(1)
							
					elif GameManager.get_weapon_in_hand() == true:
						var hand_weapon = hand.get_child(0)
						hand_weapon.queue_free()
						# Returning a Weapon
						if hitObj.get_empty_socket() == true:
							hitObj.interact(owner)
							GameManager.set_current_weapon("")
							GameManager.set_weapon_in_hand()
							print(GameManager.get_current_weapon())
							print(GameManager.get_weapon_in_hand())
							print(2)
							
						# Swapping a Weapon
						elif hitObj.get_empty_socket() == false:
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
							hitObj.interact(owner)
							GameManager.set_current_weapon(weapon_name)
							print(GameManager.get_current_weapon())
							print(GameManager.get_weapon_in_hand())
							print(3)
				else:
					hitObj.interact(owner)
