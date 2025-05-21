extends VBoxContainer

@onready var player: Node3D = GlobalPlayer.getPlayer()

@onready var health_bar = $health/healthBar
@onready var health_timer = $health/timer
@onready var health_damage_bar =$health/damageBar
@onready var mana_bar = $mana/manaBar
@onready var mana_timer = $mana/timer
@onready var mana_damage_bar =$mana/damageBar
@onready var stamina_bar_bottom = $stamina/staminaBar
@onready var stamina_bar_middle = $stamina/staminaBarMiddle
@onready var stamina_timer = $stamina/timer
@onready var stamina_damage_bar = $stamina/damageBar
@onready var stamina_damage_bar_middle = $stamina/damageBarMiddle

@onready var mana_container = $mana

func _ready() -> void:
	player.healthChanged.connect(update_health)
	player.staminaChanged.connect(update_stamina)
	player.manaChanged.connect(update_mana)
	GameManager.weapons_changed.connect(update_bars)
	init_bars()

func update_health():
	update_value(health_bar, health_damage_bar, player.health, player.maxHealth)
func update_stamina():
	update_value(stamina_bar_middle, stamina_damage_bar_middle, player.stamina, player.maxStamina)
	update_value(stamina_bar_bottom, stamina_damage_bar, player.stamina, player.maxStamina)
func update_mana():
	update_value(mana_bar, mana_damage_bar, player.mana, player.maxMana)
	
func update_bars():
	if "staff" in GameManager.get_first_weapon().to_lower() || "staff" in GameManager.get_second_weapon().to_lower():
		mana_container.process_mode = Node.PROCESS_MODE_INHERIT
		mana_container.visible = true
		stamina_bar_middle.process_mode = Node.PROCESS_MODE_INHERIT
		stamina_damage_bar_middle.process_mode = Node.PROCESS_MODE_INHERIT
		stamina_bar_middle.visible = true
		stamina_damage_bar_middle.visible = true
		stamina_bar_bottom.process_mode = Node.PROCESS_MODE_DISABLED
		stamina_damage_bar.process_mode = Node.PROCESS_MODE_INHERIT
		stamina_bar_bottom.visible = false
		stamina_damage_bar.visible = false
	else:
		mana_container.process_mode = Node.PROCESS_MODE_DISABLED
		mana_container.visible = false
		stamina_bar_middle.process_mode = Node.PROCESS_MODE_DISABLED
		stamina_damage_bar_middle.process_mode = Node.PROCESS_MODE_DISABLED
		stamina_bar_middle.visible = false
		stamina_damage_bar_middle.visible = false
		stamina_bar_bottom.process_mode = Node.PROCESS_MODE_INHERIT
		stamina_damage_bar.process_mode = Node.PROCESS_MODE_INHERIT
		stamina_bar_bottom.visible = true
		stamina_damage_bar.visible = true
	
func init_bars():
	health_bar.value = player.health * 100 / player.maxHealth
	health_damage_bar.value = player.health * 100 / player.maxHealth
	stamina_bar_bottom.value = player.stamina * 100 / player.maxStamina
	stamina_bar_middle.value = player.stamina * 100 / player.maxStamina
	stamina_damage_bar.value = player.stamina * 100 / player.maxStamina
	mana_bar.value = player.mana * 100 / player.maxMana
	mana_damage_bar.value = player.mana * 100 / player.maxMana
	
func update_value(bar, damage_bar, current_val, max_val):
	bar.value = current_val * 100 / max_val
	if bar.value < damage_bar.value:
		var tween = get_tree().create_tween()
		tween.tween_property(damage_bar, "value", bar.value, 1).set_trans(Tween.TRANS_LINEAR)
	else:
		damage_bar.value = current_val * 100 / max_val

func damage_tween(bar, val):
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", val, 1).set_trans(Tween.TRANS_LINEAR)

func _on_health_timer_timeout() -> void:
	damage_tween(health_damage_bar, health_bar.value)

func _on_stamina_timer_timeout() -> void:
	damage_tween(stamina_damage_bar_middle, stamina_bar_middle.value)
	damage_tween(stamina_damage_bar, stamina_bar_bottom.value)

func _on_mana_timer_timeout() -> void:
	damage_tween(mana_damage_bar, mana_bar.value)
