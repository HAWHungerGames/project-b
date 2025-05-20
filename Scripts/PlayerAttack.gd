extends Node3D

@export var settings: Node3D

@export var maxAttackCooldown: float = 1
@export var maxInputCooldown: float = 0.2
@export var maxStaffInputCooldown: float = 0.7
@export var maxResetComboStepCooldown: float = 1
@export var manaCostPerAttack: int = 60
@export var bowCooldown: float = 1
@export var bowMaxCooldown: float = 3


var weapon
var animation_player
var weapon_name
var reductionSpeed
var originalSpeed

var finishedCombo = false
var attackCooldown: float = 0
var inputCooldown: float = 0
var resetComboStepCooldown: float = 1
var comboStep = 0
var holdingBowAttack = false
var holdingBowAttackTimer: float = 0
var isAttacking = false

var swordName = "Sword"


func _physics_process(delta: float) -> void:
	getAccessToChild()
	playIdleAnimation()
	attacks(delta)

func playIdleAnimation():
	if GameManager.get_weapon_in_hand() == true and animation_player != null:
		if animation_player.is_playing() and animation_player.current_animation != "Idle":
			isAttacking = true
			pass
		else:
			animation_player.play("Idle")
			isAttacking = false
	elif GameManager.get_weapon_in_hand() == false and animation_player != null:
		animation_player.stop()

func usingAttack():
	if isAttacking:
		GameManager.set_is_attacking(isAttacking)
	elif !isAttacking:
		GameManager.set_is_attacking(isAttacking)

func getWeapon():
	return get_child(0)

func getAnimationPlayer(weapon_animation_player):
	return weapon_animation_player.get_node_or_null("AnimationPlayer")

func getAccessToChild():
	if GameManager.get_weapon_in_hand() == true:
		weapon = getWeapon()
		animation_player = getAnimationPlayer(weapon)

func playAttack1Animation():
	if Input.is_action_just_pressed("attack") and attackCooldown <= 0 and comboStep == 0:
		comboStep = 1
		inputCooldown = maxInputCooldown
		animation_player.play("Attack1")
		print("attack1")
		print(comboStep)

func playAttack2Animation():
	if inputCooldown <= 0 and comboStep == 1:
		if animation_player.current_animation == "Attack1" and Input.is_action_just_pressed("attack"):
			animation_player.stop()
			animation_player.play("Attack2")
			finishedCombo = true
			comboStep = 0
			resetComboStepCooldown = maxResetComboStepCooldown
			print("attack2")
			print(comboStep)

func calcAttackCooldown(delta):
	if finishedCombo == true:
		if attackCooldown <= 0:
			attackCooldown = maxAttackCooldown
		elif attackCooldown > 0:
			attackCooldown = attackCooldown - delta
			if attackCooldown <= 0:
				finishedCombo = false
				print("attack1 ready after combo")

func calcInputCooldown(delta):
	if inputCooldown >= 0:
		inputCooldown = inputCooldown - delta

func resetComboStep(delta):
	if comboStep == 1:
		if resetComboStepCooldown > 0:
			resetComboStepCooldown = resetComboStepCooldown - delta
		elif resetComboStepCooldown <= 0:
			comboStep = 0
			resetComboStepCooldown = maxResetComboStepCooldown
			print("attack1 ready after attack1")

func meleeAttack(delta):
	playAttack1Animation()
	calcInputCooldown(delta)
	playAttack2Animation()
	resetComboStep(delta)
	calcAttackCooldown(delta)

func staffAttack(delta):
	playStaffAttackAnimation()
	calcInputCooldown(delta)
	queueStaffAttackAnimation()

func playStaffAttackAnimation():
	if animation_player.current_animation == "Idle":
		if Input.is_action_just_pressed("attack") and settings.mana >= manaCostPerAttack and inputCooldown <= 0:
			print("staffAttack")
			animation_player.play("Attack1")
			inputCooldown = maxStaffInputCooldown

func queueStaffAttackAnimation():
	if animation_player.current_animation == "Attack1":
		if Input.is_action_pressed("attack") and settings.mana >= manaCostPerAttack and inputCooldown <= 0:
			print("queued staffAttack")
			animation_player.queue("Attack1")
			inputCooldown = maxStaffInputCooldown

func bowAttack(delta):
	startHoldBowAttackAnimation()
	holdingBowAttackCooldown(delta)
	finishingBowAttackAnimation()

# Press Input for Bow Attack
func startHoldBowAttackAnimation():
	if Input.is_action_pressed("attack") and !holdingBowAttack:
		animation_player.play("Attack1")
		animation_player.queue("HoldingAttack")
		holdingBowAttack = true
		# Reducing Speed while drwaing the Bow
		originalSpeed = settings.speed
		reductionSpeed = settings.speed * 0.2

# Press Input once for Quick Bow Attack, hold Input for Long Bow Attack
func holdingBowAttackCooldown(delta):
	if holdingBowAttack:
		settings.speed = reductionSpeed
		if  holdingBowAttackTimer <= bowCooldown:
			holdingBowAttackTimer += delta
			print(holdingBowAttackTimer)
		elif Input.is_action_pressed("attack") and holdingBowAttackTimer <= bowMaxCooldown:
			holdingBowAttackTimer += delta
			print(holdingBowAttackTimer)

# Release Input to finish Attack
func finishingBowAttackAnimation():
	if holdingBowAttackTimer >= bowCooldown and !Input.is_action_pressed("attack"):
		GameManager.set_bow_attack_timer(holdingBowAttackTimer)
		holdingBowAttack = false
		holdingBowAttackTimer = 0
		animation_player.stop()
		animation_player.play("FinishedAttack")
		settings.speed = originalSpeed

func attacks(delta):
	if GameManager.get_weapon_in_hand() == true and animation_player != null:
		usingAttack()
		weapon_name = GameManager.get_first_weapon()
		match weapon_name:
			swordName:
				meleeAttack(delta)
			"Placeholder Staff Hand":
				staffAttack(delta)
			"Placeholder Bow Hand":
				bowAttack(delta)
