extends Node2D

#signal used by the dialogue manager node to start a dialogue sequence
signal _initializeDialogueBox

signal _isSpaceClicked
signal _dialogueCompleted

#animation player node used for dialogue box animations
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

#main lable that contains the dialogue
@onready var label: Label = $MarginContainer/dialogue

#label that contains the entity name of that dialogue
@onready var entityName: Label = $entityName

#timer
@onready var timer: Timer = $Timer

#the dialogue manager node
@onready var gameManager: Node = %gameManager

#a sprite2D node that contains the entity face
@onready var face: Sprite2D = $npcFace

var isSpaceClicked = true
var i = 0
var allDialogues = []
var commandList = []

#a dictionary for caching entity face sprites
var face_cache = {}

func _ready():

	#connecting the signals with their corresponding handler functions
	connect("_isSpaceClicked", spaceClicked)
	connect("_dialogueCompleted", dialogueCompleted)
	connect("_initializeDialogueBox", initializeDialogueBox)

func _input(event):
	if event.is_action_pressed("lineContinue"):
		emit_signal("_isSpaceClicked")

#this function is called when the _initializeDialogueBox signal is emitted. This functions makes the dialogue box visible in the scene and sets the dialogueRunning to true so that the _showDialogue signal can work
func initializeDialogueBox(dialogues):
	animationPlayer.play("dialogue_box_appear")
	allDialogues = dialogues
	emit_signal("_dialogueCompleted")

func hideDialogueBox():
	$MarginContainer/Polygon2D.visible = false
	animationPlayer.play("dialogue_box_disappear")
	gameManager.emit_signal("_endConversation")
	
	

func getNextLine():
	if(allDialogues.is_empty()):
		hideDialogueBox()
		return
	var currentDialogue = allDialogues.pop_front()
	commandList = []
	while not "name" in currentDialogue.keys():
		commandList.append(currentDialogue)
		if allDialogues.is_empty():
			commandList.append(currentDialogue)
			sendCommands()
			hideDialogueBox()
			return
		currentDialogue = allDialogues.pop_front()

	showDialogue(currentDialogue["name"], currentDialogue["dialogue"])

#this function is called when the _showDialogue signal is emitted
func showFace(_name: String):
	var face_texture = null
	entityName.text = ""
	#checks if the entity face sprite exists in the face_cache structure. If does then loads loads from the structure or else loads from the assets
	if face_cache.has(_name):
		face_texture = face_cache[_name]
	else:
		var face_loc: String = "res://Assets/Face/" + _name + ".png"
		face_texture = load(face_loc)
		face_cache[_name] = face_texture
	#sets the entity face sprite
	face.texture = face_texture
	#sets the enitity name
	entityName.text = _name

#function to show the dialogue letter by letter by iterating through the dialogue string and adding each character one by one with a slight delay
func showDialogue(_name: String, dialogue: String):
	isSpaceClicked = false
	animationPlayer.stop()
	label.text = ""
	$MarginContainer/Polygon2D.visible = false
	sendCommands()
	showFace(_name)
	for ch in dialogue:
		if isSpaceClicked:
			label.text = dialogue
			isSpaceClicked = false
			break
		label.text += ch
		timer.start()
		await timer.timeout
	animationPlayer.play("bounce")
	if not isSpaceClicked:
		await _isSpaceClicked
	emit_signal("_dialogueCompleted")

func sendCommands():
	while not commandList.is_empty():
		var command = commandList.pop_front()
		if "blink" in command.keys():
			gameManager.emit_signal("_performBlink")
		else:
			gameManager.emit_signal("_performCommand", command["command"])
func spaceClicked():
	isSpaceClicked = true

func dialogueCompleted():
	getNextLine()
