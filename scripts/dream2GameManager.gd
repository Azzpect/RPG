extends Node

signal _sceneEnded


@onready var dialogueManager: Node = %dialogueManager
@onready var timer: Timer = $Timer
@onready var mother: Sprite2D = %mother
@onready var transitioner: Node2D = %transitioner

var nextScene: String = "res://scenes/utility/playerRoom.tscn"

func _ready():
	connect("_sceneEnded", sceneEnded)
	dialogueManager.emit_signal("_readDialogueFile")
	timer.start()
	await timer.timeout
	dialogueManager.emit_signal("_initializeDialogueSystem")
	await dialogueManager._dialougeCompleted
	transitioner.emit_signal("_endScene")

func _process(delta: float) -> void:
	if dialogueManager.i == 5 && is_instance_valid(mother):
		transitioner.emit_signal("_blink")
		mother.queue_free()

func sceneEnded():
	get_tree().change_scene_to_file(nextScene)
