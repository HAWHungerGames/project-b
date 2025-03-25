extends CharacterBody3D

@export_category("Setting")
@export var speed = 5.0
@export var acceleration = 4.0
@export_range(0, 1) var sensitivity: float = 1
@export_enum("rotate based on last movement", "rotate based on relative mouse position", "rotation based on right joystick") var rotationType: String = "rotate based on last movement"
@export var lockActive: bool = true
@export var dashStrength: int = 200
@export var dashMaxCooldown: float = 3
@export var maxStamina: int = 200
@export var staminaPerSecond: int = 10
@export var staminaCostPerDash: int = 50
@export_enum("dash with cooldown","dash with stamina") var dashType: String = "dash with cooldown"

@export_category("Components")
@export var playerShape: CollisionShape3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var temprotation = 0
var dashCooldown: float = 0
var stamina: int = maxStamina
var staminaTimer: float = 0

@onready var spring_arm = $CameraArm


func _physics_process(delta):
	apply_gravity(delta)
	get_move_input(delta)
	move_and_slide()
	rotate_player()
	dash(delta)
	stamina_system(delta)

func dash(delta):
	match dashType:
		"dash with cooldown":
			dash_with_cooldown(delta)
		"dash with stamina":
			dash_with_stamina(delta)

func dash_with_cooldown(delta):
	if Input.is_action_just_pressed("dash") and dashCooldown <= 0:
		dash_ability(delta)
		dashCooldown = dashMaxCooldown
	if dashCooldown >= 0:
		dashCooldown = dashCooldown - delta

func dash_with_stamina(delta):
	if Input.is_action_just_pressed("dash") and stamina >= staminaCostPerDash:
		dash_ability(delta)
		stamina -= staminaCostPerDash

func stamina_system(delta):
	if stamina < maxStamina:
		if staminaTimer >= 1:
			stamina += staminaPerSecond
			staminaTimer = 0
			print(stamina)
		else:
			staminaTimer += delta

func dash_ability(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "backward").normalized()
	var direction = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, direction * dashStrength, acceleration * delta)
	velocity.y = vy

func rotate_player():
	match rotationType:
		"rotate based on last movement":
			rotate_based_on_last_movement()
		"rotate based on relative mouse position":
			rotate_based_on_relative_mouse_position()
		"rotation based on right joystick":
			rotation_based_on_right_joystick()

func rotate_based_on_last_movement():
	var input = Input.get_vector("left", "right", "forward", "backward")
	var lock = false
	if lockActive:
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
	var input = Input.get_vector("left", "right", "forward", "backward")
	if (input.x != 0 or input.y != 0):
		temprotation = atan2(-input.x, -input.y)
	var look_input = Input.get_vector("look_left", "look_right", "look_forward", "look_backward")
	if (look_input.x != 0 or look_input.y != 0):
		temprotation = atan2(-look_input.x, -look_input.y)
	playerShape.rotation.y = temprotation

func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "backward").normalized()
	var direction = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	velocity.y = vy

func apply_gravity(delta):
	velocity.y += -gravity * delta
