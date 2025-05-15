extends CharacterBody3D

@export var damage: float = 10
@export var speed: float = 10
@export var trackingRadius: float = 5
@export_range(0,1) var trackingStrength: float = 0
@export var enemy: Node3D
@export var vel: Vector3 = Vector3(1,0,0)
@export var lifetime: float = 5

var isTracking: bool = false

func setParameter(damageInput: float, speedInput: float, trackingRadiusInput: float, trackingStrengthInput: float, velInput: Vector3, lifetimeInput: float):
	damage = damageInput
	speed = speedInput
	get_child(1).get_child(0).scale = Vector3(trackingRadiusInput, trackingRadiusInput, trackingRadiusInput)
	trackingStrength = trackingStrengthInput
	vel = velInput
	lifetime = lifetimeInput

func _physics_process(delta):
	move(delta)
	move_and_slide()
	lifetime -= delta
	if lifetime < 0:
		queue_free()

func move(delta):
	var tempTrackingStrength = trackingStrength/10
	var directionToEnemy
	if isTracking:
		directionToEnemy = -Vector3(global_transform.origin.x - enemy.global_transform.origin.x, 0, global_transform.origin.z - enemy.global_transform.origin.z).normalized()
	else:
		tempTrackingStrength = 0
		directionToEnemy = 0
	vel = (vel * (1 - tempTrackingStrength) + directionToEnemy * tempTrackingStrength).normalized()
	velocity = vel * speed * delta * 50

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		enemy = area
		isTracking = true

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		isTracking = false

func _on_hit_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		enemy.takeDamage(damage)
		queue_free()

func _on_hit_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("World"):
		queue_free()
