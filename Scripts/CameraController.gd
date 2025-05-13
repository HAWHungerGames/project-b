extends Node3D
@export var settings: Node3D

@onready var speed: float = settings.cameraFollowSpeed
@onready var cameraTarget: Node3D = settings.get_child(0).get_child(1).get_child(0)

func _physics_process(delta):
	move_camera_to_player()
	
func move_camera_to_player():
	var tOrigin = cameraTarget.global_transform.origin - settings.global_transform.origin
	var sOrigin = self.transform.origin
	transform.origin = Vector3(lerp(sOrigin.x, tOrigin.x, speed), lerp(sOrigin.y, tOrigin.y, speed), lerp(sOrigin.z, tOrigin.z, speed))


func _on_stamina_timer_timeout() -> void:
	pass # Replace with function body.
