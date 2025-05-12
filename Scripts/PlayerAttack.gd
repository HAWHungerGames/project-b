extends Node3D

var weapon
var animation_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	getAccessToChild()
	playIdleAnimation()
	playAttackAnimation()

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
		
func playAttackAnimation():
	if Input.is_action_just_pressed("attack") and GameManager.get_weapon_in_hand() == true and animation_player != null:
		animation_player.play("Attack1")
		print("hallo")
