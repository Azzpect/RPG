class_name GameManager
extends Node

# this signal is used by the transitioner to tell this game manager that the scene transition animation is completed so the game manager can now load the next scene
signal _sceneEnded


var nextScene = ""
var resourceManager = ResourceManager.new()

#the transitioner node that plays the fade animation for scene loading and ending
@onready var transitioner: Node2D = %transitioner

func initialize():
	#saves the current scene file path in the game data file so that if the game is quit, the next time the game can be started from here
	resourceManager.save({"scene": get_tree().current_scene.scene_file_path})
	
	#connects the signal
	connect("_sceneEnded", sceneEnded)

func teleport(scene: String, body: Node2D):
	if body.name != "player":
		return
	nextScene = scene
	transitioner.emit_signal("_endScene")

#function for _sceneEnded signal
func sceneEnded():
	get_tree().change_scene_to_file(nextScene)
