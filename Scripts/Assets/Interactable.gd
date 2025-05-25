extends CollisionObject3D
class_name Interactable

signal interacted(body)

@export var prompt_message = tr("KEY_INTERACT")
@export var prompt_input = "interact"

func get_prompt(controller_input_device):
	var key_name = ""
	for action in InputMap.action_get_events(prompt_input):
		if controller_input_device == false:
			if action is InputEventKey:
				key_name = action.as_text_physical_keycode()
				break
		elif controller_input_device == true:
			UiManager.get_controller_type()
			if action is InputEventJoypadButton:
				key_name = UiManager.get_controller_input_key(action, true)
	return prompt_message + "\n[" + key_name + "]"
	
func interact(body):
	interacted.emit(body)
