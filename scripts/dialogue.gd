extends Node2D


signal _initializeDialogueSystem
signal _showDialogue
signal _hideDialogueBox

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $Timer
@onready var gameManager: Node = %game_manager

var dialogueRunning = false

func _ready():
	connect("_initializeDialogueSystem", initializeDialogueSystem)
	connect("_showDialogue", showDialogue)
	connect("_hideDialogueBox", hideDialogueBox)


func initializeDialogueSystem():
	animationPlayer.play("dialogue_box_appear")
	dialogueRunning = true

func hideDialogueBox():
	dialogueRunning = false
	animationPlayer.play("dialogue_box_disappear")

func showDialogue(dialogue: String):
	printLetters(dialogue)

func printLetters(dialogue: String):
	label.text = ""
	animationPlayer.stop()
	$Polygon2D.visible = false
	if !dialogueRunning:
		return
	for ch in dialogue:
		label.text += ch
		timer.start()
		await timer.timeout
	gameManager.emit_signal("_lineCompleted")
	animationPlayer.play("bounce")
