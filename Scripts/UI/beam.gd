extends Node2D  # Your LaserBeam script

@onready var line = $Line2D  # Reference to your Line2D
@onready var enemy = get_parent().get_parent()  # The 3D enemy parent
@onready var target_node: Node3D = GlobalPlayer.getPlayer()
@onready var indicator_parent = get_parent()
var is_active = false

func _ready():
	# Initialize in hidden state
	visible = false

func _process(delta):
	if is_active and target_node:
		update_beam_position()

func update_beam_position():
	# Get the camera
	var camera = get_viewport().get_camera_3d()
	print(camera)
	if not camera:
		return
		
	# Get the 3D positions
	var enemy_pos_3d = enemy.global_position  # This is a Vector3
	
	# Convert to 2D screen positions
	var enemy_screen_pos = camera.unproject_position(enemy_pos_3d)
		
	# Since the laser is a child of the enemy, we need to position it at local (0,0)
	# but adjust its rotation and length to point at the target
	print(indicator_parent.position)
	indicator_parent.position = enemy_screen_pos
	
	# Make sure it's visible
	visible = is_active
func activate():
	is_active = true
	visible = true
	update_beam_position()

func deactivate():
	is_active = false
	visible = false
