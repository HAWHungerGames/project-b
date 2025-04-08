extends Node
@export_category("Actions")
@export_subgroup("Walking")
@export var speed = 5.0
@export var acceleration = 4.0
##0 = No slowdown, 1 = Instant slowdown when the input ends
@export_range(0, 1) var friction: float = 0
#@export_range(0, 1) var sensitivity: float = 1 #Currently not used
@export_subgroup("Looking")
@export_enum("rotate based on last movement", "rotate based on relative mouse position", "rotation based on right joystick") var rotationType: String = "rotate based on last movement"
##If player keep rotation if lock input key is pressed
@export var lockActive: bool = true #

@export_subgroup("Dash")
@export_enum("dash with cooldown","dash with stamina") var dashType: String = "dash with cooldown"
@export var staminaCostPerDash: int = 50
@export var dashStrength: int = 200
@export var dashMaxCooldown: float = 3
@export_subgroup("Sneak")
@export var sneakSpeedModifier: float = 2

@export_category("Resources")
@export_subgroup("Health")
@export var maxHealth: int = 200
@export_enum("Health regeneration", "Health from potions") var healthType: String = "Health from potions"
@export var healthPerSecond: int = 10
@export var healthPerPotion: int = 100

@export_subgroup("Stamina")
@export var maxStamina: int = 200
@export var staminaPerSecond: int = 10

@export_subgroup("Mana")
@export var maxMana: int = 200
@export_enum("Mana regeneration", "Mana from potions") var manaType: String = "Mana regeneration"
@export var manaPerSecond: int = 10
@export var manaPerPotion: int = 100

@export_category("Camera")
@export_subgroup("Camera behaviour")
@export_range(0, 1) var cameraFollowSpeed: float

var stamina: int = maxStamina
var health: int = maxHealth
var mana: int = maxMana
var timer: float = 0
var isSneaking: bool = false
var isInDetectionArea: bool = false
var isInHidingArea: bool = false

var isHidden: bool = false
var isDetected: bool = false

func _physics_process(delta):
	resource_system(delta)
	detection_system()

func resource_system(delta):
	if timer >= 1:
		if health < maxHealth and healthType == "Health regeneration":
			health += healthPerSecond
			if health > maxHealth:
				health = maxHealth
		if stamina < maxStamina:
			stamina += staminaPerSecond
			if stamina > maxStamina:
				stamina = maxStamina
		if mana < maxMana and manaType == "Mana regeneration":
			mana += manaPerSecond
			if mana > maxMana:
				mana = maxMana
		timer = 0
	else:
		timer += delta

func detection_system():
	#If already detected stays detected but if not detected and is sneaking and in bush is hidden
	if isSneaking and isInHidingArea and !isDetected:
		isHidden = true
	if isInDetectionArea and !(isSneaking and isInHidingArea):
		isHidden = false
		isDetected = true
	if !isInDetectionArea:
		isDetected = false

func reduce_stamina(amount: int):
	stamina -= amount

func get_stamina():
	return stamina

func set_sneaking(value: bool):
	isSneaking = value

func debug_UI():
	null


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
