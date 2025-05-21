extends MarginContainer

@onready var pause_menu = $pauseMenuContainer

@onready var buttonSelectRightStart = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsResume/buttonSelectRight
@onready var buttonSelectLeftStart = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsResume/buttonSelectLeft
@onready var buttonSelectRightOptions = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsOptions/buttonSelectRight
@onready var buttonSelectLeftOptions = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsOptions/buttonSelectLeft
@onready var buttonSelectRightExit = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsExit/buttonSelectRight
@onready var buttonSelectLeftExit = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsExit/buttonSelectLeft
@onready var blendScreen = $"../ColorRect"


func _input(event):
	if event.is_action_pressed("pause"):
		print("pause")
		if pause_menu.process_mode == Node.PROCESS_MODE_ALWAYS:
			unpause()
		else:
			pause()


func _on_exit_pressed() -> void:
	SceneManager.main_scene.emit()
	var tween = create_tween()
	tween.tween_property(blendScreen, "modulate:a", 1.0, 1.0)
	tween.play()
	pause_menu.z_index = 0
	await get_tree().create_timer(2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_resume_pressed() -> void:
	unpause()

func fadeSceneIn():
	var tween = create_tween()
	tween.tween_property(blendScreen, "modulate:a", 0.4, 0.1)
	tween.play()
	
func fadeSceneOut():
	var tween = create_tween()
	tween.tween_property(blendScreen, "modulate:a", 0.0, 0.1)
	tween.play()
	process_mode = Node.PROCESS_MODE_INHERIT
	
func unpause():
	fadeSceneOut()
	pause_menu.visible = false
	pause_menu.z_index = 0
	pause_menu.process_mode =  Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	
func pause():
	fadeSceneIn()
	pause_menu.visible = true
	pause_menu.z_index = 3
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	
func _on_resume_hover_enter() -> void:
	buttonSelectLeftStart.modulate.a = 1.0
	buttonSelectRightStart.modulate.a = 1.0


func _on_resume_hover_exit() -> void:
	buttonSelectLeftStart.modulate.a = 0.0
	buttonSelectRightStart.modulate.a = 0.0


func _on_options_hover_enter() -> void:
	buttonSelectLeftOptions.modulate.a = 1.0
	buttonSelectRightOptions.modulate.a = 1.0


func _on_options_hover_exit() -> void:
	buttonSelectLeftOptions.modulate.a = 0.0
	buttonSelectRightOptions.modulate.a = 0.0


func _on_exit_hover_enter() -> void:
	buttonSelectLeftExit.modulate.a = 1.0
	buttonSelectRightExit.modulate.a = 1.0


func _on_exit_hover_exit() -> void:
	buttonSelectLeftExit.modulate.a = 0.0
	buttonSelectRightExit.modulate.a = 0.0
