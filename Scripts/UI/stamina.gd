extends AspectRatioContainer

@export var player: Node3D
@onready var stamina_bar = $staminaBar
@onready var timer = $timer
@onready var damage_bar =$damageBar

func _ready():
	player.staminaChanged.connect(update_value)
	init_bars()
	
func init_bars():
	stamina_bar.value = player.stamina * 100 / player.maxStamina
	damage_bar.value = player.stamina * 100 / player.maxStamina

	
func update_value():
	stamina_bar.value = player.stamina * 100 / player.maxStamina
	if stamina_bar.value < damage_bar.value:
		print_debug(timer.time_left)
		if timer.time_left == 0.0:
			timer.start()
	else:
		tween_reg_stamina()


func _on_timer_timeout():
	print("hello")
	var tween = get_tree().create_tween()
	tween.tween_property(damage_bar, "value", stamina_bar.value, 1).set_trans(Tween.TRANS_LINEAR)
	
func tween_reg_stamina():
	var tween = get_tree().create_tween()
	tween.tween_property(stamina_bar, "value", player.stamina, 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(damage_bar, "value", player.stamina, 1).set_trans(Tween.TRANS_LINEAR)
