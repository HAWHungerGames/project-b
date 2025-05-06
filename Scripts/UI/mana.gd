extends AspectRatioContainer

@export var player: Node3D
@onready var mana_bar = $manaBar
@onready var timer = $timer
@onready var damage_bar =$damageBar

func _ready():
	player.manaChanged.connect(update_value)
	init_bars()
	
func init_bars():
	mana_bar.value = player.mana * 100 / player.maxMana
	damage_bar.value = player.mana * 100 / player.maxMana

	
func update_value():
	mana_bar.value = player.mana * 100 / player.maxMana
	if mana_bar.value < damage_bar.value:
		print_debug(timer.time_left)
		if timer.time_left == 0.0:
			timer.start()
	else:
		damage_bar.value = player.mana * 100 / player.maxMana


func _on_timer_timeout():
	print("hello")
	var tween = get_tree().create_tween()
	tween.tween_property(damage_bar, "value", mana_bar.value, 1).set_trans(Tween.TRANS_LINEAR)
