extends MarginContainer

@onready var pause_menu = $pauseMenuContainer
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE) || Input.action_press():
		if pause_menu.process_mode == Node.PROCESS_MODE_INHERIT:
			pause_menu.visible = false
			pause_menu.process_mode =  Node.PROCESS_MODE_DISABLED
			get_tree().paused = false
			get_tree().
		else:
			pause_menu.visible = true
			pause_menu.process_mode = Node.PROCESS_MODE_INHERIT
			get_tree().paused = true


func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_continue_pressed() -> void:
	pause_menu.visible = false
	pause_menu.process_mode =  Node.PROCESS_MODE_DISABLED
