class_name GameManager
extends Node

# this signal is used by the transitioner to tell this game manager that the scene transition animation is completed so the game manager can now load the next scene
signal _sceneEnded
# this signal is used by other nodes to tell the gamemanager to save the player data
signal _savePlayerData
@export var isSceneEnded = false


var nextScene := ""
var currentScene := ""
var resourceManager = ResourceManager.new()

#the transitioner node that plays the fade animation for scene loading and ending
@onready var transitioner: Node2D = %transitioner
@onready var player: CharacterBody2D = %player

func initialize():
	##saves the current scene file path in the game data file so that if the game is quit, the next time the game can be started from here
	#resourceManager.save(get_tree().current_scene.scene_file_path)
	resourceManager.loadData()
	player.position = resourceManager.gameData.player.position
	player.lastDirection = resourceManager.gameData.player.direction
	#connects the signal
	connect("_sceneEnded", sceneEnded)
	#connects the signal
	connect("_savePlayerData", savePlayerData)
	currentScene = get_tree().current_scene.scene_file_path

func savePlayerData():
	resourceManager.save({"player": CharacterData.new(player.position, player.lastDirection)})	


func teleport(scene: String, playerPos: Vector2, playerDirection: Vector2, body: Node2D):
	if body.name != "player":
		return
	isSceneEnded = true
	resourceManager.save({"scene": scene, "player": CharacterData.new(playerPos, playerDirection)})
	nextScene = scene
	transitioner.emit_signal("_endScene")


func assignQuest(questTitle: String):
	resourceManager.save({"quest": questTitle})

func getQuestDetails():
	return resourceManager.gameData.quest

#function for _sceneEnded signal
func sceneEnded():
	get_tree().change_scene_to_file(nextScene)
