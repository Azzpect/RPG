class_name GameManager
extends Node

# this signal is used by the transitioner to tell this game manager that the scene transition animation is completed so the game manager can now load the next scene
signal _sceneEnded
@export var isSceneEnded = false


var nextScene = ""
var resourceManager = ResourceManager.new()

#the transitioner node that plays the fade animation for scene loading and ending
@onready var transitioner: Node2D = %transitioner
@onready var player: CharacterBody2D = %player

func initialize():
	##saves the current scene file path in the game data file so that if the game is quit, the next time the game can be started from here
	#resourceManager.save(get_tree().current_scene.scene_file_path)
	resourceManager.loadData()
	player.position = resourceManager.gameData["player"].position
	player.last_direction = resourceManager.gameData["player"].direction
	#connects the signal
	connect("_sceneEnded", sceneEnded)

func saveGameData(data: Dictionary):
	if data.has("position") && data.has("direction"):
		resourceManager.save(get_tree().current_scene.scene_file_path, data["position"], data["direction"])


func teleport(scene: String, playerPos: Vector2, playerDirection: Vector2, body: Node2D):
	if body.name != "player":
		return
	isSceneEnded = true
	resourceManager.save(scene, playerPos, playerDirection)
	nextScene = scene
	transitioner.emit_signal("_endScene")

#function for _sceneEnded signal
func sceneEnded():
	get_tree().change_scene_to_file(nextScene)
