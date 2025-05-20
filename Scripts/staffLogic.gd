extends Area3D

@export var mana_cost_per_attack: int = 60

@onready var ray_position = $RayCast3D

var bullet_scene: PackedScene = preload("res://Prefabs/Asset Scenes/Weapons/player_bullet.tscn")
var bullet_intance


func spawn_bullet():
	bullet_intance = bullet_scene.instantiate()
	var direction = get_node("/root/KonradWorkScene/WorldEnvironment/Player/Controller/Model")
	bullet_intance.position = ray_position.global_position
	bullet_intance.transform.basis = direction.transform.basis
	var world = get_node("/root/KonradWorkScene/WorldEnvironment/Player")
	world.get_parent().add_child(bullet_intance)

func magicAttack():
	var stats = get_node("/root/KonradWorkScene/WorldEnvironment/Player") #very shit solution but it is what it is
	if stats.mana >= mana_cost_per_attack:
		stats.mana -= mana_cost_per_attack
		print("-" + str(mana_cost_per_attack))
		spawn_bullet()
