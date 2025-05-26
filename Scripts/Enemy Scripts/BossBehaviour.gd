extends CharacterBody3D

@export_category("Stats")

@export_subgroup("Boss Settings")
@export var baseAggressionLevel: float = 0
@export var movePoints: Array[Node3D]

@export_subgroup("Enemy Stats")
@export var health: float = 1000
@export var speed: float = 4
@export var acceleration: float = 3

@export_category("Attacks")
@export_subgroup("Ranged Spore Attack")
@export var bulletSpeed: float = 7
@export var bulletDamage: float = 5
@export var bulletLifetime: float = 120
@export var attackSpeed: float = 1
@export_range(0, 1) var homingStrength: float = 1
@export var homingRange: float = 500

@export_subgroup("Area Spore Attack")
@export var sporeArea: float = 1
@export var damageInterval: float = 0.2
@export var sporeAreaDamage: float = 5
@export var sporeActiveSlowdown: float = 2.0

@export_subgroup("ChargeAttack")
@export var chargeAttackDamage: float = 50

@export_subgroup("SpearAttack")
@export var spearDamage: float = 25

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var sporeSpawnPoints = $SporeSpawnPoints
@onready var sporeDamageArea = $SporeDamageArea
@onready var ExplosionEnemySpawnPoint = $ExplosionEnemySpawnPoint
@onready var animationPlayer = $Mesh/AnimationPlayer
@onready var sporeParticles = $AreaDamageParticles
@onready var chargeCollision = $ChargeCollision
@onready var launcherSound1 = $Sounds/LauncherSound1
@onready var launcherSound2 = $Sounds/LauncherSound2
@onready var squishSound = $Sounds/SquishSound
@onready var spearSound = $Sounds/SpearSound
@onready var walkingSound = $Sounds/WalkingSound

@onready var health_bar = get_tree().current_scene.find_child("bossHealthMargin")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bulletScene: PackedScene = preload("res://Prefabs/enemies/enemy_bullet.tscn")
var explosionEnemy: PackedScene = preload("res://Prefabs/enemies/enemy_explosion.tscn")
var teleportSmoke: PackedScene = preload("res://Prefabs/Enemies/Boss_Teleport_Smoke.tscn")
var win: PackedScene = preload("res://Prefabs/Asset Scenes/UI/win.tscn")

@onready var death_spores = GameManager.get_child_by_name(self, "DeathSpores")

var aggression: float = 0
var attacksBlockedPercentage: float = 0
var attacksDodgedPercentage: float = 0
var player
var detectedPlayer: bool = false
var playerInSporeArea: bool = false
var rng = RandomNumberGenerator.new()
var areaAttackCooldown: float = 0
var isAttacking: bool = false
var active: bool = false
var sporeTime: float = 0
var chargeAttackOnGoing: bool = false
var inChargeAttackArea: bool = false
var chargeHit: bool = false
var directionToPlayer: Vector3
var target
var comboArea1: bool = false
var comboArea2: bool = false
var comboArea3: bool = false
var spearTimeKeeper: float = 0
var teleportTimer: float = 0
var destination: Vector3
var deathTimer: float = 10

enum actionTypes {NONE, EXPLOSION_ATTACK, RANGED_ATTACK, CHARGE_ATTACK, POISON_CLOUD_ATTACK, SPEAR_ATTACK}
var actionType = actionTypes.NONE
var actionTime: float = 0

signal health_changed
signal boss_died

func _ready():
	calculateAggression()
	calculateBlocksAndDashes()
	player = GlobalPlayer.getPlayer()

func _physics_process(delta: float):
	die(delta)
	apply_gravity(delta)
	if active and deathTimer == 10:
		actionManager(delta)

func calculateAggression():
	aggression = baseAggressionLevel
	if GameManager.get_first_weapon() == "Bow" or GameManager.get_second_weapon() == "Bow": #Bow Equipped
		aggression += 0.3
	if GameManager.get_first_weapon() == "Staff" or GameManager.get_second_weapon() == "Staff": #Staff Equipped
		aggression += 0.2
	if GameManager.get_first_weapon() == "Sword" or GameManager.get_second_weapon() == "Sword": #Sword Equipped
		aggression -= 0.3
	var rangedKills: float = PlayerActionTracker.staffKills + PlayerActionTracker.bowKills
	var meleeKills: float = PlayerActionTracker.meleeKills
	var totalKills: float = rangedKills + meleeKills
	aggression += (rangedKills - meleeKills)/totalKills
	aggression = clamp(aggression, -0.7, 0.7)

func calculateBlocksAndDashes():
	var attacksBlocked: float = PlayerActionTracker.attacksBlocked
	var attacksDodged: float = PlayerActionTracker.timesDodgedInCombat
	var totalDodgedAndBlocked: float = attacksBlocked + attacksDodged
	attacksBlockedPercentage = attacksBlocked / totalDodgedAndBlocked
	attacksDodgedPercentage = attacksDodged / totalDodgedAndBlocked
	attacksBlockedPercentage = clamp(attacksBlockedPercentage, 0.3, 0.7)
	attacksDodgedPercentage = clamp(attacksDodgedPercentage, 0.3, 0.7)

func activateBoss():
	calculateAggression()
	calculateBlocksAndDashes()
	active = true
	health_bar.visible = true

func actionManager(delta):
	var playerPosition = player.get_child(0).global_position
	if actionTime > 0:
		actionTime -= delta
	if sporeTime > 0:
		sporeTime -= delta
	determineNextAction()
	
	if actionType == actionTypes.EXPLOSION_ATTACK:
		explosionAttackAction(delta, playerPosition)
	if actionType == actionTypes.CHARGE_ATTACK:
		chargeAttackAction(delta)
	if actionType == actionTypes.RANGED_ATTACK:
		rangedAttackAction(delta, playerPosition)
	if actionType == actionTypes.POISON_CLOUD_ATTACK:
		sporeAreaAttackAction(delta)
	if actionType == actionTypes.SPEAR_ATTACK:
		spearAttackAction(delta, playerPosition)
		
	ongoingSporeAreaAction(delta)
	apply_gravity(delta)
	move_and_slide()

func determineNextAction():
	if actionType == actionTypes.NONE:
		var ranged: bool = false
		var blockable: bool = false
		var randomAgressionValue: float = rng.randf_range(0.0, 1.0)
		var randomBlockValue: float = rng.randf_range(0.0, 1.0)
		var AreaAttackChance: float = rng.randf_range(0.0, 1.0)
		
		
		if AreaAttackChance < aggression and sporeTime <= 0:
			actionType = actionTypes.POISON_CLOUD_ATTACK
			actionTime = 200
		elif randomAgressionValue > aggression:
			if randomBlockValue > attacksBlockedPercentage:
				actionType = actionTypes.EXPLOSION_ATTACK #Unblockalbe and Ranged
				target = return_furthest_point_from_player()
				actionTime = 200
			else:
				actionType = actionTypes.RANGED_ATTACK #Blockalbe and Ranged
				target = return_closest_point()
				actionTime = 200
		else:
			if randomBlockValue > attacksBlockedPercentage:
				actionType = actionTypes.CHARGE_ATTACK #Unblockalbe and Melee
				target = return_closest_point()
				actionTime = 200
			else:
				actionType = actionTypes.SPEAR_ATTACK #Blockalbe and Melee
				target = return_furthest_point_from_player()
				actionTime = 200

#Boss Actions
#Movement
func reachedTarget(targetPoint):
	if global_position.distance_to(Vector3(targetPoint.x, global_position.y, targetPoint.z)) <= 2:
		return true
	return false

func return_closest_point():
	var closestPoint: Vector3
	if global_position.distance_to(movePoints[0].global_position) >= 5:
		closestPoint = movePoints[0].global_position
	else: 
		closestPoint = movePoints[1].global_position
	for point in movePoints:
		if self.global_position.distance_to(point.global_position) < self.global_position.distance_to(closestPoint) and global_position.distance_to(point.global_position) >= 5:
			closestPoint = point.global_position
	return closestPoint

func return_furthest_point_from_player():
	var furthestPoint: Vector3
	if global_position.distance_to(movePoints[0].global_position) >= 5:
		furthestPoint = movePoints[0].global_position
	else: 
		furthestPoint = movePoints[1].global_position
	for point in movePoints:
		if player.get_child(0).global_position.distance_to(point.global_position) > player.get_child(0).global_position.distance_to(furthestPoint) and global_position.distance_to(point.global_position) >= 5:
			furthestPoint = point.global_position
	return furthestPoint


func move_towards_target(delta, targetPoint):
	if !reachedTarget(targetPoint):
		var direction = Vector3()
		nav.target_position = Vector3(targetPoint.x, self.global_position.y, targetPoint.z)
		
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		rotateToTarget(targetPoint)
		animationPlayer.play("Running")
		if !walkingSound.playing:
			walkingSound.pitch_scale = 0.6
			walkingSound.play()
		return false
	else:
		velocity = Vector3(0, velocity.y, 0)
		return true

func rotateToTarget(targetPoint):
	var angleVector = targetPoint - global_position
	var angle = atan2(angleVector.x, angleVector.z)
	rotation.y = angle - PI/2

#Full Attack Actions
func explosionAttackAction(delta, playerPosition):
	if actionTime > 101:
		if move_towards_target(delta, target):
			actionTime = 100
	else:
		rotateToTarget(playerPosition)
		animationPlayer.play("Fire_bombs")
	if abs(actionTime - (100 - 2.11)) <= 1:
		explosionMiniEnemiesAttack()
		actionTime = 50
		launcherSound1.play(0.52)
	elif abs(actionTime - (50 - 1.55)) <= 1:
		explosionMiniEnemiesAttack()
		actionTime = 0.9
		launcherSound2.play(0.52)
	elif actionTime <= 0:
		animationPlayer.stop()
		actionType = actionTypes.NONE

func rangedAttackAction(delta, playerPosition):
	if actionTime > 101:
		if move_towards_target(delta, target):
			actionTime = 100
	else:
		rotateToTarget(playerPosition)
		animationPlayer.play("Squish")
	if abs(actionTime - (100 - 3.5)) <= 1:
		sporeRangedAttack()
		squishSound.play()
		actionTime = 0.65
	elif actionTime <= 0:
		animationPlayer.stop()
		actionType = actionTypes.NONE

func sporeAreaAttackAction(delta):
	if actionTime > 101:
		animationPlayer.play("Squish" )
		actionTime = 100
	if abs(actionTime - (100 - 3.5)) <= 1:
		actionTime = 0.65
		squishSound.play()
		sporeParticles.emitting = true
		sporeTime = 10
	elif actionTime <= 0:
		animationPlayer.stop()
		actionType = actionTypes.NONE

func chargeAttackAction(delta):
	if actionTime > 101:
		if move_towards_target(delta, target):
			actionTime = 100
	elif actionTime > 51:
		chargeCollision.disabled = false
		animationPlayer.play("Rush")
		chargeAttack()
		if !walkingSound.playing:
			walkingSound.pitch_scale = 1
			walkingSound.play()
	if chargeHit and actionTime >= 51:
		animationPlayer.play("Smash_After_Rush")
		actionTime = 50
	if abs(actionTime - (50 - 1.5)) <= 1:
		actionTime = 0
		chargeHit = false
		chargeCollision.disabled = true
		actionType = actionTypes.NONE

func die(delta):
	if deathTimer < 10:
		deathTimer -= delta
	if deathTimer >= 5 and deathTimer <= 9:
		var win_scene = win.instantiate()
		get_tree().current_scene.find_child("CanvasLayer").add_child(win_scene)
		animationPlayer.stop()
		animationPlayer.play("Die")
		deathTimer = 3.9167
		


func spearAttackAction(delta, playerPosition):
	if actionTime >= 151:
		if global_position.distance_to(playerPosition) >= 10:
			rotateToTarget(playerPosition)
			var smoke = teleportSmoke.instantiate()
			self.add_child(smoke)
			smoke.global_position = self.global_position
			smoke.get_child(0).emitting = true
			
			destination = playerPosition - Vector3(playerPosition - global_position).normalized() * 2.5
			
			var smoke2 = teleportSmoke.instantiate()
			self.add_child(smoke2)
			smoke2.global_position = destination
			smoke2.get_child(0).emitting = true
			actionTime = 100
		else:
			if move_towards_target(delta, playerPosition):
				actionTime = 100
	elif abs(actionTime - (100 - 2)) <= 1:
		if global_position.distance_to(playerPosition) >= 10:
			global_position = destination
		animationPlayer.play("Attack_Combo")
		actionTime = 50
	if actionTime <= 50 and actionTime >= 50 - 2.75:
		spearMeleeAttack(delta)
	elif actionTime <= 50 - 2:
		actionTime = 0
		spearTimeKeeper = 0
		actionType = actionTypes.NONE

func ongoingSporeAreaAction(delta):
	if sporeTime > 0:
		sporeAreaAttack(delta)
	else:
		sporeParticles.emitting = false

#Attacks
func sporeRangedAttack():
	for sporeSpawnPoint in sporeSpawnPoints.get_children():
		var randomTrackingDelay = rng.randf_range(0.1, 0.2)
		var pos: Vector3 = sporeSpawnPoint.global_position
		var vel: Vector3 = pos - global_position
		var bullet = bulletScene.instantiate()
		bullet.setParameter(player, bulletDamage, bulletSpeed, homingRange, homingStrength, vel, bulletLifetime)
		bullet.setTrackingDelay(randomTrackingDelay)
		bullet.setBlockCostModifier(0.5)
		self.add_child(bullet)
		bullet.global_position = pos


func chargeAttack():
	if !chargeAttackOnGoing:
		var playerPosition: Vector3 = player.get_child(0).global_position
		directionToPlayer = (playerPosition - global_position).normalized()
		rotateToTarget(playerPosition)
		chargeAttackOnGoing = true
	velocity = directionToPlayer * 10
	if inChargeAttackArea:
		player.takeDamage(chargeAttackDamage, self, false, 0)
		inChargeAttackArea = false
	if chargeHit:
		chargeAttackOnGoing = false

func explosionMiniEnemiesAttack():
	var tempExplosionEnemy = explosionEnemy.instantiate()
	self.add_child(tempExplosionEnemy)
	tempExplosionEnemy.global_position = ExplosionEnemySpawnPoint.global_position


func spearMeleeAttack(delta):
	spearTimeKeeper += delta
	if spearTimeKeeper >= 0.64 and spearTimeKeeper <= 0.73:
		spearSound.play()
		if comboArea1:
			player.takeDamage(spearDamage, self, true, 0.5)
			comboArea1 = false
	elif spearTimeKeeper >= 1.12 and spearTimeKeeper <= 1.16:
		spearSound.play()
		if comboArea2:
			player.takeDamage(spearDamage, self, true, 0.5)
			comboArea2 = false
	elif spearTimeKeeper >= 1.7 and spearTimeKeeper <= 2.1:
		spearSound.play()
		if comboArea3:
			player.takeDamage(spearDamage, self, true, 0.5)
			comboArea3 = false

func sporeAreaAttack(delta):
	areaAttackCooldown -= delta
	if areaAttackCooldown <= 0:
		if playerInSporeArea:
			player.takeDamage(sporeAreaDamage, self, false, 0)
		areaAttackCooldown = damageInterval

func apply_gravity(delta):
	velocity.y += -gravity * delta

func takeDamage(damage: int, type: String):
	health -= damage
	if health <= 0 and deathTimer == 10:
		deathTimer = 8
	health_changed.emit()
		

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


func _on_charge_attack_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		inChargeAttackArea = true
		print("Hit Player")
		chargeHit = true

func _on_charge_attack_body_entered(body: Node3D) -> void:
	if body.is_in_group("World"):
		print("Hit")
		chargeHit = true

func _on_spear_combo_1_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		comboArea1 = true

func _on_spear_combo_2_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		comboArea2 = true
	
func _on_spear_combo_3_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		comboArea3 = true

func _on_spear_combo_1_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		comboArea1 = false

func _on_spear_combo_2_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		comboArea2 = false

func _on_spear_combo_3_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		comboArea3 = false

func _on_boss_erea_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		activateBoss()
