extends Node2D


signal _initializeDialogueSystem
signal _showDialogue(name: String, dialogue: String)
signal _hideDialogueBox

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $Timer
@onready var gameManager: Node = %game_manager
@onready var face: Sprite2D = $npcFace

var dialogueRunning = false

var face_cache = {}

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

func showDialogue(name: String, dialogue: String):
	var face_texture = null
	if face_cache.has(name):
		face_texture = face_cache[name]
	else:
		var face_loc: String = "res://Assets/Face/" + name + ".png"
		face_texture = load(face_loc)
		face_cache[name] = face_texture
	face.texture = face_texture
	printLetters(dialogue)

func printLetters(dialogue: String):
	label.text = ""
	animationPlayer.stop()
	$MarginContainer/Polygon2D.visible = false
	if !dialogueRunning:
		return
	for ch in dialogue:
		label.text += ch
		timer.start()
		await timer.timeout
	gameManager.emit_signal("_lineCompleted")
	animationPlayer.play("bounce")
