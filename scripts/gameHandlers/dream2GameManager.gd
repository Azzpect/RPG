extends Node


signal _performBlink

#dialogue manager of the current scene
var gameManager = GameManager.new()

#timer to create any latency
@onready var timer: Timer = $Timer

#the transitioner node that plays the fade animation for scene loading and ending
@onready var transitioner: Node2D = %transitioner
@onready var dialogueBox: Node2D = %dialogueBox
@onready var mother = %mother

#next scene file path
var nextScene: String = "res://scenes/gameScenes/playerRoomScene.tscn"


func _ready():
	
	#connects the signal
	connect("_performBlink", performBlink)



	#saves the current scene file path in the game data file so that if the game is quit, the next time the game can be started from here
	GameData.save({"scene": get_tree().current_scene.scene_file_path})


	#emits the signal so that the dialogue manager can read the dialogue file
	gameManager.readDialogueFile("res://dll/dream.gd")


	#starts a timer and waits for it so that the dialogue manager can finish reading the file
	timer.start()
	await timer.timeout

	dialogueBox.emit_signal("_initializeDialogueBox", "cutscene2")
	
	await _performBlink
	mother.queue_free()

	await dialogueBox._dialogueCompleted
	transitioner.emit_signal("_endScene")
	GameData.save({"scene": nextScene, "player": {"position": {"x": 418, "y": 338}, "direction": {"x": 0, "y": -1}}})
	get_tree().change_scene_to_file(nextScene)


#function for _performBlink signal
func performBlink():
	transitioner.emit_signal("_blink")
