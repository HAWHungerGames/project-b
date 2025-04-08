extends Node
@export var player: Node3D
@export_category("Behaviour")
@export_subgroup("MovementBehaviour")
@export_enum("stand still", "move towards player", "flee from player") var movementType: String = "stand still"

@export_subgroup("AttackBehaviour")
@export_enum("detect within own detection-area", "detect within any detection-area", "detect within arena") var detectionType: String = "detect within detection-area"
@export var detectHiddenPlayer: bool = false
@export var onlyShotWithClearLineOfSight: bool = true
@export var detectionRange: float = 8

@export_category("Stats")
@export_subgroup("Stats")
@export var damage: int = 10
@export var health: int = 200
@export var speed: int = 5

@onready var detectionRangeNode = $DetectionArea/DetectionShape

func _ready():
	detectionRangeNode.scale = Vector3(detectionRange, detectionRange, detectionRange)
