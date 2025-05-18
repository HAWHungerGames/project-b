extends CharacterBody3D
@export_category("Behaviour")
@export_subgroup("DetectionBehaviour")
@export var hearingRange: float = 8
@export var visionRange: float = 10

@export_subgroup("MovementBehaviour")
@export_enum("stand still", "move towards player", "keep set distance from player") var movementType: String = "move towards player"
@export var keepDistance: float = 5

@export_category("Stats")
@export_subgroup("Enemy Stats")
@export var health: int = 500
@export var speed: int = 2
@export var acceleration: int = 3

@export_subgroup("Attack Stats")
@export var attackDamage: int = 5
@export var attackSpeed: float = 3
@export var attackDelay: float = 2
@export var sporeRange: float = 5

@onready var hearingNode = $HearingArea
@onready var visionNode = $VisionArea
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var sporeNode = $SporeRange

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var playerIsInHearingArea: bool = false
var playerIsInVisionArea: bool = false
var attackCooldown: float = 0
var tempAttackDelay: float = 0
var isMoving: bool = false 
var isInSporeRange: bool = false
var isAttacking: bool = false
var player: Node3D

func _ready():
	player = GlobalPlayer.getPlayer()
	hearingNode.scale = Vector3(hearingRange, hearingRange, hearingRange)
	visionNode.scale = Vector3(visionRange, visionRange, visionRange)
	sporeNode.scale = Vector3(sporeRange, sporeRange, sporeRange)

func _physics_process(delta):
	apply_gravity(delta)
	if detect_player():
		rotateToPlayer()
		attack(delta)
	if detect_player():
		if !isAttacking:
			navigation(delta)
		else:
			velocity = Vector3(0, velocity.y, 0)
	else:
			velocity = Vector3(0, velocity.y, 0)
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

func keep_set_distance_from_player(delta):
	var distance = global_position.distance_to(player.get_child(0).global_position)
	isMoving = false
	if distance >= keepDistance:
		var direction = Vector3()
		
		nav.target_position = player.get_child(0).global_position
		
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		isMoving = true

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
		attackCooldown = 1/attackSpeed
	if isAttacking:
		if tempAttackDelay > 0:
			tempAttackDelay -= delta
		else:
			if attackCooldown > 0:
				attackCooldown -= delta
			else:
				attackCooldown = 1/attackSpeed
				isAttacking = false
				if isInSporeRange:
					player.takeDamage(attackDamage, self)

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
