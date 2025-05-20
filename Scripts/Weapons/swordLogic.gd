extends Area3D


func _on_body_entered(body: Node3D) -> void:
	hitting_enemy(body)
	hitting_target_dummy(body)
		
func hitting_enemy(body):
	if body.is_in_group("enemy"):
		body.takeDamage(50)
		print("enemy hit")

func hitting_target_dummy(body):
	if body.is_in_group("TargetDummy"):
		print("dummy hit")
		var dmg_position = body.get_node_or_null("DamageNumbersPosition")
		DamageNumbers.display_number(50, dmg_position.global_position)
