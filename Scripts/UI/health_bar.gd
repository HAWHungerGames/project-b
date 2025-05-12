extends AspectRatioContainer

@export var player: Node3D
@onready var health_bar = $healthBar
@onready var timer = $timer
@onready var damage_bar =$damageBar

func _ready():
	player.healthChanged.connect(update_value)
	init_bars()
	
func init_bars():
	health_bar.value = player.health * 100 / player.maxHealth
	damage_bar.value = player.health * 100 / player.maxHealth

	
func update_value():
	health_bar.value = player.health * 100 / player.maxHealth
	if health_bar.value < damage_bar.value:
		print_debug(timer.time_left)
		if timer.time_left == 0.0:
			timer.start()
	else:
		damage_bar.value = player.health * 100 / player.maxHealth


func _on_timer_timeout():
	print("hello")
	#damage_bar.value = player.health * 100 / player.maxHealth
	var tween = get_tree().create_tween()
	tween.tween_property(damage_bar, "value", health_bar.value, 1).set_trans(Tween.TRANS_LINEAR)
