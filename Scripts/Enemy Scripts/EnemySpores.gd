extends CharacterBody3D
@export_category("Behaviour")
@export_subgroup("DetectionBehaviour")
@export var hearingRange: float = 8
@export var visionRange: float = 10

@export_subgroup("MovementBehaviour")
@export var keepDistance: float = 5

@export_category("Stats")
@export_subgroup("Enemy Stats")
@export var health: int = 500
@export var speed: int = 2
@export var acceleration: int = 3

@export_subgroup("Attack Stats")
@export var attackDamage: int = 50
@export var attackDelay: float = 3.333
@export var sporeRange: float = 5

@onready var hearingNode = $HearingArea
@onready var visionNode = $VisionArea
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var sporeNode = $SporeRange
@onready var particles = $GPUParticles3D
@onready var animationPlayer = $Mesh/AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var playerIsInHearingArea: bool = false
var playerIsInVisionArea: bool = false
var tempAttackDelay: float = 0
var isMoving: bool = false 
var isInSporeRange: bool = false
var isAttacking: bool = false
var player: Node3D
var attacked: bool = false

func _ready():
	player = GlobalPlayer.getPlayer()
	hearingNode.scale = Vector3(hearingRange, hearingRange, hearingRange)
	visionNode.scale = Vector3(visionRange, visionRange, visionRange)
	sporeNode.scale = Vector3(sporeRange, sporeRange, sporeRange)

func _physics_process(delta):
	apply_gravity(delta)
	if !isAttacking:
		particles.emitting = false
	if detect_player():
		rotateToPlayer()
		attack(delta)
		if !isAttacking:
			move_towards_player(delta)
			animationPlayer.play("Walk")
			animationPlayer.speed_scale = 2
		else:
			velocity = Vector3(0, velocity.y, 0)
	else:
		animationPlayer.speed_scale = 1
		animationPlayer.play("Idle")
		velocity = Vector3(0, velocity.y, 0)
	move_and_slide()

func move_towards_player(delta):
	var direction = Vector3()
	
	nav.target_position = player.get_child(0).global_position
	
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * speed, acceleration * delta)

func detect_player():
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

func attack(delta):
	if isInSporeRange:
		isAttacking = true
	if !isAttacking:
		tempAttackDelay = attackDelay
	if isAttacking:
		if tempAttackDelay > 0:
			particles.emitting = false
			animationPlayer.speed_scale = 1
			animationPlayer.play("attack")
			tempAttackDelay -= delta
		if tempAttackDelay <= 1.333 and !attacked:
			attacked = true
			particles.restart()
			particles.emitting = true
			if isInSporeRange:
				player.takeDamage(attackDamage, self, false)
		if tempAttackDelay <= 0:
			attacked = false
			tempAttackDelay = attackDelay
			isAttacking = false


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

func _on_spore_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInSporeRange = true

func _on_spore_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInSporeRange = false
