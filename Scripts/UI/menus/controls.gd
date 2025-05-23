extends Control

@onready var controller_text = $MarginContainer/controlsMenuContainer/MarginContainer/titles/HBoxContainer/controller
@onready var keyboard_text = $MarginContainer/controlsMenuContainer/MarginContainer/titles/HBoxContainer/keyboard
@onready var controller_menu = $MarginContainer/controlsMenuContainer/MarginContainer/Controller
@onready var controller_image = $MarginContainer/controlsMenuContainer/MarginContainer/Controller/TextureRect
@onready var keyboard_menu = $MarginContainer/controlsMenuContainer/MarginContainer/keyboard

@onready var current_lang = UiManager.current_lang

const CONTROLLER_CONTROLS: Dictionary = {
	"PSen_EN": "res://UI/Menus/Controller/PS5En.png",
	"PSde_DE": "res://UI/Menus/Controller/PS5De.png",
	"XBoxen_EN": "res://UI/Menus/Controller/XBoxEn.png",
	"XBoxde_DE": "res://UI/Menus/Controller/XBoxDe.png"
}

func _ready() -> void:
	UiManager.lang_change.connect(update_controller_controls)
	
func update_controller_controls() -> void:
	var controller_type = "XBox" if len(Input.get_connected_joypads()) > 0 && Input.get_joy_name(0).to_lower() in "xbox" else "PS"
	controller_image.texture = load(CONTROLLER_CONTROLS[controller_type + current_lang])
	
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
