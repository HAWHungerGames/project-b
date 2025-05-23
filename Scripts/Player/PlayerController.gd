extends CharacterBody3D

var speed
var acceleration 
var friction 
#@onready var sensitivity: float = settings.sensitivity
var rotationType: String 
var lockActive: bool
var dashStrength: int 
var dashMaxCooldown: float 
var maxStamina: int 
var staminaPerSecond: int
var staminaCostPerDash: int
var dashType: String
var noStaminaAfterDashTime: float

@export_category("Components")
@export var playerShape: CollisionShape3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var temprotation = 0
var dashCooldown: float = 0
var mouseMode: bool = false
var mouseTimer: float = 0
var player: Node3D
var lock = false
var sneakToggle = false

@onready var spring_arm = $CameraArm

func _ready():
	player = GlobalPlayer.getPlayer()
	speed = player.speed
	acceleration = player.acceleration
	friction = player.friction
	#@onready var sensitivity: float = settings.sensitivity
	rotationType = player.rotationType
	lockActive = player.lockActive
	dashStrength = player.dashStrength
	dashMaxCooldown = player.dashMaxCooldown
	maxStamina = player.maxStamina
	staminaPerSecond = player.staminaPerSecond
	staminaCostPerDash = player.staminaCostPerDash
	dashType = player.dashType
	noStaminaAfterDashTime = player.noStaminaAfterDashTime

func _physics_process(delta):	
	apply_gravity(delta)
	get_move_input(delta)
	move_and_slide()
	rotate_player()
	dash(delta)
	block()

func _input(event):
	if event is InputEventMouseMotion:
		if event.velocity.x > 0 or event.velocity.y > 0:
			mouseMode = true

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
	if Input.is_action_just_pressed("dash") and player.stamina >= staminaCostPerDash:
		dash_ability(delta)
		player.reduce_stamina(staminaCostPerDash)

func dash_ability(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "backward").normalized()
	var direction = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, direction * dashStrength, acceleration * delta)
	velocity.y = vy
	player.set_stamina_regen_cooldown(noStaminaAfterDashTime)
	if player.isDetected:
		PlayerActionTracker.timesDodgedInCombat += 1

func block():
	if Input.is_action_just_pressed("block"):
		if check_for_equipped_shield():
			player.isBlocking = true
	if Input.is_action_just_released("block"):
		player.isBlocking = false

func check_for_equipped_shield():
	return true

func rotate_player():
	match rotationType:
		"rotate based on last movement":
			rotate_based_on_last_movement()
		"rotate based on second input":
			rotate_based_on_second_input()

func rotate_based_on_last_movement():
	var input = Input.get_vector("left", "right", "forward", "backward")
	if lockActive:
		lock = Input.is_action_pressed("lock_movement")
	if (input.x != 0 or input.y != 0) and !lock:
		temprotation = atan2(-input.x, -input.y)
	playerShape.rotation.y = temprotation

func rotate_based_on_second_input():
	var look_input = Input.get_vector("look_left", "look_right", "look_forward", "look_backward")
	if (look_input.x != 0 or look_input.y != 0):
		mouseMode = false
	if lockActive:
		lock = Input.is_action_pressed("lock_movement")
	if !mouseMode:
		var input = Input.get_vector("left", "right", "forward", "backward")
		if (input.x != 0 or input.y != 0):
			temprotation = atan2(-input.x, -input.y)
		if (look_input.x != 0 or look_input.y != 0):
			temprotation = atan2(-look_input.x, -look_input.y)
	else:
		var mousePosition = get_viewport().get_mouse_position()
		var screenSize = get_viewport().get_visible_rect().size
		var screenCenter = Vector2(screenSize.x/2,screenSize.y/2 - 20)
		var normalizedRelativeMousePosition = Vector2(mousePosition.x - screenCenter.x, mousePosition.y - screenCenter.y).normalized()
		temprotation = atan2(normalizedRelativeMousePosition.x, normalizedRelativeMousePosition.y) + PI
	if !lock:
		playerShape.rotation.y = temprotation

func get_move_input(delta):
	sneakToggler()
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "backward").normalized()
	var direction = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	var playerSpeed = player.speed
	player.set_sneaking(false)
	if sneakToggle:
		player.set_sneaking(true)
		playerSpeed = playerSpeed / player.sneakSpeedModifier
	velocity = lerp(velocity, direction * playerSpeed, acceleration * delta)
	velocity.y = vy
	if abs(input.x) < 0.01:
		velocity.x -= velocity.x * friction
	if abs(input.y) < 0.01:
		velocity.z -= velocity.z * friction

func sneakToggler():
	if Input.is_action_just_pressed("sneak"):
		if sneakToggle:
			sneakToggle = false
		else:
			sneakToggle = true

func apply_gravity(delta):
	velocity.y += -gravity * delta
