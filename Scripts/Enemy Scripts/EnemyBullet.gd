extends CharacterBody3D

@export var damage: float = 10
@export var speed: float = 10
@export var trackingRadius: float = 5
@export_range(0,1) var trackingStrength: float = 0
@export var player: Node3D
@export var vel: Vector3 = Vector3(1,0,0)
@export var lifetime: float = 5

var isTracking: bool = false
var trackingDelay: float = 0
var delayValue: float = 0
var blockCostModifier: float = 0

func setParameter(playerInput: Node3D, damageInput: float, speedInput: float, trackingRadiusInput: float, trackingStrengthInput: float, velInput: Vector3, lifetimeInput: float):
	player = playerInput
	damage = damageInput
	speed = speedInput
	get_child(1).get_child(0).scale = Vector3(trackingRadiusInput, trackingRadiusInput, trackingRadiusInput)
	trackingStrength = trackingStrengthInput
	vel = velInput
	lifetime = lifetimeInput

func setTrackingDelay(delay):
	trackingDelay = delay

func setBlockCostModifier(value):
	blockCostModifier = value

func _physics_process(delta):
	move(delta)
	move_and_slide()
	lifetime -= delta
	if lifetime < 0:
		queue_free()

func move(delta):
	var tempTrackingStrength = trackingStrength/10
	if !isTracking:
		tempTrackingStrength = 0 
	var directionToPlayer = -Vector3(global_transform.origin.x - player.get_child(0).global_transform.origin.x, global_transform.origin.y - player.get_child(0).global_transform.origin.y, global_transform.origin.z - player.get_child(0).global_transform.origin.z).normalized()
	if trackingDelay <= 0:
		vel = (vel * (1 - tempTrackingStrength) + directionToPlayer * tempTrackingStrength).normalized()
	if trackingDelay > 0:
		trackingDelay -= delta
	velocity = vel * speed * delta * 50

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isTracking = true

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isTracking = false

func _on_hit_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		player.takeDamage(damage, self, true, blockCostModifier)
		queue_free()

func _on_hit_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("World"):
		queue_free()
