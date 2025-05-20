extends StaticBody3D

@onready var ani_player = $AnimationPlayer

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Weapon"):
		ani_player.play("GettingHit")
