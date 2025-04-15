extends CharacterBody3D
@export var player: Node3D
@export_category("Behaviour")
@export_subgroup("DetectionBehaviour")
@export_enum("detect within own detection-area", "detect within any detection-area", "detect within arena") var detectionType: String = "detect within detection-area"
@export var detectHiddenPlayer: bool = false
@export var detectionRange: float = 8

@export_subgroup("MovementBehaviour")
@export_enum("stand still", "move towards player", "flee from player", "keep set distance from player") var movementType: String = "stand still"
@export var keepDistance: float = 5

@export_subgroup("AttackBehaviour")
@export var onlyShotWithClearLineOfSight: bool = true

@export_category("Stats")
@export_subgroup("Enemy Stats")
@export var health: int = 200
@export var speed: int = 5
@export var acceleration: int = 4

@export_subgroup("Attack Stats")
@export var bulletSpeed: int = 1
@export var bulletDamage: int = 10
@export var bulletLifetime: float = 5
@export var attackSpeed: int = 1
@export_range(0, 1) var homingStrength: float = 0
@export var homingRange: float = 50

@onready var detectionRangeNode = $DetectionArea/DetectionShape
@onready var world = $"../.."
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var playerInDetectionRadius: bool = false
var attackCooldown: float
var bulletScene: PackedScene = preload("res://Prefabs/enemy_bullet.tscn")
var isMoving: bool = false 

func _ready():
	detectionRangeNode.scale = Vector3(detectionRange, detectionRange, detectionRange)

func _physics_process(delta):
	if detect_player():
		rotateToPlayer()
		attack(delta)
	if player.isDetected:
		navigation(delta)


func navigation(delta):
	match movementType:
		"stand still":
			null
		"move towards player":
			move_towards_player(delta)
		"flee from player":
			flee_from_player(delta)
		"keep set distance from player":
			keep_set_distance_from_player(delta)

func flee_from_player(delta): #Not Implemented yet
	null

func move_towards_player(delta):
	if playerInDetectionRadius:
		var direction = Vector3()
		
		nav.target_position = player.get_child(0).global_position
		
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		move_and_slide()

func keep_set_distance_from_player(delta):
	var distance = global_position.distance_to(player.get_child(0).global_position)
	isMoving = false
	if playerInDetectionRadius and (!detect_player_raycast() or distance >= keepDistance):
		var direction = Vector3()
		
		nav.target_position = player.get_child(0).global_position
		
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		move_and_slide()
		isMoving = true

func detect_player():
	if playerInDetectionRadius and player.isSneaking:
		if detect_player_raycast() or player.isDetected:
			player.isDetected = true
			return true
		else:
			player.isDetected = false
			return false
	elif playerInDetectionRadius and !player.isSneaking:
		player.isDetected = true
		return true
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

func attack(delta):
	if attackCooldown <= 0 and detect_player_raycast() and !isMoving:
		var pos: Vector3 = get_child(2).global_transform.origin
		var vel: Vector3 = player.get_child(0).global_transform.origin - global_transform.origin
		var bullet = bulletScene.instantiate()
		bullet.setParameter(player, bulletDamage, bulletSpeed, homingRange, homingStrength, vel, bulletLifetime)
		world.add_child(bullet)
		bullet.global_transform.origin = pos
		attackCooldown = 1/attackSpeed
	elif(attackCooldown >= 0): 
		attackCooldown -= delta

func takeDamage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()

func _on_detection_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerInDetectionRadius = true
		player.enemiesDetectingPlayer.append([self])

func _on_detection_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerInDetectionRadius = false
		player.enemiesDetectingPlayer.erase([self])
