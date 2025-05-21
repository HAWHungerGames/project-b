extends Node
@export var healingAmount: float = 1000

func _on_area_3d_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		area.get_parent().get_parent().heal(healingAmount)
		queue_free()
