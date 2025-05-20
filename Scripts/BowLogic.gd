extends Node3D

@onready var ray_position = $RayCast3D

var bullet_scene: PackedScene = preload("res://Prefabs/Asset Scenes/Weapons/arrow.tscn")
var bullet_intance

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "FinishedAttack":
		spawn_bullet()
		print("bow attack")

func spawn_bullet():
	bullet_intance = bullet_scene.instantiate()
	var direction = get_node("/root/KonradWorkScene/WorldEnvironment/Player/Controller/Model")
	bullet_intance.position = ray_position.global_position
	bullet_intance.transform.basis = direction.transform.basis
	var world = get_node("/root/KonradWorkScene/WorldEnvironment/Player")
	world.get_parent().add_child(bullet_intance)
