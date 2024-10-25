class_name GameManager
extends Node

# this signal is used by the transitioner to tell this game manager that the scene transition animation is completed so the game manager can now load the next scene
signal _sceneEnded
# this signal is used by other nodes to tell the gamemanager to save the player data
signal _savePlayerData

signal _startConversation

signal _performBlink

signal _endConversation

@export var isSceneEnded = false
@export var dialogueFileLoc = ""

var nextScene := ""
var currentScene := ""
var interactionRunning = false


#the transitioner node that plays the fade animation for scene loading and ending
@onready var transitioner: Node2D = %transitioner
@onready var player: CharacterBody2D = %player
@onready var dialogueBox: Node2D = %dialogueBox
@onready var npcHolder = %npcHolder

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
	#connects the signal
	connect("_endConversation", endConversation)
	currentScene = get_tree().current_scene.scene_file_path
	readDialogueFile(dialogueFileLoc)

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
		GameData.save({"quest": questTitle})
		QuestData.allQuests[questTitle]["status"] = "assigned"
		
func getQuestDetails():
	var questId = GameData.bufferedData.quest
	return QuestData.allQuests[questId].description

#function for _sceneEnded signal
func sceneEnded():
	get_tree().change_scene_to_file(nextScene)


func readDialogueFile(dialogueFileLoc: String):
	if !FileAccess.file_exists(dialogueFileLoc):
		print("wrong file path")
		return
	var dialogueFile = load(dialogueFileLoc).new()
	var fileData = dialogueFile.sceneDialogues
	for key in fileData:
		for dialogue in fileData[key]:
			var dialogueObj = []
			for line in dialogue.split("\n"):
				line = line.strip_edges()
				if line == "" or line.begins_with("*"):
					continue
				if line == "[::]":
					dialogueObj.append({"blink": true})
					continue
				line = line.split(": ")
				dialogueObj.append({"name": line[0], "dialogue": line[1]})
			DialogueData.update(key, dialogueObj)

#function for _startConversation signal
func startConversation(entity):
	if interactionRunning:
		return
	if entity.type == "NPC":
		if GameData.bufferedData.quest in entity.questList:
			dialogueBox.emit_signal("_initializeDialogueBox", GameData.bufferedData.quest)
		else:
			dialogueBox.emit_signal("_initializeDialogueBox", entity.name)
		player.speed = 0
		interactionRunning = true

func endConversation():
	player.speed = 70
	interactionRunning = false

#function for _performBlink signal
func performBlink():
	transitioner.emit_signal("_blink")


	
