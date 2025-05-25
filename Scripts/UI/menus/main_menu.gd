extends Control

@onready var color_rect = $main_menu/ColorRect
@onready var vbox = $main_menu/MarginContainer/VBoxContainer
@onready var background = $main_menu/titleBackground

@onready var main_menu = $main_menu/MarginContainer
@onready var options_menu = $Options
@onready var controls_menu = $Controls
@onready var display_menu = $Display

@onready var timer = $AspectRatioContainer/VideoStreamPlayer/Timer
#@onready var buttonSelectRightStart = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/buttonSelectRight
@onready var buttonsStart = $main_menu/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/buttonsStart
@onready var buttonsOptions = $main_menu/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/buttonsOptions
#@onready var buttonSelectLeftOptions = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer3/buttonSelectLeft
@onready var buttonsExit = $main_menu/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/buttonsExit
#@onready var buttonSelectLeftExit = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/buttonSelectLeft

@onready var buttonsDisplay = $Options/optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsDisplay
@onready var buttonsControls = $Options/optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsControls
@onready var buttonsBack = $Options/optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsBack

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

func _ready():
	SceneManager.main_scene.connect(fadeSceneIn)
	fadeSceneIn()
	connect_button_signals()

func connect_button_signals() -> void:
	display.pressed.connect(_on_display_pressed)
	controls.pressed.connect(_on_controls_pressed)
	back.pressed.connect(_on_back_pressed)
	display_back.pressed.connect(_on_display_back_pressed)
	controls_back.pressed.connect(_on_controls_back_pressed)
	
func _on_button_pressed() -> void:
	fadeSceneOut()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/Konrad Work Scene.tscn")
	SceneManager.game_scene.emit()

func _on_options_pressed() -> void:
	main_menu.visible = false
	options_menu.visible = true
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.6, 0.1)
	display.grab_focus()
	
func _on_button_3_pressed() -> void:
	fadeSceneOut()
	await get_tree().create_timer(2).timeout
	get_tree().quit()

func fadeSceneIn():
	print("scene")
	timer.start()
	print("timer")
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0, 4.0)
	tween.play()
	
func fadeSceneOut():
	color_rect.process_mode = Node.PROCESS_MODE_INHERIT
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(vbox, "modulate:a", 0.0, 1.0)
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)
	tween.play()
	
func fadeIn():
	# Start with the container invisible
	# Create a tween
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(vbox, "modulate:a", 1.0, 1.0)
	print("out?")
	tween.tween_property(background, "modulate:a", 1.0, 1.0)
	tween.play()
	color_rect.process_mode = Node.PROCESS_MODE_DISABLED

func _on_timer_timeout() -> void:
	fadeIn()

func _on_start_hover_enter() -> void:
	toggle_button_selects(buttonsStart, true)

func _on_start_hover_exit() -> void:
	toggle_button_selects(buttonsStart, false)

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
	main_menu.visible = true
	buttonsStart.get_child(1).grab_focus()
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 0.1)

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
	display_back.grab_focus()

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
