extends Control

@onready var display = $optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsDisplay
@onready var controls = $optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsControls
@onready var back = $optionsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsBack

@onready var pause_menu = $"../../pauseMenu"

func _on_display_mouse_entered() -> void:
	pause_menu.toggle_button_selects(display, true)


func _on_display_mouse_exited() -> void:
	pause_menu.toggle_button_selects(display, false)


func _on_controls_mouse_entered() -> void:
	pause_menu.toggle_button_selects(controls, true)


func _on_controls_mouse_exited() -> void:
	pause_menu.toggle_button_selects(controls, false)


func _on_back_mouse_entered() -> void:
	pause_menu.toggle_button_selects(back, true)


func _on_back_mouse_exited() -> void:
	pause_menu.toggle_button_selects(back, false)
