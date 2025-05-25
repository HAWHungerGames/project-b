extends CharacterBody3D
@export_category("Behaviour")
@export_subgroup("DetectionBehaviour")
@export var detectionRange: float = 8

@export_category("Stats")
@export_subgroup("Enemy Stats")
@export var health: int = 20
@export var speed: int = 8
@export var acceleration: int = 4

@export_subgroup("Attack Stats")
@export var attackDamage: int = 25
@export var attackDelay: float = 1
@export var timeBeforePathfinding: float = 20
@export var lifetime: float = 3

@onready var detectionRangeNode = $DetectionRange
@onready var attackNode = $AttackArea
@onready var damageNode = $DamageArea
@onready var paricles = $GPUParticles3D
@onready var mesh = $Mesh
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var animationPlayer = $Mesh/AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var boss_emitter = GameManager.get_child_by_name(self, "EnemyToBoss")
@onready var death_spores = GameManager.get_child_by_name(self, "DeathSpores")

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
	rollController(delta)
	if lifetime <= 1:
		explode()
	if lifetime <= 0:
		queue_free()
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

func rollController(delta):
	timeBeforePathfinding -= delta
	if timeBeforePathfinding <= 0:
		pathfinding = true
		animationPlayer.play("Ball roll")
		lifetime -= delta
	if !justSpawned:
		apply_gravity(delta)
	else:
		velocity.y = 20
	if global_position.y >= 20:
		if justSpawned:
			global_position = calculateFallPosition()
		justSpawned = false

func calculateFallPosition():
	var randomXOffset = rng.randf_range(-5.0, 5.0)
	var randomZOffset = rng.randf_range(-5.0, 5.0)
	var positionDifference = player.global_position - global_position
	var fallX = player.get_child(0).global_position.x - (positionDifference.x*0.1) + randomXOffset
	var fallZ = player.get_child(0).global_position.z - (positionDifference.z*0.1) + randomZOffset
	fallPosition = Vector3(fallX, global_position.y, fallZ)
	return fallPosition

func move_towards_player(delta):
	var direction = Vector3()
	
	nav.target_position = player.get_child(0).global_position
	
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * speed, acceleration * delta)

func rotateToPlayer():
	var angleVector = player.get_child(0).global_position - global_position
	var angle = atan2(angleVector.x, angleVector.z)
	rotation.y = angle - PI/2

func takeDamage(damage: int, type: String):
	health -= damage
	if health <= 0:
		if boss_emitter != null:
			GameManager.reset_child_to_root(self, boss_emitter)
			boss_emitter.activate_particles_to_boss()
		if death_spores != null:
			GameManager.reset_child_to_root(self, death_spores)
			death_spores.activate_death_particles()
		queue_free()

func attack(delta):
	if isInAttackArea and pathfinding:
		attackDelay -= delta
		if attackDelay <= 1:
			explode()
		if attackDelay <= 0:
			queue_free()

func explode():
	paricles.emitting = true
	mesh.visible = false
	if isInDamageArea:
		player.takeDamage(attackDamage, self, false, 0)
		isInDamageArea = false


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
		animationPlayer.play("Transform2ball")
		timeBeforePathfinding = 0.3
