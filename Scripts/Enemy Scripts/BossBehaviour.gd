extends CharacterBody3D

@export_category("Stats")

@export_subgroup("Boss Settings")
@export var baseAggressionLevel: float = 0
@export var movePoints: Array[Node3D]

@export_subgroup("Enemy Stats")
@export var health: float = 300
@export var speed: float = 6
@export var acceleration: float = 6

@export_category("Attacks")
@export_subgroup("Ranged Spore Attack")
@export var bulletSpeed: float = 4
@export var bulletDamage: float = 5
@export var bulletLifetime: float = 120
@export var attackSpeed: float = 1
@export_range(0, 1) var homingStrength: float = 1
@export var homingRange: float = 500

@export_subgroup("Area Spore Attack")
@export var sporeArea: float = 10
@export var damageInterval: float = 0.2
@export var sporeAreaDamage: float = 5
@export var sporeActiveSlowdown: float = 2.0

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var world = $"../.."
@onready var sporeSpawnPoints = $SporeSpawnPoints
@onready var sporeDamageArea = $SporeDamageArea
@onready var ExplosionEnemySpawnPoint = $ExplosionEnemySpawnPoint

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bulletScene: PackedScene = preload("res://Prefabs/enemy_bullet.tscn")
var explosionEnemy: PackedScene = preload("res://Prefabs/enemy_explosion.tscn")

var aggression
var player
var detectedPlayer: bool = false
var playerInSporeArea: bool = false
var rng = RandomNumberGenerator.new()
var areaAttackCooldown: float = 0
var isAttacking: bool = false

enum actionType {NONE}
var actionTIme: float = 0

func _ready():
	calculateAggression()
	player = GlobalPlayer.getPlayer()
	sporeDamageArea.scale = Vector3(sporeArea, sporeArea, sporeArea)

func _physics_process(delta: float):
	apply_gravity(delta)
	move_to_furthest_point_from_player(delta)
	sporeAreaAttack(delta)
	if Input.is_action_just_pressed("block"):
		explosionMiniEnemiesAttack()

func calculateAggression():
	aggression = baseAggressionLevel
	if false: #Bow Equipped
		aggression += 0.3
	if false: #Staff Equipped
		aggression += 0.2
	if false: #Sword Equipped
		aggression -= 0.3

func actionManager():
	null

#Boss Actions
#Movement
func move_to_closest_point(delta):
	var closestPoint: Vector3 = movePoints[0].transform.origin
	for point in movePoints:
		if self.transform.origin.distance_to(point.transform.origin) < self.transform.origin.distance_to(closestPoint):
			closestPoint = point.transform.origin
	move_towards_target(delta, closestPoint)

func move_to_furthest_point_from_player(delta):
	var furthestPoint: Vector3 = movePoints[0].global_transform.origin
	for point in movePoints:
		if player.get_child(0).global_transform.origin.distance_to(point.global_transform.origin) > player.get_child(0).global_transform.origin.distance_to(furthestPoint):
			furthestPoint = point.transform.origin
	move_towards_target(delta, furthestPoint)

func move_to_player(delta):
	move_towards_target(delta, player.get_child(0).global_transform.origin)

func move_towards_target(delta, target):
	var direction = Vector3()
	nav.target_position = Vector3(target.x, self.transform.origin.y, target.z)
	
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * speed, acceleration * delta)
	rotateToPlayer(target)
	move_and_slide()

func rotateToPlayer(target):
	var angleVector = target - global_transform.origin
	var angle = atan2(angleVector.x, angleVector.z)
	rotation.y = angle - PI/2

#Attacks
func sporeRangedAttack():
	for sporeSpawnPoint in sporeSpawnPoints.get_children():
		var randomTrackingDelay = rng.randf_range(0.0, 0.3)
		var pos: Vector3 = sporeSpawnPoint.global_transform.origin
		var vel: Vector3 = pos - global_transform.origin
		var bullet = bulletScene.instantiate()
		bullet.setParameter(player, bulletDamage, bulletSpeed, homingRange, homingStrength, vel, bulletLifetime)
		bullet.setTrackingDelay(randomTrackingDelay)
		world.add_child(bullet)
		bullet.global_transform.origin = pos


func chargeAttack():
	null


func explosionMiniEnemiesAttack():
	var tempExplosionEnemy = explosionEnemy.instantiate()
	tempExplosionEnemy.global_position = ExplosionEnemySpawnPoint.global_position
	world.add_child(tempExplosionEnemy)
	

func spearMeleeAttack():
	null


func sporeAreaAttack(delta):
	areaAttackCooldown -= delta
	if areaAttackCooldown <= 0:
		if playerInSporeArea:
			player.takeDamage(sporeAreaDamage, self, false)
		areaAttackCooldown = damageInterval

func apply_gravity(delta):
	velocity.y += -gravity * delta

func _on_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		detectedPlayer = true
		player.addDetectingEnemy([self])

func _on_detection_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		detectedPlayer = false
		player.removeDetectingEnemy([self])

func _on_spore_damage_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerInSporeArea = true

func _on_spore_damage_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		playerInSporeArea = false
