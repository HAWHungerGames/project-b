extends Node3D

@export var speed = 10.0
@export var dmg = 40
@export var lifetime = 5

#@onready var mesh = $MeshInstance3D
#@onready var hitbox = $Hitbox
var enemy_position_for_tracking
var tracking = false
var directions

func _physics_process(delta: float) -> void:
	moving(delta)
	lifetime_of_bullet(delta)
	

func moving(delta):
	if !tracking:
		position += transform.basis * Vector3(0, 0, -speed) * delta
	elif tracking:
		directions = (enemy_position_for_tracking.global_position - global_position).normalized()
		position += directions * speed * delta

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

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and !tracking:
		enemy_position_for_tracking = body
		tracking = true
		print(tracking)
		print(enemy_position_for_tracking)
		print("hallo enemy")
