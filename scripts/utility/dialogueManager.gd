extends Node


#signal used by the game manager node to start a dialogue sequence
signal _initializeDialogueSystem

#signal used by the dialogue script to mark an end of one dialogue
signal _lineCompleted

#signal to read the corresponding dialogue file
signal _readDialogueFile

#signal used to show when the space is clicked
signal _isSpaceClicked

#signal used to show the end of a dialogue sequence
signal _dialougeCompleted


#the dialogue box node
@onready var dialogueBox: Node2D = %dialogueBox

#the dialogue file path
@export var dialogueFileLoc: String = ""

#this array is populated with the dialouge by the _readDialogueFile signal
var dialogues: Array = []

#current dialouge index
@export var i = 0

#boolean used to denote the end of one dialouge
var isLineFinished: bool = false

#boolean used to denote if the space button is clicked
var isSpaceClicked: bool = false


func _ready():

	#connecting the signals with their corresponding handler functions
	connect("_readDialogueFile", readDialogueFile)
	connect("_initializeDialogueSystem", initDialougeSystem)
	connect("_lineCompleted", showNextLine)
	connect("_isSpaceClicked", spaceClicked)
	connect("_dialougeCompleted", dialogueCompleted)


#this function is called when the _isSpaceClicked signal is emitted. The reason why I used is as a signal handler and not as a normal function is that because I wanted to await for the signal to emit before showing the next line of the dialouge sequence
func spaceClicked():
	isSpaceClicked = true

func _input(event):
	#checks if the current dialogue line finished printing or not
	if !isLineFinished:
		return
	#if the space button is clicked then the _isSpaceClicked signal is emitted 
	if event.is_action_pressed("line_continue"):
		emit_signal("_isSpaceClicked")


#this function is called when the _initializeDialogueSystem signal is emitted. This function emits the _initializeDialogueBox signal of the dialougeBox node and also emits the _showDialogue signal with the first dialouge and increments the index by 1
func initDialougeSystem():
	dialogueBox.emit_signal("_initializeDialogueBox")
	dialogueBox.emit_signal("_showDialogue", dialogues[i]["name"], dialogues[i]["dialogue"])
	i += 1


#this function is called when the _lineCompleted signal is emitted. This function sets the isLineFinished variable to true, awaits for the user to press space and emits the _showDialogue signal of the dialoguebox node with the next dialouge and increments the index by 1. If the index has reached the end of the dialogue sequence then it emits the _dialougeCompleted signal
func showNextLine():
	isLineFinished = true
	await _isSpaceClicked
	if(i == dialogues.size()):
		emit_signal("_dialougeCompleted")
		return
	dialogueBox.emit_signal("_showDialogue", dialogues[i]["name"], dialogues[i]["dialogue"])
	isLineFinished = false
	isSpaceClicked = false
	i += 1

#this function is called when the _readDialogueFile signal is emitted.
func readDialogueFile():
	if !FileAccess.file_exists(dialogueFileLoc):
		print("wrong file path")
		return
	var file = FileAccess.open(dialogueFileLoc, FileAccess.READ)
	dialogues = JSON.parse_string(file.get_as_text())

#this function is called when the _dialougeCompleted signal is emitted. this function sets the dialouge index to 0 and emits the _hideDialogueBox signal of the dialogue box
func dialogueCompleted():
	i = 0
	dialogueBox.emit_signal("_hideDialogueBox")
