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
@onready var blendScreen = $blendScreen

@onready var buttonsDisplay = $Options/optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsDisplay
@onready var buttonsControls = $Options/optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsControls
@onready var buttonsBack = $Options/optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsBack

@onready var buttonsResume = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsResume
@onready var buttonsOptions = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsOptions
@onready var buttonsExit = $pauseMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsExit

@onready var display = buttonsDisplay.get_child(1)
@onready var controls = buttonsControls.get_child(1)
@onready var back = buttonsBack.get_child(1)
@onready var display_back = display_menu.find_child("buttonsBack").get_child(1)
#@onready var display_res = display_menu.find_child("back")
#@onready var display_mode = display_menu.find_child("back")
#@onready var display_lang = display_menu.find_child("back")
@onready var controls_back = controls_menu.find_child("buttonsBack").get_child(1)
@onready var controls_left = controls_menu.find_child("buttonLeft")
@onready var controls_right = controls_menu.find_child("buttonRight")

func _ready() -> void:
	connect_button_signals()

func _input(event) -> void:
	if event.is_action_pressed("pause"):
		print("pause")
		if pause_menu.visible:
			unpause()
		elif options_menu.visible:
			_on_back_pressed()
		elif controls_menu.visible:
			_on_controls_back_pressed()
		elif display_menu.visible:
			_on_display_back_pressed()
		else:
			pause()
	
func connect_button_signals() -> void:
	display.pressed.connect(_on_display_pressed)
	controls.pressed.connect(_on_controls_pressed)
	back.pressed.connect(_on_back_pressed)
	display_back.pressed.connect(_on_display_back_pressed)
	controls_back.pressed.connect(_on_controls_back_pressed)

func _on_exit_pressed() -> void:
	SceneManager.main_scene.emit()
	blendScreen.z_index = 2
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
	display.grab_focus()
	
func fadeSceneIn():
	var tween = create_tween()
	tween.tween_property(blendScreen, "modulate:a", 0.6, 0.1)
	tween.play()
	# future changes -> be generic
	#var resume = buttonsResume.get_child(1)
	#var options = buttonsOptions.get_child(1)
	#var exit = buttonsExit.get_child(1)
	#var resume_mouse_pos = resume.get_local_mouse_position()
	#var options_mouse_pos = options.get_local_mouse_position()
	#var exit_mouse_pos = exit.get_local_mouse_position()
	#
	#if (0 <= resume_mouse_pos.x && resume_mouse_pos.x <= resume.size.x) && (0 <= resume_mouse_pos.y && resume_mouse_pos.y <= resume.size.y):
		#print("resume")
		#_on_resume_hover_enter()
	#elif (0 <= options_mouse_pos.y && options_mouse_pos.y <= options.size.y) && (0 <= options_mouse_pos.y && options_mouse_pos.y <= options.size.y):
		#_on_options_hover_enter()
	#elif (0 <= exit_mouse_pos.x && exit_mouse_pos.x <= exit.size.x) && (0 <= exit_mouse_pos.y && exit_mouse_pos.y <= exit.size.y):
		#_on_exit_hover_enter()
	#else:
		#_on_resume_hover_exit()
		#_on_options_hover_exit()
		#_on_exit_hover_exit()

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
	buttonsResume.get_child(1).grab_focus()

func _on_resume_hover_enter() -> void:
	toggle_button_selects(buttonsResume, true)

func _on_resume_hover_exit() -> void:
	toggle_button_selects(buttonsResume, false)

func _on_options_hover_enter() -> void:
	toggle_button_selects(buttonsOptions, true)

func _on_options_hover_exit() -> void:
	toggle_button_selects(buttonsOptions, false)

func _on_exit_hover_enter() -> void:
	toggle_button_selects(buttonsExit, true)

func _on_exit_hover_exit() -> void:
	toggle_button_selects(buttonsExit, false)

func _on_back_pressed() -> void:
	options_menu.visible = false
	pause_menu.visible = true
	buttonsResume.get_child(1).grab_focus()

func _on_controls_pressed() -> void:
	options_menu.visible = false
	controls_menu.visible = true
	controls.grab_focus()
	controls_menu.update_controller_controls()

func _on_controls_back_pressed() -> void:
	options_menu.visible = true
	controls_menu.visible = false
	display.grab_focus()

func _on_display_pressed() -> void:
	options_menu.visible = false
	display_menu.visible = true

func _on_display_back_pressed() -> void:
	options_menu.visible = true
	display_menu.visible = false
	display.grab_focus()

func toggle_button_selects(buttons, selected) -> void:
	var left_select = buttons.get_child(0)
	var right_select = buttons.get_child(2)
	var button = buttons.get_child(1)
	if selected:
		button.grab_focus()
		left_select.modulate.a = 1.0
		right_select.modulate.a = 1.0
	else:
		left_select.modulate.a = 0.0
		right_select.modulate.a = 0.0
