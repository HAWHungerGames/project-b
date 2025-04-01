extends Node

@export var settings: Node3D
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


func _physics_process(delta):
	input.text = str(Input.get_vector("left", "right", "forward", "backward"))
	xyz.text = "(" + str(round_to_2(controller.transform.origin.x)) + ", " + str(round_to_2(controller.transform.origin.y)) + ", " + str(round_to_2(controller.transform.origin.z)) + ")"
	speed.text = "(" + str(round_to_2(controller.velocity.x)) + ", " + str(round_to_2(controller.velocity.y)) + ", " + str(round_to_2(controller.velocity.z)) + ")"
	sneaking.text = str(settings.isSneaking)
	inDetectionArea.text = str(settings.isInDetectionArea)
	inHidingArea.text = str(settings.isInHidingArea)
	detected.text = str(settings.isDetected)
	hidden.text = str(settings.isHidden)
	health.text = str(settings.health)
	stamina.text = str(settings.stamina)
	mana.text = str(settings.mana)

func round_to_2(num):
	return round(num * pow(10.0, 2)) / pow(10.0, 2)
