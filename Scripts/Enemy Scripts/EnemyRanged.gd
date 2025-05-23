extends CharacterBody3D
@export_category("Behaviour")
@export_subgroup("DetectionBehaviour")
@export var hearingRange: float = 8
@export var visionRange: float = 10

@export_subgroup("MovementBehaviour")
@export_enum("stand still", "move towards player", "keep set distance from player") var movementType: String = "stand still"
@export var keepDistance: float = 5

@export_category("Stats")
@export_subgroup("Enemy Stats")
@export var health: int = 200
@export var speed: int = 5
@export var acceleration: int = 4

@export_subgroup("Attack Stats")
@export var bulletSpeed: int = 1
@export var bulletDamage: int = 10
@export var bulletLifetime: float = 5
@export var attackSpeed: float = 1
@export_range(0, 1) var homingStrength: float = 0
@export var homingRange: float = 50

@onready var hearingNode = $HearingArea
@onready var visionNode = $VisionArea
@onready var world = $"../.."
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var playerIsInHearingArea: bool = false
var playerIsInVisionArea: bool = false
var attackCooldown: float = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bulletScene: PackedScene = preload("res://Prefabs/Enemies/enemy_bullet.tscn")
var isMoving: bool = false 
#To track the delay between stop moving and attacking 
var moveDelay: float = 0
#Tracks the time the enemy is not moving
var moveTime: float = 0
var player: Node3D
var gotAttackedTime: float = 0

func _ready():
	player = GlobalPlayer.getPlayer()
	hearingNode.scale = Vector3(hearingRange, hearingRange, hearingRange)
	visionNode.scale = Vector3(visionRange, visionRange, visionRange)

func _physics_process(delta):
	apply_gravity(delta)
	if gotAttackedTime > 0:
		gotAttackedTime -= delta
	if detect_player():
		rotateToPlayer()
		attack(delta)
	if detect_player():
		navigation(delta)
	move_and_slide()

func navigation(delta):
	match movementType:
		"move towards player":
			move_towards_player(delta)
		"keep set distance from player":
			keep_set_distance_from_player(delta)

func move_towards_player(delta):
	var direction = Vector3()
	
	nav.target_position = player.get_child(0).global_position
	
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * speed, acceleration * delta)
	move_and_slide()

func keep_set_distance_from_player(delta):
	var distance = global_position.distance_to(player.get_child(0).global_position)
	isMoving = false
	moveTime += delta
	if moveDelay > 0:
		moveDelay -= delta
	if distance >= keepDistance or !detect_player_raycast():
		var direction = Vector3()
		
		nav.target_position = player.get_child(0).global_position
		
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		isMoving = true
		moveDelay = 0.2
		moveTime = 0
	else:
		velocity = Vector3(0, velocity.y, 0)

func detect_player():
	if playerIsInHearingArea and !playerIsInVisionArea:
		if player.isSneaking and !player.isDetected and gotAttackedTime <= 0:
			player.removeDetectingEnemy([self])
			return false
		else:
			player.addDetectingEnemy([self])
			return true
	if  playerIsInVisionArea and !playerIsInHearingArea:
		if detect_player_raycast() or player.isDetected or gotAttackedTime > 0:
			player.addDetectingEnemy([self])
			return true
		else:
			player.removeDetectingEnemy([self])
			return false
	if playerIsInHearingArea and playerIsInVisionArea:
		if player.isDetected or detect_player_raycast() or !player.isSneaking or gotAttackedTime > 0:
			player.addDetectingEnemy([self])
			return true
	player.removeDetectingEnemy([self])
	return false

func detect_player_raycast():
	var space_state = get_world_3d().direct_space_state
	var origin = transform.origin
	var end = player.get_child(0).global_transform.origin
	var query = PhysicsRayQueryParameters3D.create(origin, end, 3, [self])

	var result = space_state.intersect_ray(query)
	#Might need some adustment, crashes if the raycast never hits a collider
	if result != null:
		var collider = result.collider
		if collider is Node:
			if collider.is_in_group("Player"):
				return true
	return false

func rotateToPlayer():
	var angleVector = player.get_child(0).global_transform.origin - global_transform.origin
	var angle = atan2(angleVector.x, angleVector.z)
	rotation.y = angle - PI/2

func takeDamage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()
	else:
		gotAttackedTime = 3

func attack(delta):
	if attackCooldown <= 0 and detect_player_raycast() and !isMoving and moveDelay <= 0:
		var pos: Vector3 = get_child(2).global_transform.origin
		var vel: Vector3 = player.get_child(0).global_transform.origin - global_transform.origin
		var bullet = bulletScene.instantiate()
		bullet.setParameter(player, bulletDamage, bulletSpeed, homingRange, homingStrength, vel, bulletLifetime)
		world.add_child(bullet)
		bullet.global_transform.origin = pos
		attackCooldown = 1.0/attackSpeed
	elif(attackCooldown >= 0): 
		attackCooldown -= delta

func apply_gravity(delta):
	velocity.y += -gravity * delta

func _on_hearing_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerIsInHearingArea = true

func _on_hearing_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerIsInHearingArea = false

func _on_vision_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerIsInVisionArea = true

func _on_vision_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerIsInVisionArea = false
