extends StaticBody3D

@onready var ani_player = $AnimationPlayer
@onready var fallingParticles = $FallingParticles
@onready var audio = $AudioStreamPlayer3D

var isClosed = true


func _physics_process(delta: float) -> void:
	if GameManager.get_weapon_in_hand() and isClosed:
		fallingParticles.emitting = false
		ani_player.play("Opening")
		audio.set_pitch_scale(0.2)
		audio.play()
		isClosed = false
	elif !GameManager.get_weapon_in_hand() and !isClosed:
		fallingParticles.emitting = true
		ani_player.play("Closing")
		audio.set_pitch_scale(1.2)
		audio.play()
		isClosed = true
