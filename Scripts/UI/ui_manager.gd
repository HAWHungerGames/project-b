extends Node

@onready var current_lang = TranslationServer.get_locale()
@onready var current_controller = get_controller_type()
const LANGUAGES : Dictionary = {
	"en_EN": "SETTING_LANGUAGE_ENGLISH",
	"en_GB": "SETTING_LANGUAGE_ENGLISH_GB",
	"en_US": "SETTING_LANGUAGE_ENGLISH_US",
	"en_AU": "SETTING_LANGUAGE_ENGLISH_AU",
	"de_DE": "SETTING_LANGUAGE_GERMAN"
}
const button_mappings = {
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

func update_lang(lang: String) -> void:
	TranslationServer.set_locale(lang)
	lang_change.emit()

func get_controller_type():
	var controller_type = "None" 
	if len(Input.get_connected_joypads()) > 0:
		if "ps" in Input.get_joy_name(0).to_lower():
			controller_type = "PS5"
		elif "nintendo" in Input.get_joy_name(0).to_lower():
			controller_type = "Nintendo"
		elif "xbox" in Input.get_joy_name(0).to_lower():
			controller_type = "XBox"
	return controller_type

# future changes - generic also to keyboard
func get_controller_input_key(action, controller_connected) -> String:
	return button_mappings[current_controller.to_lower()[action]]
