extends Node


signal _initializeDialogueSystem

signal _lineCompleted

signal _readDialogueFile

signal _isSpaceClicked

signal _dialougeCompleted


@onready var dialogueBox: Node2D = %dialogueBox
@export var dialogueFileLoc: String = ""

var dialogues: Array = []

@export var i = 0

var isLineFinished: bool = false
var isSpaceClicked: bool = false


func _ready():
	connect("_readDialogueFile", readDialogueFile)
	connect("_initializeDialogueSystem", initDialougeSystem)
	connect("_lineCompleted", showNextLine)
	connect("_isSpaceClicked", spaceClicked)
	connect("_dialougeCompleted", dialogueCompleted)


func spaceClicked():
	isSpaceClicked = true

func _input(event):
	if !isLineFinished:
		return
	if event.is_action_pressed("line_continue"):
		emit_signal("_isSpaceClicked")


func initDialougeSystem():
	dialogueBox.emit_signal("_initializeDialogueSystem")
	dialogueBox.emit_signal("_showDialogue", dialogues[i]["name"], dialogues[i]["dialogue"])
	i += 1



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


func readDialogueFile():
	if !FileAccess.file_exists(dialogueFileLoc):
		print("wrong file path")
		return
	var file = FileAccess.open(dialogueFileLoc, FileAccess.READ)
	dialogues = JSON.parse_string(file.get_as_text())
	
func dialogueCompleted():
	i = 0
	dialogueBox.emit_signal("_hideDialogueBox")
