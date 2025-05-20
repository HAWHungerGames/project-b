extends Control

@onready var color_rect = $MarginContainer/ColorRect
@onready var vbox = $MarginContainer/VBoxContainer
@onready var background = $MarginContainer/titleBackground

@onready var buttonSelectRightStart = $MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/buttonSelectRight
@onready var buttonSelectLeftStart = $MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/buttonSelectLeft
@onready var buttonSelectRightOptions = $MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer3/buttonSelectRight
@onready var buttonSelectLeftOptions = $MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer3/buttonSelectLeft
@onready var buttonSelectRightExit = $MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/buttonSelectRight
@onready var buttonSelectLeftExit = $MarginContainer/VBoxContainer/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/buttonSelectLeft




func _ready():
	fadeSceneIn()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nick Work Scene.tscn")


func _on_button_3_pressed() -> void:
	get_tree().quit()

func fadeSceneIn():
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0, 6.0)
	tween.play()
	
func fadeSceneOut():
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 6.0)
	tween.play()
	color_rect.process_mode = Node.PROCESS_MODE_INHERIT
func fadeIn():
	# Start with the container invisible
	# Create a tween
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(vbox, "modulate:a", 1.0, 1.0)
	tween2.tween_property(background, "modulate:a", 1.0, 1.0)
	tween.play()
	tween2.play()
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
