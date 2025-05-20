extends CharacterBody3D
@export_category("Behaviour")
@export_subgroup("DetectionBehaviour")
@export var detectionRange: float = 8

@export_subgroup("MovementBehaviour")
@export_enum("stand still", "move towards player", "keep set distance from player") var movementType: String = "move towards player"
@export var keepDistance: float = 5

@export_category("Stats")
@export_subgroup("Enemy Stats")
@export var health: int = 300
@export var speed: int = 6
@export var acceleration: int = 6

@export_subgroup("Attack Stats")
@export var attackDamage: int = 25
@export var attackDelay: float = 2

@onready var detectionRangeNode = $DetectionRange
@onready var attackNode = $AttackArea
@onready var damageNode = $DamageArea
@onready var paricles = $GPUParticles3D
@onready var mesh = $MeshInstance3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var playerIsInHearingArea: bool = false
var playerIsInVisionArea: bool = false
var attackCooldown: float = 0
var tempAttackDelay: float = 0
var isInAttackArea: bool = false
var isInDamageArea: bool = false
var isMoving: bool = false 
var isAttacking = false
var player: Node3D

func _ready():
	player = GlobalPlayer.getPlayer()
	detectionRangeNode.scale = Vector3(detectionRange, detectionRange, detectionRange)

func _physics_process(delta):
	apply_gravity(delta)
	rotateToPlayer()
	attack(delta)
	if !isInAttackArea:
		move_towards_player(delta)
		move_and_slide()

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
