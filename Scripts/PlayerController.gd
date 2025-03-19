extends CharacterBody3D

@export_category("Setting")
@export var speed = 5.0
@export var acceleration = 4.0
@export_range(0, 1) var sensitivity: float = 1
@export var lock_active: bool = false

@export_category("Components")
@export var playerShape: CollisionShape3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var temprotation = 0

@onready var spring_arm = $CameraArm


func _physics_process(delta):
	apply_gravity(delta)
	get_move_input(delta)
	move_and_slide()
	rotate_player()#


func rotate_player():
	var input = Input.get_vector("left", "right", "forward", "backward")
	var lock = false
	if lock_active:
		lock = Input.is_action_pressed("lock_movement")
	if (input.x != 0 or input.y != 0) and !lock:
		temprotation = atan2(-input.x, -input.y)
	playerShape.rotation.y = temprotation

func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "backward")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	velocity.y = vy

func apply_gravity(delta):
	velocity.y += -gravity * delta
