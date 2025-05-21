extends Area3D

@export var mana_cost_per_attack: int = 60

@onready var ray_position = $RayCast3D

@onready var player: Node3D = GlobalPlayer.getPlayer()
@onready var world = $"../../../../.."

var bullet_scene: PackedScene = preload("res://Prefabs/Asset Scenes/Weapons/player_bullet.tscn")
var bullet_instance


func spawn_bullet():
	bullet_instance = bullet_scene.instantiate()
	var direction = player.get_child(0).get_child(0)
	bullet_instance.position = ray_position.global_position
	bullet_instance.transform.basis = direction.transform.basis
	world.add_child(bullet_instance)

func magicAttack():
	if player.mana >= mana_cost_per_attack:
		player.reduce_mana(mana_cost_per_attack)
		print("-" + str(mana_cost_per_attack))
		spawn_bullet()
