extends Node

# this signal is used by the transitioner to tell this game manager that the scene transition animation is completed so the game manager can now load the next scene
signal _sceneEnded


#dialogue manager of the current scene
@onready var dialogueManager: Node = %dialogueManager

#timer to create any latency
@onready var timer: Timer = $Timer

#the transitioner node that plays the fade animation for scene loading and ending
@onready var transitioner: Node2D = %transitioner

#the mother sprite node
@onready var mother: Sprite2D = %mother

#next scene file path
var nextScene: String = "res://scenes/gameScenes/scene_1.tscn"

#the resource manager node that keeps track of the game data
var resourceManager: ResourceManager = ResourceManager.new()

func _ready():
	
	#connects the signal
	connect("_sceneEnded", sceneEnded)


	#saves the current scene file path in the game data file so that if the game is quit, the next time the game can be started from here
	resourceManager.save({"scene": get_tree().current_scene.scene_file_path})


	#emits the signal so that the dialogue manager can read the dialogue file
	dialogueManager.emit_signal("_readDialogueFile")


	#starts a timer and waits for it so that the dialogue manager can finish reading the file
	timer.start()
	await timer.timeout

	#signals the dialogue manager to start the cutscene dialogue sequence
	dialogueManager.emit_signal("_initializeDialogueSystem")
	#waits until the dialogue manager signals the end of the dialogue
	await dialogueManager._dialougeCompleted


	#performs the end scene sequence
	transitioner.emit_signal("_endScene")



func _process(delta: float) -> void:
	
	#checks if the dialogue manager reached the 5 the dialogue. if it does then it removes the mother and performs a blink animation with help of the transitioner node
	if dialogueManager.i == 5 && is_instance_valid(mother):
		transitioner.emit_signal("_blink")
		mother.queue_free()



#function for _sceneEnded signal
func sceneEnded():
	get_tree().change_scene_to_file(nextScene)
