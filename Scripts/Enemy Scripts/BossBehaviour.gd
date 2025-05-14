extends CharacterBody3D

@export_category("Stats")

@export_subgroup("Boss Settings")
@export var baseAggressionLevel: float = 0
@export var movePoints: Array[Node3D]


@export_subgroup("Enemy Stats")
@export var health: int = 300
@export var speed: int = 6
@export var acceleration: int = 6

@onready var nav: NavigationAgent3D = $NavigationAgent3D

var aggression
var player
var detectedPlayer: bool = false

func _ready():
	calculateAggression()
	player = GlobalPlayer.getPlayer()

func _physics_process(delta: float):
	move_to_furthest_point_from_player(delta)

func calculateAggression():
	aggression = baseAggressionLevel
	if false: #Bow Equipped
		aggression += 0.3
	if false: #Staff Equipped
		aggression += 0.2
	if false: #Sword Equipped
		aggression -= 0.3

#Boss Actions
#Movement
func move_to_closest_point(delta):
	var closestPoint: Vector3 = movePoints[0].transform.origin
	for point in movePoints:
		if self.transform.origin.distance_to(point.transform.origin) < self.transform.origin.distance_to(closestPoint):
			closestPoint = point.transform.origin
	move_towards_target(delta, closestPoint)

func move_to_furthest_point_from_player(delta):
	var furthestPoint: Vector3 = movePoints[0].global_transform.origin
	for point in movePoints:
		print(point.global_transform.origin)
		if player.get_child(0).global_transform.origin.distance_to(point.global_transform.origin) > player.get_child(0).global_transform.origin.distance_to(furthestPoint):
			furthestPoint = point.transform.origin
	move_towards_target(delta, furthestPoint)

func move_to_player(delta):
	move_towards_target(delta, player.get_child(0).global_transform.origin)

func move_towards_target(delta, target):
	var direction = Vector3()
	nav.target_position = Vector3(target.x, self.transform.origin.y, target.z)
	
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * speed, acceleration * delta)
	move_and_slide()


func _on_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		detectedPlayer = true


func _on_detection_area_exited(area: Area3D) -> void:
	if area.is_in_group("Player"):
		detectedPlayer = false
