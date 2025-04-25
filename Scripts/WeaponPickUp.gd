extends Interactable
class_name Weapons

func _on_interacted(body: Variant) -> void:
	print("you got a weapon")
	queue_free()
