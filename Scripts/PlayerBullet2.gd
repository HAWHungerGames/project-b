extends Node3D

@export var speed = 10.0
@export var dmg = 40
@export var lifetime = 5

#@onready var mesh = $MeshInstance3D
#@onready var hitbox = $Hitbox

func _physics_process(delta: float) -> void:
	moving(delta)
	lifetime_of_bullet(delta)
	

func moving(delta):
	position += transform.basis * Vector3(0, 0, -speed) * delta
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.takeDamage(dmg)
		queue_free()
		print("hit")
	else:
		queue_free()
		print("bullet despawned")

func lifetime_of_bullet(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		print("bullet despawned")
