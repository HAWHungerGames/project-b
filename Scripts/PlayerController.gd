extends CharacterBody3D

@export_category("Setting")
@export var speed = 5.0
@export var acceleration = 4.0
@export_range(0, 1) var sensitivity: float = 1
@export_enum("rotate based on last movement", "rotate based on relative mouse position", "rotation based on right joystick") var rotation_type: String = "rotate based on last movement"
@export var lock_active: bool = true

@export_category("Components")
@export var playerShape: CollisionShape3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var temprotation = 0

@onready var spring_arm = $CameraArm


func _physics_process(delta):
	apply_gravity(delta)
	get_move_input(delta)
	move_and_slide()
	rotate_player()

func rotate_player():
	match rotation_type:
		"rotate based on last movement":
			rotate_based_on_last_movement()
		"rotate based on relative mouse position":
			rotate_based_on_relative_mouse_position()
		"rotation based on right joystick":
			rotation_based_on_right_joystick()

func rotate_based_on_last_movement():
	var input = Input.get_vector("left", "right", "forward", "backward")
	var lock = false
	if lock_active:
		lock = Input.is_action_pressed("lock_movement")
	if (input.x != 0 or input.y != 0) and !lock:
		temprotation = atan2(-input.x, -input.y)
	playerShape.rotation.y = temprotation

func rotate_based_on_relative_mouse_position():
	var mousePosition = get_viewport().get_mouse_position()
	var screenSize = get_viewport().get_visible_rect().size
	var screenCenter = Vector2(screenSize.x/2,screenSize.y/2 - 20)
	var normalizedRelativeMousePosition = Vector2(mousePosition.x - screenCenter.x, mousePosition.y - screenCenter.y).normalized()
	var mouseAngle = atan2(normalizedRelativeMousePosition.x, normalizedRelativeMousePosition.y) + PI
	playerShape.rotation.y = mouseAngle

func rotation_based_on_right_joystick():
	var input = Input.get_vector("look_left", "look_right", "look_forward", "look_backward")
	if (input.x != 0 or input.y != 0):
		temprotation = atan2(-input.x, -input.y)
	playerShape.rotation.y = temprotation

func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "backward").normalized()
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	velocity.y = vy

func apply_gravity(delta):
	velocity.y += -gravity * delta
