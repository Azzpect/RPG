extends Node




@onready var dialogueManager: Node = %dialogueManager
@onready var timer: Timer = $Timer
var nextScene: String = "res://scenes/utility/playerRoom.tscn"

func _ready():
	dialogueManager.emit_signal("_readDialogueFile")
	timer.start()
	await timer.timeout
	dialogueManager.emit_signal("_initializeDialogueSystem")
	await dialogueManager._dialougeCompleted
	get_tree().change_scene_to_file(nextScene)
