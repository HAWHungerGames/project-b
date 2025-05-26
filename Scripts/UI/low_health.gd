extends MarginContainer

@export var player: Node3D

@onready var redTint = $redTint
@onready var myceliumFrame = $mycelium

@export var fade_speed: float = 2.0
@export var health_threshold: float = 0.4  # When to start showing the effect (40% health)

@onready var target_opacity: float = 0.0

@onready var health = $"../VBoxContainer/stats/horizontal/statBarsMargin/bars/health/healthBar"

func _ready() -> void:
	pass

func _process(delta):
	# Smoothly interpolate to target opacity
	if player.health < ((player.maxHealth / 10) * 2) && player.health > 0:
		redTint.visible = true
		myceliumFrame.visible = true
		target_opacity = player.maxHealth * 7.0 / (player.health * 255.0)
		health.material.set_shader_parameter("low_health", true)
	else:
		health.material.set_shader_parameter("low_health", false)
	if player.health <= 0:
		target_opacity = 0.5
	modulate.a = lerp(modulate.a, target_opacity, fade_speed * delta)
