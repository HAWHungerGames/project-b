extends Control

@onready var controller_text = $MarginContainer/controlsMenuContainer/MarginContainer/titles/HBoxContainer/controller
@onready var keyboard_text = $MarginContainer/controlsMenuContainer/MarginContainer/titles/HBoxContainer/keyboard
@onready var controller_menu = $MarginContainer/controlsMenuContainer/MarginContainer/Controller
@onready var controller_image = $MarginContainer/controlsMenuContainer/MarginContainer/Controller/inputs
@onready var controller_label = $MarginContainer/controlsMenuContainer/MarginContainer/Controller/connect_controller
@onready var keyboard_menu = $MarginContainer/controlsMenuContainer/MarginContainer/keyboard
@onready var button_left = $MarginContainer/controlsMenuContainer/MarginContainer/titles/HBoxContainer/buttonLeft
@onready var button_right = $MarginContainer/controlsMenuContainer/MarginContainer/titles/HBoxContainer/buttonRight
@onready var back = $MarginContainer/controlsMenuContainer/MarginContainer/NinePatchRect/buttonMargin/buttons/buttonsBack

@onready var pause_menu = $"../../pauseMenu"

const CONTROLLER_CONTROLS: Dictionary = {
	"PS5_en_EN": "res://UI/Menus/Controller/PS5_en_EN.png",
	"PS5_de_DE": "res://UI/Menus/Controller/PS5_de_DE.png",
	"XBox_en_EN": "res://UI/Menus/Controller/XBox_en_EN.png",
	"XBox_de_DE": "res://UI/Menus/Controller/XBox_de_DE.png",
	"Nintendo_en_EN": "res://UI/Menus/Controller/Nintedno_en_EN.png",
	"Nintendo_de_DE": "res://UI/Menus/Controller/Nintendo_de_DE.png",
}

var controller = false
var control_buttons = false

func _ready() -> void:
	UiManager.lang_change.connect(update_controller_controls)

func _input(event: InputEvent) -> void:
	if !visible:
		return
	if event.is_action_pressed("ui_up"):
		control_buttons = true
		if controller:
			button_right.grab_focus()
		else:
			button_left.grab_focus()
	elif event.is_action_pressed("ui_down"):
		control_buttons = false
		back.get_child(1).grab_focus()
	elif event.is_action_pressed("ui_left"):
		if !control_buttons:
			return
		print("button left")
		button_left.grab_focus()
	elif event.is_action_pressed("ui_right"):
		if !control_buttons:
			return
		print("button right")
		button_right.grab_focus()

func update_controller_controls() -> void:
	var controller_type = "XBox_" 
	if len(Input.get_connected_joypads()) > 0:
		controller = true
		reveal_controller()
		if "ps" in Input.get_joy_name(0).to_lower():
			controller_type = "PS5_"
		elif "nintendo" in Input.get_joy_name(0).to_lower():
			controller_type = "Nintendo_"
		else:
			controller_type = "XBox_"
		controller_image.visible == true
		controller_label.visible == false
		controller_image.texture = load(CONTROLLER_CONTROLS[controller_type + UiManager.current_lang])
	else:
		controller = false
		controller_image.visible == false
		controller_label.visible == true
		reveal_keyboard()
	back.get_child(1).grab_focus()
		
func _on_button_left_pressed() -> void:
	reveal_controller()

func _on_button_right_pressed() -> void:
	reveal_keyboard()

func reveal_keyboard() -> void:
	controller_text.visible = false
	controller_menu.visible = false
	keyboard_menu.visible = true
	keyboard_text.visible = true
	
func reveal_controller() -> void:
	controller_text.visible = true
	controller_menu.visible = true
	keyboard_menu.visible = false
	keyboard_text.visible = false

func _on_back_mouse_entered() -> void:
	pause_menu.toggle_button_selects(back, true)

func _on_back_mouse_exited() -> void:
	pause_menu.toggle_button_selects(back, false)
