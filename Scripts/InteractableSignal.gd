extends Interactable

func _on_interacted(body: Variant) -> void:
	$AudioStreamPlayer3D.play()
