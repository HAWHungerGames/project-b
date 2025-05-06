extends TextureProgressBar

@export var player: Node3D

func _ready():
	player.staminaChanged.connect(update_value)
	update_value()
	
func update_value():
	value = player.stamina * 100 / player.maxStamina
