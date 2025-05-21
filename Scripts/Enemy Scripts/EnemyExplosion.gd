extends CharacterBody3D
@export_category("Behaviour")
@export_subgroup("DetectionBehaviour")
@export var detectionRange: float = 8

@export_category("Stats")
@export_subgroup("Enemy Stats")
@export var health: int = 20
@export var speed: int = 6
@export var acceleration: int = 6

@export_subgroup("Attack Stats")
@export var attackDamage: int = 25
@export var attackDelay: float = 2
@export var timeBeforePathfinding: float = 20

@onready var detectionRangeNode = $DetectionRange
@onready var attackNode = $AttackArea
@onready var damageNode = $DamageArea
@onready var paricles = $GPUParticles3D
@onready var mesh = $MeshInstance3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var attackCooldown: float = 0
var tempAttackDelay: float = 0
var isInAttackArea: bool = false
var isInDamageArea: bool = false
var isMoving: bool = false 
var isAttacking = false
var player: Node3D
var pathfinding: bool = false
var justSpawned: bool = true
var fallPosition: Vector3
var rng = RandomNumberGenerator.new()


func _ready():
	player = GlobalPlayer.getPlayer()
	detectionRangeNode.scale = Vector3(detectionRange, detectionRange, detectionRange)

func _physics_process(delta):
	timeBeforePathfinding -= delta
	if timeBeforePathfinding <= 0:
		pathfinding = true
	if !justSpawned:
		apply_gravity(delta)
	else:
		velocity.y = 20
	if global_position.y >= 20:
		justSpawned = false
		global_position = calculateFallPosition()
	movement(delta)
	attack(delta)
	move_and_slide()

func movement(delta):
	rotateToPlayer()
	if !isInAttackArea:
		if pathfinding:
			move_towards_player(delta)
	else:
		velocity = Vector3(0, velocity.y, 0)

func calculateFallPosition():
	var randomXOffset = rng.randf_range(-5.0, 5.0)
	var randomZOffset = rng.randf_range(-5.0, 5.0)
	var positionDifference = player.global_position - global_position
	var fallX = player.global_position.x - positionDifference.x*0.1 - randomXOffset
	var fallZ = player.global_position.z - positionDifference.z*0.1 - randomZOffset
	fallPosition = Vector3(fallX, global_position.y, fallZ)
	return fallPosition

func move_towards_player(delta):
	var direction = Vector3()
	
	nav.target_position = player.get_child(0).global_position
	
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * speed, acceleration * delta)

func rotateToPlayer():
	var angleVector = player.get_child(0).global_transform.origin - global_transform.origin
	var angle = atan2(angleVector.x, angleVector.z)
	rotation.y = angle - PI/2

func takeDamage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()

func attack(delta):
	if isInAttackArea:
		attackDelay -= delta
		if attackDelay <= 1:
			paricles.emitting = true
			mesh.visible = false
			if isInDamageArea:
				player.takeDamage(attackDamage, self, false)
				isInDamageArea = false
		if attackDelay <= 0:
			queue_free()

func apply_gravity(delta):
	velocity.y += -gravity * delta

func _on_attack_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInAttackArea = true

func _on_damage_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInDamageArea = true

func _on_damage_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInDamageArea = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("World"):
		timeBeforePathfinding = 2
