class_name GameManager
extends Node

# this signal is used by the transitioner to tell this game manager that the scene transition animation is completed so the game manager can now load the next scene
signal _sceneEnded
# this signal is used by other nodes to tell the gamemanager to save the player data
signal _savePlayerData

signal _startConversation

signal _performBlink

@export var isSceneEnded = false


var nextScene := ""
var currentScene := ""
var dialogueRunning = false

#the transitioner node that plays the fade animation for scene loading and ending
@onready var transitioner: Node2D = %transitioner
@onready var player: CharacterBody2D = %player
@onready var dialogueManager: Node = %dialogueManager

func initialize():
	##saves the current scene file path in the game data file so that if the game is quit, the next time the game can be started from here
	#GameData.save(get_tree().current_scene.scene_file_path)
	GameData.loadData()
	player.position = GameData.bufferedData.player.position
	player.lastDirection = GameData.bufferedData.player.direction
	#connects the signal
	connect("_performBlink", performBlink)
	#connects the signal
	connect("_startConversation", startConversation)
	#connects the signal
	connect("_sceneEnded", sceneEnded)
	#connects the signal
	connect("_savePlayerData", savePlayerData)
	currentScene = get_tree().current_scene.scene_file_path

func savePlayerData():
	GameData.save({"player": CharacterData.new(player.position, player.lastDirection)})	


func teleport(scene: String, playerPos: Vector2, playerDirection: Vector2, body: Node2D):
	if body.name != "player":
		return
	isSceneEnded = true
	GameData.save({"scene": scene, "player": CharacterData.new(playerPos, playerDirection)})
	nextScene = scene
	transitioner.emit_signal("_endScene")


func assignQuest(questTitle: String):
	if QuestData.allQuests[questTitle]["status"] == "not assigned":
		GameData.save({"quest": QuestData.allQuests[questTitle].description})
		QuestData.allQuests[questTitle]["status"] = "assigned"
		print("assigned")
	print(QuestData.allQuests[questTitle])
func getQuestDetails():
	return GameData.bufferedData.quest

#function for _sceneEnded signal
func sceneEnded():
	get_tree().change_scene_to_file(nextScene)

#function for _startConversation signal
func startConversation():
	if not dialogueRunning:
		dialogueManager.emit_signal("_initializeDialogueSystem")
		dialogueRunning = true

#function for _performBlink signal
func performBlink():
	transitioner.emit_signal("_blink")
