extends Node

@onready var current_lang = TranslationServer.get_locale()

const LANGUAGES : Dictionary = {
	"en_EN": "SETTING_LANGUAGE_ENGLISH",
	"en_GB": "SETTING_LANGUAGE_ENGLISH",
	"en_US": "SETTING_LANGUAGE_ENGLISH",
	"en_AU": "SETTING_LANGUAGE_ENGLISH",
	"de_DE": "SETTING_LANGUAGE_GERMAN"
}

signal lang_change

func update_lang(lang: String) -> void:
	TranslationServer.set_locale(lang)
	lang_change.emit()
