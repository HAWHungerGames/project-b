extends StaticBody3D

@onready var ani_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer3D
@export var timer: float = 0.0

var hit = false


func _physics_process(delta: float) -> void:
	if hit:
		timer += delta
		if timer > 0.4:
			timer = 0.0
			hit = false

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Weapon") and !hit:
		ani_player.play("GettingHit")
		var rnd_pitch = randf_range(0.75, 1.25)
		audio_player.set_pitch_scale(rnd_pitch)
		audio_player.play(0)
		hit = true
