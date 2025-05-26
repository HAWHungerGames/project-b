extends ColorRect

func _ready() -> void:
	print("im alive")
	SceneManager.game_scene.connect(fadeInScene)
	fadeInScene()
	
func fadeInScene():
	print("fadeIn")
	if self != null:
		print("fadeee")
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 2.0)
	get_tree().paused = false 
	print("fadedIn")
