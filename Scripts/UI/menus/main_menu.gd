extends Control

@onready var color_rect = $MarginContainer/ColorRect
@onready var vbox = $MarginContainer/MarginContainer/VBoxContainer
@onready var background = $MarginContainer/titleBackground

@onready var timer = $AspectRatioContainer/VideoStreamPlayer/Timer
@onready var buttonSelectRightStart = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/buttonSelectRight
@onready var buttonSelectLeftStart = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/buttonSelectLeft
@onready var buttonSelectRightOptions = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer3/buttonSelectRight
@onready var buttonSelectLeftOptions = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer3/buttonSelectLeft
@onready var buttonSelectRightExit = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/buttonSelectRight
@onready var buttonSelectLeftExit = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/buttonSelectLeft

func _ready():
	SceneManager.main_scene.connect(fadeSceneIn)
	fadeSceneIn()

func _on_button_pressed() -> void:
	fadeSceneOut()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/Konrad Work Scene.tscn")

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

func _on_hover_start_enter() -> void:
	buttonSelectLeftStart.modulate.a = 1.0
	buttonSelectRightStart.modulate.a = 1.0

func _on_hover_start_exit() -> void:
	buttonSelectLeftStart.modulate.a = 0.0
	buttonSelectRightStart.modulate.a = 0.0

func _on_hover_options_enter() -> void:
	buttonSelectLeftOptions.modulate.a = 1.0
	buttonSelectRightOptions.modulate.a = 1.0

func _on_hover_options_exit() -> void:
	buttonSelectLeftOptions.modulate.a = 0.0
	buttonSelectRightOptions.modulate.a = 0.0

func _on_hover_exit_enter() -> void:
	buttonSelectLeftExit.modulate.a = 1.0
	buttonSelectRightExit.modulate.a = 1.0

func _on_hover_exit_exit() -> void:
	buttonSelectLeftExit.modulate.a = 0.0
	buttonSelectRightExit.modulate.a = 0.0
