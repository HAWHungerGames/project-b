extends MarginContainer

@onready var pause_menu = $pauseMenuContainer
@onready var options_menu = $Options
@onready var controls_menu = $Controls
@onready var display_menu = $Display

@onready var buttonSelectRightResume = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsResume/buttonSelectRightResume
@onready var buttonSelectLeftResume = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsResume/buttonSelectLeftResume
@onready var buttonSelectRightOptions = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsOptions/buttonSelectRightOptions
@onready var buttonSelectLeftOptions = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsOptions/buttonSelectLeftOptions
@onready var buttonSelectRightExit = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsExit/buttonSelectRightExit
@onready var buttonSelectLeftExit = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsExit/buttonSelectLeftExit
@onready var blendScreen = $"../../blendScreen"

@onready var buttonsDisplay = $Options/optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsDisplay
@onready var buttonsControls = $Options/optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsControls
@onready var buttonsBack = $Options/optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsBack

@onready var resume = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsResume/resume
@onready var options = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsOptions/options
@onready var exit = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsExit/exit

func _input(event):
	if event.is_action_pressed("pause"):
		print("pause")
		if pause_menu.visible:
			unpause()
		elif options_menu.visible:
			_on_back_pressed()
		elif controls_menu.visible:
			_on_back_controls_pressed()
		else:
			pause()


func _on_exit_pressed() -> void:
	SceneManager.main_scene.emit()
	pause_menu.z_index = 0
	var tween = create_tween()
	tween.tween_property(blendScreen, "modulate:a", 1.0, 1.0)
	tween.play()
	await get_tree().create_timer(2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Prefabs/Asset Scenes/UI/TitleScreen.tscn")
	
func _on_resume_pressed() -> void:
	unpause()

func _on_options_pressed() -> void:
	pause_menu.visible = false
	options_menu.visible = true
	
func fadeSceneIn():
	var tween = create_tween()
	tween.tween_property(blendScreen, "modulate:a", 0.6, 0.1)
	tween.play()
	var resume_mouse_pos = resume.get_local_mouse_position()
	var options_mouse_pos = options.get_local_mouse_position()
	var exit_mouse_pos = exit.get_local_mouse_position()
	print(resume_mouse_pos)
	print(options_mouse_pos)
	print(exit_mouse_pos)
	print(resume.size)
	print(options.size)
	print(exit.size)
	if (0 <= resume_mouse_pos.x && resume_mouse_pos.x <= resume.size.x) && (0 <= resume_mouse_pos.y && resume_mouse_pos.y <= resume.size.y):
		print("resume")
		_on_resume_hover_enter()
	elif (0 <= options_mouse_pos.y && options_mouse_pos.y <= options.size.y) && (0 <= options_mouse_pos.y && options_mouse_pos.y <= options.size.y):
		_on_options_hover_enter()
	elif (0 <= exit_mouse_pos.x && exit_mouse_pos.x <= exit.size.x) && (0 <= exit_mouse_pos.y && exit_mouse_pos.y <= exit.size.y):
		_on_exit_hover_enter()
	else:
		_on_resume_hover_exit()
		_on_options_hover_exit()
		_on_exit_hover_exit()

func fadeSceneOut():
	var tween = create_tween()
	tween.tween_property(blendScreen, "modulate:a", 0.0, 0.1)
	tween.play()

func unpause():
	fadeSceneOut()
	pause_menu.visible = false
	pause_menu.z_index = 0
	get_tree().paused = false

func pause():
	fadeSceneIn()
	pause_menu.visible = true
	pause_menu.z_index = 3
	get_tree().paused = true

func _on_resume_hover_enter() -> void:
	buttonSelectLeftResume.modulate.a = 1.0
	buttonSelectRightResume.modulate.a = 1.0

func _on_resume_hover_exit() -> void:
	buttonSelectLeftResume.modulate.a = 0.0
	buttonSelectRightResume.modulate.a = 0.0

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

func _on_back_pressed() -> void:
	options_menu.visible = false
	pause_menu.visible = true

func _on_controls_pressed() -> void:
	options_menu.visible = false
	controls_menu.visible = true

func _on_back_controls_pressed() -> void:
	options_menu.visible = true
	controls_menu.visible = false

func _on_display_pressed() -> void:
	options_menu.visible = false
	display_menu.visible = true

func _on_display_back_pressed() -> void:
	options_menu.visible = true
	display_menu.visible = false
