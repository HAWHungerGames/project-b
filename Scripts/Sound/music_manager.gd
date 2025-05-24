extends Node

# All AudioStreamPlayers must be added as children
var tracks: Array[AudioStreamPlayer] = []
var fade_duration: float = 2.0
var target_volume: float = 0.0
var off_volume: float = -80.0

func _ready():
	for i in range(get_child_count()):
		var child = get_child(i)
		if child is AudioStreamPlayer:
			if tracks.is_empty():  # First track
				child.volume_db = target_volume
			else:
				child.volume_db = off_volume
			child.play()
			tracks.append(child)


# Fade to the track by name or index
func fade_to_track(index: int):
	if index < 0 or index >= tracks.size():
		return

	for i in tracks.size():
		var player = tracks[i]
		var target_db = target_volume if i == index else off_volume
		_fade_volume(player, target_db, fade_duration)

# Internal volume fade coroutine
func _fade_volume(player: AudioStreamPlayer, to_db: float, duration: float) -> void:
	var from_db = player.volume_db
	var t := 0.0
	while t < duration:
		t += get_process_delta_time()
		var p = clamp(t / duration, 0, 1)
		player.volume_db = lerp(from_db, to_db, p)
		await get_tree().process_frame
	player.volume_db = to_db



func fade_to_Track0(area: Area3D) -> void:
	if area.is_in_group("Player"):
		fade_to_track(0)
		
func fade_to_Track1(area: Area3D) -> void:
	if area.is_in_group("Player"):
		fade_to_track(1)
func fade_to_Track2(area: Area3D) -> void:
	if area.is_in_group("Player"):
		fade_to_track(2)
func fade_to_Track3(area: Area3D) -> void:
	if area.is_in_group("Player"):
		fade_to_track(3)
