extends AspectRatioContainer

@export var player: Node3D
@onready var stamina_bar = $staminaBarMiddle
@onready var timer = $timer
@onready var damage_bar =$damageBar

func _ready():
	player.staminaChanged.connect(update_value)
	init_bars()
	
func init_bars():
	stamina_bar.value = player.maxStamina * 100 / player.maxStamina
	damage_bar.value = player.maxStamina * 100 / player.maxStamina

	
func update_value():
	stamina_bar.value = player.stamina * 100 / player.maxStamina
	if stamina_bar.value < damage_bar.value:
		var tween = get_tree().create_tween()
		tween.tween_property(damage_bar, "value", stamina_bar.value, 1).set_trans(Tween.TRANS_LINEAR)
	else:
		damage_bar.value = player.stamina * 100 / player.maxStamina


func _on_timer_timeout():
	#damage_bar.value = player.health * 100 / player.maxHealth
	var tween = get_tree().create_tween()
	tween.tween_property(damage_bar, "value", stamina_bar.value, 1).set_trans(Tween.TRANS_LINEAR)
