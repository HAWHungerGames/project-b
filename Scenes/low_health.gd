extends MarginContainer

@export var player: Node3D

@onready var redTint = $redTint
@onready var myceliumFrame = $mycelium

@export var fade_speed: float = 2.0
@export var health_threshold: float = 0.4  # When to start showing the effect (40% health)

@onready var target_opacity: float = 0.0

@onready var health = $"../VBoxContainer/stats/horizontal/statBarsMargin/bars/health/healthBar"
#shader_type canvas_item;
#
#uniform vec4 shine_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Red color
#uniform float cycle_speed : hint_range(0.1, 10.0) = 2.0;
#uniform bool full_pulse_cycle = true;

func _ready() -> void:
	pass

func _process(delta):
	# Smoothly interpolate to target opacity
	print("health: ", player.health)
	print("maxhealth: ", player.maxHealth)
	print("maxhealth10: ", (player.maxHealth * 5.0))
	print("health255: ", (player.health * 255.0))
	print("health change: ", (player.maxHealth * 2.5) / (player.health * 255.0))
	if player.health < ((player.maxHealth / 10) * 2) && player.health > 0:
		redTint.visible = true
		myceliumFrame.visible = true
		target_opacity = player.maxHealth * 4.0 / (player.health * 255.0)
		health.material.set_shader_parameter("low_health", true)
	else:
		health.material.set_shader_parameter("low_health", false)
	if player.health <= 0:
		target_opacity = 0.3
	print("opacity: ", target_opacity)
	modulate.a = lerp(modulate.a, target_opacity, fade_speed * delta)
	
	#if target_opacity > 0.3:  # Critical health
		#var pulse = (sin(OS.get_ticks_msec() * 0.005) + 1) * 0.1
		#redTint.modulate.a = lerp(modulate.a, target_opacity + pulse, fade_speed * delta)
