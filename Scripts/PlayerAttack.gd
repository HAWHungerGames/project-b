extends Node3D

@export var maxAttackCooldown: float = 1
@export var maxInputCooldown: float = 0.2
@export var maxResetComboStepCooldown: float = 1

var weapon
var animation_player
var weapon_name

var finishedCombo = false
var attackCooldown: float = 0
var inputCooldown: float = 0
var resetComboStepCooldown: float = 1
var comboStep = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	getAccessToChild()
	playIdleAnimation()
	Attacks(delta)


func playIdleAnimation():
	if GameManager.get_weapon_in_hand() == true and animation_player != null:
		if animation_player.is_playing() and animation_player.current_animation != "Idle":
			pass
		else:
			animation_player.play("Idle")
	elif GameManager.get_weapon_in_hand() == false and animation_player != null:
		animation_player.stop()

func getWeapon():
	return get_child(0)
	
func getAnimationPlayer(weapon):
	return weapon.get_node_or_null("AnimationPlayer")
	
func getAccessToChild():
	if GameManager.get_weapon_in_hand() == true:
		weapon = getWeapon()
		animation_player = getAnimationPlayer(weapon)
		
func playAttack1Animation():
	if Input.is_action_just_pressed("attack") and GameManager.get_weapon_in_hand() == true and animation_player != null and attackCooldown <= 0 and comboStep == 0:
		comboStep = 1
		inputCooldown = maxInputCooldown
		animation_player.play("Attack1")
		print("attack1")
		print(comboStep)
		
func playAttack2Animation():
	if animation_player != null and inputCooldown <= 0 and comboStep == 1:
		if animation_player.current_animation == "Attack1" and Input.is_action_just_pressed("attack") and GameManager.get_weapon_in_hand() == true:
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

func Attacks(delta):
	weapon_name = GameManager.get_first_weapon()
	match weapon_name:
		"Placeholder Sword Hand":
			meleeAttack(delta)
	
