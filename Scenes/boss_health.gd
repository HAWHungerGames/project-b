extends MarginContainer

@onready var boss = get_tree().current_scene.find_child("BossEnemy")
@onready var health_bar = $health/healthBar
@onready var damage_bar = $health/damageBar
@onready var max_health = boss.health

func _ready() -> void:
	boss.health_changed.connect(update_health)
	init_health_bar()

func update_health():
	update_value(health_bar, damage_bar, boss.health, max_health)
	
func init_health_bar():
	health_bar.value = boss.health * 100 / max_health
	damage_bar.value = boss.health * 100 / max_health

func update_value(bar, damage_bar, current_val, max_val):
	bar.value = current_val * 100 / max_val
	if bar.value < damage_bar.value:
		var tween = get_tree().create_tween()
		tween.tween_property(damage_bar, "value", bar.value, 1).set_trans(Tween.TRANS_LINEAR)
	else:
		damage_bar.value = current_val * 100 / max_val
