extends Node3D
@export_category("Actions")
@export_subgroup("Walking")
@export var speed = 5.0
@export var acceleration = 4.0
##0 = No slowdown, 1 = Instant slowdown when the input ends
@export_range(0, 1) var friction: float = 0
#@export_range(0, 1) var sensitivity: float = 1 #Currently not used
@export_subgroup("Looking")
@export_enum("rotate based on last movement", "rotate based on second input") var rotationType: String = "rotate based on last movement"
##If player keep rotation if lock input key is pressed
@export var lockActive: bool = true #

@export_subgroup("Dash")
@export_enum("dash with cooldown","dash with stamina") var dashType: String = "dash with cooldown"
@export var staminaCostPerDash: int = 50
@export var dashStrength: int = 200
@export var dashMaxCooldown: float = 3
@export var noStaminaAfterDashTime: float = 1
@export_subgroup("Sneak")
@export var sneakSpeedModifier: float = 2
@export_subgroup("Blocking")
@export var shieldRadiusProtection: float = PI/2
@export var blockingStaminaCost: int = 10
@export var brokenBlockDuration: float = 5

@export_category("Resources")
@export_subgroup("Health")
@export var maxHealth: float = 200
@export_enum("Health regeneration", "Health from potions") var healthType: String = "Health from potions"
@export var healthPerSecond: float = 10
@export var healthPerPotion: float = 100

@export_subgroup("Stamina")
@export var maxStamina: float = 200
@export var staminaPerSecond: float = 10

@export_subgroup("Mana")
@export var maxMana: float = 200
@export_enum("Mana regeneration", "Mana from potions") var manaType: String = "Mana regeneration"
@export var manaPerSecond: float = 10
@export var manaPerPotion: float = 100

@export_category("Camera")
@export_subgroup("Camera behaviour")
@export_range(0, 1) var cameraFollowSpeed: float

@export_subgroup("Camera Settings")
@export_range(-90, 0) var cameraAngle: float = -45
@export var cameraHeight: float = 6
@export var cameraDistanceFromPlayer: float = 8

var stamina: float = maxStamina
var staminaRegenCooldown: float = 0
var health: float = maxHealth
var mana: float = maxMana
var timer: float = 0
var isSneaking: bool = false
var isInDetectionArea: bool = false
var isInHidingArea: bool = false
var isBlocking: bool = false
var blockBroken: float = 0

var enemiesDetectingPlayer: Array = []

var isHidden: bool = false
var isDetected: bool = false

func _enter_tree():
	GlobalPlayer.setPlayer(self)

func _ready():
	get_child(2).rotation.x = cameraAngle * PI / 180
	get_child(0).get_child(1).transform.origin.y = cameraHeight
	get_child(0).get_child(1).spring_length = cameraDistanceFromPlayer

func _physics_process(delta):
	resource_system(delta)
	checkDetection()
	brokenBlockTracker(delta)
	print(GameManager.get_first_weapon())

func brokenBlockTracker(delta):
	if blockBroken > 0:
		blockBroken -= delta

func resource_system(delta):
	if staminaRegenCooldown > 0:
		staminaRegenCooldown -= delta
	if timer >= 0.02:
		if health < maxHealth and healthType == "Health regeneration" and !isDetected:
			health += healthPerSecond/50
			if health > maxHealth:
				health = maxHealth
		if stamina < maxStamina and !isBlocking and staminaRegenCooldown <= 0:
			stamina += staminaPerSecond/50
			if stamina > maxStamina:
				stamina = maxStamina
		if mana < maxMana and manaType == "Mana regeneration":
			mana += manaPerSecond/50
			if mana > maxMana:
				mana = maxMana
		timer = 0
	else:
		timer += delta

func addDetectingEnemy(enemy):
	if !enemiesDetectingPlayer.has(enemy):
		enemiesDetectingPlayer.append(enemy)

func removeDetectingEnemy(enemy):
	if enemiesDetectingPlayer.has(enemy):
		enemiesDetectingPlayer.erase(enemy)

func checkDetection():
	if enemiesDetectingPlayer.size() == 0:
		isDetected = false
	else:
		isDetected = true

func reduce_stamina(amount: int):
	stamina -= amount

##Reduces mana by set amount and returns true if player  had enough mana, and false if they did not
func reduce_mana(amount: int):
	if mana >= amount:
		mana -= amount
		return true
	else:
		return false

func set_sneaking(value: bool):
	isSneaking = value

func set_stamina_regen_cooldown(value: float):
	staminaRegenCooldown = value

func check_if_attack_was_blocked(attacker: Node3D):
	var diffVector = self.get_child(0).global_transform.origin - attacker.global_transform.origin
	var attackAngle = atan2(diffVector.x, diffVector.z) + PI
	var playerAngle = self.get_child(0).get_child(0).rotation.y + PI
	if !(attackAngle >= playerAngle - shieldRadiusProtection/2) or !(attackAngle <= playerAngle + shieldRadiusProtection/2) or !isBlocking or blockBroken > 0:
		return false
	if stamina < blockingStaminaCost: 
		blockBroken = brokenBlockDuration
		print("Block was broken, stamina too low")
		return false
	stamina -= blockingStaminaCost
	return true

func breakBlock():
	blockBroken = brokenBlockDuration
	print("Block was broken from attack")

func takeDamage(damage: int, attacker: Node3D):
	if check_if_attack_was_blocked(attacker):
		health -= damage*getBlockingDamageReduction()
	else:
		health -= damage

func getBlockingDamageReduction():
	if GameManager.get_first_weapon() == "Bow":
		return 0.2
	if GameManager.get_first_weapon() == "Staff":
		return 0.3
	if GameManager.get_first_weapon() == "Sword":
		if GameManager.get_second_weapon() == "Shield":
			return 1
		return 0.5
	if GameManager.get_first_weapon() == "Shield":
		return 1.0
	return 0.0

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Bush"):
		isInHidingArea = true
	if area.is_in_group("Enemy"):
		isInDetectionArea = true

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("Enemy"):
		isInDetectionArea = false
	if area.is_in_group("Bush"):
		isInHidingArea = false
