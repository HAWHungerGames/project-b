extends MarginContainer

@onready var pause_menu = $pauseMenuContainer
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE) || Input.is_joy_button_pressed(1, JOY_BUTTON_START):
		if pause_menu.process_mode == Node.PROCESS_MODE_INHERIT:
			pause_menu.visible = false
			pause_menu.process_mode =  Node.PROCESS_MODE_DISABLED
		else:
			pause_menu.visible = true
			pause_menu.process_mode = Node.PROCESS_MODE_INHERIT


func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_continue_pressed() -> void:
	pause_menu.visible = false
	pause_menu.process_mode =  Node.PROCESS_MODE_DISABLED
