extends Node

@onready var current_lang: String= TranslationServer.get_locale()
@onready var current_controller: String = get_controller_type()
@onready var text_field: Control = get_tree().current_scene.find_child("textField")
@onready var stats: MarginContainer = get_tree().current_scene.find_child("stats")
@onready var timer: Timer

const LANGUAGES : Dictionary = {
	"en_EN": "SETTING_LANGUAGE_ENGLISH",
	"en_GB": "SETTING_LANGUAGE_ENGLISH_GB",
	"en_US": "SETTING_LANGUAGE_ENGLISH_US",
	"en_AU": "SETTING_LANGUAGE_ENGLISH_AU",
	"de_DE": "SETTING_LANGUAGE_GERMAN"
}
const button_mappings: Dictionary[String, Dictionary] = {
	"xbox": {
		"interact": "A",
		"block": "LT",
		"pause": "Menu",
		"attack": "RT",
		"weapon_swap": "Y",
		"sneak": "L3",
		"dash": "LB"
	},
	"ps5": {
		"interact": "✕",
		"block": "L2", 
		"pause": "Start",
		"attack": "R2",
		"weapon_swap": "△",
		"sneak": "L3",
		"dash": "L1"
	},
	"nintendo": {
		"interact": "B",
		"block": "ZL",
		"menu": "+",
		"attack": "ZR",
		"weapon_swap": "X",
		"sneak": "L3",
		"dash": "L"
	}
}

signal lang_change

var can_toggle_display = true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if timer != null:
		timer = text_field.get_child(1)
		timer.timeout.connect(_on_timer_finished)
	print(get_tree().current_scene)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && get_tree().paused:
		toggle_display_text("None", false)
		
func update_lang(lang: String) -> void:
	TranslationServer.set_locale(lang)
	lang_change.emit()

func get_controller_type():
	var controller_type: String = "None" 
	if len(Input.get_connected_joypads()) > 0:
		if "ps" in Input.get_joy_name(0).to_lower():
			controller_type = "PS5"
		elif "nintendo" in Input.get_joy_name(0).to_lower():
			controller_type = "Nintendo"
		elif "xbox" in Input.get_joy_name(0).to_lower():
			controller_type = "XBox"
	return controller_type

# future changes - generic also to keyboard
func get_controller_input_key(action: String, controller_connected: bool) -> String:
	return button_mappings[current_controller.to_lower()][action.to_lower()]

func toggle_display_text(sign_name: String, text_displayed: bool):
	if !can_toggle_display:
		return
	can_toggle_display = false
	var text: String = "INTERACT_TOOLTIP_" + sign_name.to_upper().split("_")[-1]
	var display_text: TextEdit = text_field.get_child(0).get_child(0)
	text_field.visible = text_displayed
	display_text.text = text
	stats.visible = !text_displayed
	get_tree().paused = text_displayed
	timer.start()

func _on_timer_finished():
	can_toggle_display = true
