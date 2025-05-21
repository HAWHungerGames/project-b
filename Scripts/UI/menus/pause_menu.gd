extends MarginContainer

@onready var pause_menu = $pauseMenuContainer

func _input(event):
	if Input.is_action_just_pressed("pause"):
		if pause_menu.process_mode == Node.PROCESS_MODE_INHERIT:
			unpause()
		else:
			pause()


func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_continue_pressed() -> void:
	unpause()

func unpause():
	pause_menu.visible = false
	pause_menu.process_mode =  Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	
func pause():
	pause_menu.visible = true
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
