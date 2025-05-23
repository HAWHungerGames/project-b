extends SubViewport

@onready var enemy = get_parent()
@onready var health_bar = $MarginContainer/EnemyHealthbar
@onready var damage_bar = $MarginContainer/EnemyDamagebar
@onready var max_health = enemy.health

func _ready() -> void:
	enemy.health_changed.connect(update_health)
	init_health_bar()

func update_health():
	update_value(health_bar, damage_bar, enemy.health, max_health)
	
func init_health_bar():
	health_bar.value = enemy.health * 100 / max_health
	damage_bar.value = enemy.health * 100 / max_health

func update_value(bar, damage_bar, current_val, max_val):
	bar.value = current_val * 100 / max_val
	if bar.value < damage_bar.value:
		var tween = get_tree().create_tween()
		tween.tween_property(damage_bar, "value", bar.value, 1).set_trans(Tween.TRANS_LINEAR)
	else:
		damage_bar.value = current_val * 100 / max_val
