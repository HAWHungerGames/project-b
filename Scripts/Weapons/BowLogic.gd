extends Node3D

@onready var ray_position = $"../../../../../AimRayCast3D2"
@onready var player: Node3D = GlobalPlayer.getPlayer()
@onready var world = $"../../../../../../../.."

var bullet_scene: PackedScene = preload("res://Prefabs/Asset Scenes/Weapons/arrow.tscn")
var bullet_intance

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "Finish":
		spawn_bullet()
		#print("bow attack")

func spawn_bullet():
	bullet_intance = bullet_scene.instantiate()
	var direction = player.get_child(0).get_child(0)
	var mouse_position = GameManager.get_mouse_ground_position_fixed(self)
	bullet_intance.position = ray_position.global_position
	var direction_bullet = (mouse_position - bullet_intance.position)
	bullet_intance.transform.basis = direction.transform.basis
	world.add_child(bullet_intance)
