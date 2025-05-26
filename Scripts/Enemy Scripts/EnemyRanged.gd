extends CharacterBody3D
@export_category("Behaviour")
@export_subgroup("DetectionBehaviour")
@export var hearingRange: float = 40
@export var visionRange: float = 40

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
@export var attackSpeed: float = 1/1.6667
@export_range(0, 1) var homingStrength: float = 0
@export var homingRange: float = 50

@export_subgroup("MeleeAttack")
@export var meleeDamage: float = 20

@onready var hearingNode = $HearingArea
@onready var visionNode = $VisionArea
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var animationPlayer = $Mesh/AnimationPlayer
@onready var bulletSpawnPoint = $BulletSpawnPoint

@onready var boss_emitter = GameManager.get_child_by_name(self, "EnemyToBoss")
@onready var death_spores = GameManager.get_child_by_name(self, "DeathSpores")

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
var throwTimer: float = 0
var punchTimer: float = 0
var rangedAttackDelay: float = 0.54
var idleTimer: float = 0
var inMeleeRange: bool = false
var inMeleeDamageArea: bool = false
var deathTimer: float = 10

func _ready():
	player = GlobalPlayer.getPlayer()
	hearingNode.scale = Vector3(hearingRange, hearingRange, hearingRange)
	visionNode.scale = Vector3(visionRange, visionRange, visionRange)

func _physics_process(delta):
	apply_gravity(delta)
	die(delta)
	if gotAttackedTime > 0:
		gotAttackedTime -= delta
	if idleTimer >= 0:
		idleTimer -= delta
	if detect_player() and deathTimer == 10:
		if idleTimer <= 0:
			if !inMeleeRange:
				rangedAttack(delta)
				rotateToPlayer()
			else: 
				meleeAttack(delta)
	elif deathTimer == 10:
		animationPlayer.play("Idle")
		idleTimer = 1
	if detect_player() and deathTimer == 10:
		navigation(delta)
	move_and_slide()

func die(delta):
	if deathTimer < 10:
		deathTimer -= delta
	if deathTimer >= 5 and deathTimer <= 9:
		animationPlayer.stop()
		animationPlayer.play("Die")
		deathTimer = 2.6667
	if deathTimer <= 1:
		if boss_emitter != null:
			GameManager.reset_child_to_root(self, boss_emitter)
			boss_emitter.activate_particles_to_boss()
		if death_spores != null:
			GameManager.reset_child_to_root(self, death_spores)
			death_spores.activate_death_particles()
		queue_free()

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
	var end = player.get_child(0).global_position 
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
	var angleVector = player.get_child(0).global_position  - global_position 
	var angle = atan2(angleVector.x, angleVector.z)
	rotation.y = angle - PI/2

func takeDamage(damage: int, type: String):
	health -= damage
	$AudioStreamPlayer3D.play()
	if health <= 0 and deathTimer == 10:
		deathTimer = 8
		if type == "bow":
			PlayerActionTracker.bowKills += 1
		if type == "staff":
			PlayerActionTracker.staffKills += 1
		if type == "sword":
			PlayerActionTracker.meleeKills += 1
	else:
		gotAttackedTime = 3

func rangedAttack(delta):
	rangedAttackDelay -= delta
	if attackCooldown <= 0 and detect_player_raycast() and !isMoving and moveDelay <= 0 and rangedAttackDelay <= 0:
		var pos: Vector3 = bulletSpawnPoint.global_position 
		var vel: Vector3 = player.get_child(0).global_position - pos
		var bullet = bulletScene.instantiate()
		bullet.setParameter(player, bulletDamage, bulletSpeed, homingRange, homingStrength, vel, bulletLifetime)
		self.add_child(bullet)
		bullet.global_position = pos
		attackCooldown = 1.0/attackSpeed
		throwTimer = 1.6667
	if(attackCooldown >= 0): 
		attackCooldown -= delta
	if throwTimer >= 0:
		throwTimer -= delta
		animationPlayer.play("Throw")

func slowRotateToPlayer(delta):
	var angleVector = player.get_child(0).global_position  - global_position 
	var angle = atan2(angleVector.x, angleVector.z)  - PI/2
	var angleInDegrees = angle * 180 / PI
	var rotationInDegrees = rotation_degrees.y
	var yRotation = rotation.y
	if angleInDegrees < -360:
		angleInDegrees += 360
		angle += 2*PI
	if angleInDegrees < 0:
		angleInDegrees += 360
		angle += 2*PI
	if rotationInDegrees < -360:
		rotationInDegrees += 360
		yRotation += 2*PI
	if rotationInDegrees < 0:
		rotationInDegrees += 360
		yRotation += 2*PI
	if angleInDegrees + 180 < rotationInDegrees:
		rotation.y = lerp(yRotation, angle + 2*PI, 0.2)
	elif rotationInDegrees + 180 < angleInDegrees:
		rotation.y = lerp(yRotation + 2*PI, angle, 0.2)
	elif abs(angleInDegrees - rotationInDegrees) > 5:
		rotation.y = lerp(yRotation, angle, 0.2)
	if abs(angleInDegrees - rotationInDegrees) < 5:
		return true
	return false

func meleeAttack(delta):
	if punchTimer <= 0:
		if slowRotateToPlayer(delta):
			punchTimer = 12.0833
			animationPlayer.pause()
	if punchTimer > 0: 
		punchTimer -= delta
		animationPlayer.play("Punch")
	if punchTimer <= 11.0833 and punchTimer > 10:
		if inMeleeDamageArea:
			player.takeDamage(meleeDamage, self, true, 0)
		punchTimer -= 10

func apply_gravity(delta):
	velocity.y += -gravity * delta

func _on_hearing_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerIsInHearingArea = true
		if !playerIsInVisionArea:
			rangedAttackDelay = 0.54

func _on_hearing_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerIsInHearingArea = false
		if !playerIsInVisionArea:
			attackCooldown = 0

func _on_vision_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerIsInVisionArea = true
		if !playerIsInHearingArea:
			rangedAttackDelay = 0.54

func _on_vision_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerIsInVisionArea = false
		if !playerIsInHearingArea:
			attackCooldown = 0

func _on_melee_range_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		inMeleeRange = true 

func _on_melee_range_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		inMeleeRange = false
		rangedAttackDelay = 0.54
		attackCooldown = 0
		punchTimer = 0

func _on_melee_damage_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		inMeleeDamageArea = true

func _on_melee_damage_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		inMeleeDamageArea = false
