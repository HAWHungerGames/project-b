extends Node3D

@export var speed = 40.0
@export var dmg = 60
@export var lifetime = 5

#@onready var mesh = $MeshInstance3D
#@onready var hitbox = $Hitbox

var extraDmg

func _physics_process(delta: float) -> void:
	moving(delta)
	lifetime_of_bullet(delta)
	

func moving(delta):
		position += transform.basis * Vector3(0, 0, -speed) * delta


func lifetime_of_bullet(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		print("bullet despawned")


func _on_area_3d_body_entered(body: Node3D) -> void:
	attack(body)
			

func attack(body):
	extraDmg = GameManager.get_bow_attack_timer()
	if body.is_in_group("enemy"):
		# Normal or somewhat charged Bow Attack
		if extraDmg < 3:
			dmg *= extraDmg
			print(dmg)
			body.takeDamage(dmg)
			queue_free()
			print("hit")
		# Fully Charged Bow Attack
		elif extraDmg >= 3:
			dmg *= 4
			print(dmg)
			body.takeDamage(dmg)
			print("hit")
			dmg /= 4
	else:
		queue_free()
		print("bullet despawned")
