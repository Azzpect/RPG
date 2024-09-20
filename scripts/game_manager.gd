extends Node

signal _lineCompleted
signal _isSpaceClicked


@onready var dialogueBox: Node2D = %dialogue_box
@onready var timer: Timer = $Timer

var dialogues = [
	"You are a mere mortal, how could you think of defeating me.",
	"With your fall this world will succumb to darknes and I will become the almighty, the one true king of this world",
	"No! I won't let that happen",
	"Ha Ha Ha! You are almost defeated so how are you going to stand against my power.",
	"I am carrying the hope of all of humanity.",
	"As long as I don't give up I believe they will lend me their power",
	"Why don't you wake up now?",
	"It's almost 10'o clock, Johny, Johny, wake up. The breakfast is ready, wake up quick."
]
var i = 0
var isSpaceClicked = false
var isLineFinished = false

func _ready():
	connect("_lineCompleted", lineCompleted)
	connect("_isSpaceClicked", spaceClicked)
	timer.start()
	await timer.timeout
	dialogueBox.emit_signal("_initializeDialogueSystem")
	dialogueBox.emit_signal("_showDialogue", dialogues[i])
	i += 1


func _input(event):
	if !isLineFinished:
		return
	if event.is_action_pressed("line_continue"):
		emit_signal("_isSpaceClicked")

func spaceClicked():
	isSpaceClicked = true

func lineCompleted():
	isLineFinished = true
	await _isSpaceClicked
	if(i == dialogues.size()):
		i = 0
		dialogueBox.emit_signal("_hideDialogueBox")
		return
	dialogueBox.emit_signal("_showDialogue", dialogues[i])
	isLineFinished = false
	isSpaceClicked = false
	i += 1
