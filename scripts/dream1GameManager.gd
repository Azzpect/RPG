extends Node


signal _sceneEnded

@onready var dialogueManager: Node = %dialogueManager
@onready var timer: Timer = $Timer
@onready var transitioner: Node2D = %transitioner
var nextScene: String = "res://scenes/Cutscenes/dream_2.tscn"

func _ready():
	connect("_sceneEnded", sceneEnded)
	dialogueManager.emit_signal("_readDialogueFile")
	timer.start()
	await timer.timeout
	dialogueManager.emit_signal("_initializeDialogueSystem")
	await dialogueManager._dialougeCompleted
	transitioner.emit_signal("_endScene")

func sceneEnded():
	get_tree().change_scene_to_file(nextScene)
