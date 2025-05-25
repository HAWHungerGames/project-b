extends Node

var tracks: Array[AudioStreamPlayer] = []
var fade_duration: float = 4.0  # Dauer des Crossfades
var target_volume: float = 0.0
var off_volume: float = -80.0

var player
var currentTrack: AudioStreamPlayer
var isInArea1: bool = false
var isSwitching: bool = false
var atBoss: bool = false

func _ready():
	player = GlobalPlayer.getPlayer()

	for i: int in range(get_child_count()):
		var child := get_child(i)
		if child is AudioStreamPlayer:
			child.volume_db = off_volume
			child.play()
			tracks.append(child)

	if tracks.size() > 0:
		tracks[0].volume_db = target_volume
		currentTrack = tracks[0]


func _physics_process(_delta: float) -> void:
	if player.isDetected and !atBoss:
		await switch_with_crossfade(2)
		print("Battle")
	elif isInArea1 and !atBoss:
		await switch_with_crossfade(1)
		print("Area1")
	elif atBoss:
		await switch_with_crossfade(3)
		print("Boss")
	else:
		await switch_with_crossfade(0)
		#print("Area0")


func switch_with_crossfade(index: int) -> void:
	if index < 0 or index >= tracks.size():
		return
	if currentTrack == tracks[index] or isSwitching:
		return

	isSwitching = true
	var from_player: AudioStreamPlayer = currentTrack
	var to_player: AudioStreamPlayer = tracks[index]
	currentTrack = to_player

	if not to_player.playing:
		to_player.play()

	await crossfade_tracks(from_player, to_player, fade_duration)

	isSwitching = false


func crossfade_tracks(from_player: AudioStreamPlayer, to_player: AudioStreamPlayer, duration: float) -> void:
	var t: float = 0.0
	
	while t < duration:
		t += get_process_delta_time()
		var ratio = clamp(t / duration, 0, 1)
		
		# Sinus/Cosinus Crossfade für konstante Gesamtamplitude
		var amp_from = cos(ratio * PI * 0.5)
		var amp_to = sin(ratio * PI * 0.5)
		
		from_player.volume_db = linear_to_db(amp_from)
		to_player.volume_db = linear_to_db(amp_to)
		
		await get_tree().process_frame
	
	from_player.volume_db = off_volume
	to_player.volume_db = target_volume


# Hilfsfunktionen als Methoden außerhalb von crossfade_tracks:

func db_to_amp(db: float) -> float:
	return pow(10, db / 20.0)

func linear_to_db(amp: float) -> float:
	return 20.0 * (log(amp) / log(10))




# Trigger von Arealen
func fade_to_Track0(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInArea1 = false

func fade_to_Track1(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInArea1 = true

func fade_to_Track2(area: Area3D) -> void:
	if area.is_in_group("Player"):
		await switch_with_crossfade(2)

func fade_to_Track3(area: Area3D) -> void:
	if area.is_in_group("Player"):
		isInArea1 = false
		atBoss = true
		await switch_with_crossfade(3)
