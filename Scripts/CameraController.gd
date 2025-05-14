extends Node3D

var player: Node3D
var speed: float
var cameraTarget: Node3D

func _ready():
	player = GlobalPlayer.getPlayer()
	speed = player.cameraFollowSpeed
	cameraTarget = player.get_child(0).get_child(1).get_child(0)
	
func _physics_process(delta):
	move_camera_to_player()
	
func move_camera_to_player():
	var tOrigin = cameraTarget.global_transform.origin - player.global_transform.origin
	var sOrigin = self.transform.origin
	transform.origin = Vector3(lerp(sOrigin.x, tOrigin.x, speed), lerp(sOrigin.y, tOrigin.y, speed), lerp(sOrigin.z, tOrigin.z, speed))
