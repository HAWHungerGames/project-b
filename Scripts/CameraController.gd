extends Node3D
@export var CameraTarget: Node3D
@export_range(0, 1) var speed: float

func _physics_process(delta):
	move_camera_to_player()
	
func move_camera_to_player():
	var tOrigin = CameraTarget.global_transform.origin
	var sOrigin = self.transform.origin
	transform.origin = Vector3(lerp(sOrigin.x, tOrigin.x, speed), lerp(sOrigin.y, tOrigin.y, speed), lerp(sOrigin.z, tOrigin.z, speed))
