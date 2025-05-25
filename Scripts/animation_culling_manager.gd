extends Node

var animated_objects = []
var camera: Camera3D
var culling_distance: float = 43

func _ready() -> void:
	set_process(true)
	
	var animated_nodes = get_tree().get_nodes_in_group("animated_objects")
	
	for node in animated_nodes:
		var animation_player = node.find_child("AnimationPlayer")
		if animation_player:
			register_animated_object(node, animation_player)
	
func _process(delta: float) -> void:
	if !camera:
		camera = get_viewport().get_camera_3d()
		return
	for item in animated_objects:
		if !is_instance_valid(item.object):
			continue
		var distance = item.object.global_position.distance_to(camera.global_position)
		if distance > culling_distance || camera.is_position_behind(item.object.global_position):
			if item.animation_player.is_playing():
				item.animation_player.pause()
				item.was_playing = true
		else:
			if item.was_playing && !item.animation_player.is_playing():
				item.animation_player.play()

func register_animated_object(object: Node3D, animation_player: AnimationPlayer):
	animated_objects.append({
		"object": object,
		"animation_player": animation_player,
		"was_playing": false
	})
	
