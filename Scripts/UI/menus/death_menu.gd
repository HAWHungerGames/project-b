extends MarginContainer

@onready var death_menu = self
@onready var buttonsRetry = $deathMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsRetry
@onready var buttonsExit = $deathMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsExit

@onready var blendScreen = $blendScreen
@onready var death_black_screen = $death_blackscreen

@onready var player = GlobalPlayer.getPlayer()
func _ready() -> void:
	player.healthChanged.connect(fade_in_death_screen)
func fade_in_death_screen():
	if player.health > 0:
		return
	death_menu.visible = true
	get_tree().paused = true
	var tween = create_tween()
	tween.tween_property(death_black_screen, "modulate:a", 1.0, 2.0)
	
func _on_retry_hover_enter() -> void:
	print("hovered")
	toggle_button_selects(buttonsRetry, true)

func _on_retry_hover_exit() -> void:
	toggle_button_selects(buttonsRetry, false)

func _on_exit_hover_enter() -> void:
	toggle_button_selects(buttonsExit, true)

func _on_exit_hover_exit() -> void:
	toggle_button_selects(buttonsExit, false)

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


func _on_retry_pressed() -> void:
	print("presed")
	SceneManager.game_scene.emit()
	blendScreen.z_index = 2
	var tween = create_tween()
	tween.tween_property(blendScreen, "modulate:a", 1.0, 2.0)
	tween.play()
	await get_tree().create_timer(2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Konrad Work Scene.tscn")
	
func _on_exit_pressed() -> void:
	SceneManager.main_scene.emit()
	blendScreen.z_index = 2
	var tween = create_tween()
	tween.tween_property(blendScreen, "modulate:a", 1.0, 2.0)
	tween.play()
	await get_tree().create_timer(2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Prefabs/Asset Scenes/UI/TitleScreen.tscn")
