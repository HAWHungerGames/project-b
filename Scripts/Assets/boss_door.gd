extends StaticBody3D

@onready var animation_player = $AnimationPlayer
var is_closed = false

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player") and !is_closed:
		animation_player.play("Closing")
		is_closed = true
