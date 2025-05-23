extends Node3D

var lifeTime: float

func _ready():
	lifeTime = 5

func _physics_process(delta: float):
	lifeTime -= delta
	if lifeTime <= 0:
		queue_free()
