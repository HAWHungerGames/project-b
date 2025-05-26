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
@export var lifetime: float = 5

@onready var hearingNode = $HearingArea
@onready var visionNode = $VisionArea
@onready var attackNode = $AttackArea
@onready var damageNode = $DamageArea
@onready var paricles = $GPUParticles3D
@onready var mesh = $Mesh
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var animationPlayer = $Mesh/AnimationPlayer

@onready var death_spores = GameManager.get_child_by_name(self, "DeathSpores")

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
var pathfinding: bool = false
var justSpawned: bool = true
var fallPosition: Vector3
var rng = RandomNumberGenerator.new()
var gotAttackedTime: float = 0


func _ready():
	player = GlobalPlayer.getPlayer()

func _physics_process(delta):
	if lifetime <= 1:
		explode()
	if lifetime <= 0:
		queue_free()
	movement(delta)
	attack(delta)
	move_and_slide()
	if detect_player() and timeBeforePathfinding > 10:
		animationPlayer.play("Transform2ball")
		timeBeforePathfinding = 0.3
	if timeBeforePathfinding < 10 and timeBeforePathfinding >= 0:
		timeBeforePathfinding -= delta
	if timeBeforePathfinding <= 0:
		pathfinding = true
		animationPlayer.play("Ball roll")
		lifetime -= delta
	

func detect_player():
	if gotAttackedTime > 0:
		return true
	if playerIsInHearingArea and !playerIsInVisionArea:
		if player.isSneaking and !player.isDetected:
			player.removeDetectingEnemy([self])
			return false
		else:
			player.addDetectingEnemy([self])
			return true
	if  playerIsInVisionArea and !playerIsInHearingArea:
		if detect_player_raycast() or player.isDetected:
			player.addDetectingEnemy([self])
			return true
		else:
			player.removeDetectingEnemy([self])
			return false
	if playerIsInHearingArea and playerIsInVisionArea:
		if player.isDetected or detect_player_raycast() or !player.isSneaking:
			player.addDetectingEnemy([self])
			return true
	player.removeDetectingEnemy([self])
	return false

func detect_player_raycast():
	var space_state = get_world_3d().direct_space_state
	var origin = global_position
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

func movement(delta):
	rotateToPlayer()
	if !isInAttackArea:
		if pathfinding:
			move_towards_player(delta)
	else:
		velocity = Vector3(0, velocity.y, 0)

func move_towards_player(delta):
	var direction = Vector3()
	
	nav.target_position = player.get_child(0).global_position
	
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * speed, acceleration * delta)

func rotateToPlayer():
	var angleVector = player.get_child(0).global_transform.origin - global_transform.origin
	var angle = atan2(angleVector.x, angleVector.z)
	rotation.y = angle - PI/2

func takeDamage(damage: int, type: String):
	health -= damage
	if health <= 0:
		if death_spores != null:
			GameManager.reset_child_to_root(self, death_spores)
			death_spores.activate_death_particles()
			if type == "bow":
				PlayerActionTracker.bowKills += 1
			if type == "staff":
				PlayerActionTracker.staffKills += 1
			if type == "sword":
				PlayerActionTracker.meleeKills += 1
		queue_free()
	else:
		gotAttackedTime = 4

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
	$ExplosionAudio.play()
	if isInDamageArea:
		player.takeDamage(attackDamage, self, false, 0)
		isInDamageArea = false

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

func _on_attack_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInAttackArea = true

func _on_damage_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInDamageArea = true

func _on_damage_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInDamageArea = false
