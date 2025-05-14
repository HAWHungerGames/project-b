extends Node

@export var controller: Node3D


@export var input: RichTextLabel
@export var xyz: RichTextLabel
@export var speed: RichTextLabel
@export var sneaking: RichTextLabel
@export var inDetectionArea: RichTextLabel
@export var inHidingArea: RichTextLabel
@export var detected: RichTextLabel
@export var hidden: RichTextLabel
@export var health: RichTextLabel
@export var stamina: RichTextLabel
@export var mana: RichTextLabel

var player: Node3D

func _ready():
	player = GlobalPlayer.getPlayer()

func _physics_process(delta):
	input.text = str(Input.get_vector("left", "right", "forward", "backward"))
	xyz.text = "(" + str(round_to_2(controller.transform.origin.x)) + ", " + str(round_to_2(controller.transform.origin.y)) + ", " + str(round_to_2(controller.transform.origin.z)) + ")"
	speed.text = "(" + str(round_to_2(controller.velocity.x)) + ", " + str(round_to_2(controller.velocity.y)) + ", " + str(round_to_2(controller.velocity.z)) + ")"
	sneaking.text = str(player.isSneaking)
	inDetectionArea.text = str(player.isInDetectionArea)
	inHidingArea.text = str(player.isInHidingArea)
	detected.text = str(player.isDetected)
	hidden.text = str(player.isHidden)
	health.text = str(player.health)
	stamina.text = str(player.stamina)
	mana.text = str(player.mana)

func round_to_2(num):
	return round(num * pow(10.0, 2)) / pow(10.0, 2)
