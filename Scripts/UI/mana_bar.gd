extends TextureProgressBar

@export var player: Node3D

func _ready():
	player.manaChanged.connect(update_value)
	update_value()
	
func update_value():
	value = player.mana * 100 / player.maxMana
