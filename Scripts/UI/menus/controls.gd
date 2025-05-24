extends Control

@onready var controller_text = $MarginContainer/controlsMenuContainer/MarginContainer/titles/HBoxContainer/controller
@onready var keyboard_text = $MarginContainer/controlsMenuContainer/MarginContainer/titles/HBoxContainer/keyboard
@onready var controller_menu = $MarginContainer/controlsMenuContainer/MarginContainer/Controller
@onready var controller_image = $MarginContainer/controlsMenuContainer/MarginContainer/Controller/TextureRect
@onready var keyboard_menu = $MarginContainer/controlsMenuContainer/MarginContainer/keyboard

const CONTROLLER_CONTROLS: Dictionary = {
	"PS5_en_EN": "res://UI/Menus/Controller/PS5_en_EN.png",
	"PS5_de_DE": "res://UI/Menus/Controller/PS5_de_DE.png",
	"XBox_en_EN": "res://UI/Menus/Controller/XBox_en_EN.png",
	"XBox_de_DE": "res://UI/Menus/Controller/XBox_de_DE.png",
	"Nintendo_en_EN": "res://UI/Menus/Controller/Nintedno_en_EN.png",
	"Nintendo_de_DE": "res://UI/Menus/Controller/Nintendo_de_DE.png",
}

func _ready() -> void:
	UiManager.lang_change.connect(update_controller_controls)
	
func update_controller_controls() -> void:
	var controller_type = "XBox_" 
	if len(Input.get_connected_joypads()) > 0:
		if "ps" in Input.get_joy_name(0).to_lower():
			controller_type = "PS5_"
		elif "nintendo" in Input.get_joy_name(0).to_lower():
			controller_type = "Nintendo_"
		else:
			controller_type = "XBox_"
	controller_image.texture = load(CONTROLLER_CONTROLS[controller_type + UiManager.current_lang])
	
func _on_button_left_pressed() -> void:
	controller_text.visible = true
	controller_menu.visible = true
	keyboard_menu.visible = false
	keyboard_text.visible = false

func _on_button_right_pressed() -> void:
	controller_text.visible = false
	controller_menu.visible = false
	keyboard_menu.visible = true
	keyboard_text.visible = true
