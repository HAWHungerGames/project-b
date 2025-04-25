extends RayCast3D

@onready var prompt = $Prompt
@onready var hand = $"../Hand"

@onready var sword = preload("res://Scenes/Asset Scenes/placeholder_sword2_hand.tscn")
@onready var staff = preload("res://Scenes/Asset Scenes/placeholder_staff2_hand.tscn")

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
			prompt.text = hitObj.get_prompt(controller_input_device)
			
			if Input.is_action_just_pressed(hitObj.prompt_input):
				if hitObj is Weapons and GameManager.get_weapon_in_hand() == false:
					print(GameManager.get_weapon_in_hand())
					if hitObj.get_name() == "Placeholder Sword":
						weapon = sword.instantiate()
						hand.add_child(weapon)
						
					elif hitObj.get_name() == "Placeholder Staff":
						weapon = staff.instantiate()
						hand.add_child(weapon)
						
					hitObj.interact(owner)
					GameManager.set_weapon_in_hand()
					print(GameManager.get_weapon_in_hand())
					
				elif hitObj is Weapons and GameManager.get_weapon_in_hand() == true:
					if hitObj.get_name() == "Placeholder Sword":
						hand.remove_child(weapon)
						weapon = sword.instantiate()
						hand.add_child(weapon)
						
					elif hitObj.get_name() == "Placeholder Staff":
						hand.remove_child(weapon)
						weapon = staff.instantiate()
						hand.add_child(weapon)
						
					hitObj.interact(owner)

				elif hitObj is not Weapons:
					hitObj.interact(owner)
				
