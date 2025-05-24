extends Interactable
class_name Sign

func _on_interacted(body: Variant) -> void:
	UiManager.toggle_display_text(self.name, true)
