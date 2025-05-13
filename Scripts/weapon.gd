extends Area3D


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		print("enemy hit")



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.takeDamage(50)
		print("enemy hit")
