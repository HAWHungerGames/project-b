extends StaticBody3D

@onready var ani_player = $AnimationPlayer
@onready var fallingParticles = $FallingParticles
var isClosed = true

func _physics_process(delta: float) -> void:
	if GameManager.get_weapon_in_hand() and isClosed:
		fallingParticles.emitting = false
		ani_player.play("Opening")
		isClosed = false
	elif !GameManager.get_weapon_in_hand() and !isClosed:
		fallingParticles.emitting = true
		ani_player.play("Closing")
		isClosed = true
