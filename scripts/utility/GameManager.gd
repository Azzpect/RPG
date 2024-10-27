class_name GameManager
extends Node

# this signal is used by other nodes to tell the gamemanager to save the player data
signal _savePlayerData

signal _startConversation

signal _performBlink

signal _endConversation

signal _performCommand

@export var isSceneEnded = false
@export var dialogueFileLoc = ""

var nextScene = ""
var currentScene = ""
var interactionRunning = false
var commandData = {}
var dialogueObj = {}


#the transitioner node that plays the fade animation for scene loading and ending
@onready var transitioner: Node2D = %transitioner
@onready var player: CharacterBody2D = %player
@onready var dialogueBox: Node2D = %dialogueBox

func initialize():
	##saves the current scene file path in the game data file so that if the game is quit, the next time the game can be started from here
	#GameData.save(get_tree().current_scene.scene_file_path)
	GameData.loadData()
	if player != null:
		player.position = GameData.bufferedData.player.position
		player.lastDirection = GameData.bufferedData.player.direction
	#connects the signal
	connect("_performBlink", performBlink)
	#connects the signal
	connect("_performCommand", performCommand)
	#connects the signal
	connect("_startConversation", startConversation)
	#connects the signal
	connect("_savePlayerData", savePlayerData)
	#connects the signal
	connect("_endConversation", endConversation)
	currentScene = get_tree().current_scene.scene_file_path
	readDialogueFile(dialogueFileLoc)
	GameData.save({"scene": currentScene})


func savePlayerData():
	GameData.save({"player": CharacterData.new(player.position, player.lastDirection)})	


func teleport(scene: String, playerPos: Vector2 = Vector2.ZERO, playerDirection: Vector2 = Vector2.ZERO, body: Node2D = null):
	if body != null and body.name != "player":
		return
	isSceneEnded = true
	GameData.save({"scene": scene, "player": CharacterData.new(playerPos, playerDirection)})
	transitioner.emit_signal("_endScene")
	get_tree().change_scene_to_file(scene)

		
func getQuestDetails():
	var questId = GameData.bufferedData.quest
	return {"description": GameData.allQuests[questId]["description"], "npc": GameData.allQuests[questId]["npc"]}



func readDialogueFile(dialogueFileLoc: String):
	if !FileAccess.file_exists(dialogueFileLoc):
		print("wrong file path")
		return
	var dialogueFile = load(dialogueFileLoc).new()
	var fileData = dialogueFile.sceneDialogues
	for key in fileData:
		dialogueObj[key] = []
		for line in fileData[key].split("\n"):
			line = line.strip_edges()
			if line == "" or line.begins_with("*"):
				continue
			if line == "[::]":
				dialogueObj[key].append({"blink": true})
				continue
			if line.begins_with("/"):
				if dialogueObj[key].size() > 0 and dialogueObj[key][-1].keys()[0] == "command":
					dialogueObj[key][-1]["command"].append(line.substr(1))
					continue
				dialogueObj[key].append({"command": [line.substr(1)]})
				continue
			line = line.split(": ")
			dialogueObj[key].append({"name": line[0], "dialogue": line[1]})

func performCommand(commands: Array):
	for command in commands:
		var commandParts = command.split(" ")
		if commandParts[0] == "get":
			if commandParts[1] in commandData.keys():
				return
			commandData[commandParts[1]] = getNode("%"+commandParts[1])
		elif commandParts[0] == "set":
			var value = getValue(commandParts[3])
			commandData[commandParts[1]].set(commandParts[2], value)
		elif commandParts[0] == "destroy":
			getNode("%"+commandParts[1]).queue_free()

func getNode(elementStruct: String):
	if "." in elementStruct:
		var temp = elementStruct.split(".")
		var element = null
		for e in temp:
			if element != null:
				element = element.get_child(int(e))
				continue
			element = get_node(e)
		return element
	return get_node(elementStruct)

func getValue(property: String):
	var value = null
	if "," in property:
		var temp = property.split(",")
		return Vector2(float(temp[0]), float(temp[1]))
	if "load(" in property:
		var loc = property.split("(")[1].split(")")[0]
		return load(loc)
	if property == "true":
		return true
	if property == "false":
		return false
	if property.is_valid_float():
		return float(property)
	if property.is_valid_int():
		return int(property)
	return property


#function for _startConversation signal
func startConversation(entity = null):
	if interactionRunning:
		return
	if GameData.bufferedData.quest != "" and getQuestDetails()["npc"] == entity.name:
		dialogueBox.emit_signal("_initializeDialogueBox", dialogueObj[GameData.bufferedData.quest])
		player.speed = 0
		interactionRunning = true

func endConversation():
	if player != null:
		player.speed = 70
	interactionRunning = false
	commandData = {}
	if GameData.bufferedData.quest != "":
		GameData.allQuests[GameData.bufferedData.quest]["status"] = 2
		GameData.assignQuest()

#function for _performBlink signal
func performBlink():
	transitioner.emit_signal("_blink")


	
